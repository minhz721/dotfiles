{
  description = "Hệ thống NixOS hoàn chỉnh cho minhtd (Cả System và Home Manager)";

  inputs = {
    # Nhánh unstable để có phần mềm mới như Arch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # CẤU HÌNH HỆ THỐNG (Dùng cho lệnh: nixos-rebuild switch --flake .#desk)
      nixosConfigurations."desk" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          /etc/nixos/hardware-configuration.nix # Lấy driver phần cứng gốc của máy mới
          ./configuration.nix                    # File cấu hình hệ thống từ repo của bạn
        ];
      };

      # CẤU HÌNH NGƯỜI DÙNG (Dùng cho lệnh: home-manager switch --flake .#minhtd)
      homeConfigurations."minhtd" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      # Môi trường biệt lập nix-develop tự động để check lỗi Python Qtile
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          (pkgs.python3.withPackages (ps: with ps; [
            qtile qtile-extras psutil mypy black dbus-fast dbus-next
          ]))
        ];
        shellHook = ''
          echo "⚡ Đã vào môi trường phát triển Qtile cô lập!"
          echo "👉 Chạy 'python3 -m py_compile ../qtile/config.py' để test lỗi cú pháp."
        '';
      };
    };
}
