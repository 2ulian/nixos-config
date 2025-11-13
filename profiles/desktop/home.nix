{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../home-modules/base.nix
    ../../home-modules/spicetify.nix
    ../../home-modules/hyprland/hyprland.nix
    ../../home-modules/hyprland/illogical-impulse.nix
  ];

  home.packages = [
    # required for qemu/kvm:
    pkgs.virt-manager
    pkgs.virt-viewer
    pkgs.spice
    pkgs.spice-gtk
    pkgs.spice-protocol
    pkgs.virtio-win
    pkgs.win-spice

    pkgs.calibre
    pkgs.prismlauncher
    pkgs.lunar-client
    pkgs.lutris
    pkgs.python313Packages.openai-whisper
  ];

  xdg.configFile."hypr/hyprland.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/desktop.conf;
  xdg.configFile."hypr/desktop.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/hyprland.conf;
  xdg.configFile."hypr/luminosity_up.sh".source =
    lib.mkOverride 10 ../../dotfiles/hypr/luminosity_up.sh;
  xdg.configFile."hypr/luminosity_down.sh".source =
    lib.mkOverride 10 ../../dotfiles/hypr/luminosity_down.sh;

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
