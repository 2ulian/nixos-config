{ config, pkgs, ... }:

{

  # Activer l'émulation x86_64 dans Docker via QEMU
  virtualisation.docker.enable = true;
  #virtualisation.docker.emulateArchs = [ "x86_64-linux" ];
}
