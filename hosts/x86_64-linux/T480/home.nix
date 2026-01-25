{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../../home-modules/base.nix
    ../../../home-modules/spicetify.nix
    ../../../home-modules/dwl.nix
    ../../../home-modules/android.nix
  ];

  # xdg.configFile."hypr/hyprland.conf".source = lib.mkOverride 10 ../../../dotfiles/hypr/laptop.conf;
  # xdg.configFile."hypr/laptop.conf".source = lib.mkOverride 10 ../../../dotfiles/hypr/hyprland.conf;

  home.packages = [
  ];
}
