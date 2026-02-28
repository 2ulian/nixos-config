{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    lazydocker
  ];

  users.users.fellwin.extraGroups = [
    "docker"
  ];

  virtualisation.docker.enable = true;
}
