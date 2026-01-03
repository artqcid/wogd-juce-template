# Multi-Framework Support Branch

This branch adds support for multiple GUI frameworks (Vue.js, React, Angular, Vanilla JS).

## 🎯 Features

- **Framework Selection** during setup
- **Easy Migration** between frameworks
- **Pre-configured Templates** for each framework
- **Automatic Port Configuration**

## 🚀 Quick Start

### New Project with Framework Selection

```powershell
.\setup.ps1
```

The setup script will ask you to choose a GUI framework:
1. Vue.js (default)
2. React
3. Angular
4. Vanilla JavaScript
5. Custom (provide your own repository)

### Migrate Existing Project

```powershell
.\migrate-framework.ps1
```

## 📦 Required GUI Template Repositories

You need to create these repositories for each framework:

1. **Vue.js**: `https://github.com/artqcid/wogd-juce-template-gui-vue.git`
2. **React**: `https://github.com/artqcid/wogd-juce-template-gui-react.git`
3. **Angular**: `https://github.com/artqcid/wogd-juce-template-gui-angular.git`
4. **Vanilla JS**: `https://github.com/artqcid/wogd-juce-template-gui-vanilla.git`

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
