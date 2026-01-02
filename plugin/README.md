![WOGD JUCE Template](assets/images/pamplejuce.png)

# WOGD JUCE Template - Plugin

Modern JUCE 8 plugin template with Vue.js WebView2 GUI integration.

## Features

Out-of-the-box, it provides:

1. **JUCE 8.x** as a git submodule (tracking develop)
2. **CPM** for dependency management
3. **CMake 3.25+** for cross-platform building
4. **Catch2 v3.7.1** for testing framework
5. **Melatonin Inspector** for UI debugging
6. **WebView2** integration for Vue.js GUI
7. **Clang/LLVM** support with MSVC toolchain

### Build Targets
- `<PluginName>_VST3` - VST3 plugin
- `<PluginName>_AU` - Audio Unit (macOS)
- `<PluginName>_Standalone` - Standalone application
- `Tests` - Unit tests with Catch2
- `Benchmarks` - Performance benchmarks

## Quick Start

See the [main README](../README.md) for setup instructions.

## Project Structure

```
plugin/
├── source/              # Plugin source code
│   ├── PluginProcessor.cpp/h
│   └── PluginEditor.cpp/h
├── assets/              # Resources and images
├── tests/               # Unit tests
├── benchmarks/          # Performance tests
├── modules/             # JUCE modules
├── build/               # Build output (generated)
├── CMakeLists.txt       # Main CMake configuration
└── VERSION              # Version file
```

## Building

### Configure CMake
```powershell
cmake --preset ninja-clang
# or
cmake --preset vs2026-clang
```

### Build
```powershell
cmake --build build --config Debug
# or use VS Code tasks:
# - Plugin: Build
# - Plugin: CMake Build (Incremental)
```

### Build Specific Target
```powershell
cmake --build build --target <PluginName>_VST3
```

## Development

### Adding Parameters
Edit `source/PluginProcessor.cpp`:

```cpp
void PluginProcessor::addParameters()
{
    addParameter(new juce::AudioParameterFloat(
        "gain",           // parameterID
        "Gain",          // parameter name
        0.0f, 1.0f,      // min, max
        0.5f             // default
    ));
}
```

### GUI Integration
The plugin editor loads the Vue.js GUI via WebView2:
- **Debug builds**: Loads from `http://localhost:5173` (hot reload)
- **Release builds**: Loads from bundled `dist/index.html`

See [source/PluginEditor.cpp](source/PluginEditor.cpp) for WebView2 integration.

### Communication with GUI
Parameters are synchronized bidirectionally:
- Plugin → GUI: Automatic updates via parameter listeners
- GUI → Plugin: Via `setParameter()` calls from JavaScript

See [../gui/src/services/pluginService.ts](../gui/src/services/pluginService.ts) for the communication layer.

## Testing

### Run Tests
```powershell
cd build
ctest --output-on-failure
```

Or use VS Code task: **Plugin: CMake Build Tests**

### Run Benchmarks
```powershell
.\build\Benchmarks_artefacts\Benchmarks.exe
```

## CMake Presets

Available presets (see `CMakePresets.json`):

- **ninja-clang** - Ninja generator with Clang/LLVM (Windows)
- **vs2026-clang** - Visual Studio 2026 with ClangCL
- **default** - Platform default generator

## CI/CD

This template includes GitHub Actions for:
- Cross-platform builds (Linux, macOS, Windows)
- Running tests in CI
- Code signing (macOS and Windows)
- Plugin validation with pluginval

## Credits

Based on [Pamplejuce](https://github.com/sudara/pamplejuce) by Sudara.
Extended with Vue.js WebView2 GUI integration by WordOfGearDevelopment.

