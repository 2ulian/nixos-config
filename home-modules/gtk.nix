{
  config,
  pkgs,
  lib,
  ...
}:
{
  # GTK Theming
  gtk = {
    enable = true;
    theme = {
      name = "Flat-Remix-GTK-Blue-Darkest";
      package = pkgs.flat-remix-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}
