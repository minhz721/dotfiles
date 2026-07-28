{ config, pkgs, ... }: {
  imports = [
    ./sddm.nix
    ./bootloader.nix
    ./locales.nix
    ./network.nix
    ./audio.nix
    ./package.nix
    ./service.nix
    ./user.nix
    ./docker.nix
    ./home-manager.nix
  ];
}