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
```

### 5. First Time Setup Task
Wenn du **ohne** `--recursive` geklont hast, führe diesen Task aus, um alles zu initialisieren:

**Ctrl+Shift+P** → "Tasks: Run Task" → **Plugin: 🚀 First Time Setup**

Dieser Task erledigt:
1. Initialisiert das GUI-Submodul (`git submodule update --init`)
2. Installiert GUI-Abhängigkeiten (`npm install`)
3. Konfiguriert CMake
4. Baut das Plugin
5. (GUI-Dev-Server manuell starten mit **GUI: Start Dev Server**)

### 6. Build & Run (Nach dem First Setup)
Verwende die VS Code Tasks mit den neuen Namen:

- **Plugin: Build** – baut das Plugin
- **GUI: Build** – baut das GUI
- **GUI: Start Dev Server** – startet den GUI-Entwicklungsserver
## 🏷️ Task-Übersicht

| Task-Name                      | Funktion                        |
|--------------------------------|---------------------------------|
| Plugin: 🚀 First Time Setup     | Initialisiert alles fürs Plugin  |
| Plugin: Build                  | Baut das Plugin                  |
| Plugin: Configure CMake        | CMake-Konfiguration fürs Plugin  |
| GUI: Install Dependencies      | Installiert GUI-Abhängigkeiten   |
| GUI: Build                     | Baut das GUI                     |
| GUI: Start Dev Server          | Startet den GUI-Dev-Server       |

## 📁 Structure

- `plugin/` - JUCE C++ plugin code
- `gui/` - Vue.js GUI (git submodule)
- `template.code-workspace` - VS Code workspace

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

- Visual Studio 2026 or later
- CMake 3.25+
- Node.js 18+
- WebView2 Runtime (usually pre-installed on Windows)

## 📝 Customization

After setup, customize:
- Plugin parameters in `plugin/source/PluginProcessor.cpp`
- GUI in `gui/src/views/PluginView.vue`
- Styles in `gui/src/assets/master.css`

## 📚 Resources

- [JUCE Documentation](https://juce.com/learn/documentation)
- [Vue.js 3 Guide](https://vuejs.org/guide/)
- [WebView2 Docs](https://learn.microsoft.com/en-us/microsoft-edge/webview2/)
