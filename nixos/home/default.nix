{ config, pkgs, ... }: {
  # 1. Target user environment configuration
  home.username = "leomin";
  home.homeDirectory = "/home/leomin";

  # 2. User-specific packages
  home.packages = with pkgs; [
    vscode
    librewolf
  ];

  # 3. Programs managed by Home Manager
  programs.home-manager.enable = true;

  # 4. State version for stateful data
  home.stateVersion = "26.05";
}
