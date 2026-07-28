{ config, pkgs, ... }:

{
  users.users."leomin" = {
    isNormalUser = true;
    description = "leomin";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "docker" ];
    shell = pkgs.fish;
    packages = with pkgs; [];
  };
}
