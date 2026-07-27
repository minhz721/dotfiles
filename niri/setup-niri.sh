#!/bin/bash
#   _  ______  _  _  _____ ____  __  __
#  | |/ /  _ \| || ||_   _/ ____||  \/  |
#  | ' /| |_) | || |_ | || |  __ | \  / |
#  |  < |  _ <|__   _|| || | |_ || |\/| |
#  | . \| |_) |  | | _| || |__| || |  | |
#  |_|\_\____/   |_||_____|\____||_|  |_|
#
# Niri Wayland Environment Setup Script

set -euo pipefail

# --------------------------------------
# CONFIGURATION SECTION: Set up variables, timezone, user, and package lists
# --------------------------------------

TIMEZONE="Asia/Ho_Chi_Minh" # Timezone for your system

# List of essential packages for Niri (Wayland Ecosystem)

PACKAGES=(
    # --- Niri & Wayland Compositor Ecosystem ---
    swaybg                # Wallpaper manager for Wayland
    waybar                # Status bar
    mako                # Notification center & Control center
    grim slurp swappy     # Screenshot tools (grim=capture, slurp=select, swappy=edit)
    wl-clipboard          # Wayland clipboard utilities (wl-copy, wl-paste)
    swayidle              # Idle management daemon
    swaylock              # Modern screen locker
    wlr-randr             # Display output management
    nwg-displays

    # --- Development & CLI Tools ---
    python python-pip python-virtualenv tk ffmpeg vim neovim stow eza bat fzf tree ripgrep tldr dotnet-sdk-8.0 dotnet-runtime-8.0 zoxide starship git fastfetch visual-studio-code-bin mission-center dbeaver lazygit lazydocker docker localsend-bin zsh

    # --- Browsers & Communication ---
    thorium-browser-bin brave-bin discord telegram-desktop-bin zathura ghostty insomnia-bin

    # --- Input Method ---
    fcitx5 fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-bamboo fcitx5-configtool

    # --- Fonts ---
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji ttf-dejavu ttf-roboto ttf-liberation adobe-source-han-sans-otc-fonts

    # --- Cursors, Themes, Look & Feel ---
    bibata-cursor-theme adw-gtk-theme papirus-icon-theme

    # --- File Managers & Utilities ---
    nemo nemo-fileroller yazi

    # --- System Utilities & Media ---
    gnome-disk-utility polkit-gnome obs-studio ntfs-3g exfatprogs imv pamac-aur dconf-editor qemu-full virt-manager libvirt dnsmasq ebtables iptables-nft mpv cava keyd unzip

    # --- Audio & Bluetooth ---
    pamixer pipewire-alsa pipewire-pulse wireplumber playerctl python-pulsectl-asyncio bluez bluez-utils blueman python-dbus-fast python-dbus-next sddm-sugar-candy-git
)

# --------------------------------------
# HELPER FUNCTIONS SECTION: Utility, logging, package management
# --------------------------------------

log_info() { echo "[INFO] $1"; }
log_success() { echo "[OK]   $1"; }
log_warning() { echo "[WARN] $1"; }
log_error() { echo "[ERR]  $1"; }

check_result() {
    if [ "$1" -ne 0 ]; then
        log_error "$2"
        exit 1
    fi
}

is_installed() {
    paru -Q "$1" &>/dev/null || pacman -Q "$1" &>/dev/null
}

install_package() {
    if ! is_installed "$1"; then
        log_info "Installing $1..."
        paru -S --noconfirm "$1"
    else
        log_info "$1 already installed. Skipping."
    fi
}

# Install paru if not available (AUR helper)
if ! is_installed "paru"; then
    log_info "Installing paru..."
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru && makepkg -si --noconfirm && cd .. && rm -rf paru
fi

# --------------------------------------
# GIT AND SSH KEY CONFIGURATION
# --------------------------------------
configure_git_and_ssh() {
    SSH_KEY_FILE="$HOME/.ssh/id_ed25519"

    if [ -f "$SSH_KEY_FILE" ]; then
        echo "SSH key already exists at $SSH_KEY_FILE. Skipping Git and SSH configuration."
        return
    fi

    read -rp "Enter your Git user.name: " USER_NAME
    read -rp "Enter your Git user.email: " USER_EMAIL

    git config --global user.name "$USER_NAME"
    git config --global user.email "$USER_EMAIL"

    echo "Generating SSH key at $SSH_KEY_FILE..."
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$SSH_KEY_FILE" -N ""

    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_FILE"

    echo "Your public SSH key:"
    cat "${SSH_KEY_FILE}.pub"
}

# --------------------------------------
# DOCKER INSTALLATION AND ENABLEMENT
# --------------------------------------
config_docker() {
    sudo systemctl enable docker.service
    local real_user="${SUDO_USER:-$USER}"
    sudo usermod -aG docker "$real_user"
    log_success "Docker installed. Please log out or run 'newgrp docker'."
}


# --------------------------------------
# DOWNLOAD WALLPAPER REPOSITORY FROM GITHUB
# --------------------------------------
clone_wallpaper() {
    log_info "Cloning wallpaper repository..."

    if [ ! -d "$HOME/Pictures" ]; then
        log_info "$HOME/Pictures does not exist. Creating it..."
        mkdir -p "$HOME/Pictures" &&
            log_success "Successfully created $HOME/Pictures." ||
            {
                log_error "Failed to create $HOME/Pictures. Aborting wallpaper clone."
                return 1
            }
    fi

    if [ ! -d "$HOME/Pictures/wallpaper" ]; then
        cd "$HOME/Pictures" || {
            log_error "Failed to change directory to $HOME/Pictures. Aborting."
            return 1
        }
        git clone --depth=1 https://github.com/Leomin07/wallpaper.git "$HOME/Pictures/wallpaper" &&
            log_success "Wallpaper repository cloned to $HOME/Pictures/wallpaper." ||
            log_error "Failed to clone wallpaper repository."
    else
        log_info "Wallpaper repository already exists in $HOME/Pictures/wallpaper, skipping clone."
    fi
}

# --------------------------------------
# NODEJS (NVM + YARN) INSTALLATION
# --------------------------------------
install_nodejs() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install --lts
    npm install --global yarn
}

# --------------------------------------
# YES/NO PROMPT FUNCTION FOR USER CONFIRMATION
# --------------------------------------
ask_yes_no() {
    while true; do
        read -rp "$1 [y/n]: " yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*) return 1 ;;
        *) echo "Please answer yes or no." ;;
        esac
    done
}

# --------------------------------------
# INSTALL AND CONFIGURE ZSH
# --------------------------------------
setup_zsh() {
    if ! command -v zsh &>/dev/null; then
        install_package "zsh"
    else
        log_info "Zsh is already installed, skipping."
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh My Zsh..."
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &&
            log_success "Oh My Zsh installed." || {
            log_error "Failed to install Oh My Zsh."
            return 1
        }
    else
        log_info "Oh My Zsh is already installed, skipping."
    fi

    local real_user="${SUDO_USER:-$USER}"
    local current_shell
    current_shell="$(getent passwd "$real_user" | cut -d: -f7)"
    if [ "$current_shell" != "$(which zsh)" ]; then
        log_info "Changing default shell to Zsh for user $real_user..."
        sudo chsh -s "$(which zsh)" "$real_user" &&
            log_success "Default shell changed to Zsh (log out to apply)." ||
            log_error "Failed to change default shell to Zsh."
    else
        log_info "Default shell is already Zsh."
    fi

    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    declare -A plugins=(
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
        ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    )
    for name in "${!plugins[@]}"; do
        local dir="$plugins_dir/$name"
        if [ ! -d "$dir" ]; then
            log_info "Installing Zsh plugin: $name..."
            git clone "${plugins[$name]}" "$dir" && log_success "Plugin '$name' installed." || log_error "Failed to install plugin '$name'."
        else
            log_info "Zsh plugin '$name' is already installed, skipping."
        fi
    done

    local zshrc="$HOME/.zshrc"
    local desired_plugins="plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions z docker docker-compose)"
    if grep -qE '^plugins=\(.*\)' "$zshrc"; then
        log_info "Updating plugins list in ~/.zshrc..."
        sed -i 's/^plugins=(.*)/'"$desired_plugins"'/' "$zshrc" &&
            log_success "Updated plugins in ~/.zshrc." ||
            log_error "Failed to update plugins in ~/.zshrc."
    else
        log_info "Adding plugins list to ~/.zshrc..."
        echo "$desired_plugins" >>"$zshrc" &&
            log_success "Added plugins to ~/.zshrc." ||
            log_error "Failed to add plugins to ~/.zshrc."
    fi

    if [ -f "$HOME/.zshrc" ]; then
        log_info "Detected old ~/.zshrc, proceeding to delete..."
        rm "$HOME/.zshrc"
    fi
    if [ -f "$HOME/dotfiles/zshrc/.zshrc" ]; then
        stow "zshrc" --target="$HOME" --dir="$HOME/dotfiles"
        log_success "Stow ~/dotfiles/zshrc/.zshrc to $HOME/.zshrc"
    else
        log_warning "~/dotfiles/zshrc/.zshrc not found, skipping copy step."
    fi
}

# --------------------------------------
# GNU STOW CONFIGURATION
# --------------------------------------
stow_configs() {
    # Thay thế qtile bằng niri và các app Wayland trong danh sách stow
    local folders=("ghostty" "nvim" "keyd" "niri" )
    local config_dir="$HOME/.config"
    local dotfiles_dir="$HOME/dotfiles"

    if [ ! -d "$dotfiles_dir" ]; then
        log_error "Dotfiles directory '$dotfiles_dir' does not exist. Please create it first."
        return 1
    fi

    (
        cd "$dotfiles_dir" || {
            log_error "Could not access directory $dotfiles_dir"
            return 1
        }

        local normalized_dotfiles_root
        normalized_dotfiles_root="$(readlink -f "$dotfiles_dir")"
        normalized_dotfiles_root="${normalized_dotfiles_root%/}"

        for folder in "${folders[@]}"; do
            log_info "Processing package '$folder'..."

            local package_source_dir="${normalized_dotfiles_root}/${folder}"

            if [ ! -d "$package_source_dir" ]; then
                log_warning "Source package directory '$package_source_dir' does not exist. Skipping this package."
                continue
            fi

            local target="$config_dir/$folder"
            local relative_target_from_config="${target#$config_dir/}"
            local expected_symlink_target="${package_source_dir}/.config/${relative_target_from_config}"
            expected_symlink_target="${expected_symlink_target%/}"

            if [ ! -e "$target" ]; then
                log_info "  '$target' does not exist. Proceeding to stow '$folder'."
                stow "$folder" --target="$HOME" --dir="$dotfiles_dir"
                if [ $? -eq 0 ]; then
                    log_success "  Successfully stowed '$folder' into '$config_dir'."
                else
                    log_error "  Stow of '$folder' failed."
                fi
                continue
            fi

            if [ -L "$target" ]; then
                local actual_link
                actual_link="$(readlink -f "$target")"
                actual_link="${actual_link%/}"

                if [ "$actual_link" = "$expected_symlink_target" ]; then
                    log_info "  '$target' is already correctly symlinked to '$expected_symlink_target'. Skipping."
                    continue
                else
                    log_info "  '$target' is an incorrect symlink (points to '$actual_link' instead of '$expected_symlink_target')."
                fi
            else
                log_info "  '$target' exists but is not a symlink. Will move to .bak."
            fi

            local bak_name="${target}.bak"
            local i=1
            while [ -e "$bak_name" ]; do
                bak_name="${target}.bak$i"
                ((i++))
            done

            log_info "  Moving '$target' to '$bak_name' to make way for new symlink."
            mv "$target" "$bak_name"
            if [ $? -ne 0 ]; then
                log_error "  Could not rename '$target' to '$bak_name'. Skipping stow for this package."
                continue
            fi

            log_info "  Proceeding to stow '$folder'."
            stow "$folder" --target="$HOME" --dir="$dotfiles_dir"
            if [ $? -eq 0 ]; then
                log_success "  Successfully stowed '$folder' into '$config_dir'."
            else
                log_error "  Stow of '$folder' failed."
            fi
        done
    )
}

# --------------------------------------
# SETUP NIRI ENVIRONMENT (WAYLAND)
# --------------------------------------
setup_niri_environment() {
    echo "🔧 Setting up Niri (Wayland) environment..."

    # Enable + start Bluetooth
    sudo systemctl enable --now bluetooth.service

    # Enable + start Pipewire and related services
    systemctl --user enable --now pipewire pipewire-pulse wireplumber

    # Enable + start libvirtd (virtualization)
    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt "$USER"
    sudo virsh net-start default 2>/dev/null || true
    sudo virsh net-autostart default 2>/dev/null || true
    sudo systemctl restart libvirtd

    # GTK / Gnome interface settings (Wayland Dark Theme)
    local base="org.gnome.desktop.interface"
    declare -A gnome_settings=(
        [color-scheme]="prefer-dark"
        [gtk-theme]="adw-gtk3-dark"
        [icon-theme]="Papirus-Dark"
        [cursor-theme]="Bibata-Modern-Ice"
        [font-name]="JetBrainsMono Nerd Font 11"
    )

    for key in "${!gnome_settings[@]}"; do
        gsettings set "$base" "$key" "${gnome_settings[$key]}" || true
    done

    # Create default user directories
    mkdir -p "$HOME/Documents" "$HOME/Downloads" "$HOME/Videos" "$HOME/Music" "$HOME/Pictures"

    # Grant permissions to scripts if present in niri config
    if [ -d "$HOME/.config/niri/scripts" ]; then
        chmod +x ~/.config/niri/scripts/*.sh 2>/dev/null || true
    fi

    echo "📦 Setting default applications (Wayland Native)..."

    declare -A default_apps=(
        ["x-scheme-handler/http"]="thorium-browser.desktop"
        ["x-scheme-handler/https"]="thorium-browser.desktop"
        ["text/html"]="thorium-browser.desktop"
        ["video/mp4"]="mpv.desktop"
        ["video/x-matroska"]="mpv.desktop"
        ["video/webm"]="mpv.desktop"
        ["audio/mpeg"]="mpv.desktop"
        ["audio/flac"]="mpv.desktop"
        ["application/x-terminal-emulator"]="com.mitchellh.ghostty.desktop"
        ["application/pdf"]="org.pwmt.zathura.desktop"
        ["image/png"]="imv.desktop"
        ["image/jpeg"]="imv.desktop"
        ["image/gif"]="imv.desktop"
        ["image/webp"]="imv.desktop"
    )

    for mime in "${!default_apps[@]}"; do
        xdg-mime default "${default_apps[$mime]}" "$mime" 2>/dev/null ||
            echo "⚠️ Could not set ${default_apps[$mime]} for $mime"
    done

    # Set default browser
    xdg-settings set default-web-browser "thorium-browser.desktop" ||
        echo "⚠️ Failed to set Thorium as default browser."

    # SDDM Theme Setup
    sudo mkdir -p /etc
    echo -e "[Theme]\nCurrent=sugar-candy" | sudo tee /etc/sddm.conf >/dev/null

    echo "✅ Niri environment setup complete."
}

# --------------------------------------
# SETUP KEYD REMAP
# --------------------------------------
setup_keyd_remap() {
    log_info "Setting up Keyd remapping for Insert to Home..."

    if [ ! -d "/etc/keyd" ]; then
        log_info "Creating /etc/keyd directory..."
        sudo mkdir -p /etc/keyd || {
            log_error "Failed to create /etc/keyd. Aborting."
            return 1
        }
    fi

    local keyd_config_file="/etc/keyd/default.conf"

    log_info "Writing Keyd configuration to $keyd_config_file..."
    if sudo bash -c 'cat <<EOF > "$0"
[ids]
*

[main]
insert = home
EOF' "$keyd_config_file"; then
        log_success "Keyd configuration written to $keyd_config_file."
    else
        log_error "Failed to write Keyd configuration. Aborting."
        return 1
    fi

    log_info "Enabling and starting keyd service..."
    if sudo systemctl enable --now keyd; then
        log_success "Keyd service enabled and started."
    else
        log_error "Failed to enable/start keyd service."
        return 1
    fi

    return 0
}

# --------------------------------------
# MAIN EXECUTION SECTION
# --------------------------------------

sudo timedatectl set-timezone "$TIMEZONE"
sudo pacman -Syu --noconfirm

# Install all base packages
for pkg in "${PACKAGES[@]}"; do install_package "$pkg"; done

# Install and configure Zsh & plugins
setup_zsh

# Install NodeJS (nvm, yarn)
install_nodejs

# Configure Git and SSH key
configure_git_and_ssh

# Config Docker
config_docker

# Stow config
stow_configs

# Optional setups
if ask_yes_no "Setup Niri environment?"; then setup_niri_environment; fi
if ask_yes_no "Remap keyd?"; then setup_keyd_remap; fi
if ask_yes_no "Clone wallpaper repository?"; then clone_wallpaper; fi

log_success "Arch Linux setup script for Niri completed!"
