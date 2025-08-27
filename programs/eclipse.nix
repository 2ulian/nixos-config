{ config, pkgs, ... }:
{
  programs.eclipse = {
    enable = true;
    package = pkgs.eclipses.eclipse-java;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };
}
