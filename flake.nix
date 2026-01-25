{
  description = "Fully Dynamic Hybrid Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-25.05";
    chaotic.url = "github:chaotic-cx/nyx";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;
    darwinLib = nix-darwin.lib;

    defaultUser = "fellwin";

    mkPkgs = system: src:
      import src {
        inherit system;
        config.allowUnfree = true;
      };

    #Builder NixOS
    mkNixos = system: hostname:
      lib.nixosSystem {
        inherit system;
        pkgs = mkPkgs system inputs.nixpkgs;
        specialArgs = {
          inherit inputs;
          stablePkgs = mkPkgs system inputs.nixpkgs-stable;
          oldPkgs = mkPkgs system inputs.nixpkgs-old;
        };
        modules = [
          (./hosts + "/${system}/${hostname}/configuration.nix") # Import dynamique via le chemin
          inputs.chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${defaultUser} = import (./hosts + "/${system}/${hostname}/home.nix");
            home-manager.extraSpecialArgs = {
              inherit inputs;
              spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
              stablePkgs = mkPkgs system inputs.nixpkgs-stable;
              oldPkgs = mkPkgs system inputs.nixpkgs-old;
            };
            home-manager.sharedModules = [inputs.spicetify-nix.homeManagerModules.default];
          }
        ];
      };

    #Builder Darwin
    mkDarwin = system: hostname:
      darwinLib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          (./hosts + "/${system}/${hostname}")
          inputs.nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = defaultUser;
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${defaultUser} = import (./hosts + "/${system}/${hostname}/home.nix");
            home-manager.extraSpecialArgs = {
              inherit inputs;
              spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
            };
            home-manager.sharedModules = [inputs.spicetify-nix.homeManagerModules.default];
          }
        ];
      };

    scanHosts = path: builder: let
      dir = builtins.readDir path;
      validHosts = lib.filterAttrs (name: type: type == "directory") dir;
    in
      lib.mapAttrs (name: _: builder (baseNameOf path) name) validHosts;

    pathX86Linux = ./hosts/x86_64-linux;
    pathArmLinux = ./hosts/aarch64-linux;
    pathArmDarwin = ./hosts/aarch64-darwin;
  in {
    nixosConfigurations =
      (scanHosts pathX86Linux mkNixos)
      // (scanHosts pathArmLinux mkNixos);

    darwinConfigurations =
      scanHosts pathArmDarwin mkDarwin;
  };
}
