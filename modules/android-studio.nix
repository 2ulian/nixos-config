{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    android-studio
  ];

  # Activer ADB et la gestion des permissions USB
  programs.adb.enable = true;

  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   stdenv.cc.cc
  #   zlib
  #   fuse3
  #   icu
  #   nss
  #   openssl
  #   curl
  #   expat
  # ];

  users.users.fellwin = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
