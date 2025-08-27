{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    #systemd.enable = true;
  };

  home.packages = [
    # required packages for hyprland:
    pkgs.wofi
    pkgs.walker
    pkgs.hyprshade
    pkgs.hyprpanel
    pkgs.hyprshot
    pkgs.hyprsunset
    pkgs.hyprpolkitagent
    pkgs.bibata-cursors
    
    #required for wallpapers:
    pkgs.mpvpaper
    pkgs.imagemagick
    pkgs.waypaper
    pkgs.swww

    # fonts (run "fc-cache -f" if the system dont detect the fonts):
    pkgs.google-fonts
  ];
}
