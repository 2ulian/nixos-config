{
  description = "Home Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixgl.url = "github:nix-community/nixGL";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, nixgl, caelestia-shell, ... }:
    let
      system = "x86_64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
      };
      lib = home-manager.lib;
      spicePkgs = spicetify-nix.legacyPackages.${system};
    in {

      nixosConfigurations = {
        T480 = nixpkgs.lib.nixosSystem {
          #inherit system;
          system = "x86_64-linux";
          modules = [
            ./modules/configuration.nix
          ];
        };
      };

      homeConfigurations = {

        T480 = lib.homeManagerConfiguration {
          inherit pkgs;
          # Optionnel (pratique pour accéder à inputs dans tes modules)
          extraSpecialArgs = { inherit spicePkgs; };

          modules = [ 
	          ./profiles/laptop/laptop.nix 
                  spicetify-nix.homeManagerModules.spicetify
	        ];
        };

        desktop = lib.homeManagerConfiguration {
          inherit pkgs;
          # Optionnel (pratique pour accéder à inputs dans tes modules)
          extraSpecialArgs = { inherit spicePkgs; };

          modules = [ 
	          ./profiles/desktop/home.nix 
                  spicetify-nix.homeManagerModules.spicetify
	        ];
        };
        T480-nixos = lib.homeManagerConfiguration {
          inherit pkgs;
          # Optionnel (pratique pour accéder à inputs dans tes modules)
          extraSpecialArgs = { inherit spicePkgs; };

          modules = [ 
	          ./profiles/laptop-nixos/home.nix 
                  spicetify-nix.homeManagerModules.spicetify
                  caelestia-shell.homeManagerModules.default
	        ];
        };
      };
    };
}

