{
	description = "vm nix fun";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		dolphin-overlay.url = "github:rumboon/dolphin-overlay";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
    };
	};

	outputs = inputs@{self, nixpkgs, home-manager, zen-browser, dolphin-overlay, dankMaterialShell, dgop, ...}: {

		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			
			modules = [
				
				./configuration.nix
				{
				nixpkgs.overlays = [ dolphin-overlay.overlays.default ];
				}
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.fredrik = import ./home.nix;
						backupFileExtension = "backup";
					};
				}

			];
		};
	};
}
