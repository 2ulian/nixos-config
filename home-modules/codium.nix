{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    # VSCode extensions
    profiles.default.extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode
      vscodevim.vim
      ritwickdey.liveserver
    ];

    # Tu peux aussi ajouter des extensions depuis nixpkgs non packagées avec :
    # pkgs.vscode-utils.extensionsFromVscodeMarketplace
    # si tu veux une extension spécifique.
  };
}
