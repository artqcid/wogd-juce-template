# WOGD JUCE Template

Audio plugin template with JUCE 8 + Vue.js 3 WebView2 GUI

## 🚀 Quick Start

### 1. Create New Project
Click "Use this template" on GitHub to create your own plugin project.

### 2. Clone with Submodules
```bash
git clone --recursive https://github.com/YOUR_USERNAME/YOUR_PROJECT.git
cd YOUR_PROJECT
```

### 3. Run Setup
```powershell
./setup.ps1
```

The setup will ask for:
- **Plugin Name** (e.g., "My Awesome Synth")
- **Company Name** (e.g., "Your Company")
- **GUI Repository URL** (optional, uses default template)

### 4. Open in VS Code
```powershell
code template.code-workspace
```

### 5. Build & Run
Use VS Code tasks (Ctrl+Shift+P → "Tasks: Run Task"):
- **🚀 Setup & Start Everything** - Complete build + dev server
- **Start GUI Dev Server** - Launch Vue dev server
- **Build Plugin** - Compile the plugin

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
