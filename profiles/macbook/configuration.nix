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
    #./apple-silicon-support
    ./hardware-configuration.nix
    <apple-silicon-support/apple-silicon-support>
  ];

  networking.hostName = "mac"; # Define your hostname.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false; # Disable EFI variable modification

  # Force network manager to use iwd instead of wpa_supplicant
  networking.wireless.iwd.enable = true;

  # Add firmware files:
  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    peripheralFirmwareDirectory = /boot/asahi;
  };

  # patched hyprland
  programs.hyprland = {
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # enable opengl
  hardware.graphics.enable = true;

  # Get the fullscreen
  boot.kernelParams = [
    "apple_dcp.show_notch=1"
  ];

  services.auto-cpufreq.enable = lib.mkForce false;

  # Emulate x86 apps on arm
  boot.kernel.sysctl = {"vm.max_map_count" = 262144;};
  nix.settings.extra-platforms = ["x86_64-linux"];
  nix.settings.trusted-users = ["fellwin"];
  boot.binfmt.emulatedSystems = ["x86_64-linux"];
  security.unprivilegedUsernsClone = true;
}
