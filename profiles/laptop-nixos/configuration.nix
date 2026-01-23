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
    ../../modules/grub.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "T480"; # Define your hostname.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Battery optimisations
  services.thermald.enable = true;

  services.openssh = {
    enable = true;
  };
}
