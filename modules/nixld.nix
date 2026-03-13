{pkgs, ...}: {
  #nix-ld with some libraries
  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;
    libraries = with pkgs; [
      glib
      zlib
      openssl
      libX11
      libXext
      libGL
      libxcb
      libXrandr
      libXfixes
      libxshmfence
      libXrender
      libXcomposite
      #gstreamer
      #gst-plugins-base
      #gst-plugins-good

      #android:
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      libgcc
    ];
  };
}
