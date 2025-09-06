{ lib, pkgs, ... }:

{


  home.packages = with pkgs; [

    quickshell

    # Qt / KDE
    kdePackages.kdialog
    kdePackages.qt5compat
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qtpositioning
    kdePackages.qtquicktimeline
    kdePackages.qtsensors
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.qttranslations
    kdePackages.qtvirtualkeyboard
    kdePackages.qtwayland
    kdePackages.syntax-highlighting
    kdePackages.breeze

    #font
    material-symbols
    google-fonts

    # wallpaper switcher utils
    xdg-user-dirs
    bc
    jq
    gsettings-qt
    matugen
  ];

  xdg.configFile."quickshell".source = ../../dotfiles/quickshell;

}
