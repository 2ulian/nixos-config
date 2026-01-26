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
    ../../../modules/android-studio.nix
    /etc/nixos/hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos-hardened;

  # Battery optimisations
  services.thermald.enable = true;

  services.openssh = {
    enable = true;
  };
}
