{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.lsd
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
      ignoreSpace = true;
    };

    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
    ];

    # .zshrc
    initContent = ''
      # pywal
      (cat ~/.cache/wal/sequences &)

      # emacs mode
      bindkey -e

      # Configuration of powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Configuration of historySubstringSearch
      zmodload zsh/terminfo
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down
      #bindkey '^[[A' history-substring-search-up
      #bindkey '^[OA' history-substring-search-up
      #bindkey '^[[B' history-substring-search-down
      #bindkey '^[OB' history-substring-search-down
    '';

    shellAliases = {
      vim = "nvim";
      ls = "lsd";
      ll = "lsd -l";
      update = "sudo nixos-rebuild switch --flake ~/nixos-config/ --impure";
      vpniut = "sudo openfortivpn u-vpn-plus.unilim.fr --saml-login";
    };
  };
}
