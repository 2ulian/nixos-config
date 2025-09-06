{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  programs.gamemode.enable = true;
  programs.steam.gamescopeSession.enable = true;
}
