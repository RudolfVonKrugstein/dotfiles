FROM ubuntu:23.04

LABEL maintainer="Nathan Hüsken"

ENV PATH=$PATH:/usr/local/bin

ENV LANG="en_US.UTF8"
ENV TERM=xterm-256color

ARG DEPS="build-essential pkg-config lld ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils wget tmux ripgrep curl wget zsh golang gpg python3 fontconfig zip cmake gnupg ca-certificates libfreetype-dev libexpat-dev libbz2-dev libfontconfig-dev xclip libxcursor-dev"

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET=stable

# install deps
RUN apt update && apt upgrade -y && \
  apt install -y ${DEPS} && \
  rm -rf /var/lib/apt/lists/*

# neovim
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
  cd /tmp/neovim && \
  git fetch --all --tags -f && \
  git checkout ${TARGET} && \
  make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local/ && \
  make install && \
  strip /usr/local/bin/nvim && \
  rm /tmp/neovim -rf

# antibody
RUN curl -sfL git.io/antibody | sh -s - -b /usr/local/bin

# lazygit
ENV PATH=$PATH:/home/dev/go/bin
RUN go install github.com/jesseduffield/lazygit@latest

# now everything as user
RUN useradd -ms /bin/zsh dev
USER dev

ENV PATH=$PATH:/home/dev/.cargo/bin

# fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install --all

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN rustup component add rust-src
RUN rustup component add rust-analyzer

# install helix
RUN git clone https://github.com/helix-editor/helix.git /tmp/helix && \
  cd /tmp/helix && \
  cargo install --path helix-term && \
  strip $HOME/.cargo/bin/hx && \
  mkdir -p $HOME/.config/helix && \
  mv runtime $HOME/.config/helix && \
  rm /tmp/helix -rf

# install rust tools
RUN cargo install starship zoxide

# copy config
RUN mkdir -p ~/.config
RUN mkdir -p ~/.config/tmux
RUN mkdir -p ~/.config/nvim

COPY --chown=dev starship.toml /home/dev/.config/starship.toml

COPY --chown=dev zshrc /home/dev/.zshrc

COPY --chown=dev tmux.conf /home/dev/.config/tmux/tmux.conf

# install tmux plugin manager
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

ADD nvim_lua_custom /home/dev/.config/nvim/lua/custom

# install nerdfonts
ADD fonts /home/dev/.fonts
RUN cd /home/dev/.fonts && fc-cache -f -v

# run neovim and install dependencies
RUN nvim +q --headless

# same with tmux
RUN tmux start-server && \
  tmux new-session -d && \
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh && \
  tmux kill-server

ENTRYPOINT ["/usr/bin/tmux"]

WORKDIR "/home/dev"
