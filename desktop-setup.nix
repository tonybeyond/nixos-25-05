{ config, pkgs, lib, ... }:

{
  options.desktop-setup = {
    enable = lib.mkEnableOption "Complete desktop setup";
    user = lib.mkOption {
      type = lib.types.str;
      description = "Username to configure";
    };
  };

  config = lib.mkIf config.desktop-setup.enable {
    # Enable essential services
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Flatpak is removed, services.flatpak.enable = true; is deleted

    # Enable virtualization
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # Enable ZSH
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Firewall configuration using NixOS module
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # Example, adjust as needed
      # allowedUDPPorts = [ ... ];
    };

    # System optimization
    services.logind.lidSwitch = "ignore";

    # Kernel parameters for optimization
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
    };

    # Fonts
    fonts.packages = with pkgs; [
      jetbrains-mono
      # Install the specific Nerd Font package you want
      jetbrains-mono-nerd-font  # Correct - installs JetBrains Mono Nerd Font
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
    ];

    # System packages
    environment.systemPackages = with pkgs; [
      # Core utilities
      wget
      curl
      git
      neovim # Neovim is also managed by home-manager, consider if system-wide is needed
      btop
      tmux
      fzf
      tree
      unzip
      zip

      # Development tools
      gcc
      gnumake
      python3
      nodejs # Consider specific versions if needed, e.g., nodejs-18_x
      # npm # Usually comes with nodejs, or can be specified if a different version is needed
      cargo
      rustc

      # Media and codecs
      ntfs3g
      libva
      libvdpau # For hardware video acceleration

      # Terminal and shell
      alacritty # Also configured via home-manager
      eza # eza is installed here, script removed from home-manager

      # GNOME extensions and tools
      gnome-tweaks
      gnomeExtensions.pop-shell
      gnomeExtensions.user-themes
      gnomeExtensions.workspace-indicator
      gnomeExtensions.dash-to-panel
      gnome-extension-manager

      # Browsers
      brave
      chromium # Added from former Flatpak list

      # AppImage support
      appimage-run

      # Virtualization
      qemu
      virt-viewer

      # System tools
      # firewalld # Removed, using NixOS networking.firewall

      # Archive tools
      p7zip
      unrar

      # Applications previously installed via Flatpak script
      vscode # Or vscodium 
      rnote
      vlc
      zed-editor
      rustdesk
    ];

    # Enable AppImage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    # User configuration
    users.users.${config.desktop-setup.user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "audio" "video" ]; # Added audio and video groups
      shell = pkgs.zsh;
    };
  };
}
