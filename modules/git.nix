{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    config = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
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
