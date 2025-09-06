{ config, pkgs, ... }:
{
  # service to show battery information
  services.upower.enable = true;

  # NetworkManager powersave
  networking.networkmanager.wifi.powersave = true;

  # Battery optimisations
  services.thermald.enable = true;

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
     governor = "powersave";
     turbo = "never";
    };
    charger = {
     governor = "performance";
     turbo = "auto";
    };
  };
}
