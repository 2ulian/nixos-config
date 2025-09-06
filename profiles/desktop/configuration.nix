{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/base.nix
      ../../modules/nvidia.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "sirius"; # hostname
}
