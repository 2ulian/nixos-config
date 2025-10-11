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
      path = "/home/fellwin/nixos-config/modules/filter.nix";
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
  security.doas.enable = lib.mkForce false;
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
    if [ ! -e /var/hosts ]; then
      ${pkgs.curl}/bin/curl -fSL --retry 3 --connect-timeout 10 -o /var/hosts https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn/hosts
      ${pkgs.e2fsprogs}/bin/chattr +i /var/hosts
      echo "ATTENTION: open librewolf/firefox to install extensions and then rebuild system"
    else
      ${pkgs.e2fsprogs}/bin/chattr -i /etc/hosts >/dev/null 2>&1
      rm -f /etc/hosts >/dev/null 2>&1
      cp /var/hosts /etc/hosts
      echo "
        # Chrome Web Store
        0.0.0.0 chrome.google.com
        0.0.0.0 clients.google.com
        0.0.0.0 clients2.google.com
        0.0.0.0 clients4.google.com
        0.0.0.0 clients5.google.com
        0.0.0.0 clients6.google.com
        0.0.0.0 lh3.googleusercontent.com
        0.0.0.0 lh4.googleusercontent.com
        0.0.0.0 lh5.googleusercontent.com
        0.0.0.0 lh6.googleusercontent.com

        # Firefox Add-ons (AMO)
        0.0.0.0 addons.mozilla.org
        0.0.0.0 services.addons.mozilla.org
        0.0.0.0 discovery.addons.mozilla.org
        0.0.0.0 addons.cdn.mozilla.net
        0.0.0.0 aus5.mozilla.org
      " >> /etc/hosts
      ${pkgs.e2fsprogs}/bin/chattr +i /etc/hosts
    fi
  '';

  # nixos-rebuild wrapper
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nixos-rebuild-secure" ''
      #!/usr/bin/env bash
      set -euo pipefail

      require_filter_present() {
        local FLAKE_PATH="''${FLAKE:-/home/fellwin/nixos-config/flake.nix}"

        strip_comments() {
          perl -0777 -pe 's:/\*.*?\*/::gs' "''${1}" | sed 's/#.*$//'
        }

        extract_nixos_configurations_block() {
          awk '
            /nixosConfigurations[[:space:]]*=/ {start=1}
            start {
              depth += gsub(/\{/, "{")
              depth -= gsub(/\}/, "}")
              print
              if (start && depth==0) exit
            }
          '
        }

        discover_hosts() {
          local content block
          content="$(strip_comments "''${FLAKE_PATH}")"
          block="$(printf "%s" "''${content}" | extract_nixos_configurations_block)"
          printf "%s\n" "''${block}" | awk '
            match($0, /^[[:space:]]*([A-Za-z0-9_-]+)[[:space:]]*=[[:space:]]*nixpkgs\.lib\.nixosSystem[[:space:]]*\{/, m) {
              print m[1]
            }
          '
        }

        extract_host_block() {
          local host="''${1}"
          awk -v host="''${host}" '
            $0 ~ "^[[:space:]]*"host"[[:space:]]*=[[:space:]]*nixpkgs\\.lib\\.nixosSystem[[:space:]]*\\{" {inb=1}
            inb {print}
            inb && /};/ {inb=0; exit}
          '
        }

        local -a HOSTS_ARRAY=()
        if [[ -n "''${HOSTS:-}" ]]; then
          # shellcheck disable=SC2206
          HOSTS_ARRAY=(''${HOSTS})
        else
          mapfile -t HOSTS_ARRAY < <(discover_hosts)
        fi

        if [[ "''${#HOSTS_ARRAY[@]}" -eq 0 ]]; then
          echo "Aucun hôte détecté dans nixosConfigurations de ''${FLAKE_PATH}" >&2
          exit 2
        fi

        if [[ ! -f "''${FLAKE_PATH}" ]]; then
          echo "Fichier flake introuvable : ''${FLAKE_PATH}" >&2
          exit 2
        fi

        local content overall=0
        content="$(strip_comments "''${FLAKE_PATH}")"

        for host in "''${HOSTS_ARRAY[@]}"; do
          local block flat
          block="$(printf "%s" "''${content}" | extract_host_block "''${host}")" || true
          flat="$(printf "%s" "''${block}" | tr '\n' ' ')"

          if [[ -z "''${block}" ]]; then
            echo "''${host}: bloc nixpkgs.lib.nixosSystem introuvable." >&2
            overall=1
            continue
          fi

          if printf "%s" "''${flat}" | grep -qE 'modules[[:space:]]*=[[:space:]]*\[[^]]*./modules/filter\.nix'; then
            echo "''${host}: ./modules/filter.nix trouvé (non commenté)"
          else
            echo "''${host}: ./modules/filter.nix NON trouvé (ou commenté/obfusqué)" >&2
            overall=1
          fi
        done

        if [[ "''${overall}" -ne 0 ]]; then
          echo "Au moins une configuration manque l'import non commenté de ./modules/filter.nix. Arrêt." >&2
          exit 1
        fi
      }

      ALLOWED="${flakeDirectoryPath}"
      g=$(grep -r '{pkgs.nixos-rebuild}/bin/nixos-rebuild' /home/fellwin/nixos-config/ | wc -l)

      if [ "$EUID" -ne 0 ]; then
        echo "nixos-rebuild should be executed as root" >&2
        exit 1
      fi

      if [[ $g -gt 2 ]]
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

      require_filter_present

      exec ${pkgs.nixos-rebuild}/bin/nixos-rebuild "$@"
    '')
  ];

  networking.firewall.enable = lib.mkForce false;
  networking.nftables.enable = lib.mkForce true;
  networking.nftables.ruleset = lib.mkBefore ''
    table inet filter {
      chain output {
        type filter hook output priority 0;
        tcp dport { 9001, 9030, 9050, 9150 } drop
        oif "lo" accept
        ct state established,related accept

        udp dport 53 accept
        tcp dport 53 accept

        tcp dport { 80, 443 } accept

        tcp dport { 3128, 8080, 8000, 8888, 8118, 3129, 3130 } drop
        tcp dport { 1080, 9050, 9150 } drop    # socks / tor ports
        udp dport { 3128, 8080, 8000 } drop
      }
    }
  '';

}
