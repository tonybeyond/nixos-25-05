{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      # Environment settings
      env = {
        TERM = "xterm-256color";
      };

      # Window configuration
      window = {
        dimensions = {
          columns = 120;
          lines = 30;
        };
        padding = {
          x = 8;
          y = 8;
        };
        dynamic_padding = false;
        decorations = "full";
        opacity = 0.95;
        startup_mode = "Windowed";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };

      # Scrolling configuration
      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      # Font configuration
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold Italic";
        };
        size = 12.0;
        offset = { x = 0; y = 0; };
        glyph_offset = { x = 0; y = 0; };
        builtin_box_drawing = true;
      };

      # Color configuration (Catppuccin Mocha with Golden Accents)
      colors = {
        draw_bold_text_with_bright_colors = true;
        
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          dim_foreground = "#7f849c";
          bright_foreground = "#cdd6f4";
        };

        # ... (rest of your color configuration remains the same)
        # You can keep the entire colors block from your original configuration
      };

      # Bell configuration
      bell = {
        animation = "EaseOutExpo";
        duration = 0;
        color = "#d4af37";
      };

      # Cursor configuration
      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        vi_mode_style = "None";
        blink_interval = 750;
        unfocused_hollow = true;
        thickness = 0.15;
      };

      # Mouse and keyboard bindings
      mouse = {
        hide_when_typing = false;
        bindings = [
          {
            mouse = "Right";
            action = "PasteSelection";
          }
        ];
      };

      # Keyboard bindings (you can add more or customize)
      keyboard.bindings = [
        # Clipboard operations
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        # Add more bindings from your original configuration
      ];
    };
  };
}
