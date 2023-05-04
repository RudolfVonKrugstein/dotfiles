FROM ubuntu:23.04

LABEL maintainer="Nathan Hüsken"

ENV PATH=$PATH:/usr/local/bin

ENV LANG="en_US.UTF8"
ENV TERM=xterm-256color

ARG DEPS="build-essential software-properties-common pkg-config lld ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils wget tmux ripgrep curl wget zsh golang gpg python3 fontconfig zip cmake gnupg gnupg2 ca-certificates libfreetype-dev libexpat-dev libbz2-dev libfontconfig-dev xclip libxcursor-dev sudo jq nodejs npm pipx ruby libssl-dev libhunspell-dev lsb-release htop locales"

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET=stable

# install deps
RUN apt update && apt upgrade -y && \
  apt install -y ${DEPS} && \
  rm -rf /var/lib/apt/lists/*

# locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

#install terraform
RUN mkdir /tmp/terraform && \
  cd /tmp/terraform && \
  wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip && \
  unzip terraform_1.4.6_linux_amd64.zip && \
  mv terraform /usr/local/bin && \
  rm -rf /tmp/terraform

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


# now everything as user
RUN usermod -l dev ubuntu
RUN usermod -md /home/dev dev
RUN usermod -aG sudo dev
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER dev

ENV PATH=$PATH:/home/dev/.cargo/bin

# lazygit
ENV PATH=$PATH:/home/dev/go/bin
RUN go install github.com/jesseduffield/lazygit@latest

# fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install --all
RUN echo "# fzf\n\
export PATH=$HOME/.fzf/bin:\$PATH\n" >> ~/.bashrc

# python
RUN pipx install poetry

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN rustup component add rust-src
RUN rustup component add rust-analyzer
# rust wasm
RUN rustup toolchain install nightly
RUN rustup target add wasm32-unknown-unknown --toolchain nightly
# rust leptos
RUN cargo install leptos-language-server --git https://github.com/bram209/leptos-language-server && \
  rm -rf ~/.cargo/registry
RUN /home/dev/.cargo/bin/rustup component add rustfmt
# gws2
RUN git clone --recurse-submodules https://github.com/emlun/gws2.git /tmp/gws2 && \
  cd /tmp/gws2 && \
  cargo install --path . && \
  cd / && \
  rm -rf /tmp/gws2 && \
  rm -rf ~/.cargo/registry


# install helix
RUN git clone https://github.com/helix-editor/helix.git /tmp/helix && \
  cd /tmp/helix && \
  cargo install --path helix-term && \
  strip $HOME/.cargo/bin/hx && \
  mkdir -p $HOME/.config/helix && \
  mv runtime $HOME/.config/helix && \
  rm /tmp/helix -rf && \
  rm -rf ~/.cargo/registry

# install cli tools with cargo
RUN cargo install starship zoxide fd-find && \
  rm -rf ~/.cargo/registry
RUN echo "eval \"\$(starship init bash)\"" >> ~/.bashrc


# copy config
RUN mkdir -p ~/.config
RUN mkdir -p ~/.config/tmux
RUN mkdir -p ~/.config/nvim

COPY --chown=dev starship.toml /home/dev/.config/starship.toml

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
RUN nvim --headless -c "TSInstall all" -c "qall"
RUN nvim --headless -c "MasonInstall yaml-language-server\
  actionlint\
  yamlfmt\
  typescript-language-server\
  taplo\
  tailwindcss-language-server\
  stylua\
  shellcheck\
  pyright\
  pydocstyle\
  prettierd\
  prettier\
  ltex-ls\
  misspell\
  markdown-toc\
  marksman\
  markdownlint\
  latexindent\
  jq\
  js-debug-adapter\
  jq-lsp\
  graphql-language-service-cli\
  gopls\
  golangci-lint-langserver\
  golangci-lint\
  gofumpt\
  go-debug-adapter\
  goimports\
  elm-language-server\
  elm-format\
  dockerfile-language-server\
  docker-compose-language-service\
  cucumber-language-server\
  debugpy\
  cpptools\
  dart-debug-adapter\
  cpplint\
  codespell\
  cmake-language-server\
  bash-language-server\
  codelldb\
  ansible-lint\
  awk-language-server\
  black\
  css-lsp\
  cssmodules-language-server\
  eslint-lsp\
  eslint_d\
  html-lsp\
  htmlbeautifier\
  lua-language-server\
  rust-analyzer\
  rustfmt\
  rustywind\
  tflint\
  terraform-ls\
  unocss-language-server" -c "qall"

# same with tmux
RUN tmux start-server && \
  tmux new-session -d && \
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh && \
  tmux kill-server

RUN echo "# tmux session manager\n\
# ~/.tmux/plugins\n\
export PATH=\$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:\$PATH\n\
# ~/.config/tmux/plugins\n\
export PATH=\$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:\$PATH\n" >> ~/.bashrc

ENTRYPOINT ["/usr/bin/tmux"]

WORKDIR "/home/dev"
