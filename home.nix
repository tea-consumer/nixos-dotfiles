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

  # automounting and privlige utility.
  services.udiskie = {
    enable = true;
    settings = {
        # workaround for
        # https://github.com/nix-community/home-manager/issues/632
        program_options = {
            file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin"; # replace with your favorite file manager | uses kde Dolphin by default
        };
    };
  };
  # Configure Hyprland through home-manager
  wayland.windowManager.hyprland = {
    enable = true;
    # Uses existing configuration files from the other-dotfiles directory
    extraConfig = builtins.readFile ./other-dotfiles/hypr/hyprland.conf;
    # Enable the split-monitor-workspaces plugin
    plugins = [ pkgs.hyprlandPlugins.hyprsplit ];
  };

  # Creates symlinks to configuration files from other dotfiles in the repo
  # syntax: home.file"<target>".source = <configuration>;  <- DON'T forget semicolon1
  home.file.".config/kitty".source = ./other-dotfiles/kitty;
  home.file.".config/dolphinrc".source = ./other-dotfiles/dolphinrc;
} 