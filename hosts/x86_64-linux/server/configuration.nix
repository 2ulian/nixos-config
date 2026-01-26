{
  config,
  pkgs,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.server = {
    isNormalUser = true;
    description = "server";
    extraGroups = [
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  boot.loader.systemd-boot.enable = true;

  time.timeZone = "Europe/Paris";

  boot.kernelPackages = pkgs.linuxPackages_hardened;

  services.openssh.enable = true;

  networking = {
    useDHCP = false;
    interfaces.nominterface.useDHCP = false;
    interfaces.nominterface.ipv4.addresses = [
      {
        address = "192.168.1.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.1.1";
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  # fileSystems."/home/fellwin/data" = {
  #   device = "/dev/disk/by-uuid/7691b034-9844-41b8-b76c-6d7927e98462";
  #   fsType = "ext4";
  #   options = [
  #     # If you don't have this options attribute, it'll default to "defaults"
  #     # boot options for fstab. Search up fstab mount options you can use
  #     "users" # Allows any user to mount and unmount
  #     "nofail" # Prevent system from failing if this drive doesn't mount
  #     "exec" # Allow execution of binaries and scripts (required for Steam)
  #   ];
  # };
  system.stateVersion = "26.05"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
