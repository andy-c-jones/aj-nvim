# AJ's Minimalist Neovim Configuration


## Features

- Floating terminal toggle with `<Space>t`
- Basic editor settings optimized for coding
- Minimal and fast configuration

## Installation

### Windows

1. Clone or download this repository
2. Open **PowerShell as Administrator**
3. Create a symbolic link to your Neovim config directory:

```powershell
New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "path\to\aj-nvim"
```

Replace the path with your actual project location.

### Linux/macOS

1. Clone or download this repository
2. Create a symbolic link to your Neovim config directory:

```bash
# Linux/macOS
ln -s /path/to/aj-nvim ~/.config/nvim
```

Replace `/path/to/aj-nvim` with your actual project location.

## Usage

- `<Space>t` - Toggle floating terminal (works in normal and terminal mode)
- Terminal window is persistent and will remember your session

## Configuration

The entire configuration is contained in `init.lua`. Modify this file to customize your setup.
