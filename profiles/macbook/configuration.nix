{
  config,
  pkgs,
  hyprland,
  lib,
  ...
}: {
  imports = [
    ../../modules/base.nix
    ../../modules/battery.nix
    ../../modules/docker.nix
    ./apple-silicon-support
    ./hardware-configuration.nix
  ];

  networking.hostName = "mac"; # Define your hostname.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false; # Disable EFI variable modification

  # Force network manager to use iwd instead of wpa_supplicant
  networking.wireless.iwd.enable = true;

  # Add firmware files:
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = ./firmware;
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  hardware.graphics.enable = true;

  programs.hyprland = {
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  # Get the fullscreen
  boot.kernelParams = [
    #"apple_dcp.show_notch=1"
  ];

  services.auto-cpufreq.enable = lib.mkForce false;
}
