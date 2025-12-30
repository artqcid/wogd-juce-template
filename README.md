# Pamplejuce mit Vue.js + WebView2 GUI

JUCE Audio Plugin Template mit moderner Web-UI über Microsoft Edge WebView2.

## 🎯 Architektur

```
pamplejuce/
├── plugin/              # C++ JUCE Audio Plugin
│   ├── source/
│   │   └── webview/    # WebView2 Integration
│   └── CMakeLists.txt
├── gui/                # Vue.js TypeScript GUI
│   ├── src/
│   │   ├── services/   # Plugin Communication
│   │   └── components/ # UI Components
│   └── package.json
└── pamplejuce.code-workspace
```

## 🔌 Plugin ↔ GUI Kommunikation

### Native WebView2 Message-Passing (kein WebSocket!)

**JavaScript → C++ (Plugin):**
```typescript
// gui/src/services/pluginService.ts
window.chrome.webview.postMessage({
  type: 'setParameter',
  data: { id: 'gain', value: 0.75 }
})
```

**C++ (Plugin) → JavaScript:**
```cpp
// plugin/source/webview/WebViewComponent.cpp
webview->sendMessage(R"({
  "type": "parameter",
  "data": {"id": "gain", "value": 0.75}
})");
```

**JavaScript empfängt:**
```typescript
window.chrome.webview.addEventListener('message', (event) => {
  const { type, data } = event.data
  // Verarbeite Plugin-Nachricht
})
```

## 🚀 Schnellstart

### 1. Workspace öffnen
```powershell
code C:\Users\marku\Documents\GitHub\pamplejuce\pamplejuce.code-workspace
```

### 2. GUI entwickeln (Browser Dev-Mode)
```bash
cd gui
npm install
npm run dev
```
Öffnet: http://localhost:5173
- ✅ Hot-Reload aktiv
- ✅ Mock-Daten für Entwicklung
- ✅ Browser DevTools verfügbar

### 3. Plugin mit WebView2 GUI bauen
```bash
cd plugin
cmake -B build
cmake --build build --config Debug
```

Das Plugin lädt automatisch:
- **Dev:** `http://localhost:5173` (wenn npm dev läuft)
- **Production:** `file:///path/to/gui/dist/index.html`

## 🔧 Entwicklungs-Workflow

### Parallele Entwicklung
1. **Terminal 1:** `cd gui && npm run dev` (Vue Dev-Server)
2. **Terminal 2:** Plugin in DAW/Host laden
3. Parameter im Browser ändern → Sofort im Plugin sichtbar
4. Plugin-Änderungen → Automatisch im Browser aktualisiert

### Debugging
- **GUI:** Browser DevTools (F12 im WebView2)
- **Plugin:** VS Code C++ Debugger mit Breakpoints
- **Kommunikation:** Console logs in beiden Richtungen

## 📦 WebView2 Setup

### Windows Voraussetzungen
- **WebView2 Runtime:** Meist vorinstalliert (Windows 11)
- Download: https://developer.microsoft.com/microsoft-edge/webview2/

### CMakeLists.txt Integration
```cmake
# WebView2 NuGet Package hinzufügen
find_package(Microsoft.Web.WebView2 REQUIRED)

target_sources(${PROJECT_NAME} PRIVATE
    source/webview/WebViewComponent.h
    source/webview/WebViewComponent.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Microsoft.Web.WebView2
)
```

## 🎨 GUI Features

### Aktuell implementiert:
- ✅ ParameterSlider Komponente
- ✅ Auto-Detection (WebView2 vs. Browser)
- ✅ Mock-Daten für Dev-Mode
- ✅ Bidirektionale Kommunikation
- ✅ Hot-Reload im Browser

### Beispiel: Parameter im Plugin exponieren
```cpp
// Im PluginProcessor
webview->onMessageReceived = [this](const juce::String& message) {
    auto json = juce::JSON::parse(message);
    auto type = json["type"].toString();
    
    if (type == "setParameter") {
        auto id = json["data"]["id"].toString();
        auto value = json["data"]["value"];
        
        if (auto* param = apvts.getParameter(id))
            param->setValueNotifyingHost(value);
    }
};

// Parameter-Änderungen an GUI senden
void audioProcessorValueTreeStateChanged() {
    juce::DynamicObject::Ptr data = new juce::DynamicObject();
    data->setProperty("type", "parameter");
    // ... Parameter-Daten hinzufügen
    
    webview->sendMessage(juce::JSON::toString(data));
}
```

## 📁 Projekt-Struktur

### Plugin (C++)
```
plugin/source/
├── PluginProcessor.h/cpp    # Audio-Verarbeitung
├── PluginEditor.h/cpp        # UI (enthält WebViewComponent)
└── webview/
    ├── WebViewComponent.h    # WebView2 Wrapper
    └── WebViewComponent.cpp  # Platform-spezifisch
```

### GUI (TypeScript/Vue)
```
gui/src/
├── services/
│   └── pluginService.ts      # Kommunikation mit Plugin
├── components/plugin/
│   └── ParameterSlider.vue   # UI-Komponenten
└── views/
    └── PluginView.vue        # Haupt-View
```

## 🛠️ Build für Production

### GUI bauen
```bash
cd gui
npm run build
# Output: gui/dist/
```

### Plugin mit eingebettetem GUI
```cpp
// In WebViewComponent: Pfad zum dist/ Ordner
auto guiPath = juce::File::getSpecialLocation(
    juce::File::currentExecutableFile
).getParentDirectory().getChildFile("gui/dist/index.html");

webview->loadURL("file:///" + guiPath.getFullPathName());
```

## 🎯 Nächste Schritte

1. **WebView2 NuGet Package zu CMake hinzufügen**
2. **PluginEditor.cpp: WebViewComponent integrieren**
3. **Parameter-Synchronisation implementieren**
4. **Custom UI-Komponenten erstellen** (Knobs, Meters, etc.)
5. **Audio-Visualisierung** (Canvas API für Spektrum/Waveform)

## 💡 Vorteile dieses Ansatzes

- ✅ **Keine Netzwerk-Overhead:** Direkte Kommunikation (kein WebSocket)
- ✅ **Moderne Web-Technologien:** Vue 3, TypeScript, Vite
- ✅ **Hot-Reload:** Änderungen sofort sichtbar
- ✅ **Cross-Platform GUI:** Selber Code, verschiedene Hosts
- ✅ **Browser DevTools:** Professionelles Debugging
- ✅ **NPM Ecosystem:** Tausende UI-Libraries verfügbar

## 🛠️ Benötigte Tools

- CMake 3.25+
- MSVC 2022+ (Windows)
- Node.js 20+
- Git
- WebView2 Runtime

## 📄 Lizenz

Siehe `plugin/LICENSE`
