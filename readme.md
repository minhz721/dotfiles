### My dotfiles

- Don't copy :))

- Dump config nemo
```bash
dconf dump /org/nemo/ > nemo_dconf_backup.txt
```
- Load config nemo

```bash
dconf load /org/nemo/ < nemo_dconf_backup.txt
```

## 🛠️ Virt-manager & SPICE Setup (Arch Linux & NixOS)

Guide to configuring KVM/QEMU virtualization, `virt-manager` GUI, hardware-accelerated graphics, and shared clipboard support via `SPICE`.

---

### 1. Arch Linux

Run the following commands in your Arch Linux terminal.

#### Step 1: Install required packages
```bash
sudo pacman -Syu qemu virt-manager libvirt dnsmasq ebtables iptables-nft spice-vdagent
```

#### Step 2: Enable and start the Libvirt service
```bash
sudo systemctl enable --now libvirtd
```

#### Step 3: Add your user to the libvirt group
Replace `$USER` with your actual username to run `virt-manager` without `sudo`.
```bash
sudo usermod -aG libvirt \$USER
```
*Note: Log out and log back in for the group changes to take effect.*

#### Step 4: Activate the default network
```bash
sudo virsh net-autostart default
sudo virsh net-start default
```

---

### 2. NixOS

Add the following configuration to your system configuration file (usually `/etc/nixos/configuration.nix`).

#### Step 1: Add configuration block to `configuration.nix`

```nix
{ config, pkgs, ... }:

{
  # 1. Enable Virtualization and Libvirtd
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      # Enable TPM and UEFI support for SPICE
      swtpm.enable = true;
      ovmf.enable = true;
    };
  };

  # 2. Install virt-manager GUI management program
  programs.virt-manager.enable = true;

  # 3. Enable SPICE agent service for guest optimization
  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # 4. Add your user to the libvirt group
  users.users.YOUR_USERNAME = { # Replace YOUR_USERNAME with your actual username
    extraGroups = [ "libvirt" ];
  };
}
```

#### Step 2: Rebuild the NixOS system
```bash
sudo nixos-rebuild switch
```
*Note: Reboot your system or log out and log back in to apply the new user group permissions.*

---

### 3. SPICE Configuration in Virtual Machines (For both OS)

To enable automatic display resizing and seamless copy-paste between the Host and Guest OS:

1. **On Virt-manager (Host):**
   * Open the virtual machine hardware details (Lightbulb icon `i`).
   * Ensure the display type is set to **Display SPICE**.
   * Ensure the video card type is set to **QXL** or **Virtio** (Enable 3D Acceleration if supported).
   * Add a new hardware device: Select **Channel** -> Name: `org.spice-space.webdav.0`.
2. **Inside the Virtual Machine (Guest):**
   * **If the Guest is Linux:** Install the `spice-vdagent` package inside that guest OS.
   * **If the Guest is Windows:** Download and install the `virtio-win.iso` drivers or run `spice-guest-tools.exe`.
   * Run `spice-vdagent -x`
