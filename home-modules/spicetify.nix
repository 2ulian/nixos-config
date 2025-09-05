{ config, pkgs, spicePkgs, ... }:
{
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      #adblockify
      shuffle
    ];
    theme = spicePkgs.themes.lucid;
  };
}
