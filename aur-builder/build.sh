#!/bin/bash
set -euo pipefail

PACKAGES_FILE="${PACKAGES_FILE:-/etc/aur-builder/packages/packages.txt}"
REPO_DIR="${REPO_DIR:-/repo}"
REPO_NAME="${REPO_NAME:-aurto}"
SIGNING_KEY="${SIGNING_KEY:-}"
BUILD_USER="makepkg"

# Read package list, skip comments and blank lines
mapfile -t PACKAGES < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    echo "No packages to build"
    exit 0
fi

echo "==> Packages to sync: ${PACKAGES[*]}"

# Import GPG signing key if provided
SIGN_ARGS=()
if [[ -n "$SIGNING_KEY" && -f "$SIGNING_KEY" ]]; then
    echo "==> Importing GPG signing key"
    sudo -u "$BUILD_USER" gpg --import "$SIGNING_KEY"
    KEY_ID=$(sudo -u "$BUILD_USER" gpg --list-keys --with-colons 2>/dev/null | awk -F: '/^pub/{found=1} found && /^fpr/{print $10; exit}')
    echo "==> Signing with key: $KEY_ID"
    SIGN_ARGS=(--sign --gpg-sign="$KEY_ID")
    # Export public key to repo directory so it's served over HTTP
    sudo -u "$BUILD_USER" gpg --export --armor "$KEY_ID" > "$REPO_DIR/signing-key.pub"
fi

# Initialize repo DB if it doesn't exist
if [[ ! -f "$REPO_DIR/$REPO_NAME.db.tar" ]]; then
    echo "==> Initializing empty repo database"
    sudo -u "$BUILD_USER" repo-add "${SIGN_ARGS[@]}" "$REPO_DIR/$REPO_NAME.db.tar"
fi

# Configure pacman to know about our local repo so aur sync can check versions
if ! grep -q "^\[$REPO_NAME\]" /etc/pacman.conf; then
    cat >> /etc/pacman.conf <<EOF

[$REPO_NAME]
SigLevel = Never
Server = file://$REPO_DIR
EOF
    pacman -Sy
fi

# Build aur sync command
SYNC_ARGS=(
    --no-view
    --no-confirm
    --database="$REPO_NAME"
    --root="$REPO_DIR"
    --nocheck
)
if [[ ${#SIGN_ARGS[@]} -gt 0 ]]; then
    SYNC_ARGS+=("${SIGN_ARGS[@]}")
fi

# Run aur sync — builds only packages with newer AUR versions than repo DB
sudo -u "$BUILD_USER" \
    env AUR_SYNC_USE_NINJA=1 \
    aur sync \
        "${SYNC_ARGS[@]}" \
        "${PACKAGES[@]}" || {
            echo "==> aur sync exited with $?, some packages may have failed"
        }

# Clean old package versions, keep latest 2
if command -v paccache &>/dev/null; then
    echo "==> Cleaning old package versions"
    paccache -r -k2 -c "$REPO_DIR" || true
fi

echo "==> Build complete"
ls -la "$REPO_DIR/$REPO_NAME.db.tar"
