# WOGD JUCE Template

Audio plugin template with JUCE 8 + Vue.js 3 WebView2 GUI

## 🚀 Quick Start

### 1. Create New Project
Click "Use this template" on GitHub to create your own plugin project.

### 2. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

### 3. Quick Start - Automated Setup (Recommended)

**Für Einsteiger - alles automatisch:**

```powershell
.\quick-start.ps1
```

**Was macht das Quick-Start-Script?**
1. ✅ **Prüft alle Voraussetzungen** (Git, CMake, Node.js, Visual Studio, Clang, Ninja)
2. 🔧 **Installiert VS Code Extensions** (optional, C++, CMake, Vue.js, etc.)
3. 🌐 **Hilft bei Environment Variables** (optional, z.B. JUCE_DIR)
4. 🚀 **Führt komplettes First-Time Setup durch** (Submodul, Dependencies, Build)
5. ✓ **Plugin ist sofort einsatzbereit!**

**Optionen:**
```powershell
# Extensions überspringen
.\quick-start.ps1 -SkipExtensions

# Ohne Interaktion (für CI/CD)
.\quick-start.ps1 -NoInteractive
```

---

### Alternative: Manuelle Konfiguration (für Fortgeschrittene)

#### 3a. Setup Script - Projekt konfigurieren
```powershell
./setup.ps1
```

**Was macht das Setup-Script?**
- 📝 Fragt nach **Plugin Name**, **Company Name** und **GUI Repository**
- 🔄 Aktualisiert `project-config.json` mit deinen Daten
- 📦 Ersetzt GUI-Submodule mit deinem eigenen Repository (optional)
- 📄 Benennt Workspace-Datei um nach deinem Plugin-Namen
- ⚠️ **Wichtig:** Baut NICHT das Projekt - nur Konfiguration!

**Wann verwenden?**
- Du willst nur die Projekt-Namen anpassen
- Du hast ein eigenes GUI-Repository
- Du möchtest manuell bauen

#### 3b. Open in VS Code
```powershell
code template.code-workspace
# Nach setup.ps1 wird die Workspace-Datei umbenannt zu <DeinPluginName>.code-workspace
```

#### 3c. First Time Setup - Manuell in VS Code

**Mit VS Code (Empfohlen):**

**Ctrl+Shift+P** → "Tasks: Run Task" → **PROJECT First Time Setup**

Dieser Task erledigt alles automatisch:
1. Initialisiert das GUI-Submodul (`git submodule update --init`)
2. Installiert GUI-Abhängigkeiten (`npm install`)
3. Konfiguriert CMake (lädt JUCE automatisch herunter, falls nicht vorhanden)
4. Baut das Plugin
5. Startet GUI-Dev-Server im Hintergrund

**Ohne VS Code (Kommandozeile):**
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

---

### 4. Build & Run (Nach dem First Setup)
Verwende die VS Code Tasks mit den neuen Namen:

- **PLUGIN CMake Build** – baut das Plugin
- **GUI Build** – baut das GUI
- **GUI Start Dev Server** – startet den GUI-Entwicklungsserver
## 🏷️ Task-Übersicht

| Task-Name                      | Funktion                        |
|--------------------------------|---------------------------------|
| PROJECT First Time Setup       | Initialisiert alles fürs Plugin  |
| PLUGIN CMake Build             | Baut das Plugin                  |
| PLUGIN CMake Configure         | CMake-Konfiguration fürs Plugin  |
| PLUGIN CMake Clean Build       | Clean Build (bei Problemen)      |
| Plugin: CMake Build (Incremental) | Inkrementelles Build (Standard) |
| GUI Install Dependencies       | Installiert GUI-Abhängigkeiten   |
| GUI Build                      | Baut das GUI                     |
| GUI Start Dev Server           | Startet den GUI-Dev-Server       |

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
# Set environment variable (works with both source code and installed JUCE)
$env:JUCE_DIR = "C:/dev/juce-8.0.4"

# Make it permanent (optional)
[System.Environment]::SetEnvironmentVariable('JUCE_DIR', 'C:/dev/juce-8.0.4', 'User')
```

**Note:** `JUCE_DIR` can point to either:
- JUCE source directory (containing `CMakeLists.txt`)
- Installed JUCE with config files (containing `JUCEConfig.cmake`)

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
| `JUCE_DIR` | Path to JUCE source or installation | `C:/dev/juce-8.0.4` |
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
   - Run task: **PLUGIN CMake Build** or **Plugin: CMake Build (Incremental)**

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

## 🔧 Troubleshooting

### CMake can't find JUCE

**Problem:** `CMake Error: Could not find a package configuration file provided by "JUCE"`

**Solution:**
1. Set environment variable:
   ```powershell
   $env:JUCE_DIR = "C:/path/to/juce-source-or-installation"
   ```
2. OR add JUCE as submodule:
   ```bash
   git submodule add https://github.com/juce-framework/JUCE.git juce
   ```
3. OR let CMake download automatically (requires internet)

### clangd IntelliSense not working

**Problem:** Red squiggles everywhere, no code completion

**Solution:**
1. Make sure clangd extension is installed
2. Build the project first to generate `compile_commands.json`:
   ```bash
   cmake --preset ninja-clang
   ```
3. Check `.vscode/settings.json` has correct path to compile commands
4. Reload VS Code window: `Ctrl+Shift+P` → "Reload Window"

### WebView2 Runtime not found

**Problem:** Plugin crashes or shows black screen

**Solution:**
1. Install WebView2 Runtime: https://developer.microsoft.com/en-us/microsoft-edge/webview2/
2. OR set environment variable to local SDK:
   ```powershell
   $env:WEBVIEW2_SDK_DIR = "C:/path/to/webview2-sdk"
   ```

### Build fails after Git pull

**Problem:** Build errors after pulling changes or switching branches

**Solution:**
1. Run clean build:
   - VS Code: **PLUGIN CMake Clean Build** task
   - OR manually: `cmake --build build --clean-first`
2. If still failing, delete build folder and reconfigure:
   ```bash
   Remove-Item -Recurse -Force plugin/build
   cmake --preset ninja-clang
   ```

### GUI not loading in plugin

**Problem:** Plugin shows blank/white screen

**Debug Build:**
1. Make sure GUI dev server is running:
   - Task: **GUI Start Dev Server**
   - OR manually: `cd gui && npm run dev`
2. Check console for connection errors

**Release Build:**
1. Build GUI first: **GUI Build** task
2. Rebuild plugin to include bundled GUI

### Visual Studio not found (setup.ps1)

**Problem:** Setup script can't find Visual Studio

**Solution:**
1. Install Visual Studio 2026 with C++ Desktop Development workload
2. OR manually set MSVC environment before running setup
3. Check if `vswhere.exe` is available at default location

### Node modules errors

**Problem:** `npm install` fails or module not found errors

**Solution:**
```bash
cd gui
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
npm install
```

### Plugin format not found (VST3/AU/Standalone)

**Problem:** Built plugin binary doesn't exist

**Solution:**
1. Check `CMakeLists.txt` line 23 for enabled formats
2. Build specific target:
   ```bash
   cmake --build build --target YourPlugin_VST3
   ```

---

## 📖 Additional Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Guidelines for contributing to this project
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and changes
- **[plugin/BUILD_WITH_GUI.md](plugin/BUILD_WITH_GUI.md)** - Detailed GUI integration guide
- **[docs/WEBVIEW2_SETUP.md](plugin/docs/WEBVIEW2_SETUP.md)** - WebView2 setup instructions

---

## 🔄 Setup Scripts im Detail

### quick-start.ps1 - Komplettes Projekt-Setup

**Für wen:** Einsteiger und alle, die schnell loslegen wollen

**Was macht es:**
```powershell
.\quick-start.ps1
```

1. **Prerequisite Check:**
   - Git, CMake 3.25+, Node.js 18+
   - Visual Studio 2026 mit C++ Workload
   - Clang/LLVM, Ninja Build System

2. **VS Code Extensions (optional):**
   - C/C++ (Microsoft) - Debugging
   - clangd (LLVM) - IntelliSense
   - CMake Tools (Microsoft)
   - Vue - Official (Vue.js)
   - Prettier - Code Formatter

3. **Environment Variables (optional):**
   - Hilft bei JUCE_DIR Setup
   - WebView2 SDK Path
   - AudioPluginHost für Debugging

4. **First-Time Build:**
   - Initialisiert GUI-Submodule
   - `npm install` für Dependencies
   - CMake Configure + Build
   - Startet Dev Server

**Parameter:**
```powershell
# Extensions überspringen
.\quick-start.ps1 -SkipExtensions

# Ohne User-Interaktion (für CI/CD)
.\quick-start.ps1 -NoInteractive
```

**Ergebnis:** Lauffertiges Plugin-Projekt, sofort entwicklungsbereit!

---

### setup.ps1 - Projekt-Konfiguration

**Für wen:** Fortgeschrittene, die nur Namen/Config ändern wollen

**Was macht es:**
```powershell
.\setup.ps1
```

1. **Interaktive Konfiguration:**
   - Plugin Name eingeben (z.B. "My Awesome Synth")
   - Company Name eingeben
   - Optional: Eigenes GUI-Repository URL
   - **Plugin-Formate auswählen:**
     - Für jedes Format (AUv3, VST3, Standalone, AU, AAX, Unity) wirst du gefragt, ob es gebaut werden soll (y/n, Standard: AUv3, VST3, Standalone aktiviert)
     - Mindestens ein Format muss gewählt werden
     - Die Auswahl wird automatisch in die `plugin/CMakeLists.txt` übernommen

2. **project-config.json Update:**
   - Aktualisiert Namen und IDs
   - Setzt Company/Bundle Identifier
   - Plugin- und Manufacturer-Codes

3. **GUI Submodule (optional):**
   - Kann Standard-GUI durch eigenes ersetzen
   - Klont neues GUI-Repository
   - Initialisiert Submodule

4. **Workspace Rename:**
   - Benennt `template.code-workspace` um
   - Neuer Name: `<DeinPluginName>.code-workspace`

**⚠️ Wichtig:** 
- Baut NICHT das Projekt
- Nur Konfiguration, keine Dependencies
- Du musst danach manuell bauen (First-Time Setup Task)
- **Plugin-Formate:** Die Standard-Formate sind jetzt **AUv3, VST3 und Standalone**. Du kannst beim Setup weitere Formate aktivieren/deaktivieren.
- Die Auswahl wird in der Zeile `set(FORMATS ...)` in der `plugin/CMakeLists.txt` gespeichert und steuert, welche Binaries gebaut werden.

**Typischer Workflow:**
```powershell
# 1. Projekt konfigurieren
.\setup.ps1

# 2. VS Code öffnen
code MeinPlugin.code-workspace

# 3. First-Time Setup Task ausführen
# Ctrl+Shift+P → Tasks: Run Task → PROJECT First Time Setup
```

---

### Welches Script soll ich verwenden?

| Situation | Script | Grund |
|-----------|--------|-------|
| Erstes Mal Template verwenden | `quick-start.ps1` | Alles automatisch, nichts vergessen |
| Nur Plugin-Namen ändern | `setup.ps1` | Schnell, keine Dependencies installieren |
| Eigenes GUI-Repository | `setup.ps1` | Kann GUI-Submodule ersetzen |
| Clean Install nach Git Pull | VS Code Task: **PROJECT First Time Setup** | Rebuild ohne Config ändern |
| CI/CD Pipeline | `quick-start.ps1 -NoInteractive` | Automatisiert, keine Prompts |

---

## 🏷️ Template Versioning & Releases

When you use the "Use this template" button on GitHub, you always get the latest state of the `main` branch. If you want a stable, tested version, use a tagged release.

### Recommended Workflow
- **main branch:** Always stable and production-ready
- **development branch:** For new features and testing (optional)
- **Releases:** Mark stable milestones (e.g. v1.0.0)

### Using a Specific Version
To start from a specific release:
```bash
# Clone the template
git clone https://github.com/artqcid/wogd-juce-template.git my-plugin
cd my-plugin
# Checkout the desired version
git checkout v1.0.0
```

### Downloading a Release
You can also download a ZIP of any release from the [Releases page](https://github.com/artqcid/wogd-juce-template/releases).

### For Contributors
- Only merge tested, stable changes to `main`
- Update `CHANGELOG.md` and bump version for each release
- See CONTRIBUTING.md for the full release process

**Extended by:** [WordOfGearDevelopment](https://github.com/artqcid)  
**License:** MIT (see LICENSE file)

Special thanks to all contributors who make open-source audio development possible! 🎵
