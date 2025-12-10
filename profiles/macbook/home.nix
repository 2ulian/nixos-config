{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../home-modules/base.nix
    ../../home-modules/dwm.nix
    ../../home-modules/hyprland/hyprland.nix
    #../../home-modules/hyprland/caelestia.nix
    ../../home-modules/hyprland/illogical-impulse.nix
  ];

  xdg.configFile."hypr/hyprland.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/macbook.conf;
  xdg.configFile."hypr/laptop.conf".source = lib.mkOverride 10 ../../dotfiles/hypr/hyprland.conf;

  home.packages = [
  ];
}
