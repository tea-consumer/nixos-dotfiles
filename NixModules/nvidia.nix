# NVIDIA Graphics Configuration
# =============================
# This module configures NVIDIA proprietary drivers and related settings.
# Enable this module by uncommenting the import in configuration.nix.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  #############################################################################
  ## NVIDIA DRIVER                                                           ##
  ## Proprietary NVIDIA driver configuration                                 ##
  #############################################################################

  # Graphics Configuration
  # ----------------------
  # Enable modern graphics stack
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # VAAPI driver for NVIDIA
    ];
  };

  # NVIDIA Driver
  # -------------
  # Use the proprietary NVIDIA driver for optimal performance
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use proprietary/open kernel module
    # Set to true for newer GPUs (RTX 30xx+) with open driver support and vice versa
    open = true;

    # Enable modesetting for Wayland
    modesetting.enable = true;

    # Power management for better battery life on laptops
    #powerManagement = {
    #  enable = true;
    #  finegrained = false;
    #};

    # NVIDIA settings GUI
    nvidiaSettings = true;

    # Use stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  #############################################################################
  ## ENVIRONMENT VARIABLES                                                   ##
  ## Required for NVIDIA + Wayland                                           ##
  #############################################################################

  environment.sessionVariables = {
    # VAAPI configuration
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";

    # Required for Firefox hardware decoding
    MOZ_DISABLE_RDD_SANDBOX = "1";

    # Wayland/NVIDIA variables for Hyprland
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  #############################################################################
  ## FIREFOX HARDWARE DECODING                                               ##
  ## Enable hardware video decoding in Firefox                               ##
  #############################################################################

  programs.firefox = {
    enable = true;
    preferences = {
      "media.hardware-video-decoding.force-enabled" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      #"gfx.x11-egl.force-enabled" = true;
      #"widget.dmabuf.force-enabled" = true;
      # Disable AV1 if your GPU doesn't support it (pre-RTX 30 series)
      "media.av1.enabled" = false;
    };
  };
}
