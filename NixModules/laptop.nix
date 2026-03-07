{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  #Enables the battery monitoring daemon
  services.upower.enable = true;

  # 1. Set lid-close action to suspend-then-hibernate
  services.logind = {
    settings.Login.HandleLidSwitch = "suspend-then-hibernate";
    # Optional: different behavior when plugged in
    settings.Login.HandleLidSwitchExternalPower = "suspend";
  };

  # 2. Set the delay before hibernation (e.g., 30 minutes)
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "15m";
    # Optionally, ensure deep suspend (more power‑efficient)
    # SuspendState = "mem";
  };

  # 3. (Optional) Ensure deep sleep (S3) instead of s2idle
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 70; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  powerManagement.powertop.enable = true;
  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    powertop
  ];
}
