{ lib, illogical-impulse, ... }:

{

  illogical-impulse = {
    # Enable the dotfiles suite
    enable = true;


    # Dotfiles configurations
    dotfiles = {
        fish.enable = false;
        kitty.enable = false;
    };
  };

  # Dont remove my config
  #xdg.configFile."hypr/hyprland.conf" = lib.mkForce { enable = false; };
  #xdg.configFile."hypr" = lib.mkForce enable = false;
  xdg.configFile."fish/config.fish" = lib.mkForce { enable = false; };
  xdg.configFile."quickshell".source = lib.mkForce ../../dotfiles/quickshell;
  gtk.iconTheme = lib.mkForce null;
}
