{
  config,
  pkgs,
  lib,
  ...
}:
let
  flakeDirectoryPath = "/home/fellwin/nixos-config/";
  protectedItems = [
    {
      path = "/home/fellwin/nixos-config/test";
      owner = "root";
      group = "root";
      mode = "0444";
      recursive = false;
    }
  ];

  applyAllLines = lib.concatStringsSep "\n" (
    map (item: ''
      apply_protect "${item.path}" "${item.mode}" "${item.owner}" "${item.group}" ${
        if item.recursive then "true" else "false"
      }
    '') protectedItems
  );

  protectScript = pkgs.writeShellScript "protect-immutable" ''
    set -euo pipefail

    apply_protect() {
      local p="$1" m="$2" owner="$3" group="$4" rec="$5"

      # Choix des flags -R
      local RF=""
      if [ "$rec" = "true" ]; then
        RF="-R"
      fi

      if [ -e "$p" ]; then
        ${pkgs.e2fsprogs}/bin/chattr -i $RF "$p" || true
        ${pkgs.coreutils}/bin/chown $RF "''${owner}:''${group}" "$p" || true
        if [ "$rec" = "true" ]; then
          # chmod récursif: -R DOIT venir avant le mode
          ${pkgs.coreutils}/bin/chmod -R "$m" "$p" || true
        else
          ${pkgs.coreutils}/bin/chmod "$m" "$p" || true
        fi
        # Remettre l'immutable
        ${pkgs.e2fsprogs}/bin/chattr +i $RF "$p" || true
      fi
    }

    # Applique à tous les items
    ${applyAllLines}
  '';
in
{
  security.sudo.enable = lib.mkForce true;
  users.users.root.hashedPassword = lib.mkForce "!";

  security.sudo.extraConfig = lib.mkForce ''
    Cmnd_Alias SHELLS = \
        /bin/bash, /usr/bin/bash, /run/current-system/sw/bin/bash, /nix/store/*/bin/bash, \
        /bin/sh, /usr/bin/sh, /run/current-system/sw/bin/sh, /nix/store/*/bin/sh, \
        /run/current-system/sw/bin/dash, /nix/store/*/bin/dash, \
        /run/current-system/sw/bin/csh, /nix/store/*/bin/csh, \
        /run/current-system/sw/bin/tcsh, /nix/store/*/bin/tcsh, \
        /etc/profiles/per-user/fellwin/bin/zsh, /run/current-system/sw/bin/zsh, /nix/store/*/bin/zsh, \
        /etc/profiles/per-user/fellwin/bin/fish, /run/current-system/sw/bin/fish, /nix/store/*/bin/fish, \
        /run/wrappers/bin/su, /nix/store/*/bin/su, \
        /usr/bin/sudoedit, /run/current-system/sw/bin/sudoedit, /nix/store/*/bin/sudoedit, \
        /usr/bin/sudo -i, /run/current-system/sw/bin/sudo -i, /nix/store/*/bin/sudo -i
    Cmnd_Alias FORBIDDEN = /run/current-system/sw/bin/chattr, /nix/store/*/bin/chattr
    Cmnd_Alias FORBIDDEN_REBUILD = /run/current-system/sw/bin/nixos-rebuild, /nix/store/*/bin/nixos-rebuild
    %wheel ALL=(ALL) ALL, !FORBIDDEN, !FORBIDDEN_REBUILD, !SHELLS
  '';

  systemd.services.protect-immutable = lib.mkForce {
    description = "Protect configured paths with chattr +i";
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

  system.activationScripts.apply-immutable-protection.text = lib.mkForce ''
    ${protectScript}
  '';

  system.activationScripts.updateHostsOnSwitch = lib.mkForce ''
    ${pkgs.e2fsprogs}/bin/chattr -i /etc/hosts >/dev/null 2>&1
    rm -f /etc/hosts >/dev/null 2>&1
    ${pkgs.curl}/bin/curl -fSL --retry 3 --connect-timeout 10 -o /etc/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts
    ${pkgs.e2fsprogs}/bin/chattr +i /etc/hosts
  '';

  # nixos-rebuild wrapper
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nixos-rebuild-secure" ''
      #!/usr/bin/env bash
      set -euo pipefail

      ALLOWED="${flakeDirectoryPath}"
      g=$(grep -r '{pkgs.nixos-rebuild}/bin/nixos-rebuild' /home/fellwin/nixos-config/ | wc -l)

      if [ "$EUID" -ne 0 ]; then
        echo "nixos-rebuild should be executed as root" >&2
        exit 1
      fi

      if [[ g -gt 2 ]]
      then
        echo "Error: cant rebuild system, you tried to add another nixos-rebuild wrapper"
        exit 1
      fi

      if [[ " $@ " =~ "--flake" ]]; then
        # extract argument after --flake
        flake_arg=$(echo "$@" | sed -E 's/.*--flake[[:space:]]+([^[:space:]]+).*/\1/')
        if [[ "$flake_arg" != "$ALLOWED" ]]; then
          echo "Error: rebuild you system with --flake ${flakeDirectoryPath}." >&2
          exit 1
        fi
      else
        echo "Error: rebuild you system with --flake ${flakeDirectoryPath}." >&2
        exit 1
      fi

      exec ${pkgs.nixos-rebuild}/bin/nixos-rebuild "$@"
    '')
  ];
  networking.nftables.enable = lib.mkForce true;
  networking.nftables.ruleset = lib.mkForce ''
    table inet filter {
      chain output {
        type filter hook output priority 0;
        # drop tor ports
        tcp dport { 9001, 9030, 9050, 9150 } drop
      }
    }
  '';
}
