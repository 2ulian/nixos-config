{ config, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.mullvad
  ];
  services.mullvad-vpn.enable = true;
}
