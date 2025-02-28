# Defaults to version 3.21.3 as of 20250226
#ARG alpine_version=:3.21.3
ARG alpine_version=@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
FROM alpine${alpine_version}

RUN apk add --no-cache \
    ansible \
    bash \
    bash-completion \
    bind-tools \
    ca-certificates \
    curl \
    fd \
    g++ \
    gcc \
    git \
    git-bash-completion \
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
    opentofu \
    ripgrep \
    rsync \
    shadow \
    sudo \
    tmux \
    yq \
    yq-go-bash-completion

COPY --chmod=755 entrypoint.sh /sbin/entrypoint.sh

VOLUME ["/home","/etc/ssh"]

EXPOSE 22

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["default"]
