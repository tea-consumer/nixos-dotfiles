{config, pkgs, ...}:

{
	home.username = "fredrik";
	home.homeDirectory = "/home/fredrik";
	home.stateVersion = "25.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use nix btw test";
			retest = "sudo nixos-rebuild test --flake  ~/nixos-dotfiles#nixos --impure";
			renix = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --impure";
		};
	};
	home.file.".config/hypr".source = ./other-dotfiles/hypr;
	home.file.".config/waybar".source = ./other-dotfiles/waybar;
	home.file.".config/DankMaterialShell".source = builtins.path {
  		name = "dms-filtered-source";
  		path = ./other-dotfiles/DankMaterialShell;
  		filter = (path: type:
    # Keep everything that is NOT a .git directory
    		type != "directory" || builtins.baseNameOf path != ".git"
  		);
	};
}
