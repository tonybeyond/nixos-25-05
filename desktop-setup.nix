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

    # Enable sound
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Enable Flatpak
    services.flatpak.enable = true;

    # Enable virtualization
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    # Enable ZSH
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # Firewall configuration
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
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
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
    ];

    # System packages (equivalent to dnf install)
    environment.systemPackages = with pkgs; [
      # Core utilities
      wget
      curl
      git
      neovim
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
      nodejs
      npm
      cargo
      rustc
      
      # Media and codecs
      ntfs3g
      libva
      libvdpau
      
      # Terminal and shell
      alacritty
      eza
      
      # GNOME extensions and tools
      gnome.gnome-tweaks
      gnomeExtensions.pop-shell
      gnomeExtensions.user-themes
      gnomeExtensions.workspace-indicator
      gnomeExtensions.dash-to-panel
      gnomeExtensions.extension-manager
      
      # Browsers
      brave
      
      # AppImage support
      appimage-run
      
      # Virtualization
      qemu
      virt-viewer
      
      # System tools
      firewalld
      
      # Archive tools
      p7zip
      unrar
    ];

    # Enable AppImage support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    # User configuration
    users.users.${config.desktop-setup.user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "audio" "video" ];
      shell = pkgs.zsh;
    };
  };
}
