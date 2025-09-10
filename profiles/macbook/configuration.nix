{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/base.nix
    ../../modules/battery.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "mac"; # Define your hostname.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false; # Disable EFI variable modification
}
