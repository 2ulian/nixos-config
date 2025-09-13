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
    # html
    superhtml
    #bash
    bash-language-server
    #nix
    nixd #lsp
    alejandra #formatter
    #java
    jdt-language-server #lsp
    #rust
    rust-analyzer # lsp
    vscode-extensions.vadimcn.vscode-lldb # lsp debugger

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
  ];

  programs.neovim = {
    enable = true;
  };
}
