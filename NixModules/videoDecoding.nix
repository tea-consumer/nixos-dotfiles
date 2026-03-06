# Intel Graphics Configuration
# ===========================
# This module configures Intel graphics drivers and hardware video decoding.
# For NVIDIA GPUs, use ./nvidia.nix instead.

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  #############################################################################
  ## GRAPHICS DRIVER                                                         ##
  ## Intel integrated and discrete GPU configuration                         ##
  #############################################################################

  # Use modesetting driver for Intel GPUs
  services.xserver.videoDrivers = [ "modesetting" ];

  # Graphics Configuration
  # ----------------------
  # Enable modern graphics stack with Intel-specific packages
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Required for modern Intel GPUs (Xe iGPU and ARC)
      intel-media-driver # VA-API (iHD) userspace
      vpl-gpu-rt # oneVPL (QSV) runtime

      # Optional (compute / tooling):
      intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
      # NOTE: 'intel-ocl' also exists as a legacy package; not recommended for Arc/Xe.
      # libvdpau-va-gl # Only if you must run VDPAU-only apps
    ];
  };

  #############################################################################
  ## ENVIRONMENT VARIABLES                                                   ##
  ## Required for Intel VAAPI                                                ##
  #############################################################################

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
    # VDPAU_DRIVER = "va_gl"; # Only if using libvdpau-va-gl
  };

  #############################################################################
  ## KERNEL CONFIGURATION                                                    ##
  ## Enable GuC firmware for better hardware decoding                        ##
  #############################################################################

  # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915)
  hardware.enableRedistributableFirmware = true;
  boot.kernelParams = [ "i915.enable_guc=3" ];

  #############################################################################
  ## PERMISSIONS                                                             ##
  ## Ensure services can access /dev/dri                                     ##
  #############################################################################

  # May help services that have trouble accessing /dev/dri (e.g., jellyfin/plex):
  # users.users.<service>.extraGroups = [ "video" "render" ];
}
