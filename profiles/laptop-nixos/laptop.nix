{ config, pkgs, ... }:

{
  imports = [
    ../base.nix
    ./shellScript.nix
    ../../home-modules/dwm.nix
    ../../home-modules/hyprland.nix
  ];

  home.packages = [
  ];
}
