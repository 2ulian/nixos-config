{ config, pkgs, ... }:
{

  home.packages = [
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    userName  = "Julian";
    userEmail = "rayconstantyjulian@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "2ulian";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
