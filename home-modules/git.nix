{ config, pkgs, ... }:
{

  home.packages = [
    pkgs.gnupg
    pkgs.pass
    pkgs.pass-secret-service
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    userName  = "Julian";
    userEmail = "rayconstantyjulian@gmail.com";
    package = pkgs.git.override { withLibsecret = true; };
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "libsecret";
    };
  };
}
