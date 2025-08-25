{ config, pkgs, ... }:

{
  imports = [
    ../base.nix
    ./shellScript.nix
    ./picom.nix
  ];

  home.packages = [
    #system
    pkgs.nixgl.nixGLIntel
    pkgs.redshift
    pkgs.brillo
    pkgs.flameshot
    pkgs.picom

    #wallpaper
    pkgs.rofi
    pkgs.xwinwrap
    pkgs.mpv
    pkgs.xdotool
    pkgs.pywal
    pkgs.pywalfox-native

    #programs
    pkgs.steam

    #font
    pkgs.terminus_font

  ];

  xdg.configFile.picom.source = ../../dotfiles/laptop/picom;
  xdg.configFile.rofi.source = ../../dotfiles/laptop/rofi;
  home.file.".xinitrc".source = ../../dotfiles/laptop/xinitrc;

  # .zprofile for session autologin
  home.file.".zprofile".text = ''
    # only launch startx if there is no other services
    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "''${XDG_VTNR:-0}" -eq 1 ] && [ -z "$TMUX" ]
    then
      if ! pgrep -x Xorg >/dev/null
      then
        startx
      fi
    fi
  '';


  # dconf
  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "st";
        # exec-arg = ""; # argument
      };
    };
  };
}
