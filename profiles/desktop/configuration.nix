{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/base.nix
      ../../modules/nvidia.nix
      ../../modules/gaming.nix
      ./hardware-configuration.nix
    ];

  networking.hostName = "sirius"; # hostname
}
