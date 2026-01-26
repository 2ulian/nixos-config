{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../modules/base.nix
    ../../../modules/intel-drivers.nix
    ../../../modules/battery.nix
    ../../../modules/gaming.nix
    ../../../modules/grub.nix
    /etc/nixos/hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Battery optimisations
  services.thermald.enable = true;

  services.openssh = {
    enable = true;
  };
}
