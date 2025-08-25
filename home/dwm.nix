{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
  ];

  home.packages = [
    #paquet systeme
    pkgs.nixgl.nixGLIntel
    pkgs.redshift
    pkgs.brillo
    pkgs.flameshot

    # wallpaper
    pkgs.rofi
    pkgs.xwinwrap
    pkgs.mpv
    pkgs.xdotool
    pkgs.pywal
    pkgs.pywalfox-native

    pkgs.steam

    #font
    pkgs.terminus_font

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    (pkgs.writeShellScriptBin "cache_update" ''
      rm -rf ~/.cache/dmenu_run
    '')

    (pkgs.writeShellScriptBin "dmenu_run_nix" ''
      dmenu_path | dmenu "$@" | run_nixGL &
    '')

    (pkgs.writeShellScriptBin "run_nixGL" ''
      read input

      nix=$(which $input 2>/dev/null| grep nix)

      if [[ $nix != "" ]]
      then
        nixGLIntel $input &
        exit 0
      fi

      which $input 2>/dev/null

      if [[ $? -eq 0 ]]
      then
        echo "Launching base app..."
        $input &
        exit 0
      fi
    '')
  ];

  programs.zsh = {
    shellAliases = {
      update = "home-manager switch --flake ~/dotfiles#T480";
    };
  };

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

  # GTK Theming
  gtk = {
    enable = true;
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    #cursorTheme = {
    #  name = "Bibata-Modern-Ice";
    #  package = pkgs.bibata-cursors;
    #};
  };

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
