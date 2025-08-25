{ config, pkgs, spicePkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "fellwin";
  home.homeDirectory = "/home/fellwin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  imports = [
    ./librewolf.nix
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # fonts (run "fc-cache -f" if the system dont detect the nerd font):
    pkgs.nerd-fonts.jetbrains-mono

    # other packages:
    pkgs.fzf
    pkgs.vim
    pkgs.neovim
    pkgs.fastfetch
    pkgs.vlc
    pkgs.btop
    pkgs.openssl
    pkgs.rustc
    pkgs.keepassxc
    pkgs.obsidian
    pkgs.vesktop
    pkgs.stremio
    pkgs.syncthing
    pkgs.kitty
    pkgs.nemo-with-extensions
    pkgs.file-roller
    pkgs.nemo-fileroller
    pkgs.parsec-bin
    pkgs.qbittorrent-enhanced
    pkgs.libreoffice-qt6
    pkgs.eclipses.eclipse-java
    pkgs.jdk17
    pkgs.lazygit

    #pkgs.gnome-keyring
    #pkgs.libsecret
    pkgs.gnupg
    pkgs.pass
    pkgs.pass-secret-service


    # Compressor/Extraction utilities
    pkgs.zip
    pkgs.p7zip
    pkgs.unzip
    pkgs.unrar
    pkgs.xz

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    #(pkgs.writeShellScriptBin "cache_update" ''
    #  rm -rf ~/.cache/dmenu_run
    #'')
  ];

  programs.git = {
    enable = true;
    userName  = "Julian";
    userEmail = "rayconstantyjulian@gmail.com";
    package = pkgs.git.override { withLibsecret = true; };
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "libsecret";
    };
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      #adblockify
      shuffle
    ];
    theme = spicePkgs.themes.hazy;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    # VSCode extensions
    profiles.default.extensions = with pkgs.vscode-extensions; [
      esbenp.prettier-vscode
        vscodevim.vim
    ];

    # Tu peux aussi ajouter des extensions depuis nixpkgs non packagées avec :
    # pkgs.vscode-utils.extensionsFromVscodeMarketplace
    # si tu veux une extension spécifique.
  };

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
    '';

    #shellAliases = {
    #  update = "sudo nixos-rebuild switch --flake ~/dotfiles";
    #};
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/fellwin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
