FROM archlinux:latest

RUN pacman -Syu --noconfirm --needed \
        base-devel git aurutils pacman-contrib sudo && \
    useradd -m -s /bin/bash makepkg && \
    echo 'makepkg ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    mkdir -p /home/makepkg/.gnupg && \
    echo 'keyserver-options auto-key-retrieve' > /home/makepkg/.gnupg/gpg.conf && \
    chown -R makepkg:makepkg /home/makepkg && \
    echo 'MAKEFLAGS="-j$(nproc)"' >> /etc/makepkg.conf && \
    pacman -Scc --noconfirm

COPY build.sh /build.sh
RUN chmod +x /build.sh

ENTRYPOINT ["/build.sh"]
