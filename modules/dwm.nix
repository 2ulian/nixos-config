{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "fr";
    displayManager.startx.enable = true;
  };


  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    xorg.libX11
    wireplumber
    pipewire
  ];

  # Add permission to video group to modify backlight
  services.udev.packages = [ pkgs.acpilight ];

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = ../dotfiles/laptop-nixos/suckless/dwm;
    };
  };
}
