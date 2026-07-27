{ config, pkgs, ... }:

{
  home.username = "minhtd";
  home.homeDirectory = "/home/minhtd";
  home.stateVersion = "24.11"; 

  # --- DANH SÁCH PACKAGES TỪ ARCH LINUX ---
  home.packages = with pkgs; [
    # Development & CLI Tools
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.tkinter
    ffmpeg
    vim
    neovim
    stow
    eza
    bat
    fzf
    tree
    ripgrep
    tldr
    dotnet-sdk_8
    fastfetch
    vscode
    mission-center
    dbeaver-bin
    lazygit
    lazydocker

    # Browsers & Communication
    brave
    discord
    telegram-desktop
    zathura
    ghostty
    insomnia

    # Cursors, Themes, Look & Feel
    bibata-cursors
    adw-gtk3
    papirus-icon-theme

    # File Managers & Utilities
    nemo
    nemo-with-extensions
    yazi
    gsimplecal

    # System Utilities & Media
    gnome-disk-utility
    obs-studio
    imv
    dconf-editor
    mpv
    cava
    xclip
    unzip

    # Audio & Bluetooth
    pamixer
    playerctl
    blueman

    # Qtile Widgets & Support Tools
    rofi
    picom
    dunst
    xidlehook
    xorg.xrandr
    scrot
    yad
    xdotool
    python3Packages.psutil
    python3Packages.dbus-fast
    python3Packages.dbus-next
  ];

  # Tự động hóa nạp cấu hình Shell tối ưu bằng Nix
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  # --- ÁNH XẠ ĐƯỜNG DẪN DOTFILES SẴN CÓ ---
  # Đứng từ folder nixos/ trỏ ngược ra thư mục cha (../) để tạo symlink vào ~/.config/
  xdg.configFile."qtile/config.py".source = ../qtile/config.py;
  xdg.configFile."kitty".source = ../kitty/.config/kitty;
  xdg.configFile."alacritty".source = ../alacritty/.config/alacritty;
  xdg.configFile."nvim".source = ../nvim/.config/nvim;
  xdg.configFile."zsh".source = ../zsh/.config/zsh;

  programs.home-manager.enable = true;
}
