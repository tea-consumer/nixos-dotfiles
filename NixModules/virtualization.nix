# Virtualization Configuration
# ============================
# This module configures virtual machine support using libvirt/KVM.
# Enable this module by uncommenting the import in configuration.nix.

{
  config,
  lib,
  pkgs,
  ...
}:

{
  #############################################################################
  ## LIBVIRT / KVM                                                           ##
  ## Virtual machine management and hardware virtualization                  ##
  #############################################################################

  # libvirt provides VM management; KVM provides hardware virtualization
  virtualisation.libvirtd = {
    enable = true;

    # VM behavior on host boot/shutdown
    onBoot = "ignore"; # Don't auto-start VMs
    onShutdown = "shutdown"; # Gracefully shutdown VMs

    # Socket permissions for users in libvirtd group
    # Allows passwordless VM management for group members
    extraConfig = ''
      unix_sock_group = "libvirtd"
      unix_sock_ro_perms = "0777"
      unix_sock_rw_perms = "0770"
      auth_unix_ro = "none"
      auth_unix_rw = "none"
    '';
  };

  # Virt-Manager GUI
  # ----------------
  # Graphical interface for managing virtual machines
  programs.virt-manager.enable = true;

  # TPM for Virtual Machines
  # ------------------------
  # Software TPM support for Windows 11 and secure VMs
  virtualisation.libvirtd.qemu = {
    swtpm.enable = true;
  };
}
