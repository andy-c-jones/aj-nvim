# AJ's Minimalist Neovim Configuration

## Features

- **Performance**: Optimized for speed through minimalism
- **Navigation**: Telescope for fuzzy finding files, grep, and buffers
- **Testing**: Neotest integration with support for .NET and Vitest
- **LSP Support**: Multi-language LSP with auto-completion and diagnostics
- **Auto-completion**: nvim-cmp auto-completion
- **Terminal**: Persistent floating terminal toggle with `<leader>tt`
- **UI**: Custom statusline, transparent theme, and keybinding cheatsheet (`<leader>cc`)
- **Treesitter**: Syntax highlighting and code understanding
- **Mason**: Automatic LSP server management

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

This configuration uses **Mason** for automatic LSP server management. All language servers are automatically installed when you first start Neovim.

### Supported Languages

The following LSP servers are automatically installed and configured:

- **Lua** (`lua_ls`) - Full Neovim integration with vim globals
- **Bash/Shell** (`bashls`) - Script linting and completion  
- **TypeScript/JavaScript** (`ts_ls`) - Full TS/JS support with inlay hints
- **C#** (`csharp_ls`) - .NET development support
- **PowerShell** (`powershell_es`) - PowerShell scripting support

No manual installation required - Mason handles everything automatically!

