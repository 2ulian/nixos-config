{
  description = "Home Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    nixpkgs-old,
    home-manager,
    spicetify-nix,
    nix-darwin,
    nix-homebrew,
    ...
  }: let
    systems = {
      x86 = "x86_64-linux";
      arm = "aarch64-linux";
      darwin = "aarch64-darwin";
    };
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    mkPkgs-stable = system:
      import nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    mkPkgs-old = system:
      import nixpkgs-old {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    spicePkgs = spicetify-nix.legacyPackages.${systems.x86};
  in {
    nixosConfigurations = {
      T480 = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs systems.x86;
        system = systems.x86;
        modules = [
          ./profiles/laptop-nixos/configuration.nix
          ./modules/filter.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [spicetify-nix.homeManagerModules.default];
            home-manager.extraSpecialArgs = {inherit spicePkgs;};
            home-manager.users.fellwin = import ./profiles/laptop-nixos/home.nix;
            home-manager.extraSpecialArgs = {
              stablePkgs = mkPkgs-stable systems.arm;
              oldPkgs = mkPkgs-old systems.arm;
            };
          }
        ];
      };

      sirius = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs systems.x86;
        system = systems.x86;
        modules = [
          ./profiles/desktop/configuration.nix
          ./modules/filter.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [spicetify-nix.homeManagerModules.default];
            home-manager.extraSpecialArgs = {inherit spicePkgs;};
            home-manager.users.fellwin = import ./profiles/desktop/home.nix;
            home-manager.extraSpecialArgs = {
              stablePkgs = mkPkgs-stable systems.arm;
              oldPkgs = mkPkgs-old systems.arm;
            };
          }
        ];
      };

      mac = nixpkgs.lib.nixosSystem {
        pkgs = mkPkgs systems.arm;
        system = systems.arm;
        modules = [
          ./profiles/macbook/configuration.nix
          ./modules/filter.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fellwin = import ./profiles/macbook/home.nix;
            home-manager.extraSpecialArgs = {
              stablePkgs = mkPkgs-stable systems.arm;
              oldPkgs = mkPkgs-old systems.arm;
            };
          }
        ];
      };
    };
    darwinConfigurations = {
      mac = nix-darwin.lib.darwinSystem {
        pkgs = mkPkgs systems.darwin;
        system = systems.darwin;
        modules = [
          ./profiles/macos/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "fellwin";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [spicetify-nix.homeManagerModules.default];
            home-manager.extraSpecialArgs = {spicePkgs = spicetify-nix.legacyPackages.${systems.darwin};};
            home-manager.users.fellwin = import ./profiles/macos/home.nix;
          }
        ];
      };
    };
    homeConfigurations = {
      mac = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs systems.darwin;
        modules = [
          {
            imports = [
              ./profiles/macos/home.nix
              spicetify-nix.homeManagerModules.default
            ];
          }
        ];
      };
    };
  };
}
