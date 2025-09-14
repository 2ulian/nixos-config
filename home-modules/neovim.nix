{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wl-clipboard
    ripgrep
    gcc
    efm-langserver
    nodejs

    # language servers
    # lua
    lua-language-server # lsp
    luajitPackages.luacheck # linter
    stylua # formatter
    # python
    pyright # lsp
    black # formatter
    python313Packages.flake8 # linter
    # typescript
    typescript-language-server
    eslint # linter
    prettier # formatter for a lot of languages
    # json
    fixjson # linter
    # html/css
    vscode-langservers-extracted # lsp for html, css, json
    # php
    intelephense # lsp
    php84Packages.php-cs-fixer
    php84Packages.php-codesniffer
    phpactor
    #twig
    twig-language-server
    #bash
    bash-language-server
    #nix
    nixd #lsp
    alejandra #formatter
    #java
    jdt-language-server #lsp
    #rust
    rust-analyzer # lsp
    lldb # to get lldb-dap

    # rust dependencies
    cargo

    #java dependencies
    maven # dependency management
    jdk21
    javaPackages.openjfx21

    # for live-server plugin
    live-server

    # for msql support in dadbod
    sqlcmd

    # To get google ai api for avante
    litellm
    # dependency of avante:
    gnumake

    # python
    python3
  ];

  # Make sure mason's bin directory is in your PATH
  home.sessionPath = [
    "$HOME/.local/share/nvim/mason/bin"
  ];

  programs.neovim = {
    enable = true;
  };
}
