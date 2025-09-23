{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./uniliste.nix
  ];
  home.packages = with pkgs; [
    # neovim dependencies
    wl-clipboard
    ripgrep
    gcc
    nodejs

    # language servers
    # html/css
    vscode-langservers-extracted # lsp for html, css, json
    #twig
    twig-language-server
    #nix
    nixd #lsp
    #java
    jdt-language-server #lsp
    sonarlint-ls
    #rust
    rust-analyzer # lsp
    # lldb # to get lldb-dap
    #vuejs
    vue-language-server

    rustfmt # rust formatter

    # rust dependencies
    rustc
    cargo
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
    python3

    # to install lua dependencies(required for mason)
    luarocks
  ];

  # to add mason bin, make sure to have nix-ld enabled
  home.sessionPath = [
    "$HOME/.local/share/nvim/mason/bin"
  ];

  programs.neovim = {
    enable = true;
  };
}
