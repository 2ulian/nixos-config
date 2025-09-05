{ config, pkgs, ... }:

{
  imports = [
    ./shellScript.nix
    ../../home-modules/base.nix
    #../../home-modules/dwm.nix
    ../../home-modules/hyprland/hyprland.nix
    ../../home-modules/hyprland/caelestia.nix
  ];

  home.packages = [
  ];
}
