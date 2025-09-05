{ config, pkgs, lib, ... }:

{
  imports = [
    #./illogical-impulse.nix
  ];
  home.packages = [
    # required packages for hyprland:
    pkgs.brillo
    pkgs.walker
    pkgs.hyprshade
    pkgs.hyprshot
    pkgs.hyprsunset
    pkgs.hyprpolkitagent
    pkgs.apple-cursor

    pkgs.waybar
    pkgs.nerd-fonts._0xproto
    
    #required for wallpapers:
    pkgs.mpvpaper
    pkgs.imagemagick
    pkgs.waypaper
    pkgs.swww
    pkgs.pywal
    pkgs.pywalfox-native

    # fonts (run "fc-cache -f" if the system dont detect the fonts):
  ];

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
        # exec-arg = ""; # argument
      };
    };
  };

  # GTK Theming
  gtk.cursorTheme = {
    name = "macOS";
    package = pkgs.apple-cursor;
  };

  # .zprofile for hyprland autologin
  home.file.".zprofile".text = ''
    # only launch hyprland if there is no other services
    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "''${XDG_VTNR:-0}" -eq 1 ] && [ -z "$TMUX" ]
    then
      exec Hyprland
    fi
  '';
}
