# User-Specific Packages and Services
# ===================================
# This module contains user-specific applications, gaming setup, and personal utilities.
# These are separate from system-wide configuration in configuration.nix.
#
# IMPORTANT: All services and packages below are commented out as examples.
# Uncomment the sections you want to enable for your system.

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  #############################################################################
  ## GAMING                                                                  ##
  ## Steam, Proton, game launchers, and gaming utilities                    ##
  #############################################################################

  # Steam Configuration
  # -------------------
  # Steam is the primary gaming platform with Proton for Windows games
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Steam Remote Play streaming
  #   dedicatedServer.openFirewall = true; # Source Dedicated Server hosting
  #   localNetworkGameTransfers.openFirewall = true; # Local network game transfers
  #   protontricks.enable = true; # Winetricks GUI for Proton
  #   gamescopeSession.enable = true; # Big Picture mode with Gamescope
  # };

  # Proton-GE - Custom Proton build with additional fixes
  # programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];

  # GameMode - System optimizer for gaming
  # programs.gamemode.enable = true;

  # Gamescope
  # ---------
  # SteamOS session compositing window manager with HDR support
  # programs.gamescope = {
  #   enable = true;
  #   capSysNice = true; # Higher process priority for smoother gaming
  # };

  #############################################################################
  ## HARDWARE CONTROL                                                        ##
  ## System monitoring, RGB lighting, and cooling control                    ##
  #############################################################################

  # Kernel module for NCT6775 hardware monitoring chip
  # boot.kernelModules = [ "nct6775" ];

  # CoolerControl - GUI for fan and cooling management
  # programs.coolercontrol.enable = true;
  # services.lm_sensors.enable = true; # Sensor detection
  # services.coolercontrold.enable = true; # CoolerControl daemon

  # OpenRGB - RGB lighting control
  # services.hardware.openrgb.enable = true;

  #############################################################################
  ## SYSTEM INTEGRATION                                                      ##
  ## Flatpak support, device connectivity, and binary compatibility          ##
  #############################################################################

  # Flatpak - Universal Linux application distribution
  # services.flatpak.enable = true;

  # KDE Connect - Desktop and mobile device integration
  # programs.kdeconnect.enable = true;

  # GNOME Keyring - Secret storage for passwords
  # services.gnome.gnome-keyring.enable = true;

  # Nix-ld
  # ------
  # Run non-NixOS dynamically linked binaries
  # Provides FHS-compatible dynamic linker for proprietary games and apps
  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #     # Audio
  #     alsa-lib
  #     # Graphics and display
  #     wayland
  #     libxkbcommon
  #     libGL
  #     vulkan-loader
  #     # X11 libraries
  #     libx11
  #     libxcb
  #     libxcursor
  #     libxrandr
  #     libxi
  #     # Fonts
  #     fontconfig
  #     freetype
  #   ];
  # };

  #############################################################################
  ## USER APPLICATIONS                                                       ##
  ## Personal applications organized by category                             ##
  #############################################################################

  environment.systemPackages = with pkgs; [
    # Browsers
    # inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen browser
    # chromium # Open-source web browser

    # Development
    # vim # Classic text editor
    # vscodium # VS Code without telemetry
    # code-cursor # AI-powered code editor
    # direnv # Directory-specific environment variables
    # nixd # Nix language server
    # nil # Alternative Nix language server

    # Office
    # libreoffice-qt # Office suite
    # hunspell # Spell checker
    # hunspellDicts.en_US # English dictionaries
    # hunspellDicts.nb_NO # Norwegian Bokmål dictionaries
    # hunspellDicts.nn_NO # Norwegian Nynorsk dictionaries

    # Communication
    # discord # Voice and text chat
    # vesktop # Alternative Discord client with Vencord

    # Security
    # bitwarden-desktop # Password manager

    # Media
    # spotify # Music streaming
    # vlc # Universal media player
    # ffmpeg # Audio/video processing
    # imv # Minimal image viewer

    # Productivity
    # geogebra # Dynamic mathematics software
    # geogebra6 # Classic Geogebra version

    # Creative
    # davinci-resolve # Professional video editing

    # Gaming
    # lutris # Game launcher
    # bottles # Wine/Proton prefix manager
    # starsector # Space exploration game
    # rimsort # RimWorld mod manager
    # ckan # Kerbal Space Program mod manager
    # mangohud # Vulkan/OpenGL overlay
    # winetricks # Wine utility
    # wine64 # Windows compatibility layer

    # Utilities
    # firefoxpwa # Firefox PWA runtime
    # file # File type identification
    # xkill # Kill X11 windows
    # lm_sensors # Hardware sensors
    # openrgb # RGB lighting control
  ];

  #############################################################################
  ## FIREFOX CONFIGURATION                                                   ##
  ## Firefox PWA and native messaging hosts                                  ##
  #############################################################################

  # PWA for Firefox
  # programs.firefox = {
  #   nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  # };
}
