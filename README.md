# AJ's Minimalist Neovim Configuration

## Features

- Optimized for performance through minimalism
- Persistant floating terminal toggle with `<leader>tt`
- Keybinding cheatsheet with `<leader>cc`
- Telescope for fuzzy finding

## Prerequisites

### Windows

Install required dependencies using winget:

```powershell
# Install ripgrep (required for telescope file searching)
winget install BurntSushi.ripgrep.MSVC

# Install zig (required for treesitter compilation)
winget install zig.zig
```

### Ubuntu/Debian

```bash
# Install ripgrep
sudo apt update
sudo apt install ripgrep

# Install zig
sudo snap install zig --classic --beta
```

### Arch Linux

```bash
# Install ripgrep and zig
sudo pacman -S ripgrep zig
```

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

## Language Server Setup

This configuration includes LSP support for multiple languages. Each LSP server needs to be installed separately.

### Lua Language Server

**Installation**: Automatically installed via Mason when you first start Neovim.

### Bash Language Server

**Installation**:
```bash
# Via npm (cross-platform)
npm install -g bash-language-server
```

### C# Language Server (Roslyn)

**Installation**:
```bash
# Install via VS Code C# extension (recommended)
code --install-extension ms-dotnettools.csharp
```

### Ruby Language Server

**Installation**:
```bash
# Install via RubyGems
gem install ruby-lsp
```

### TypeScript/JavaScript Language Server

**Installation**:
```bash
# Install via npm
npm install -g typescript-language-server typescript
```

