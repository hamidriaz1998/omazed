# Omazed

Live theme switching for Zed in Omarchy - automatically synchronize your Zed editor theme with your Omarchy system theme. Includes automatic theme generation from Alacritty configs when no Zed theme is available.

## Features

- 🎨 **Live Theme Switching**: Zed theme changes instantly when you change your Omarchy system theme
- 🤖 **Automatic Theme Generation**: Creates Zed themes from Alacritty configs when no pre-made theme exists
- 🪝 **Omarchy Hook Integration**: Uses native omarchy hooks for seamless integration (no background service needed!)
- ⚡ **Lightweight**: Simple bash script

## Installation

### AUR (Recommended)

```bash
yay -S omazed

# Complete setup
omazed setup
```

That's it! Live theme switching is now active.

**Note:** Version 1.1.0+ uses the new omarchy hook system available in omarchy 3.1.0. If you're upgrading from an older version, run `omazed setup` to automatically migrate from systemd to hooks.

### Manual Install

```bash
git clone https://github.com/aps6/omazed.git
cd omazed
./install.sh
```

## Quick Update

### AUR Installation
```bash
yay -S omazed && omazed setup
```

### Manual Installation
```bash
cd omazed && git pull && ./install.sh
```

## How It Works

1. **Theme Installation**: Copies `.json` theme files to `~/.config/zed/themes/`
2. **Hook Integration**: Adds `omazed set "$1"` to `~/.config/omarchy/hooks/theme-set`
3. **Theme Change Trigger**: When you change your Omarchy theme, omarchy calls the hook
4. **Theme Resolution**: Uses pre-made theme or generates one from Alacritty config
5. **Settings Update**: Updates `~/.config/zed/settings.json` with new theme
6. **Instant Apply**: Zed automatically picks up the theme change

## Available Themes

The following default Omarchy themes are included:
- Catppuccin 
- Catppuccin Latte
- Everforest 
- Gruvbox
- Kanagawa 
- Matte Black 
- Nord 
- Osaka Jade 
- Ristretto 
- Rose Pine
- Tokyo Night
- Flexoki Light 
- Ethereal
- Hackerman

## Automatic Theme Generation

For themes without pre-made Zed themes, Omazed automatically:
- Reads the Alacritty config from `~/.config/omarchy/current/alacritty.toml`
- Extracts color palette information
- Generates a compatible Zed theme with proper syntax highlighting
- Saves the generated theme for future use

This ensures that **all** Omarchy themes work with Zed.

> **Note**: Some extra themes may not work with the converter.

## Adding Custom Themes

1. Add your `.json` theme file to the `~/.config/zed/themes` directory
   > **Tip**: You can find additional themes at [zed-themes.com](https://zed-themes.com/)
2. Ensure that the theme name matches the omarchy theme name (ex: Tokyo Night) and the file name is the theme name in lowercase separated by '-' (ex: tokyo-night).
3. The sync script will automatically use it when that theme is active

## Usage

### Commands
```bash
# Set up themes and hook integration (or systemd fallback)
omazed setup

# Set a specific theme by name (used by omarchy hooks)
omazed set "theme-name"

# Sync current omarchy theme to Zed
omazed sync
```

### Migration from Older Versions

If you're upgrading from v1.0.x or earlier (systemd-based):

```bash
# Automatic migration
omazed setup
```

This will:
- Detect your existing systemd setup
- Stop and disable the systemd service
- Set up omarchy hook integration
- Preserve all your themes and settings

You can safely remove the old systemd service file afterwards:
```bash
rm ~/.config/systemd/user/omazed.service
```

## Troubleshooting

### Theme Not Syncing (Hook-based setup)
```bash

# Check if hook file exists and is executable
ls -la ~/.config/omarchy/hooks/theme-set

# Manually sync once to test
omazed sync

# Try setting a specific theme
omazed set "tokyo-night"
```

## Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/aps6/omazed/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/aps6/omazed/discussions)
