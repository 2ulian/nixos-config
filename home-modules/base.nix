{ config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fellwin";
  home.homeDirectory = "/home/fellwin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  imports = [
    ./librewolf.nix
    ./codium.nix
    ./git.nix
    ./obs.nix
    ./spicetify.nix
    ./zsh.nix
    ./eclipse.nix
    ./opsec.nix
    ./fish.nix
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # fonts (run "fc-cache -f" if the system dont detect the nerd font):
    pkgs.nerd-fonts.jetbrains-mono

    # other packages:
    pkgs.fzf
    pkgs.feh
    pkgs.vim
    pkgs.fastfetch
    pkgs.vlc
    pkgs.btop
    pkgs.keepassxc
    pkgs.obsidian
    pkgs.vesktop
    pkgs.stremio
    pkgs.nemo-with-extensions
    pkgs.file-roller
    pkgs.nemo-fileroller
    pkgs.parsec-bin
    pkgs.qbittorrent-enhanced
    pkgs.libreoffice-qt6
    pkgs.calibre
    pkgs.pwvucontrol
    pkgs.ttyper
    pkgs.tmux
    pkgs.lutris
    pkgs.heroic
    pkgs.ncspot
    pkgs.anki-bin

    #neovim
    pkgs.neovim
    pkgs.wl-clipboard
    pkgs.ripgrep
    pkgs.gcc
    pkgs.efm-langserver
    pkgs.nodejs

    # language servers
    # lua
    pkgs.lua-language-server
    pkgs.luajitPackages.luacheck
    pkgs.stylua
    # python
    pkgs.pyright
    pkgs.black
    pkgs.python313Packages.flake8
    # typescript
    pkgs.typescript-language-server
    pkgs.eslint
    pkgs.prettier # do a lot of languages
    # json
    pkgs.fixjson


    # for live-server plugin
    pkgs.live-server


    # Compressor/Extraction utilities
    pkgs.zip
    pkgs.p7zip
    pkgs.unzip
    pkgs.unrar
    pkgs.xz


    # dépendance projet de merde
    pkgs.python313
    pkgs.python313Packages.blinker
    pkgs.python313Packages.click
    pkgs.python313Packages.flask
    pkgs.python313Packages.importlib-metadata
    pkgs.python313Packages.itsdangerous
    pkgs.python313Packages.jinja2
    pkgs.python313Packages.markupsafe
    pkgs.python313Packages.werkzeug
    pkgs.python313Packages.zipp

  ];

  services.syncthing.enable = true;

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fellwin/etc/profile.d/hm-session-vars.sh
  #

  # GTK Theming
  gtk = {
    enable = true;
    theme = {
      name = "Flat-Remix-GTK-Blue-Darkest";
      package = pkgs.flat-remix-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # Force dark mode
    gtk3.extraConfig = { "gtk-application-prefer-dark-theme" = 1; };
    gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = 1; };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
