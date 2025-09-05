{ config, pkgs, lib, caelestia-shell, ... }:

{
  imports = [
    #./ax-shell.nix
  ];

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

    sleep 5

    while true; do
      cur="$(caelestia wallpaper || true)"
      if [[ -n "${cur:-}" && "$cur" != "$prev" ]]; then
        wal -n -i "$cur" && pywalfox update
        prev=$cur
      fi
      sleep 2
    done
  '';
  home.file.".local/bin/caelestia-wallwatch".executable = true;
}
