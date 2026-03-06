# Home Manager Configuration
# ==========================
# User-level configuration for applications, shell, and desktop environment.
# This file is imported by configuration.nix through home-manager integration.
#
# IMPORTANT: Search and replace all instances of YOUR_USERNAME with your actual username!

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  #############################################################################
  ## HOME MANAGER SETTINGS                                                   ##
  ## Basic home manager configuration                                        ##
  #############################################################################

  home.username = "YOUR_USERNAME";
  home.homeDirectory = "/home/YOUR_USERNAME";
  home.stateVersion = "25.05";

  #############################################################################
  ## SERVICES                                                                ##
  ## User-level services                                                     ##
  #############################################################################

  # GNOME Keyring
  # -------------
  # Secret storage for passwords and encryption keys
  services.gnome-keyring.enable = true;
  home.packages = [ pkgs.gcr ]; # org.gnome.keyring.SystemPrompter

  # Udiskie
  # -------
  # Automatic mounting of removable media
  services.udiskie = {
    enable = true;
    settings = {
      program_options = {
        file_manager = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      };
    };
  };

  #############################################################################
  ## SHELL                                                                   ##
  ## Zsh configuration with plugins and aliases                              ##
  #############################################################################

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Shell Aliases
    # -------------
    shellAliases = {
      btw = "echo i use nix btw test";
      retest = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --impure";
      renix = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos --impure";
    };

    # History
    # -------
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
    ];

    # Plugins
    # -------
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    # Init Content
    # ------------
    # Source p10k config and show system info on shell start
    initContent = ''
      ${builtins.readFile ./other-dotfiles/zsh/.p10k.zsh}
      fastfetch
    '';

    # Oh My Zsh
    # ---------
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
    };
  };

  #############################################################################
  ## WINDOW MANAGER                                                          ##
  ## Hyprland configuration                                                  ##
  #############################################################################

  wayland.windowManager.hyprland = {
    enable = true;

    # Plugins
    # -------
    # Built from flake input to match running Hyprland version
    plugins = [
      inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    ];

    # Extra Config
    # ------------
    # Home-Manager owns the main config file, DMS owns the sourced file
    # Changes to sourced file are picked up by `hyprctl reload`
    extraConfig = ''
      source = /home/YOUR_USERNAME/nixos-dotfiles/other-dotfiles/hypr/hyprland.conf
    '';

    # Systemd Integration
    # -------------------
    # Exposes all systemd env vars for portals and D-Bus
    systemd.variables = [ "--all" ];
  };

  #############################################################################
  ## CONFIGURATION FILES                                                     ##
  ## User application config files                                           ##
  #############################################################################

  # Dolphin file manager configuration
  home.file.".config/dolphinrc".source = ./other-dotfiles/dolphinrc;

  #############################################################################
  ## ACTIVATION SCRIPTS                                                      ##
  ## Copy non-home-managed dotfiles on first activation                      ##
  #############################################################################

  # On first activation, copy selected non-home-managed dotfiles from ./other-dotfiles
  # into their expected locations under ~/.config (kitty and DankMaterialShell only),
  # but only if they don't already exist. This keeps them mutable and not managed by HM.
  home.activation.copyOtherDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dotfiles_dir="${config.home.homeDirectory}/nixos-dotfiles/other-dotfiles"

    # Kitty
    if [ ! -f "${config.home.homeDirectory}/.config/kitty/kitty.conf" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/kitty"
      cp "$dotfiles_dir/kitty/kitty.conf" \
         "${config.home.homeDirectory}/.config/kitty/kitty.conf"
    fi

    if [ ! -f "${config.home.homeDirectory}/.config/kitty/dank-tabs.conf" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/kitty"
      cp "$dotfiles_dir/kitty/dank-tabs.conf" \
         "${config.home.homeDirectory}/.config/kitty/dank-tabs.conf"
    fi

    if [ ! -f "${config.home.homeDirectory}/.config/kitty/dank-theme.conf" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/kitty"
      cp "$dotfiles_dir/kitty/dank-theme.conf" \
         "${config.home.homeDirectory}/.config/kitty/dank-theme.conf"
    fi

    # DankMaterialShell
    if [ ! -f "${config.home.homeDirectory}/.config/DankMaterialShell/settings.json" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/DankMaterialShell"
      cp "$dotfiles_dir/DankMaterialShell/settings.json" \
         "${config.home.homeDirectory}/.config/DankMaterialShell/settings.json"
    fi

    if [ ! -f "${config.home.homeDirectory}/.config/DankMaterialShell/firefox.css" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/DankMaterialShell"
      cp "$dotfiles_dir/DankMaterialShell/firefox.css" \
         "${config.home.homeDirectory}/.config/DankMaterialShell/firefox.css"
    fi

    if [ ! -f "${config.home.homeDirectory}/.config/DankMaterialShell/plugin_settings.json" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/DankMaterialShell"
      cp "$dotfiles_dir/DankMaterialShell/plugin_settings.json" \
         "${config.home.homeDirectory}/.config/DankMaterialShell/plugin_settings.json"
    fi
  '';
}
