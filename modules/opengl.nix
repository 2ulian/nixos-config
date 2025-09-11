{ config, pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      mesa-asahi
    ];
  };
}
