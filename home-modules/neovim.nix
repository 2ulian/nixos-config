{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
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
    vscode-langservers-extracted # lsp
    #bash
    bash-language-server
    #nix
    nixd #lsp
    alejandra #formatter

    # for live-server plugin
    live-server
  ];
}
