{
  config,
  pkgs,
  lib,
  ...
}: let
  devPkgs = with pkgs; [
    zlib.dev
    glib.dev
    gtk3.dev
    webkitgtk_4_1.dev
    cairo.dev
    pango.dev
    gdk-pixbuf.dev
    atk.dev
    libsoup_3.dev
    harfbuzz.dev
  ];
in {
  home.packages = with pkgs; [
    pkg-config
    zlib # runtime/libz.so
    glib
    gtk3
    webkitgtk_4_1
    cairo
    pango
    gdk-pixbuf
    atk
    libsoup_3
    harfbuzz
    # vuejs dependencies
    pnpm
    vite
  ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = lib.makeSearchPathOutput "dev" "lib/pkgconfig" devPkgs;
    # Aide le linker hors devShell (pas nécessaire si tu utilises mkShell/direnv)
    LIBRARY_PATH = lib.makeLibraryPath [pkgs.zlib];
    LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.zlib];
  };
}
