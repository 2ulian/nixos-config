{
  description = "Home Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, nixgl,... }:
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
      homeConfigurations = {

        T480 = lib.homeManagerConfiguration {
          inherit pkgs;
          # Optionnel (pratique pour accéder à inputs dans tes modules)
          extraSpecialArgs = { inherit spicePkgs; };

          modules = [ 
	    ./home/dwm.nix 
            spicetify-nix.homeManagerModules.spicetify
	  ];
        };

        sirius = lib.homeManagerConfiguration {
          inherit pkgs;
          # Optionnel (pratique pour accéder à inputs dans tes modules)
          extraSpecialArgs = { inherit spicePkgs; };

          modules = [ 
	    ./home/hyprland.nix 
            spicetify-nix.homeManagerModules.spicetify
	  ];
        };
      };
    };
}

