{ config, pkgs, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    ghostty
    btop
    fastfetch
    librewolf
    sddm-astronaut
    qtile
  ];
}
