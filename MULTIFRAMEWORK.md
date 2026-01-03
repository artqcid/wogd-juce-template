# Multi-Framework Support

This template supports multiple GUI frameworks (Vue.js, React, Angular, Vanilla JS, Svelte) for building audio plugin interfaces.

## 🎯 Features

- **Framework Selection** during setup
- **Easy Migration** between frameworks with `migrate-framework.ps1`
- **Pre-configured Templates** for each framework
- **Automatic Port Configuration**
- **Framework-agnostic** workspace and build system

## 🚀 Quick Start

### New Project with Framework Selection

1. **Create your GUI repository** from one of the templates:
   - Vue.js: https://github.com/artqcid/wogd-juce-template-gui
   - React: https://github.com/artqcid/wogd-juce-template-gui-react
   - Angular: https://github.com/artqcid/wogd-juce-template-gui-angular
   - Vanilla JS: https://github.com/artqcid/wogd-juce-template-gui-vanilla
   - Svelte: https://github.com/artqcid/wogd-juce-template-gui-svelte

2. **Run setup script**:
```powershell
.\setup.ps1
```

3. **Follow the prompts**:
   - Choose your framework (1-5)
   - Enter **your GUI repository URL** (that you created in step 1)
   - Enter plugin name, company name, codes

The setup script will:
- Configure the project for your chosen framework
- Link your GUI repository as a submodule
- Update workspace and build files

### Migrate Existing Project

```powershell
.\migrate-framework.ps1
```

## 📦 GUI Template Repositories

### Official Templates (Use as starting point)

1. **Vue.js**: `https://github.com/artqcid/wogd-juce-template-gui.git`
2. **React**: `https://github.com/artqcid/wogd-juce-template-gui-react.git`
3. **Angular**: `https://github.com/artqcid/wogd-juce-template-gui-angular.git`
4. **Vanilla JS**: `https://github.com/artqcid/wogd-juce-template-gui-vanilla.git`
5. **Svelte**: `https://github.com/artqcid/wogd-juce-template-gui-svelte.git`

**Important**: These are templates! Click "Use this template" to create your own repository.

## 🛠️ GUI Template Requirements

Each GUI template repository must have:

### Required Files
- `package.json` with correct scripts
- `index.html` entry point
- Build configuration (vite.config.js, angular.json, etc.)

### Required Scripts in package.json
```json
{
  "scripts": {
    "dev": "...",     // Or "start" for Angular
    "build": "...",
    "preview": "..."
  }
}
```

### Directory Structure
```
gui-template/
├── package.json
├── index.html
├── src/
│   └── main.{js,ts,tsx}
└── dist/           (build output)
```

### Dev Server Requirements
- Must serve on configured port (default: 5173, Angular: 4200)
- Must support hot reload
- Must build to `dist/` directory

## 🔧 Framework-Specific Notes

### Vue.js
- Uses Vite
- Port: 5173
- Dev script: `dev`
- Already implemented in main branch

### React
- Uses Vite or Create React App
- Port: 5173
- Dev script: `dev`
- Build output: `dist/`

### Angular
- Uses Angular CLI
- Port: 4200
- Dev script: `start`
- Build output: `dist/`

### Vanilla JS
- Uses Vite
- Port: 5173
- Dev script: `dev`
- Minimal setup, no framework overhead

### Svelte
- Uses Vite
- Port: 5173
- Dev script: `dev`
- Compiles to vanilla JS, smallest bundle size
- Build output: `dist/`

### Custom Framework

The "Custom" option allows you to use **any web framework or technology stack** not included in the predefined templates.

**When to use Custom:**
- You want to use a different framework (e.g., Preact, Solid.js, Lit, Qwik, Alpine.js)
- You have a company-internal UI framework
- You're experimenting with new technologies
- You need a specific build setup not covered by the templates

**Custom Setup Process:**

1. **Choose "Custom" during setup**:
   ```powershell
   ./setup.ps1
   # Select option 6: Custom
   ```

2. **Provide configuration**:
   - **Dev Server Port**: The port your dev server runs on (e.g., 3000, 8080, 5173)
   - **Dev Script Name**: The npm script to start dev server (e.g., "dev", "start", "serve")
   - **Repository URL**: Your custom GUI repository URL

3. **GUI Repository Requirements**:
   Your custom repository must have:
   - `package.json` with the specified dev script
   - A dev server that serves on the specified port
   - Build output to `dist/` directory (configurable)
   - WebView2 communication via `window.__JUCE__` API

**Example Custom Setups:**

```powershell
# Preact
Port: 5173
Dev Script: dev
Repo: https://github.com/user/my-plugin-gui-preact

# Solid.js  
Port: 3000
Dev Script: start
Repo: https://github.com/user/my-plugin-gui-solid

# Company Framework
Port: 8080
Dev Script: serve
Repo: https://internal-git.company.com/plugin-ui
```

**Custom Framework Checklist:**
- ✅ Has `package.json` with dev and build scripts
- ✅ Dev server runs on specified port
- ✅ Builds to `dist/` directory
- ✅ Implements WebView2 message-passing API
- ✅ Compatible with C++ PluginEditor expectations

## 📝 Configuration

### framework-templates.json

Defines available frameworks and their settings:

```json
{
  "frameworks": {
    "vue": {
      "name": "Vue.js",
      "repository": "https://github.com/artqcid/wogd-juce-template-gui-vue.git",
      "devScript": "dev",
      "buildScript": "build",
      "devPort": 5173,
      "outputDir": "dist"
    }
  }
}
```

### project-config.json

Stores selected framework configuration:

```json
{
  "project": { ... },
  "gui": {
    "framework": "vue",
    "repository": "https://github.com/...",
    "devPort": 5173,
    "devScript": "dev"
  }
}
```

## 🔄 Migration Process

The migration script (`migrate-framework.ps1`):

1. Removes current GUI submodule
2. Adds new framework GUI submodule
3. Updates `project-config.json`
4. Updates `PluginEditor.cpp` with new port
5. Commits changes

## ⚠️ Important Notes

- **Backup before migration**: Always commit your changes before migrating
- **GUI Submodule**: Each framework uses a separate git submodule
- **Port Configuration**: Different frameworks may use different default ports
- **Dependencies**: Run `npm install` after adding/changing GUI

## 🐛 Troubleshooting

### GUI submodule not found
```powershell
git submodule update --init --recursive
```

### Wrong port in PluginEditor
Check `project-config.json` and update `PluginEditor.cpp` manually if needed

### Build errors
Ensure the GUI template repository structure matches requirements

## 📚 Next Steps

1. Create GUI template repositories for each framework
2. Test setup with each framework
3. Update main README with multi-framework instructions
4. Consider merging to main branch when stable
