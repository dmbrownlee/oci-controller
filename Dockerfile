# Defaults to version 3.22.1 as of 20250919
ARG alpine_version=@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1
FROM alpine${alpine_version}

RUN apk add --no-cache \
    ansible \
    bash \
    bash-completion \
    bind-tools \
    ca-certificates \
    curl \
    diffutils \
    file \
    fd \
    g++ \
    gcc \
    git \
    git-bash-completion \
    git-doc \
    github-cli \
    github-cli-bash-completion \
    gnupg \
    helm \
    helm-bash-completion \
    iproute2 \
    jq \
    kubectl \
    kubectl-bash-completion \
    lazydocker \
    lazygit \
    linux-headers \
    lsb-release-minimal \
    lua5.4 \
    lua5.4-dev \
    mandoc \
    mtr \
    mtr-bash-completion \
    neovim \
    neovim-doc \
    openssh-client-common \
    openssh-client-default \
    openssh-keygen \
    openssh-server \
    openssl \
    opentofu \
    py3-passlib \
    ripgrep \
    rsync \
    shadow \
    sudo \
    tmux \
    tree-sitter-lua \
    yq \
    yq-go-bash-completion

COPY --chmod=755 entrypoint.sh /sbin/entrypoint.sh

VOLUME ["/home","/etc/ssh"]

EXPOSE 22

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["default"]
