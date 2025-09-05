{ config, pkgs, ... }:

{
  home.packages = [
    #system
    pkgs.redshift
    pkgs.brillo
    pkgs.flameshot
    pkgs.picom
    pkgs.dmenu
    pkgs.networkmanagerapplet

    #wallpaper
    pkgs.rofi
    pkgs.xwinwrap
    pkgs.mpv
    pkgs.xdotool
    pkgs.pywal
    pkgs.pywalfox-native

    #font
    pkgs.terminus_font

    # overrided st
    (pkgs.st.overrideAttrs (old: {
      src = ../dotfiles/laptop-nixos/suckless/st-flexipatch;
      buildInputs = old.buildInputs or [] ++ [
        pkgs.imlib2
      ];
    }))

    # overrided slstatus
    (pkgs.slstatus.overrideAttrs {
      src = ../dotfiles/laptop-nixos/suckless/slstatus;
    })

    # overrided slock
    (pkgs.slock.overrideAttrs {
      src = ../dotfiles/laptop-nixos/suckless/slock;
    })
  ];

  xdg.configFile.picom.source = ../dotfiles/laptop-nixos/picom;
  xdg.configFile.rofi.source = ../dotfiles/laptop-nixos/rofi;
  home.file.".xinitrc".source = ../dotfiles/laptop-nixos/xinitrc;

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
