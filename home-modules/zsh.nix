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

      # Configuration of powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # vi mode
      #ZVM_CURSOR_STYLE_ENABLED=true

      # Configuration of historySubstringSearch
      zmodload zsh/terminfo
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down
      bindkey '^[[A' history-substring-search-up
      bindkey '^[OA' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^[OB' history-substring-search-down
      bindkey -M vicmd '^[[A' history-substring-search-up
      bindkey -M vicmd '^[OA' history-substring-search-up
      bindkey -M vicmd '^[[B' history-substring-search-down
      bindkey -M vicmd '^[OB' history-substring-search-down
      bindkey -M viins '^[[A' history-substring-search-up
      bindkey -M viins '^[OA' history-substring-search-up
      bindkey -M viins '^[[B' history-substring-search-down
      bindkey -M viins '^[OB' history-substring-search-down

      # Compile .zshrc into .zshrc.zwc if needed for faster zsh
      if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
        zcompile ~/.zshrc
      fi
    '';

    #shellAliases = {
    #  update = "sudo nixos-rebuild switch --flake ~/dotfiles";
    #};
  };
}
