# CLI-Only Development Guide

This guide explains how to develop with this template using only the command line (without VS Code or other IDEs).

## ✅ Current CLI-Friendliness Assessment

**Good News:**
- ✅ All core functionality works without VS Code
- ✅ CMake-based build system (standard industry tooling)
- ✅ npm scripts for GUI development
- ✅ PowerShell scripts work in any terminal

**Limitations:**
- ⚠️ VS Code tasks need manual translation to commands
- ⚠️ No IDE-agnostic project files (yet)
- ⚠️ Workspace setup is VS Code-specific

## 🚀 CLI Development Workflow

### 1. Initial Setup (Command Line)

```powershell
# Clone your project
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT

# Run setup (works in any PowerShell terminal)
.\setup.ps1

# Initialize GUI submodule manually (if needed)
git submodule update --init --recursive
```

### 2. Install Dependencies

```powershell
# Install GUI dependencies
cd gui
npm install
cd ..
```

### 3. Configure CMake

```powershell
cd plugin

# Option A: Use preset (recommended)
cmake --preset ninja-clang

# Option B: Manual configuration
cmake -B build -G Ninja -DCMAKE_C_COMPILER=clang-cl -DCMAKE_CXX_COMPILER=clang-cl
```

### 4. Build Plugin

```powershell
# Build with preset
cmake --build --preset ninja-clang-debug

# Or manual build
cmake --build build --config Debug

# Build specific targets
cmake --build build --target Pamplejuce_VST3
cmake --build build --target Pamplejuce_Standalone
cmake --build build --target Tests
```

### 5. Start GUI Dev Server

```powershell
cd gui
npm run dev
# Server starts on http://localhost:5173 (or port from project-config.json)
```

### 6. Test Plugin

```powershell
# Run standalone
.\plugin\build\Pamplejuce_artefacts\Debug\Standalone\Pamplejuce.exe

# Run tests
.\plugin\build\Tests_artefacts\Debug\Tests.exe

# Run benchmarks
.\plugin\build\Benchmarks_artefacts\Debug\Benchmarks.exe
```

## 📋 Common CLI Commands

### Building

```powershell
# Clean build
cmake --build build --clean-first

# Release build
cmake --build --preset ninja-clang-release

# Incremental build (fast)
cmake --build build
```

### GUI Development

```powershell
cd gui

# Start dev server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Type checking (if available)
npm run check  # Svelte only
npm run build  # TypeScript compilation
```

### Testing

```powershell
# Build and run tests
cd plugin
cmake --build build --target Tests
.\build\Tests_artefacts\Debug\Tests.exe

# With specific test filter
.\build\Tests_artefacts\Debug\Tests.exe "Plugin Basics"
```

## 🔧 IDE-Independent Development

### With Any Editor/IDE

You can use **any text editor or IDE** that supports:
- C++ development
- TypeScript/JavaScript
- File navigation

**Recommended Editors:**
- VS Code (best integration, templates provided)
- CLion (CMake native support)
- Visual Studio (Windows, MSBuild or CMake)
- Vim/Neovim + Language Servers
- Emacs
- Sublime Text

### CLion Setup

```powershell
# CLion automatically detects CMakePresets.json
# Just open the 'plugin' folder in CLion

# Select preset: "ninja-clang"
# Build configuration: "ninja-clang-debug" or "ninja-clang-release"
```

### Visual Studio Setup

```powershell
# Visual Studio 2022+ supports CMakePresets.json
# Open folder: 'plugin'
# Select configuration from dropdown
```

### Vim/Neovim Setup

```vim
" Use clangd for C++ LSP
" Install with: npm install -g clangd

" compile_commands.json is generated in build/
" Point clangd to it:
let g:lsp_settings = {
  \ 'clangd': {
  \   'cmd': ['clangd', '--compile-commands-dir=plugin/build']
  \ }
  \}
```

## 🛠️ Advanced CLI Workflows

### Parallel Building

```powershell
# Use all CPU cores (faster)
cmake --build build --parallel

# Specific number of jobs
cmake --build build --parallel 8
```

### Cross-Platform CMake

```powershell
# List available presets
cmake --list-presets

# Use different generator
cmake -B build -G "Visual Studio 17 2022"
cmake -B build -G "Unix Makefiles"
```

### Watch Mode Development

```powershell
# Terminal 1: Watch GUI changes
cd gui
npm run dev

# Terminal 2: Rebuild plugin on source changes (manual for now)
cd plugin
# Edit source files, then rebuild:
cmake --build build
```

## 🎯 Script Translation Guide

VS Code tasks can be replicated with these commands:

| VS Code Task | CLI Command |
|--------------|-------------|
| `GUI: Start Dev Server` | `cd gui && npm run dev` |
| `GUI: Build` | `cd gui && npm run build` |
| `Plugin: Configure CMake` | `cd plugin && cmake --preset ninja-clang` |
| `Plugin: Build` | `cd plugin && cmake --build build --config Debug` |
| `Plugin: CMake Build (Incremental)` | `cd plugin && cmake --build build` |
| `Plugin: CMake Clean Build` | `cd plugin && cmake --build build --clean-first` |
| `Plugin: Build Standalone` | `cd plugin && cmake --build build --target Pamplejuce_Standalone` |
| `Plugin: Build VST3` | `cd plugin && cmake --build build --target Pamplejuce_VST3` |

## 📦 Packaging from CLI

```powershell
# Build release version
cd plugin
cmake --build --preset ninja-clang-release

# Build production GUI
cd ../gui
npm run build

# Artefacts location:
# Plugin: plugin/build/Pamplejuce_artefacts/Release/
# GUI: gui/dist/
```

## 🐛 Troubleshooting CLI Development

### CMake not found
```powershell
# Install CMake
choco install cmake  # Windows
# Or download from https://cmake.org/download/
```

### Ninja not found
```powershell
# Install Ninja
choco install ninja  # Windows
```

### Clang not found
```powershell
# Install LLVM/Clang
choco install llvm  # Windows
# Or use Visual Studio's clang-cl
```

### GUI port already in use
```powershell
# Check what's using the port
netstat -ano | findstr :5173

# Kill process or change port in project-config.json
```

## 🔮 Future Improvements

Planned features for better CLI/IDE support:

1. **Multi-IDE Support**:
   - CLion project files
   - Visual Studio solution files
   - Xcode project files (macOS)

2. **Setup Script Enhancement**:
   - IDE selection during setup
   - Generate IDE-specific config files
   - Optional VS Code workspace generation

3. **Watch Mode Scripts**:
   - Auto-rebuild on file changes
   - Integrated GUI + Plugin development

4. **CI/CD Templates**:
   - GitHub Actions
   - GitLab CI
   - Jenkins pipelines

## 💡 Recommendations

**For CLI-Only Developers:**
1. Use CMake presets for consistency
2. Create shell aliases/functions for common commands
3. Use `compile_commands.json` for editor integration
4. Consider `just` or `make` for task automation

**For IDE Users:**
1. CLion: Native CMake support (recommended)
2. Visual Studio: Use CMake Tools extension
3. VS Code: Use provided workspace templates
4. Vim/Neovim: Use clangd + LSP

## 🤝 Contributing

Help make this template more IDE-agnostic!

**Wanted:**
- CLion project templates
- Visual Studio solution files
- Xcode project files
- Makefiles or Justfiles
- Shell script alternatives to PowerShell
- Linux/macOS testing and fixes

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.
