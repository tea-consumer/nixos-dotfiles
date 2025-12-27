{
  description = "vm nix fun";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    # Add these two new inputs
    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
     quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    dolphin-overlay,
    dgop,
    hyprland,
    split-monitor-workspaces,
    ...}:
    let
    system = "x86_64-linux"; 
    in {
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
            extraSpecialArgs = { inherit inputs; }; # Pass inputs to home-manager
          };
        }
      ];
    };
  };
}