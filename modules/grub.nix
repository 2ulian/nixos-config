{
  pkgs,
  lib,
  ...
}: let
  minegrubThemeSrc = pkgs.fetchFromGitHub {
    owner = "Lxtharia";
    repo = "minegrub-theme";
    rev = "dev";
    sha256 = "sha256-GvlAAIpM/iZtl/EtI+LTzEsQ2qlUkex9i4xRUZXmadM=";
  };

  minegrubTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "minegrub-theme";
    version = "dev";

    src = minegrubThemeSrc;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./* $out/

      # adapte le chemin si le thème attend un fichier précis
      # ici on force background.png à la racine (ou dans le dossier du thème)
      cp "${minegrubThemeSrc}/background_options/1.16 - [Nether Update].png" \
         "$out/minegrub/background.png"

      runHook postInstall
    '';
  };
in {
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = false;
      theme = "${minegrubTheme}/minegrub";
      extraEntries = ''
        menuentry "Qubes OS" {
          insmod part_gpt
          insmod fat
          insmod chain
          insmod efi_gop
          search --file --set=root /EFI/qubes/grubx64.efi
          chainloader /EFI/qubes/grubx64.efi
        }
        menuentry "Firmware Settings" {
          fwsetup
        }
      '';
    };
  };
}
