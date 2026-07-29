{ config, pkgs, ... }: {
  # 1. Import all sub-folders containing raw config setups
  imports = [
    ./ghostty
    # ./zsh
    ./dunst
    ./picom
    ./rofi
    ./qtile
  ];

  # 2. Target user profile
  home.username = "leomin";
  home.homeDirectory = "/home/leomin";

  # 3. Other general packages (without raw configs)
  home.packages = with pkgs; [
    vscode
    fish
    neovim
  ];

  # 4. Enable Home Manager
  programs.home-manager.enable = true;
  
  home.stateVersion = "26.11";
}
