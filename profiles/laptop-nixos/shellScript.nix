
{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "update" ''
      home-manager switch --flake ~/nixos-config#T480-nixos
      rm -rf ~/.cache/dmenu_run
    '')
  ];
}
