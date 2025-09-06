{ config, pkgs, ... }:
{

  home.packages = [
    #pkgs.grc
    pkgs.lsd
  ];

  # enable fish
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      #set fish_greeting # Disable greeting
    '';

    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      #{ name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages.src; }
    ];
  };

  # shellAliases
  xdg.configFile."fish/conf.d/10-aliases.fish".text = ''
    alias ls="lsd"
    alias ll="lsd -l"
    alias vim="nvim"
  '';

  xdg.configFile."fish/conf.d/00-greeting.fish".text = ''
    set fish_greeting # Disable greeting
  '';
}
