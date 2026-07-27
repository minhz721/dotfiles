{ config, pkgs, ... }:

{
  # 1. Kích hoạt giao diện đồ họa X11, Qtile và màn hình đăng nhập SDDM
  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
  };
  
  services.displayManager.sddm.enable = true;

  # 2. Hệ thống Âm thanh Pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # 3. Kích hoạt Bluetooth & Docker
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  virtualisation.docker.enable = true;

  # 4. Ảo hóa (QEMU, Libvirt, Virt-manager)
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # 5. Đọc ghi ổ cứng NTFS / ExFAT
  boot.supportedFilesystems = [ "ntfs" "exfat" ];

  # 6. Quản lý Fonts hệ thống (Tải bộ font nerd và các font hiển thị cơ bản)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    dejavu_fonts
    roboto
    liberation_ttf
    source-han-sans
  ];

  # 7. Bộ gõ tiếng Việt Fcitx5 + Bamboo
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-bamboo
      fcitx5-gtk
      fcitx5-configtool
    ];
  };

  # 8. Trình quản lý daemon map phím Keyd
  services.keyd.enable = true;

  # 9. Cho phép tải ứng dụng mã nguồn đóng (Brave, VS Code, Discord...)
  nixpkgs.config.allowUnfree = true;

  # 10. Phân quyền cho User minhtd
  users.users.minhtd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Bật tính năng Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
