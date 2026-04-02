#!/bin/bash
set -euo pipefail

PACKAGES_FILE="${PACKAGES_FILE:-/etc/aur-builder/packages.txt}"
REPO_DIR="${REPO_DIR:-/repo}"
REPO_NAME="${REPO_NAME:-aurto}"
BUILD_USER="makepkg"

# Read package list, skip comments and blank lines
mapfile -t PACKAGES < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$')

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    echo "No packages to build"
    exit 0
fi

echo "==> Packages to sync: ${PACKAGES[*]}"

# Initialize repo DB if it doesn't exist
if [[ ! -f "$REPO_DIR/$REPO_NAME.db.tar" ]]; then
    echo "==> Initializing empty repo database"
    sudo -u "$BUILD_USER" repo-add "$REPO_DIR/$REPO_NAME.db.tar"
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

# Run aur sync — builds only packages with newer AUR versions than repo DB
# --no-view: don't prompt to inspect PKGBUILDs
# --no-confirm: don't prompt for confirmation
# --database: target repo name
# --root: directory containing the repo DB and packages
# --nocheck: skip check() to speed up builds
sudo -u "$BUILD_USER" \
    env AUR_SYNC_USE_NINJA=1 \
    aur sync \
        --no-view \
        --no-confirm \
        --database="$REPO_NAME" \
        --root="$REPO_DIR" \
        --nocheck \
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
