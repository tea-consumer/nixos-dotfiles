# Zed Editor FHS Environment
# ==========================
# Creates an FHS environment for the Zed editor.
# IMPORTANT: Update the runScript path to match your Zed installation location.

{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.buildFHSEnv {
      name = "zed";
      targetPkgs =
        pkgs: with pkgs; [
          alsa-lib
          wayland
          libxkbcommon
          xkeyboard_config
          libGL
          fontconfig
          freetype
          libx11
          libxcb
          libxcursor
          libxrandr
          libxi
          vulkan-loader
        ];
      # Replace YOUR_USERNAME with your actual username
      runScript = "/home/YOUR_USERNAME/.local/zed.app/libexec/zed-editor";
    })
  ];
}
