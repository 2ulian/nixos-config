{
  config,
  pkgs,
  lib,
  oldPkgs,
  stablePkgs,
  x86_64Pkgs,
  ...
}: let
  stremio-xcb = oldPkgs.writeShellScriptBin "stremio" ''
    exec env QT_QPA_PLATFORM=xcb ${oldPkgs.stremio}/bin/stremio "$@"
  '';
in {
  imports = [
    ../../../home-modules/base.nix
    #../../home-modules/dwm.nix
    ../../../home-modules/dwl.nix
  ];

  #xdg.configFile."hypr/hyprland.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/macbook.conf;
  #xdg.configFile."hypr/laptop.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/hyprland.conf;

  home.packages = [
    stremio-xcb
    pkgs.rpcs3
    stablePkgs.azahar
    x86_64Pkgs.spotify

    pkgs.superTuxKart
  ];

  xdg.desktopEntries.stremio = {
    name = "Stremio";
    genericName = "Media Center";
    exec = "stremio %U";
    icon = "${oldPkgs.stremio}/share/pixmaps/stremio.png";
    terminal = false;
    categories = ["Video" "AudioVideo" "Player" "Network"];
    mimeType = ["application/x-mpegURL" "application/vnd.apple.mpegurl" "x-scheme-handler/stremio"];
    comment = "Watch videos, movies, TV series and TV channels instantly";
  };
}
