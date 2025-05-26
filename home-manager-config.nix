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
        
        # EZA aliases
        shellAliases = {
          ls = "eza --icons --group-directories-first";
          ll = "eza -alF --icons --group-directories-first";
          la = "eza -a --icons --group-directories-first";
          l = "eza -F --icons --group-directories-first";
        };
        
        initExtra = ''
          # Add cargo bin to PATH
          export PATH="$HOME/.cargo/bin:$PATH"
          
          # Ghostty resources
          export GHOSTTY_RESOURCES_DIR="$HOME/.local/share/ghostty"
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
              background = "#1e1e2e";
              foreground = "#cdd6f4";
              dim_foreground = "#7f849c";
              bright_foreground = "#cdd6f4";
            };

            cursor = {
              text = "#1e1e2e";
              cursor = "#d4af37";  # Rich gold
            };

            vi_mode_cursor = {
              text = "#1e1e2e";
              cursor = "#f4d03f";  # Lighter gold
            };

            search = {
              matches = { foreground = "#1e1e2e"; background = "#a6adc8"; };
              focused_match = { foreground = "#1e1e2e"; background = "#d4af37"; };
            };

            selection = {
              text = "#1e1e2e";
              background = "#e6c547";
            };

            normal = {
              black = "#45475a";
              red = "#f38ba8";
              green = "#a6e3a1";
              yellow = "#d4af37";     # Rich golden yellow
              blue = "#89b4fa";
              magenta = "#f5c2e7";
              cyan = "#94e2d5";
              white = "#bac2de";
            };

            bright = {
              black = "#585b70";
              red = "#f38ba8";
              green = "#a6e3a1";
              yellow = "#f4d03f";     # Bright golden yellow
              blue = "#89b4fa";
              magenta = "#f5c2e7";
              cyan = "#94e2d5";
              white = "#a6adc8";
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

      # Git configuration
      programs.git = {
        enable = true;
        userName = "Your Name";
        userEmail = "your.email@example.com";
      };

      # Neovim
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };

      # Flatpak applications (installed via script)
      home.file.".local/bin/install-flatpaks.sh" = {
        text = ''
          #!/bin/bash
          
          # Add Flathub repository
          flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
          
          # Install Flatpak applications
          FLATPAK_APPS=(
            "com.visualstudio.code"
            "org.standardnotes.standardnotes"
            "com.github.flxzt.rnote"
            "com.github.tchx84.Flatseal"
            "org.videolan.VLC"
            "com.mattjakeman.ExtensionManager"
            "io.github.brunofin.Cohesion"
            "dev.zed.Zed"
            "com.belmoussaoui.Obfuscate"
            "com.rustdesk.RustDesk"
            "com.github.johnfactotum.Foliate"
            "app.zen_browser.zen"
            "org.chromium.Chromium"
            "com.microsoft.Edge"
            "org.feichtmeier.Musicpod"
          )
          
          for app_id in "''${FLATPAK_APPS[@]}"; do
            echo "Installing $app_id..."
            flatpak install -y --user flathub "$app_id" || echo "Failed to install $app_id"
          done
        '';
        executable = true;
      };

      # Ghostty AppImage installer script
      home.file.".local/bin/install-ghostty.sh" = {
        text = ''
          #!/bin/bash
          
          APP_DIR="$HOME/.local/bin"
          mkdir -p "$APP_DIR"
          
          GHOSTTY_APPIMAGE="$APP_DIR/Ghostty-x86_64.AppImage"
          
          if [ ! -f "$GHOSTTY_APPIMAGE" ]; then
            echo "Downloading Ghostty..."
            wget -O "$GHOSTTY_APPIMAGE" "https://github.com/psadi/ghostty-appimage/releases/download/v1.0.1%2B4/Ghostty-1.0.1-x86_64.AppImage"
            chmod +x "$GHOSTTY_APPIMAGE"
            
            # Create desktop entry
            mkdir -p "$HOME/.local/share/applications"
            cat > "$HOME/.local/share/applications/ghostty.desktop" << EOF
          [Desktop Entry]
          Name=Ghostty
          Exec=$GHOSTTY_APPIMAGE
          Icon=terminal
          Type=Application
          Categories=System;TerminalEmulator;
          EOF
            
            echo "Ghostty installed successfully"
          else
            echo "Ghostty already installed"
          fi
        '';
        executable = true;
      };

      # EZA installer script
      home.file.".local/bin/install-eza.sh" = {
        text = ''
          #!/bin/bash
          
          if ! command -v eza &>/dev/null; then
            echo "Installing eza via cargo..."
            cargo install eza
            echo "eza installed successfully"
          else
            echo "eza already installed"
          fi
        '';
        executable = true;
      };

      home.stateVersion = "24.05";
    };
  };
}
