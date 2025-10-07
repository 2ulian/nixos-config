{
  config,
  pkgs,
  lib,
  ...
}:

let
  flakePath = "/home/fellwin/nixos-config/flake.nix";

  protectScript = pkgs.writeShellScript "protect-flake" ''
    set -euo pipefail
    if [ -e "${flakePath}" ]; then
      ${pkgs.coreutils}/bin/chown root:root "${flakePath}"
      ${pkgs.e2fsprogs}/bin/chattr -i "${flakePath}"
      ${pkgs.coreutils}/bin/chmod 0444 "${flakePath}"
      ${pkgs.e2fsprogs}/bin/chattr +i "${flakePath}"
    fi
  '';
in
{
  security.sudo.enable = true;

  # Block chattr via sudo
  security.sudo.extraConfig = ''
    # Interdire "chattr" à tous via sudo
    Cmnd_Alias FORBIDDEN = /run/current-system/sw/bin/chattr
    ALL ALL=(ALL) ALL, !FORBIDDEN
  '';

  # systemd service to chattr +i on files
  systemd.services.protect-flake-nixos = {
    description = "Protect ${flakePath} (set immutable bit)";
    wantedBy = [ "multi-user.target" ];
    after = [
      "local-fs.target"
      "home.mount"
    ];
    requires = [ "home.mount" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = protectScript;
    };
  };

  # if file is regenerated
  system.activationScripts.apply-flake-protection.text = ''
    if [ -e "${flakePath}" ]; then
      ${pkgs.coreutils}/bin/chown root:root "${flakePath}" || true
      ${pkgs.e2fsprogs}/bin/chattr -i "${flakePath}"
      ${pkgs.coreutils}/bin/chmod 0444 "${flakePath}" || true
      ${pkgs.e2fsprogs}/bin/chattr +i "${flakePath}" || true
    fi
  '';
}
