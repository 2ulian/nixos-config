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
  home.stateVersion = "25.05"; # Please read the comment before changing.

  imports = [
    ../programs/librewolf.nix
    ../programs/codium.nix
    ../programs/git.nix
    ../programs/obs.nix
    ../programs/spicetify.nix
    ../programs/zsh.nix
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
    pkgs.vim
    pkgs.neovim
    pkgs.fastfetch
    pkgs.vlc
    pkgs.btop
    pkgs.openssl
    pkgs.rustc
    pkgs.keepassxc
    pkgs.obsidian
    pkgs.vesktop
    pkgs.stremio
    pkgs.syncthing
    pkgs.kitty
    pkgs.nemo-with-extensions
    pkgs.file-roller
    pkgs.nemo-fileroller
    pkgs.parsec-bin
    pkgs.qbittorrent-enhanced
    pkgs.libreoffice-qt6
    pkgs.eclipses.eclipse-java
    pkgs.jdk17
    pkgs.age

    # Compressor/Extraction utilities
    pkgs.zip
    pkgs.p7zip
    pkgs.unzip
    pkgs.unrar
    pkgs.xz
  ];

  # enable keyring service
  services.pass-secret-service.enable = true;

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
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
