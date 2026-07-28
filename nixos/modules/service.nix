{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;
}
