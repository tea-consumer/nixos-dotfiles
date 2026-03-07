# Bluetooth Configuration
# =======================
# This module configures Bluetooth support for wireless devices.
# Enable this module by uncommenting the import in configuration.nix.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  #############################################################################
  ## BLUETOOTH HARDWARE                                                      ##
  ## Enable Bluetooth controller support                                     ##
  #############################################################################

  # Enable Bluetooth hardware support
  hardware.bluetooth = {
    enable = true;

    # Power management settings
    powerOnBoot = true; # Automatically power on Bluetooth at boot

    # Audio support (for Bluetooth headsets/speakers)
    settings = {
      General = {
        # Enable A2DP sink for high-quality audio streaming
        Enable = "Source,Sink,Media,Socket";

        # Auto-enable controllers
        AutoEnable = true;
      };
    };
  };

  #############################################################################
  ## BLUETOOTH GUI                                                           ##
  ## Graphical interface for Bluetooth management                            ##
  #############################################################################

  # Blueman - Bluetooth manager GUI
  services.blueman = {
    enable = true;
  };

  #############################################################################
  ## SYSTEM PACKAGES                                                         ##
  ## Additional Bluetooth utilities                                          ##
  #############################################################################

  environment.systemPackages = with pkgs; [
    # Bluetooth command-line utilities
    bluez # Bluetooth protocol stack
    bluez-tools # Command-line tools for Bluetooth

    # Audio utilities for Bluetooth devices
    #pulseaudio-utils # pactl for Bluetooth audio control (works with PipeWire)
  ];
}
