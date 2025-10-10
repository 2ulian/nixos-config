{
  description = "Home Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    spicetify-nix,
    ...
  }: let
    systems = {
      x86 = "x86_64-linux";
      arm = "aarch64-linux";
    };
    mkPkgs = system:
      import nixpkgs {
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
            home-manager.sharedModules = [spicetify-nix.homeManagerModules.default];
            home-manager.extraSpecialArgs = {inherit spicePkgs;};
            home-manager.users.fellwin = import ./profiles/macbook/home.nix;
          }
        ];
      };
    };
  };
}
