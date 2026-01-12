{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules/base.nix
    ../../modules/battery.nix
    #../../modules/dwm.nix
    #./apple-silicon-support
    ./hardware-configuration.nix
    <apple-silicon-support/apple-silicon-support>
  ];

  networking.hostName = "mac"; # Define your hostname.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false; # Disable EFI variable modification

  # Force network manager to use iwd instead of wpa_supplicant
  networking.wireless.iwd.enable = false;
  networking.wireless.enable = lib.mkForce true;

  # Add firmware files:
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = /boot/asahi;
  };

  # enable opengl
  hardware.graphics.enable = true;

  # Get the fullscreen
  # boot.kernelParams = [
  #   "apple_dcp.show_notch=1"
  # ];

  services.auto-cpufreq.enable = lib.mkForce false;
  boot.binfmt.emulatedSystems = ["x86_64-linux" "i686-linux"];
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = 1;
}
