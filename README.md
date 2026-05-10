# Omazed

Live theme switching for Zed in Omarchy. Omazed generates a Zed theme from the current Omarchy palette and keeps it in sync when you change themes.

## Features

- Live theme syncing through Omarchy hooks
- Generates `~/.config/zed/themes/omazed.json` from `colors.toml` (fallback to `alacritty.toml`)
- Per-theme caching — **~0.1s** on cache hit instead of ~10s regeneration
- Smart cache invalidation via mtime comparison (colors, template, light/dark mode)
- One-time Zed theme selection on first run after install/update
- Lightweight Bash workflow

## Installation

### AUR (Original)

```bash
yay -S omazed

# Complete setup
omazed setup
```

### Manual (User-space)

```bash
git clone https://github.com/hamidriaz1998/omazed.git
cd omazed
./install.sh
```

### System-wide (mirrors AUR layout)

```bash
git clone https://github.com/hamidriaz1998/omazed.git
cd omazed
sudo bash install-system.sh
```

## How It Works

1) Omazed registers itself as an Omarchy hook at `~/.config/omarchy/hooks/theme-set` with the **full absolute path** to the `omazed` binary, ensuring it works regardless of PATH (fixes issues with Hyprland keybindings and other minimal-PATH environments).
2) On first run after install/update, Omazed sets the Zed theme to `Omazed` once in `settings.json`.
3) On every theme change (`omarchy theme set "name"`), Omarchy triggers the hook which runs `omazed set "name"`.
4) **Cache check**: if `~/.cache/omazed/<name>.json` exists and is newer than the source `colors.toml`, template, and `light.mode` file, it's copied instantly (~0.1s).
5) **Cache miss**: regenerates the theme via `omazed-generator.sh` and saves the result to cache for next time.
6) `omazed sync` always regenerates, then updates the cache.

## Usage

```bash
# Set up hooks and sync once
omazed setup

# Regenerate theme for the current Omarchy palette (always regens)
omazed sync

# Generate theme (used by Omarchy hook, serves from cache if valid)
omazed set "theme-name"
```

## File Locations

| What | Path |
|---|---|
| Generated Zed theme | `~/.config/zed/themes/omazed.json` |
| Theme cache | `~/.cache/omazed/<theme-name>.json` |
| Omarchy hook | `~/.config/omarchy/hooks/theme-set` |
| Color source | `~/.config/omarchy/current/theme/colors.toml` |
| Logs | `~/.local/share/omazed/sync.log` |

## Notes

- Omazed only sets the Zed theme to `Omazed` once on first run after install/update.
- After that, it never overrides your Zed theme selection.
- To force-regenerate and refresh cache: `omazed sync`
- To clear the cache entirely: `rm -rf ~/.cache/omazed`

## Troubleshooting

```bash
# Verify hook exists
ls -la ~/.config/omarchy/hooks/theme-set

# Check hook contains full path to omazed
grep omazed ~/.config/omarchy/hooks/theme-set

# Manual regeneration test
omazed sync

# Check log file
cat ~/.local/share/omazed/sync.log

# Verify cached themes
ls -la ~/.cache/omazed/
```

## Support

- Issues: https://github.com/hamidriaz1998/omazed/issues
