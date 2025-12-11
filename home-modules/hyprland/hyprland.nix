{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    #./illogical-impulse.nix
  ];
  home.packages = [
    # required packages for hyprland:
    pkgs.brillo
    pkgs.waybar
    pkgs.brightnessctl
    pkgs.hyprshot
    pkgs.hyprlock
    pkgs.hyprshade
    pkgs.hypridle
    pkgs.hyprsunset
    pkgs.hyprpicker
    pkgs.hyprpolkitagent
    pkgs.apple-cursor
    pkgs.kitty
    pkgs.rofi-unwrapped

    #required for wallpapers:
    pkgs.mpvpaper
    pkgs.imagemagick
    pkgs.waypaper
    pkgs.swww
    pkgs.pywal
    pkgs.pywalfox-native

    # To have all icons
    pkgs.adwaita-icon-theme
  ];

  #kitty configuration
  xdg.configFile.kitty.source = ../../dotfiles/kitty;

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
        # exec-arg = ""; # argument
      };
    };
  };

  # Enable qt for icon compability and PATH issue
  qt = {
    enable = true;
    platformTheme.name = "kde";
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
