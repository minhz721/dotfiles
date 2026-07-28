#!/bin/bash
#  _      ______ ____  __  __ _____ _   _
# | |    |  ____/ __ \|  \/  |_   _| \ | |
# | |    | |__ | |  | | \  / | | | |  \| |
# | |    |  __|| |  | | |\/| | | | | . ` |
# | |____| |___| |__| | |  | |_| |_| |\  |
# |______|______\____/|_|  |_|_____|_| \_|

set -euo pipefail

# --------------------------------------
# CONFIGURATION SECTION: Set up variables, timezone, user, and package lists
# --------------------------------------

TIMEZONE="Asia/Ho_Chi_Minh" # Timezone for your system

# List of essential packages to install (system, dev, terminal, GUI, fonts, etc.)

PACKAGES=(
    # --- Development & CLI Tools ---
    python python-pip python-virtualenv tk ffmpeg vim neovim stow eza bat fzf tree ripgrep tldr dotnet-sdk-8.0 dotnet-runtime-8.0 zoxide starship git fastfetch visual-studio-code-bin mission-center dbeaver lazygit lazydocker docker localsend-bin

    # --- Browsers & Communication ---
    thorium-browser-bin brave-bin discord telegram-desktop-bin zathura ghostty 

    # --- Input Method ---
    fcitx5 fcitx5-im fcitx5-qt fcitx5-gtk fcitx5-bamboo fcitx5-configtool

    # --- Fonts ---
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji ttf-dejavu ttf-roboto ttf-liberation adobe-source-han-sans-otc-fonts

    # --- Cursors, Themes, Look & Feel ---
    bibata-cursor-theme adw-gtk-theme papirus-icon-theme

    # --- File Managers & Utilities ---
    nemo nemo-fileroller gsimplecal

    # --- System Utilities & Media ---
    gnome-disk-utility polkit-gnome obs-studio ntfs-3g exfatprogs imv pamac-aur dconf-editor qemu virt-manager libvirt dnsmasq ebtables iptables-nft mpv cava keyd xclip unzip

    # --- Audio (commented out, optional) ---
    pamixer pipewire-alsa pipewire-pulse wireplumber playerctl python-pulsectl-asyncio bluez bluez-utils blueman python-dbus-fast python-dbus-next

    # qtile
    rofi picom python-psutil dunst xorg-xrandr scrot yad xdotool xautolock sddm-sugar-candy-git xfce4-screensaver feh 
)

# --------------------------------------
# HELPER FUNCTIONS SECTION: Utility, logging, package management
# --------------------------------------

# Logging functions for info, success, warning, and error
log_info() { echo "[INFO] $1"; }
log_success() { echo "[OK]   $1"; }
log_warning() { echo "[WARN] $1"; }
log_error() { echo "[ERR]  $1"; }

# Check result of a command, exit if non-zero
check_result() {
    if [ "$1" -ne 0 ]; then
        log_error "$2"
        exit 1
    fi
}

# Check if a package is installed (pacman or paru)
is_installed() {
    paru -Q "$1" &>/dev/null || pacman -Q "$1" &>/dev/null
}

# Install a package if not already installed
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
# Setup global Git user and email, generate SSH key if not exists
# --------------------------------------
configure_git_and_ssh() {
    SSH_KEY_FILE="$HOME/.ssh/id_ed25519"

    # Skip the entire function if SSH key already exists
    if [ -f "$SSH_KEY_FILE" ]; then
        echo "SSH key already exists at $SSH_KEY_FILE. Skipping Git and SSH configuration."
        return
    fi

    # Prompt for Git user.name and user.email
    read -rp "Enter your Git user.name: " USER_NAME
    read -rp "Enter your Git user.email: " USER_EMAIL

    # Configure Git
    git config --global user.name "$USER_NAME"
    git config --global user.email "$USER_EMAIL"

    # Generate SSH key
    echo "Generating SSH key at $SSH_KEY_FILE..."
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$SSH_KEY_FILE" -N ""

    # Add key to ssh-agent
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_FILE"

    # Show public key
    echo "Your public SSH key:"
    cat "${SSH_KEY_FILE}.pub"
}

# --------------------------------------
# DOCKER INSTALLATION AND ENABLEMENT
# Install Docker and add current user to docker group
# --------------------------------------
config_docker() {
    # Enable and start docker service
    sudo systemctl enable docker.service

    # Make sure to add the executing user (not root if running sudo)
    local real_user="${SUDO_USER:-$USER}"
    sudo usermod -aG docker "$real_user"

    log_success "Docker installed. Please log out or run 'newgrp docker'."
}

# --------------------------------------
# DOWNLOAD WALLPAPER REPOSITORY FROM GITHUB
# --------------------------------------
clone_wallpaper() {
    log_info "Cloning wallpaper repository..."

    # Check if ~/Pictures directory exists, if not, create it
    if [ ! -d "$HOME/Pictures" ]; then
        log_info "$HOME/Pictures does not exist. Creating it..."
        mkdir -p "$HOME/Pictures" &&
            log_success "Successfully created $HOME/Pictures." ||
            {
                log_error "Failed to create $HOME/Pictures. Aborting wallpaper clone."
                return 1
            }
    fi

    # Check if wallpaper repository directory exists before cloning
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
    # Install NVM (Node Version Manager)
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # Source NVM to make it available in the current shell session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install the latest LTS version of Node.js
    nvm install --lts

    # Install Yarn globally using npm
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
# INSTALL AND CONFIGURE ZSH (Oh My Zsh + plugins)
# --------------------------------------
setup_zsh() {
    # 1. Install Zsh if not present
    if ! command -v zsh &>/dev/null; then
        log_info "Installing Zsh..."
        # sudo pacman -S --noconfirm zsh && log_success "Zsh installed." || {
        #     log_error "Failed to install Zsh."
        #     return 1
        # }
        install_package "zsh"
    else
        log_info "Zsh is already installed, skipping."
    fi

    # 2. Install Oh My Zsh
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

    # 3. Set Zsh as default shell
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

    # 4. Install recommended Zsh plugins
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

    # 5. Update ~/.zshrc plugins section
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

    # 6. Check and copy .zshrc file from dotfiles
    if [ -f "$HOME/.zshrc" ]; then
        log_info "Detected old ~/.zshrc, proceeding to delete..."
        rm "$HOME/.zshrc"
    fi
    if [ -f "$HOME/dotfiles/zshrc/.zshrc" ]; then
        # cp "$HOME/dotfiles/zshrc/.zshrc" "$HOME/"
        stow "zshrc" --target="$HOME" --dir="$HOME/dotfiles"
        log_success "Stow ~/dotfiles/zshrc/.zshrc to $HOME/.zshrc"
    else
        log_warning "~/dotfiles/zshrc/.zshrc not found, skipping copy step."
    fi

    log_warning "📌 Add the following plugins to your ~/.zshrc: plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions z docker docker-compose)"
}

# Gnu stow config
stow_configs() {
    local folders=("ghostty" "nvim" "keyd" "qtile" )
    local config_dir="$HOME/.config"
    local dotfiles_dir="$HOME/dotfiles"

    # Ensure the dotfiles_dir exists
    if [ ! -d "$dotfiles_dir" ]; then
        log_error "Dotfiles directory '$dotfiles_dir' does not exist. Please create it first."
        return 1
    fi

    # Change into the dotfiles_dir so 'stow' can operate correctly
    # Use a subshell () to avoid changing the current directory of the calling shell
    (
        cd "$dotfiles_dir" || {
            log_error "Could not access directory $dotfiles_dir"
            return 1
        }

        local normalized_dotfiles_root
        normalized_dotfiles_root="$(readlink -f "$dotfiles_dir")"
        normalized_dotfiles_root="${normalized_dotfiles_root%/}" # Remove trailing slash if any

        for folder in "${folders[@]}"; do
            log_info "Processing package '$folder'..."

            # Full path to the package source directory within dotfiles (e.g., /home/minhtd/dotfiles/nvim)
            local package_source_dir="${normalized_dotfiles_root}/${folder}"

            # Check if the package source directory actually exists
            if [ ! -d "$package_source_dir" ]; then
                log_error "  Source package directory '$package_source_dir' does not exist. Skipping this package."
                continue
            fi

            # The path where the symlink is expected to appear (e.g., ~/.config/nvim)
            local target="$config_dir/$folder"

            # --- CALCULATE PRECISE expected_symlink_target ---
            # This is crucial to match your specific dotfile structure (e.g., dotfiles/package/.config/package)
            local expected_symlink_target=""

            # => relative_target_from_config = nvim
            local relative_target_from_config="${target#$config_dir/}"

            expected_symlink_target="${package_source_dir}/.config/${relative_target_from_config}"
            expected_symlink_target="${expected_symlink_target%/}" # Canonicalize: remove trailing slash if any

            # --- 1. If the target does NOT exist ---
            if [ ! -e "$target" ]; then
                log_info "  '$target' does not exist. Proceeding to stow '$folder'."
                stow "$folder" --target="$HOME" --dir="$dotfiles_dir"
                if [ $? -eq 0 ]; then
                    log_success "  Successfully stowed '$folder' into '$config_dir'."
                else
                    log_error "  Stow of '$folder' failed."
                fi
                continue # Move to the next package
            fi

            # --- 2. If the target IS a symlink AND points to the CORRECT source ---
            if [ -L "$target" ]; then # Check if it's a symbolic link
                local actual_link
                actual_link="$(readlink -f "$target")" # Get the absolute path the symlink points to
                actual_link="${actual_link%/}"         # Canonicalize: remove trailing slash if any

                if [ "$actual_link" = "$expected_symlink_target" ]; then
                    log_info "  '$target' is already correctly symlinked to '$expected_symlink_target'. Skipping."
                    continue # Move to the next package
                else
                    log_info "  '$target' is an incorrect symlink (points to '$actual_link' instead of '$expected_symlink_target')."
                fi
            else
                # If -e is true but -L is false, it's a regular directory or file
                log_info "  '$target' exists but is not a symlink. Will move to .bak."
            fi

            # --- 3. If the target exists but is NOT a correct symlink (or is a wrong symlink) ---
            # (Execution reaches here if the above conditions were not met)
            local bak_name="${target}.bak"
            local i=1
            while [ -e "$bak_name" ]; do # Find a unique backup name
                bak_name="${target}.bak$i"
                ((i++))
            done

            log_info "  Moving '$target' to '$bak_name' to make way for new symlink."
            mv "$target" "$bak_name"
            if [ $? -ne 0 ]; then
                log_error "  Could not rename '$target' to '$bak_name'. Skipping stow for this package."
                continue
            fi

            # Finally, perform the stow operation
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

config_nemo(){
    # Configure Nemo Action for Ghostty
    echo "📂 Configuring Nemo Action for Ghostty..."

    local nemo_action_dir="$HOME/.local/share/nemo/actions"
    local nemo_action_file="$nemo_action_dir/ghostty.nemo_action"

    mkdir -p "$nemo_action_dir"

    if [[ -f "$nemo_action_file" ]] && grep -q '^Exec=ghostty --working-directory=%F$' "$nemo_action_file"; then
        echo "ℹ️ Ghostty Nemo Action already exists. Skipping."
    else
        cat > "$nemo_action_file" <<'EOF'
[Nemo Action]
Name=Open in Ghostty
Comment=Open Ghostty terminal in the current directory
Exec=ghostty --working-directory=%F
Icon-Name=com.mitchellh.ghostty
Selection=none
Extensions=dir;
Quote=double
EOF

        echo "✅ Created Ghostty Nemo Action."

        # Restart Nemo if it's running
        if pgrep -x nemo >/dev/null; then
            nemo -q
            nohup nemo >/dev/null 2>&1 &
        fi
    fi

    # Load confg
    dconf load /org/nemo/ < nemo_dconf_backup.txt

}

setup_qtile_environment() {
    echo "🔧 Setting up Qtile environment..."

    # Enable and start Bluetooth service
    sudo systemctl enable --now bluetooth.service

    # Enable and start Pipewire and related audio services
    systemctl --user restart pipewire pipewire-pulse wireplumber

    # Enable and start libvirtd (virtualization)
    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt "$USER"

    # Safely start and autostart default network
    sudo virsh net-start default --already-activated 2>/dev/null || true
    sudo virsh net-autostart default 2>/dev/null || true

    # GNOME interface settings
    local base="org.gnome.desktop.interface"
    declare -A gnome_settings=(
        [color-scheme]="prefer-dark"
        [gtk-theme]="adw-gtk3-dark"
        [icon-theme]="Adwaita"
        [cursor-theme]="Bibata-Modern-Ice"
        [font-name]="JetBrainsMono Nerd Font 11"
    )

    for key in "${!gnome_settings[@]}"; do
        gsettings set "$base" "$key" "${gnome_settings[$key]}" || true
    done

    # Cinnamon / General Desktop settings
    # gsettings set org.cinnamon.desktop.default-applications.terminal exec ghostty || true
    gsettings set org.cinnamon.desktop.privacy remember-recent-files false || true

    # Create default user directories
    mkdir -p "$HOME/Documents" "$HOME/Downloads" "$HOME/Videos" "$HOME/Music"

    # Grant execution permissions to Qtile scripts
    [[ -f ~/.config/qtile/autostart_once.sh ]] && chmod +x ~/.config/qtile/autostart_once.sh
    if [[ -d ~/.config/qtile/scripts ]]; then
        chmod +x ~/.config/qtile/scripts/*.sh 2>/dev/null || true
    fi

    # Copy xinitrc file
    if [[ -f "$HOME/dotfiles/.xinitrc" ]]; then
        cp "$HOME/dotfiles/.xinitrc" "$HOME/.xinitrc"
    fi

    echo "📦 Setting default applications..."

    # Ensure xdg-utils is available
    if ! command -v xdg-mime &> /dev/null; then
        echo "⚠️ Error: xdg-utils is not installed."
    fi

    # MIME type definitions
    declare -A default_apps=(
        [x-scheme-handler/http]="thorium-browser.desktop"
        [x-scheme-handler/https]="thorium-browser.desktop"
        [text/html]="thorium-browser.desktop"
        [video/mp4]="mpv.desktop"
        [video/x-matroska]="mpv.desktop"
        [video/webm]="mpv.desktop"
        [video/avi]="mpv.desktop"
        [audio/mpeg]="mpv.desktop"
        [audio/flac]="mpv.desktop"
        [audio/wav]="mpv.desktop"
        [application/pdf]="org.pwmt.zathura.desktop"
        [image/png]="imv.desktop"
        [image/jpeg]="imv.desktop"
        [image/gif]="imv.desktop"
        [image/webp]="imv.desktop"
        [image/bmp]="imv.desktop"
        [image/tiff]="imv.desktop"
        [image/svg+xml]="imv.desktop"
    )

    for mime in "${!default_apps[@]}"; do
        xdg-mime default "${default_apps[$mime]}" "$mime" 2>/dev/null ||
            echo "⚠️ Warning: Could not set ${default_apps[$mime]} for $mime"
    done

    # Set default web browser
    xdg-settings set default-web-browser "thorium-browser.desktop" 2>/dev/null ||
        echo "⚠️ Warning: Failed to set Thorium as default browser."

    # Configure SDDM Theme
    sudo mkdir -p /etc
    echo -e "[Theme]\nCurrent=sugar-candy" | sudo tee /etc/sddm.conf >/dev/null

    # Configure Nemo Action for Ghostty
    config_nemo

    xfconf-query -c xfce4-screensaver -p /saver/enabled -n -t bool -s false

    echo "✅ Qtile environment setup complete."
}


setup_keyd_remap() {
    log_info "Setting up Keyd remapping for Insert to Home..."

    sudo systemctl enable --now keyd
    sudo systemctl restart keyd

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
    if sudo systemctl enable keyd && sudo systemctl start keyd; then
        log_success "Keyd service enabled and started."
    else
        log_error "Failed to enable/start keyd service. Check logs."
        return 1
    fi

    log_info "Reloading keyd service to apply changes..."
    if sudo systemctl restart keyd; then
        log_success "Keyd configuration applied. Insert key should now function as Home."
    else
        log_warning "Could not reload keyd service (it might not have been running). Please check manually."
    fi

    log_success "Keyd remapping setup complete."
    return 0
}

# --------------------------------------
# MAIN EXECUTION SECTION: The actual installation steps and user prompts
# --------------------------------------

# Set timezone and update system packages
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

# Optional setups with yes/no prompt for user customization
if ask_yes_no "Setup qtile environment?"; then setup_qtile_environment; fi
if ask_yes_no "Remap keyd?"; then setup_keyd_remap; fi
if ask_yes_no "Clone wallpaper repository?"; then clone_wallpaper; fi

log_success "Arch Linux setup script completed!"
