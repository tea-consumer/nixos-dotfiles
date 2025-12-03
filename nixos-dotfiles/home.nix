{config, pkgs, ...}:

{
	home.username = "fredrik";
	home.homeDirectory = "/home/fredrik";
	home.stateVersion = "25.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use nix btw";
			retest = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
			renix = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
		};
	};
}
