{
  config,
  pkgs,
  lib,
  ...
}: {
  home.homeDirectory = lib.mkForce "/Users/fellwin";
  imports = [
    ../../../home-modules/base.nix
    ../../../home-modules/spicetify.nix
  ];

  home.packages = [
    pkgs.aerospace
  ];
}
