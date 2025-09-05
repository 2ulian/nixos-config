{ config, pkgs, lib, caelestia-shell, ... }:

{
  imports = [
    #./ax-shell.nix
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

    pkgs.quickshell
    pkgs.kdePackages.qt5compat
    
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
  programs.caelestia = {
    enable = true;
    systemd = {
      enable = false; # if you prefer starting from your compositor
      target = "graphical-session.target";
      environment = [];
    };
    settings = {
      bar.status = {
        showBattery = true;
      };
      paths.wallpaperDir = "~/Images";
    };
    settings.appearance = {
      font.size.scale = 0.9;   # essaie 0.9, 0.85, 0.8…
      # En option, pour compacter un peu l'UI :
      padding.scale = 0.7;
      spacing.scale = 0.5;
      font.family = {
        sans     = "Inter";                    # UI
        mono     = "JetBrainsMono Nerd Font";
      };
      transparency = {
        enabled = true;
        base    = 0.9;
        layers  = 0.9;
      };
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = false;
      };
    };
  };

  # Script qui surveille le fond d’écran courant et applique pywal
  home.file.".local/bin/caelestia-wallwatch".text = ''
    #!/bin/sh
    #set -euo pipefail
    #prev=""
    #[[ -f "$state" ]] && prev="$(cat "$state")"

    while true; do
      cur="$(caelestia wallpaper || true)"
      if [[ -n "${cur:-}" && "$cur" != "$prev" ]]; then
        wal -n -i "$cur"
        prev=$cur
      fi
      sleep 2
    done
  '';
  home.file.".local/bin/caelestia-wallwatch".executable = true;

  systemd.user.services."caelestia-pywal" = {
    Unit = { Description = "Apply pywal on Caelestia wallpaper change"; };
    Service = {
      ExecStart = "%h/.local/bin/caelestia-wallwatch";
      Restart = "always";
      RestartSec = 2;
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
