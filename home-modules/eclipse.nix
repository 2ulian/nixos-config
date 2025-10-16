{
  config,
  pkgs,
  ...
}: let
  jdkWithFX = pkgs.openjdk21.override {
    enableJavaFX = true; # for JavaFX
    # include following line if JavaFX with Webkit is needed
    openjfx_jdk = pkgs.openjfx21.override {withWebKit = true;};
  };
in {
  programs.eclipse = {
    enable = true;
    package = pkgs.eclipses.eclipse-java;
  };
  home.packages = with pkgs; [
    jdkWithFX
    graphviz
  ];
}
