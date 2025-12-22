{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/base.nix
      ../../modules/nvidia.nix
      ../../modules/gaming.nix
      ../../modules/grub.nix
      /etc/nixos/hardware-configuration.nix
    ];

  networking.hostName = "sirius"; # hostname

  fileSystems."/home/fellwin/data" = {
    device = "/dev/disk/by-uuid/7691b034-9844-41b8-b76c-6d7927e98462";
    fsType = "ext4";
    options = [ # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec" # Allow execution of binaries and scripts (required for Steam)
    ];
  };
}
