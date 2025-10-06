{ config, pkgs, ... }:
{

  home.packages = [
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    userName = "Julian";
    userEmail = "rayconstantyjulian@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
