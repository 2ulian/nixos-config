{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/base.nix
    ../../modules/intel-drivers.nix
    ../../modules/battery.nix
    ../../modules/gaming.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "T480"; # Define your hostname.

  # Battery optimisations
  services.thermald.enable = true;
}
