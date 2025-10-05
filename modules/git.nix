{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    extraConfig = {
      credential.helper = "libsecret";
    };
  };

  services.gnome.gnome-keyring.enable = true;

  security.pam.services = {
    login.enableGnomeKeyring = true; # console/tty
  };

  environment.systemPackages = with pkgs; [
    libsecret
    seahorse
  ];
}
