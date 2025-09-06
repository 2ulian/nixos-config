{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/base.nix
      ../../modules/intel-drivers.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "sirius"; # hostname
}
