{ config, pkgs, inputs, ... }:

{ #Change the USERNAME to the name you want
  home.username = "USERNAME";
  home.homeDirectory = "/home/USERNAME";
  home.stateVersion = "25.05";

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      btw = "echo i use nix btw test";
      retest = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --impure";
      renix = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --impure";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [ "rm *" "pkill *" "cp *" ];


    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      # Embedded Powerlevel10k config
      ${builtins.readFile ./other-dotfiles/zsh/.p10k.zsh}
      fastfetch
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
    };
  };

  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
            # replace with your favorite file manager
            file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        };
    };
  };
  # Configure Hyprland through home-manager
  wayland.windowManager.hyprland = {
    enable = true;
    # Use your existing configuration files
    extraConfig = builtins.readFile ./other-dotfiles/hypr/hyprland.conf;
    # Enable the split-monitor-workspaces plugin
    plugins = [ pkgs.hyprlandPlugins.hyprsplit ];
  };

  # Remove the hypr file copy since we're now managing it through home-manager
  # home.file.".config/hypr".source = ./other-dotfiles/hypr;

  home.file.".config/kitty".source = ./other-dotfiles/kitty;
  home.file.".config/dolphinrc".source = ./other-dotfiles/dolphinrc;
}