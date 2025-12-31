# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{ 
  ######################
  ## DRIVERS AND BOOT ##
  ######################

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      #./NixModules/laptop.nix

    ];

  # NVIDIA DRIVERS:
  #hardware.graphics.enable = true;
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia.open = true; 
  
  #BOOT:
  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  #Use the grub boot loader for bios systems
  #boot.loader.grub.device = "dev/" #set the boot disk

  #boot.kernelParams = [ 
  #  "quiet" 
  #  "splash"
  #  "console=tty0"
  # ];
  #boot.plymouth.enable = true;

  

  ############
  ## SYSTEM ##
  ############

  #NETWORKING:
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  #display manager

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "hyprland";
    configHome = "/home/fredrik";
    quickshell.package = pkgs.quickshell;
  };

  #services.displayManager.dms-greeter = {
  #  enable = true;
  #  compositor.name = "hyprland";
  #  configHome = "/home/fredrik";
  #  quickshell.package = pkgs.quickshell;
  #};

  #services.displayManager = {
 	# sddm.enable = true;
 	# sddm.wayland.enable = true;
  # autoLogin.enable = true;
  # autoLogin.user = "fredrik";
  #};



  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # enable automounting for flashdrives.
  services.udisks2.enable = true;

  # Enable sound.
  #services.pulseaudio.enable = true;
  #services.pipewire.enable = lib.mkForce false;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.USERNAME = { #set this before first switch
   isNormalUser = true;
   shell = pkgs.zsh;
   extraGroups = [ "wheel" "libvirtd" ]; # Enable ‘sudo’ for the user.
   packages = with pkgs; [
     tree
   ];
 };

  ##############
  ## PROGRAMS ##
  ##############

  programs.firefox = {
  enable = true;
  package = pkgs.firefox;
  nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };


  #programs.steam = {
  #	enable = true;
 	#	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #	localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	#};	
  
  programs.gamescope = {
  enable = true;
  capSysNice = true;
  };

  programs.steam.gamescopeSession.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    wmenu
    wl-clipboard
    vim
    wget
    kitty
    git
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pavucontrol
    kdePackages.dolphin
    rose-pine-hyprcursor
    cliphist
    hyprpolkitagent
    vscodium
    btop
    rose-pine-cursor
    quickshell
    kdePackages.qt6ct
    kdePackages.qt5compat
    firefoxpwa
    hyprshot
    playerctl
    direnv
    #spotify
    hyprlandPlugins.hyprsplit
    fastfetch
    adw-gtk3
    zplug
    zsh-z
    zsh-powerlevel10k
    #vesktop #discord 
    imv
    #dnsmasq
   ];

  #############
  ## DESKTOP ##
  #############

  programs.hyprland = {
	  enable = true;
    xwayland.enable = true;
	};

  programs.dsearch.enable = true;
  programs.dms-shell = {
    enable = true;
    quickshell.package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
    
    # Optional feature toggles

    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
  };

  programs.zsh = {
    enable = true;
  };

  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  
  xdg.portal = {
   enable = true;
   config = {
     hyprland = {
       default = [
         "hyprland"
         "kde"
       ];
     };
   };
   configPackages = with pkgs; [
     xdg-desktop-portal-hyprland
     kdePackages.xdg-desktop-portal-kde
   ];
  };


  nixpkgs.config.qt6 = {
    enable = true;
    platformTheme = "qt6ct"; 
    style = {
      name = "Matugen";
    };
  };




   fonts.packages = with pkgs; [
    	nerd-fonts.jetbrains-mono
    ];

  ####################
  ## Virtualisation ##
  ####################

  #virtualisation.libvirtd = {
  #  enable = true;
  #  # Allow passwordless access for users in libvirtd group
  #  onBoot = "ignore";
  #  onShutdown = "shutdown";
  #  extraConfig = ''
  #    unix_sock_group = "libvirtd"
  #    unix_sock_ro_perms = "0777"
  #    unix_sock_rw_perms = "0770"
  #    auth_unix_ro = "none"
  #    auth_unix_rw = "none"
  #  '';
  #};
  #programs.virt-manager.enable = true;
  #virtualisation.libvirtd.qemu = {
  #  swtpm.enable = true;
  #};

  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      # Add other libraries here if needed
    ];
  };
}

