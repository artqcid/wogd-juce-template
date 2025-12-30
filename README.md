# WOGD JUCE Template

A modern JUCE plugin template with embedded Vue.js GUI using WebView2.

## ✨ Features

- 🎸 **JUCE 8.x** - Modern C++ audio plugin framework
- 🎨 **Vue.js 3 + TypeScript** - Embedded WebView2 GUI
- 🔧 **CMake** - Cross-platform build system
- 📦 **Centralized Configuration** - Single `project-config.json` for all settings
- 🔄 **Live Reload** - Hot module replacement during development
- 🧪 **Testing Ready** - Catch2 test framework included

## 🚀 Quick Start

### 1. Use This Template

Click **"Use this template"** on GitHub to create your own repository.

### 2. Configure Your Project

Edit `project-config.json`:

```json
{
  "project": {
    "name": "MyPlugin",
    "displayName": "My Awesome Plugin",
    "version": "1.0.0",
    "company": "YourCompany",
    "bundleId": "com.yourcompany.myplugin",
    "pluginCode": "Mplg",
    "manufacturerCode": "Ycom"
  }
}
```

### 3. Open Workspace in VS Code

```bash
code wogd-juce-template.code-workspace
```

### 4. Build

**Plugin (C++):**
```bash
cd plugin
cmake -B build -G Ninja
cmake --build build --config Debug
```

**GUI (Vue.js):**
```bash
cd gui
npm install
npm run dev
```

### 5. Run & Debug

Press **F5** in VS Code to launch the plugin with debugging.

The plugin will automatically load the Vue.js GUI from the dev server (`http://localhost:5173`) with hot reload enabled.

## 📁 Project Structure

```
├── project-config.json          # 🎯 Central configuration (edit this!)
├── wogd-juce-template.code-workspace
├── plugin/                      # C++ JUCE Plugin
│   ├── CMakeLists.txt
│   ├── cmake/
│   │   └── ProjectConfig.cmake  # Reads project-config.json
│   └── source/
│       ├── PluginProcessor.cpp
│       ├── PluginEditor.cpp     # WebView integration
│       └── webview/
│           └── WebViewComponent.h/cpp
└── gui/                         # Vue.js GUI
    ├── package.json
    ├── scripts/
    │   └── sync-config.js       # Syncs project name/version
    └── src/
        ├── views/
        │   └── PluginView.vue
        └── services/
            └── pluginService.ts # C++ ↔ JS communication
```

## 🔄 Development Workflow

### Debug Mode (Development)
- Plugin loads GUI from `http://localhost:5173`
- Hot reload enabled - changes instantly visible
- `npm run dev` must be running

### Release Mode (Production)
- Plugin loads GUI from embedded files
- Run `npm run build` first to create `dist/` folder

## 💬 Communication (C++ ↔ JavaScript)

### JavaScript → C++
```typescript
import { pluginService } from '@/services/pluginService'

pluginService.sendMessage({
  type: 'setParameter',
  data: { id: 'gain', value: 0.75 }
})
```

### C++ → JavaScript
```cpp
#include "webview/WebViewComponent.h"

webView->sendMessage(R"({
  "type": "parameter",
  "id": "gain",
  "value": 0.75
})")
```

### Receive Messages in JavaScript
```typescript
pluginService.onMessage((message) => {
  console.log('From plugin:', message)
  // Handle parameter updates, etc.
})
```

## 🛠️ Requirements

- **Windows**: Visual Studio 2019+ (for WebView2)
- **CMake**: 3.25+
- **Node.js**: 20.19+ or 22.12+
- **Ninja** (recommended) or Visual Studio

### Optional Environment Variables
- `JUCE_DIR` - Path to shared JUCE installation
- `CLAP_JUCE_EXTENSIONS_DIR` - Path to clap-juce-extensions

## 📝 Notes

- **WebView2 is Windows-only** - macOS/Linux require native implementations
- The `project-config.json` is the single source of truth for project settings
- Both CMake and NPM read from this file automatically

## 🎓 Learn More

- [JUCE Documentation](https://juce.com/learn/documentation)
- [Vue.js Documentation](https://vuejs.org/)
- [WebView2 Documentation](https://learn.microsoft.com/en-us/microsoft-edge/webview2/)

## 📄 License

Specify your license here.
