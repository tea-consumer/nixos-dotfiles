{
	description = "vm nix fun";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{self, nixpkgs, home-manager, zen-browser,  ...}: {

		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
				{
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
