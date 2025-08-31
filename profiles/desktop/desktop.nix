{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
  ];

  home.packages = [
    pkgs.pywal
    pkgs.pywalfox-native


    # required for qemu/kvm:
    pkgs.virt-manager
    pkgs.virt-viewer
    pkgs.spice
    pkgs.spice-gtk
    pkgs.spice-protocol
    pkgs.win-virtio
    pkgs.win-spice
  ];

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
        # exec-arg = ""; # argument
      };
    };
  };

  programs.zsh = {
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/dotfiles";
    };
  };


  # .zprofile for hyprland autologin
  home.file.".zprofile".text = ''
    # only launch hyprland if there is no other services
    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "''${XDG_VTNR:-0}" -eq 1 ] && [ -z "$TMUX" ]
    then
      exec Hyprland
    fi
  '';


  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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

}
