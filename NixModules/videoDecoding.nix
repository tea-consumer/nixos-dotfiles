{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable; # Use a stable version.
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # <<< CRITICAL: The only required VAAPI package for NVIDIA[citation:2][citation:10].
    ];
  };

  # Essential environment variables
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct"; # Use the direct backend for the NVIDIA driver[citation:2][citation:8].
    # Required to bypass Firefox's security sandbox for the media process (security trade-off)[citation:2][citation:10].
    MOZ_DISABLE_RDD_SANDBOX = "1";
    # Wayland/NVIDIA variables for Hyprland
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Firefox preferences to force-enable features
  programs.firefox = {
    enable = true;
    preferences = {
      "media.hardware-video-decoding.force-enabled" = true; # Bypass the Mozilla blocklist.
      "media.ffmpeg.vaapi.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      "gfx.x11-egl.force-enabled" = true;
      "widget.dmabuf.force-enabled" = true;
      "media.av1.enabled" = false; # Your RTX 2080 Super does not support AV1 hardware decode[citation:2].
    };
  };
}
