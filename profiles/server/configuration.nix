{
  config,
  pkgs,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];
  home.username = "server";
  home.homeDirectory = "/home/server";
  home.stateVersion = "26.05"; # Please read the comment before changing.

  networking.hostName = "server";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
