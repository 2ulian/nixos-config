
{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "homeupdate" ''
      home-manager switch --flake ~/nixos-config#sirius
    '')

    (pkgs.writeShellScriptBin "nixupdate" ''
      sudo nixos-rebuild switch --flake ~/nixos-config#sirius
    '')
  ];
}
