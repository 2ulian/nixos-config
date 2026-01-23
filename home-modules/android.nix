{ config, pkgs, lib, ... }:

let
  android = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
    buildToolsVersions = [ "34.0.0" ];
    abiVersions = [ "x86_64" ];
    includeEmulator = true;
    includeSystemImages = true;
  };
in
{
  ############################
  # Android SDK licenses
  ############################
  nixpkgs.config.android_sdk.accept_license = true;

  ############################
  # Packages
  ############################
  home.packages = with pkgs; [
    android-studio
    android.androidsdk
    android-tools   # adb, fastboot
    jdk17
  ];

  ############################
  # Environment variables
  ############################
  home.sessionVariables = {
    ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = "${android.androidsdk}/libexec/android-sdk";
    JAVA_HOME = "${pkgs.jdk17}";

    # Hyprland / Wayland: avoid emulator GPU crashes
    QT_QPA_PLATFORM = "wayland;xcb";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  ############################
  # Gradle cache (optional but clean)
  ############################
  home.file.".gradle/gradle.properties".text = ''
    org.gradle.jvmargs=-Xmx4g
    android.useAndroidX=true
    android.enableJetifier=true
  '';

  ############################
  # Android Studio launcher helper
  ############################
  home.file.".local/bin/android-studio-wayland" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      exec android-studio \
        --disable-gpu \
        --nosplash "$@"
    '';
  };

  ############################
  # PATH extension
  ############################
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
