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
	};

	outputs = inputs@{self, nixpkgs, home-manager, zen-browser, dolphin-overlay, ...}: {

		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
				{
				nixpkgs.overlays = [ dolphin-overlay.overlays.default ];
				_module.args = { inherit inputs; };
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
