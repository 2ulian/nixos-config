{ config, pkgs, ... }:

{
  imports = [
    ./shellScript.nix
    ../../home-modules/base.nix
    ../../home-modules/dwm.nix
  ];

  home.packages = [
  ];
}
