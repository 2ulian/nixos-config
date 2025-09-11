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
    hyprland.url = "github:gulafaran/Hyprland?ref=rendernode";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    spicetify-nix,
    nixgl,
    caelestia-shell,
    hyprland,
    ...
  }: let
    system = "x86_64-linux";
    systemArch = "aarch64-linux";
    #pkgs = nixpkgs.legacyPackages.${system};
    pkgs2 = import nixpkgs {
      inherit system;
      overlays = [nixgl.overlay];
    };
    pkgs = nixpkgs.legacyPackages.${systemArch};
    lib = home-manager.lib;
    spicePkgs = spicetify-nix.legacyPackages.${system};
    spicePkgsArch = spicetify-nix.legacyPackages.${systemArch};
  in {
    nixosConfigurations = {
      T480 = nixpkgs.lib.nixosSystem {
        #inherit system;
        system = "x86_64-linux";
        modules = [
          ./profiles/laptop-nixos/configuration.nix
        ];
      };

      sirius = nixpkgs.lib.nixosSystem {
        #inherit system;
        system = "x86_64-linux";
        modules = [
          ./profiles/desktop/configuration.nix
        ];
      };

      mac = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit spicePkgsArch hyprland;};
        modules = [
          ./profiles/macbook/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [spicetify-nix.homeManagerModules.default];
            home-manager.extraSpecialArgs = {inherit spicePkgsArch;};
            home-manager.users.fellwin = import ./profiles/macbook/home.nix;
          }
        ];
      };
    };

    homeConfigurations = {
      sirius = lib.homeManagerConfiguration {
        inherit pkgs;
        # Optionnel (pratique pour accéder à inputs dans tes modules)
        extraSpecialArgs = {inherit spicePkgs;};

        modules = [
          ./profiles/desktop/home.nix
          spicetify-nix.homeManagerModules.spicetify
        ];
      };

      T480 = lib.homeManagerConfiguration {
        inherit pkgs;
        # Optionnel (pratique pour accéder à inputs dans tes modules)
        extraSpecialArgs = {inherit spicePkgs;};

        modules = [
          ./profiles/laptop-nixos/home.nix
          spicetify-nix.homeManagerModules.spicetify
          caelestia-shell.homeManagerModules.default
        ];
      };
    };
  };
}
