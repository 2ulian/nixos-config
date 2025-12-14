{
  config,
  pkgs,
  lib,
  ...
}: let
  wlrootsPkg =
    if pkgs ? wlroots_0_19
    then pkgs.wlroots_0_19
    else if pkgs ? wlroots_0_18
    then pkgs.wlroots_0_18
    else pkgs.wlroots;

  wlrootsPc =
    if pkgs ? wlroots_0_19
    then "wlroots-0.19"
    else if pkgs ? wlroots_0_18
    then "wlroots-0.18"
    else "wlroots";

  dwl-custom = pkgs.dwl.overrideAttrs (old: {
    src = pkgs.fetchFromGitHub {
      owner = "2ulian";
      repo = "dwl";
      rev = "main";
      hash = "sha256-StmO1zA53ussHG6G+gmhmgR920D5aQZU0nupXXMmLK4=";
    };

    # s’assure que wlroots est bien dans l'env de build
    buildInputs =
      (old.buildInputs or [])
      ++ [
        wlrootsPkg
        pkgs.fcft
        pkgs.libdrm
        pkgs.dbus
      ];

    # force le Makefile de ton repo à utiliser le bon pkg-config name
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace Makefile \
          --replace "wlroots-0.19" "${wlrootsPc}" \
          --replace "wlroots-0.18" "${wlrootsPc}"

      '';
    # cp ${../dotfiles/config.def.h} config.def.h
  });
in {
  home.packages = [
    # required packages for hyprland:
    pkgs.brillo
    pkgs.hyprshot
    pkgs.hyprlock
    pkgs.hyprshade
    pkgs.hyprpicker
    pkgs.hyprpolkitagent
    pkgs.apple-cursor
    pkgs.foot
    pkgs.rofi-unwrapped

    #required for wallpapers:
    pkgs.mpvpaper
    pkgs.imagemagick
    pkgs.swww
    pkgs.pywal
    pkgs.pywalfox-native

    # To have all icons
    pkgs.adwaita-icon-theme

    dwl-custom
    pkgs.wlr-randr
    pkgs.brightnessctl
    pkgs.terminus_font
    pkgs.tofi
    pkgs.wmenu
    pkgs.wtype

    # overrided slstatus
    (pkgs.slstatus.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          cp ${../dotfiles/laptop-nixos/suckless/slstatus/config.h} config.h
        '';
    }))
  ];

  #foot configuration
  xdg.configFile.foot.source = ../dotfiles/foot;

  # pywal configuration
  xdg.configFile."wal/hooks".source = ../dotfiles/wal/hooks;
  xdg.configFile."wal/templates".source = ../dotfiles/wal/templates;

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "foot";
        # exec-arg = ""; # argument
      };
    };
  };

  # GTK Theming
  gtk.cursorTheme = {
    name = "macOS";
    package = pkgs.apple-cursor;
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  # .zprofile for dwl autologin
  # home.file.".zprofile".text = ''
  #   # only launch hyprland if there is no other services
  #   if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "''${XDG_VTNR:-0}" -eq 1 ] && [ -z "$TMUX" ]
  #   then
  #     exec dwl
  #   fi
  # '';
}
