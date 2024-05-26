FROM archlinux

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm \
    base-devel \
    git

RUN useradd --no-create-home --shell=/bin/false build && usermod -L build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sudo -u build bash -c "&& \ curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/aurutils.tar.gz | tar xz && \
    cd aurutils && \
    gpg --recv-keys DBE7D3DD8C81D58D0A13D0E76BC26A17B9B7018A && \
    makepkg -srci
