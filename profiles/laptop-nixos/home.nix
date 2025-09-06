{ config, pkgs, lib,... }:

{
  imports = [
    ./shellScript.nix
    ../../home-modules/base.nix
    #../../home-modules/dwm.nix
    ../../home-modules/hyprland/hyprland.nix
    ../../home-modules/hyprland/caelestia.nix
  ];

  xdg.configFile."hypr/hyprland.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/laptop.conf;
  xdg.configFile."hypr/laptop.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/hyprland.conf;

  home.packages = [
  ];
}
