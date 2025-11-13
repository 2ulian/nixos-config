{
  config,
  pkgs,
  lib,
  homebrew,
  ...
}: {
  imports = [
  ];

  #networking.hostName = "mac"; # Define your hostname.

system.primaryUser = "fellwin";

environment.systemPackages = [
  ];

system = {
  defaults = {
    dock.autohide = true;
  };
  keyboard = {
      enableKeyMapping = true;
  };
};
  # disable spotlight
  system.defaults.CustomUserPreferences = {
    "com.apple.symbolichotkeys" = {
      AppleSymbolicHotKeys = {
        "64" = { enabled = false; };
        "65" = { enabled = false; };
      };
    };
  };

  launchd.user.agents.aerospace = {
    #command = "${pkgs.aerospace}/bin/aerospace";
    # Nom du binaire — ajuste selon ton installation
    command = "/etc/profiles/per-user/${builtins.getEnv "USER"}/bin/aerospace";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Interactive";
    };
  };


homebrew = {
enable = true;
casks = [
"raycast"
"ghostty"
"stremio"
"firefox"
];
onActivation.cleanup = "zap";
onActivation.autoUpdate = true;
onActivation.upgrade = true;
};

system.stateVersion = 6;
}
