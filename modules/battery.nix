{ config, pkgs, ... }:
{
  networking.networkmanager.wifi.powersave = true;
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
