{
  config,
  pkgs,
  ...
}:
{
  imports = [
    #./uniliste.nix
  ];
  home.packages = with pkgs; [
    # neovim dependencies
    #wl-clipboard
    ripgrep
    gcc
    nodejs

    # language servers
    # html/css
    vscode-langservers-extracted # lsp for html, css, json
    #twig
    twig-language-server
    #nix
    nixd # lsp
    nixfmt
    alejandra
    #java
    jdt-language-server # lsp
    sonarlint-ls
    # lldb # to get lldb-dap
    #vuejs
    vue-language-server
    #php
    phpPackages.php-codesniffer
    # prettier
    prettier

    clang-tools # lsp for c/c++

    # rust dependencies
    rustup
    rustlings # to train

    #java dependencies
    maven # dependency management

    # for live-server plugin
    live-server

    # for msql support in dadbod
    sqlcmd

    # dependency of avante:
    gnumake

    # python
    python313
    python313Packages.pip

    # to install lua dependencies(required for mason)
    luarocks

    # to compile emacs vterm
    cmake
    libtool

    # spell checking
    ispell

    # to enable copilot in emacs
    copilot-language-server

    # to enable aider.el plugin to get ai editing
    aider-chat-full
  ];

  # to add mason bin, make sure to have nix-ld enabled
  home.sessionPath = [
    #$HOME/.local/share/nvim/mason/bin"
  ];

  programs.neovim = {
    enable = true;
  };
}
