FROM archlinux:latest

# Install official packages (aurutils is AUR-only, built separately below)
RUN pacman -Syu --noconfirm --needed \
        base-devel git pacman-contrib sudo ninja pcre expect && \
    useradd -m -s /bin/bash makepkg && \
    echo 'makepkg ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir -p /home/makepkg/.gnupg && \
    echo 'keyserver-options auto-key-retrieve' > /home/makepkg/.gnupg/gpg.conf && \
    chown -R makepkg:makepkg /home/makepkg && \
    echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf && \
    pacman -Scc --noconfirm

# Build and install aurutils from AUR
RUN cd /tmp && \
    sudo -u makepkg git clone https://aur.archlinux.org/aurutils.git && \
    cd aurutils && \
    sudo -u makepkg makepkg -si --noconfirm && \
    cd / && rm -rf /tmp/aurutils

COPY build.sh /build.sh
RUN chmod +x /build.sh

ENTRYPOINT ["/build.sh"]
