{pkgs, ...}: {
  #nix-ld with some libraries
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
    libraries = with pkgs; [
      glib
      zlib
      openssl
      xorg.libX11
      xorg.libXext
      libGL
      xorg.libxcb
      xorg.libXrandr
      xorg.libXfixes
      xorg.libxshmfence
      xorg.libXrender
      xorg.libXcomposite
      #gstreamer
      #gst-plugins-base
      #gst-plugins-good
    ];
  };
}
