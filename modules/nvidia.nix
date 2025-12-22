{ config, pkgs, ... }:
{
  # Nvidia graphics
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;
    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    open = false;
  };

  # Luminosity for external display:
  hardware.i2c.enable = true;

  users.users.fellwin.extraGroups = [ "i2c" ];
}
