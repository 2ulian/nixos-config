{
  config,
  pkgs,
  ...
}: let
  jdkWithFX = pkgs.openjdk17.override {
    enableJavaFX = true; # for JavaFX
    # include following line if JavaFX with Webkit is needed
    openjfx_jdk = pkgs.openjfx17.override {withWebKit = true;};
  };
in {
  programs.eclipse = {
    enable = true;
    package = pkgs.eclipses.eclipse-java;
  };
  home.packages = with pkgs; [
    jdkWithFX
  ];
}
