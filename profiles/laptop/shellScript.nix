
{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "dmenu_run" ''
      dmenu_path | dmenu "$@" | run_nixGL &
    '')

    (pkgs.writeShellScriptBin "run_nixGL" ''
      read input

      nix=$(which $input 2>/dev/null| grep nix)

      if [[ $nix != "" ]]
      then
        nixGLIntel $input &
        exit 0
      fi

      which $input 2>/dev/null

      if [[ $? -eq 0 ]]
      then
        $input &
        exit 0
      fi
    '')

    (pkgs.writeShellScriptBin "update" ''
      home-manager switch --flake ~/nixos-config#T480
      rm -rf ~/.cache/dmenu_run
    '')

    #(pkgs.writeShellScriptBin "picom" ''
    #  nixGLIntel ${pkgs.picom}/bin/picom
    #'')
  ];
}
