{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.metasploit
    pkgs.nmap
    pkgs.openvpn
    pkgs.postgresql
  ];
}
