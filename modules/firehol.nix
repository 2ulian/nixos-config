{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #make
    firehol
    ddcutil
  ];

  environment.etc."firehol/firehol.conf".text = ''
    version 6

    transparent_proxy "80" 3129 "nobody root squid"
    transparent_proxy "443" 3130 "nobody root squid"
    interface any world
      client all accept
  '';
}
