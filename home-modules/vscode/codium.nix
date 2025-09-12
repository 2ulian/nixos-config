{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    # VSCode extensions
    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        esbenp.prettier-vscode
        vscodevim.vim
        ritwickdey.liveserver
        github.copilot

        # Extensions for web devlopment
        # General
        alefragnani.project-manager
        christian-kohler.path-intellisense
        yzhang.markdown-all-in-one
        # Environnment Dev
        # sftp
        ms-vscode-remote.remote-ssh
        cweijan.vscode-database-client2
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        ms-vsliveshare.vsliveshare
        formulahendry.auto-rename-tag
        # PHP
        xdebug.php-debug
        bmewburn.vscode-intelephense-client
        # JS
        dbaeumer.vscode-eslint
        # es6
        # TWIG
        # twig 1
        # twig 2
      ])
      ++ (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "sftp";
          publisher = "natizyskunk";
          version = "1.16.3";
          hash = "sha256-HifPiHIbgsfTldIeN9HaVKGk/ujaZbjHMiLAza/o6J4=";
        }
        {
          name = "javascriptsnippets";
          publisher = "xabikos";
          version = "1.8.0";
          hash = "sha256-ht6Wm1X7zien+fjMv864qP+Oz4M6X6f2RXjrThURr6c=";
        }
        {
          name = "twig-language";
          publisher = "mblode";
          version = "0.9.4";
          hash = "sha256-TZRjodIQkgFlPlMaZs3K8Rrcl9XCUaz4/vnIaxU+SSA=";
        }
        {
          name = "twig-language-2";
          publisher = "mblode";
          version = "0.9.4";
          hash = "sha256-JbcygVMAsjF+jWZ7AlxkR+Q7skX1VYvgc0veSA1vsiU=";
        }
      ]);
  };
}
