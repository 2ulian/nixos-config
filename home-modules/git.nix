{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "rayconstantyjulian@gmail.com";
        name = "Julian";
      };
      init.defaultBranch = "main";
    };
  };
}
