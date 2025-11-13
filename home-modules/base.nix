{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fellwin";
  home.homeDirectory = lib.mkDefault "/home/fellwin";

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
    ./vscode/codium.nix
    ./git.nix
    #./obs.nix
    ./zsh.nix
    ./eclipse.nix
    #./opsec.nix
    #./fish.nix
    ./neovim.nix
  ];

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
    pkgs.btop
    pkgs.keepassxc
    pkgs.obsidian
    pkgs.vesktop
    pkgs.code-cursor-fhs
    pkgs.qbittorrent-enhanced
    pkgs.ttyper
    # tmux
    pkgs.tmux
    pkgs.ncdu

    #pkgs.libreoffice-qt6
    #pkgs.nemo-with-extensions
    #pkgs.pwvucontrol
    #pkgs.file-roller
    #pkgs.nemo-fileroller

    pkgs.tree

    pkgs.ncspot
    pkgs.openfortivpn

    # Compressor/Extraction utilities
    pkgs.zip
    pkgs.p7zip
    pkgs.unzip
    pkgs.unrar
    pkgs.xz

    # Python
    #pkgs.python313

    #pkgs.prismlauncher
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  services.syncthing.enable = true;

  # for emacs
  home.sessionPath = [
    "$HOME/.config/emacs/bin/"
  ];

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
