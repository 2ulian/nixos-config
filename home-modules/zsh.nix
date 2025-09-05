{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    #plugins = [
    #  {
      #    name = "zsh-vi-mode";
      #    src = pkgs.zsh-vi-mode;
      #    file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      #  }
    #];

    # .zshrc
    initContent = ''
      # pywal
      (cat ~/.cache/wal/sequences &)

      # to not get the vim mode
      bindkey -e

      # Configuration of powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # vi mode
      #ZVM_CURSOR_STYLE_ENABLED=true

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
    #  update = "sudo nixos-rebuild switch --flake ~/dotfiles";
      vim = "nvim";
    };

  };
}
