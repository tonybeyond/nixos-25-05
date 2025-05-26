{ config, pkgs, lib, ... }:

{
  options.home-manager-setup = {
    enable = lib.mkEnableOption "Home Manager configuration";
    user = lib.mkOption {
      type = lib.types.str;
      description = "Username to configure";
    };
  };

  config = lib.mkIf config.home-manager-setup.enable {
    home-manager.users.${config.home-manager-setup.user} = { config, pkgs, ... }: {

      # ZSH with Oh My Zsh
      programs.zsh = {
        enable = true;
        oh-my-zsh = {
          enable = true;
          theme = "agnoster";
          plugins = [
            "git"
            "sudo"
            "docker"
            "kubectl"
            "zsh-syntax-highlighting"
            "zsh-autosuggestions"
          ];
        };
        # EZA aliases (eza is installed system-wide now)
        shellAliases = {
          ls = "eza --icons --group-directories-first";
          ll = "eza -alF --icons --group-directories-first";
          la = "eza -a --icons --group-directories-first";
          l = "eza -F --icons --group-directories-first";
        };
        initExtra = ''
          # Add user-installed cargo binaries to PATH
          export PATH="$HOME/.cargo/bin:$PATH"
          # Ghostty resources line removed
        '';
      };

      # Alacritty configuration with golden Catppuccin theme
      programs.alacritty = {
        enable = true;
        settings = {
          env.TERM = "xterm-256color";
          window = {
            dimensions = { columns = 120; lines = 30; };
            padding = { x = 8; y = 8; };
            dynamic_padding = false;
            decorations = "full";
            opacity = 0.95;
            startup_mode = "Windowed";
            title = "Alacritty";
            dynamic_title = true;
          };
          scrolling = {
            history = 10000;
            multiplier = 3;
          };
          font = {
            normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
            bold = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
            italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
            bold_italic = { family = "JetBrainsMono Nerd Font"; style = "Bold Italic"; };
            size = 12.0;
            builtin_box_drawing = true;
          };
          colors = {
            draw_bold_text_with_bright_colors = true;
            primary = {
              background = "#1e1e2e"; # Catppuccin Macchiato Base
              foreground = "#cdd6f4"; # Catppuccin Macchiato Text
              dim_foreground = "#7f849c"; # Catppuccin Macchiato Subtext0
              bright_foreground = "#cdd6f4"; # Catppuccin Macchiato Text
            };
            cursor = {
              text = "#1e1e2e";       # Catppuccin Macchiato Base
              cursor = "#f5e0dc";     # Catppuccin Macchiato Rosewater (example, can be gold)
            };
            vi_mode_cursor = {
              text = "#1e1e2e";       # Catppuccin Macchiato Base
              cursor = "#b4befe";     # Catppuccin Macchiato Lavender (example)
            };
            search = {
              matches = { foreground = "#1e1e2e"; background = "#a6adc8"; }; # Base, Overlay0
              focused_match = { foreground = "#1e1e2e"; background = "#f9e2af"; }; # Base, Yellow
            };
            selection = {
              text = "#1e1e2e";        # Catppuccin Macchiato Base
              background = "#f5c2e7";  # Catppuccin Macchiato Pink
            };
            normal = { # Catppuccin Macchiato
              black = "#45475a";   # Surface1
              red = "#f38ba8";     # Red
              green = "#a6e3a1";   # Green
              yellow = "#f9e2af";  # Yellow
              blue = "#89b4fa";    # Blue
              magenta = "#f5c2e7"; # Pink
              cyan = "#94e2d5";    # Teal
              white = "#bac2de";   # Subtext1
            };
            bright = { # Catppuccin Macchiato
              black = "#585b70";   # Surface2
              red = "#f38ba8";     # Red
              green = "#a6e3a1";   # Green
              yellow = "#f9e2af";  # Yellow
              blue = "#89b4fa";    # Blue
              magenta = "#f5c2e7"; # Pink
              cyan = "#94e2d5";    # Teal
              white = "#a6adc8";   # Overlay0
            };
          };
          cursor = {
            style = { shape = "Block"; blinking = "On"; };
            blink_interval = 750;
            unfocused_hollow = true;
          };
          keyboard.bindings = [
            # Clipboard
            { key = "V"; mods = "Control|Shift"; action = "Paste"; }
            { key = "C"; mods = "Control|Shift"; action = "Copy"; }
            # Font size
            { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
            { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
            { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
            # Window management
            { key = "T"; mods = "Control|Shift"; action = "CreateNewWindow"; }
          ];
        };
      };

      # Git configuration (User should personalize these values)
      programs.git = {
        enable = true;
        userName = "Your Name"; # FIXME: Replace with your actual name
        userEmail = "your.email@example.com"; # FIXME: Replace with your actual email
      };

      # Neovim (basic enabling, configuration typically done via Neovim's own init.lua/vim or a Nixified Neovim config)
      programs.neovim = {
        enable = true;
        defaultEditor = true; # Sets $EDITOR to nvim
        viAlias = true;       # alias vi=nvim
        vimAlias = true;      # alias vim=nvim
      };

      # Flatpak applications script removed
      # home.file.".local/bin/install-flatpaks.sh" = { ... }; # REMOVED

      # Ghostty AppImage installer script removed
      # home.file.".local/bin/install-ghostty.sh" = { ... }; # REMOVED

      # EZA installer script removed (eza is now in systemPackages)
      # home.file.".local/bin/install-eza.sh" = { ... }; # REMOVED

      # Ensure Home Manager version aligns with system.stateVersion
      home.stateVersion = "25.05"; # Updated from "24.05"
    };
  };
}
