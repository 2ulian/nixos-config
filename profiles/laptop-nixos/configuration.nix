{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/base.nix
      ../../modules/intel-drivers.nix
      ../../modules/battery.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "T480"; # Define your hostname.
}
