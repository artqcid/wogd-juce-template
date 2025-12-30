# Building Plugin with Embedded GUI

This template supports embedding the Vue.js GUI directly into the plugin binary for Release builds.

## How it Works

### Debug Mode
- GUI is loaded from development server (`http://localhost:5173`)
- Allows hot-reload and rapid development
- No build step required for GUI

### Release Mode
- GUI files are embedded into the plugin binary as `BinaryData`
- No external files needed for distribution
- Single VST3/AU file contains everything

## Build Process

### 1. Build the GUI (Production)

```powershell
cd gui
npm install
npm run build
```

This creates optimized production files in `gui/dist/`

### 2. Build the Plugin (Release)

```powershell
cd plugin

# Configure CMake for Release
cmake -B build -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release

# Build the plugin
cmake --build build --config Release
```

The CMake build process will:
1. Check for `gui/dist/` folder
2. Copy GUI files to `plugin/assets/gui/`
3. Embed all assets into the plugin binary via `BinaryData`

### 3. Find Your Plugin

Built plugins are located in:
```
plugin/build/PluginName_artefacts/Release/
├── VST3/PluginName.vst3
├── AU/PluginName.component (macOS)
└── Standalone/PluginName.exe
```

## Development Workflow

### Starting Development
1. Start GUI dev server: `cd gui && npm run dev`
2. Build plugin in Debug mode
3. Load plugin in DAW - GUI connects to localhost:5173

### Creating Release
1. Build GUI: `cd gui && npm run build`
2. Build plugin in Release mode
3. Distribute single plugin file (VST3/AU)

## Troubleshooting

### "GUI build not found" warning
- Run `npm run build` in the `gui/` folder
- Check that `gui/dist/index.html` exists

### Plugin shows black screen in Release
- Verify GUI files were embedded: Check build logs for "✓ GUI files embedded"
- Ensure `BinaryData.h` is generated in build folder
- Check that `index.html` is in `plugin/assets/gui/`

### WebView2 not working (Windows)
- Install Microsoft Edge WebView2 Runtime
- Download from: https://developer.microsoft.com/en-us/microsoft-edge/webview2/

## File Structure

```
plugin/
├── assets/
│   └── gui/              # GUI files copied here during Release build
│       ├── index.html
│       ├── assets/
│       └── ...
├── cmake/
│   ├── Assets.cmake      # Embeds assets into BinaryData
│   └── EmbedGUI.cmake    # Copies GUI files to assets/
└── source/
    ├── PluginEditor.cpp  # Loads localhost (Debug) or embedded (Release)
    └── webview/
        └── WebViewComponent.cpp  # loadEmbeddedGUI() method
```

## Notes

- GUI embedding only happens for `CMAKE_BUILD_TYPE=Release`
- Debug builds always use localhost dev server
- Embedded files are accessible via `BinaryData::*` functions
- WebView2 Component handles loading embedded HTML
