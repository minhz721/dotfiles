{
  description = "NixOS configuration with Flakes, Home-manager, and latest Qtile";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Cấu hình Home-manager tương thích với unstable
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Lấy mã nguồn Qtile mới nhất từ kho chính thức
    qtile-flake = {
      url = "github:qtile/qtile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      qtile-flake,
    }:
    let
      system = "x86_64-linux";
    in
    {
      # LƯU Ý: Đổi "leomin" thành đúng tên Hostname của máy bạn
      nixosConfigurations.leomin = nixpkgs.lib.nixosSystem {
        inherit system;

        # Truyền package Qtile từ Flake vào hệ thống
        specialArgs = {
          qtile-package = qtile-flake.packages.${system}.default;
        };

        modules = [
          ./hardware-configuration.nix
          ./configuration.nix

          # Tích hợp Home-manager làm một module của NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # LƯU Ý: Thay "leomin" bằng tên User đăng nhập của bạn
            home-manager.users.leomin = import ./home.nix; 

            # Cho phép home-manager truy cập biến qtile-package nếu cần
            home-manager.extraSpecialArgs = {
              qtile-package = qtile-flake.packages.${system}.default;
            };
          }

          # Cấu hình hệ thống cho Qtile và SDDM
          (
            { config, pkgs, lib, qtile-package, ... }:
            {
              services.xserver = {
                enable = true;
                windowManager.qtile = {
                  enable = true;
                  package = qtile-package; # Ép dùng bản dựng từ Flake
                };
              };

              services.displayManager.sddm.enable = true;
              services.displayManager.defaultSession = lib.mkForce "qtile";
            }
          )
        ];
      };
    };
}
