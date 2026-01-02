# WOGD JUCE Template

Audio plugin template with JUCE 8 + Vue.js 3 WebView2 GUI

## 🚀 Quick Start

### 1. Create New Project
Click "Use this template" on GitHub to create your own plugin project.

### 2. Clone Repository
```bash
# Option A: Clone without GUI (recommended for first setup)
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT

# Option B: Clone with GUI submodule
git clone --recursive https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

### 3. Run Setup Script (Optional)
```powershell
./setup.ps1
```

The setup will ask for:
- **Plugin Name** (e.g., "My Awesome Synth")
- **Company Name** (e.g., "Your Company")
- **GUI Repository URL** (optional, uses default template)

This script updates project names and can replace the GUI submodule.

### 4. Open in VS Code
```powershell
code template.code-workspace
# After setup.ps1, the workspace file will be renamed to <YourPluginName>.code-workspace
```

### 5. First Time Setup

**With VS Code (Recommended):**

**Ctrl+Shift+P** → "Tasks: Run Task" → **First Time Setup**

Dieser Task erledigt alles automatisch:
1. Initialisiert das GUI-Submodul (`git submodule update --init`)
2. Installiert GUI-Abhängigkeiten (`npm install`)
3. Konfiguriert CMake (lädt JUCE automatisch herunter, falls nicht vorhanden)
4. Baut das Plugin
5. Startet GUI-Dev-Server im Hintergrund

**Without VS Code (Manual):**
```bash
# Initialize submodules
git submodule update --init --recursive

# Install GUI dependencies
cd gui && npm install && cd ..

# Configure and build plugin
cd plugin
cmake --preset ninja-clang
cmake --build build
```

### 6. Build & Run (Nach dem First Setup)
Verwende die VS Code Tasks mit den neuen Namen:

- **Plugin: Build** – baut das Plugin
- **GUI: Build** – baut das GUI
- **GUI: Start Dev Server** – startet den GUI-Entwicklungsserver
## 🏷️ Task-Übersicht

| Task-Name                      | Funktion                        |
|--------------------------------|---------------------------------|
| First Time Setup               | Initialisiert alles fürs Plugin  |
| Plugin: Build                  | Baut das Plugin                  |
| Plugin: Configure CMake        | CMake-Konfiguration fürs Plugin  |
| Plugin: CMake Build (Incremental) | Inkrementelles Build (Standard) |
| GUI: Install Dependencies      | Installiert GUI-Abhängigkeiten   |
| GUI: Build                     | Baut das GUI                     |
| GUI: Start Dev Server          | Startet den GUI-Dev-Server       |

## 📁 Structure

```
wogd-juce-template/
├── plugin/                    # JUCE C++ plugin code
├── gui/                       # Vue.js GUI (git submodule)
├── cmake/                     # CMake configuration files
├── template.code-workspace    # VS Code workspace (renamed after setup)
└── setup.ps1                  # Setup script
```

### Workspace Folders
- **GUI (Vue.js)** - Frontend development
- **Plugin (JUCE)** - C++ plugin development
- **Root** - Project configuration

## 🎨 GUI Development

The GUI is a **separate repository** as a git submodule.

**For GUI-only development:**
```bash
cd gui
npm install
npm run dev
```

Open http://localhost:5173 in your browser.

## 🔧 Requirements

- **Visual Studio 2026** (MSVC 18) with C++ Desktop Development workload
- **Clang/LLVM** (for clang-cl)
- **Ninja** build system
- **CMake 3.25+**
- **Node.js 18+**
- **WebView2 Runtime** (usually pre-installed on Windows 10/11)

### CMake Presets
- `ninja-clang` - Windows with Ninja + Clang (recommended)
- `vs2026-clang` - Visual Studio 2026 with Clang

## 🎯 JUCE Setup

The project supports **4 flexible options** for JUCE integration. Choose the one that fits your workflow:

### Option 1: Environment Variable (Recommended for Power Users)
Use a central JUCE installation shared across multiple projects:

```powershell
# Set environment variable
$env:WOGD_JUCE_DIR = "C:/dev/juce-8.0.4"

# Make it permanent (optional)
[System.Environment]::SetEnvironmentVariable('WOGD_JUCE_DIR', 'C:/dev/juce-8.0.4', 'User')
```

**Pros:** Shared across projects, faster builds, easy updates  
**Cons:** Requires manual JUCE installation

### Option 2: Git Submodule (Recommended for Teams)
Version-controlled JUCE for consistent builds across developers:

```bash
# Add JUCE as submodule at repository root
git submodule add https://github.com/juce-framework/JUCE.git juce
git submodule update --init --recursive
```

**Pros:** Version-controlled, offline builds, team consistency  
**Cons:** Larger repository size, slower clone

### Option 3: Prebuilt Installation (Legacy)
Place a prebuilt JUCE installation in `juce-install/` folder.

**Pros:** Fast builds, no environment variables needed  
**Cons:** Not version-controlled, manual setup required

### Option 4: Automatic Download (Zero-Config)
If none of the above are set, JUCE will be **automatically downloaded** via CPM:

**With VS Code (Recommended):**
```
Ctrl+Shift+P → Tasks: Run Task → First Time Setup
```
The task handles everything automatically (CMake configure, build, dependencies).

**Without VS Code (Manual):**
```bash
# Configure - JUCE downloads automatically
cmake --preset ninja-clang
cmake --build build
```

**Pros:** Zero configuration, perfect for first-time users  
**Cons:** Requires internet, slower first build

## 🌐 Environment Variables

Optional environment variables for advanced configuration:

| Variable | Purpose | Example |
|----------|---------|---------|
| `WOGD_JUCE_DIR` | Path to JUCE installation | `C:/dev/juce-8.0.4` |
| `CLAP_JUCE_EXTENSIONS_DIR` | Path to clap-juce-extensions | `C:/dev/clap-juce-extensions` |
| `WEBVIEW2_SDK_DIR` | Path to WebView2 SDK | `C:/dev/webview2-sdk` |
| `JUCE_AUDIO_PLUGIN_HOST` | Path to AudioPluginHost.exe (debugging) | `C:/path/to/AudioPluginHost.exe` |

Create a `.env` file (gitignored) or set them system-wide.

## 🔧 VS Code Configuration

The project is pre-configured for VS Code with optimal C++ development settings:

### IntelliSense & Code Completion
- **clangd** is used for C++ IntelliSense (Native C/C++ extension is disabled)
- Automatically uses `compile_commands.json` from CMake build
- Configured in `.vscode/settings.json` and `.vscode/c_cpp_properties.json`

### Recommended Extensions
Install these when prompted (or manually):
- **C/C++** (Microsoft) - For debugging support
- **clangd** (LLVM) - For IntelliSense and code navigation
- **CMake Tools** (Microsoft) - For CMake integration
- **Vue - Official** (Vue) - For GUI development
- **Prettier** (Prettier) - For code formatting

### Available VS Code Files
```
.vscode/
├── settings.json           # clangd and editor configuration
├── c_cpp_properties.json   # C++ IntelliSense paths
├── tasks.json              # Build and run tasks
└── launch.json             # Debugging configuration
```

### Debugging Setup
To debug the plugin with AudioPluginHost:

1. **Set environment variable:**
   ```powershell
   $env:JUCE_AUDIO_PLUGIN_HOST = "C:/path/to/AudioPluginHost.exe"
   ```

2. **Launch configuration:**
   - Press `F5` or use "Debug Plugin (AudioPluginHost)" configuration
   - The plugin will launch in AudioPluginHost automatically

3. **Build the plugin first:**
   - Run task: **Plugin: Build** or **Plugin: CMake Build (Incremental)**

### CMake Presets
- `ninja-clang` - Windows with Ninja + Clang (recommended)
- `vs2026-clang` - Visual Studio 2026 with Clang

## 📝 Customization

After setup, customize:
- Plugin parameters in `plugin/source/PluginProcessor.cpp`
- GUI in `gui/src/views/PluginView.vue`
- Styles in `gui/src/assets/master.css`

## 📚 Resources

- [JUCE Documentation](https://juce.com/learn/documentation)
- [Vue.js 3 Guide](https://vuejs.org/guide/)
- [WebView2 Docs](https://learn.microsoft.com/en-us/microsoft-edge/webview2/)

## 🙏 Credits & Acknowledgments

This template builds upon the excellent work of the open-source community:

### Core Framework
- **[Pamplejuce](https://github.com/sudara/pamplejuce)** by [Sudara Williams](https://github.com/sudara)  
  Modern JUCE template with CMake, CPM, and CI/CD integration

- **[JUCE](https://github.com/juce-framework/JUCE)** by [JUCE Team](https://juce.com)  
  Cross-platform C++ framework for audio applications

### Build System & Tools
- **[cmake-includes](https://github.com/sudara/cmake-includes)** by Sudara  
  Reusable CMake configurations for JUCE projects

- **[CPM.cmake](https://github.com/cpm-cmake/CPM.cmake)**  
  CMake's missing package manager

### JUCE Modules & Extensions
- **[Melatonin Inspector](https://github.com/sudara/melatonin_inspector)** by Sudara  
  Visual debugging tool for JUCE UI components

- **[clap-juce-extensions](https://github.com/free-audio/clap-juce-extensions)** by free-audio  
  CLAP plugin format support for JUCE

### Testing
- **[Catch2](https://github.com/catchorg/Catch2)**  
  Modern C++ test framework

### WebView Integration
- **[Microsoft WebView2](https://developer.microsoft.com/en-us/microsoft-edge/webview2/)**  
  Embed web technologies in native applications

### Frontend
- **[Vue.js](https://github.com/vuejs/core)** by Evan You & Vue Team  
  Progressive JavaScript framework

- **[Vite](https://github.com/vitejs/vite)** by Evan You & Vite Team  
  Next-generation frontend tooling

---

**Extended by:** [WordOfGearDevelopment](https://github.com/artqcid)  
**License:** MIT (see LICENSE file)

Special thanks to all contributors who make open-source audio development possible! 🎵
