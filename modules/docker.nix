{
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.fellwin.extraGroups = [
    "docker"
  ];
  virtualisation.docker.enable = true;
}
