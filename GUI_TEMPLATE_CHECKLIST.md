# GUI Template Repository Checklist

Use this checklist when creating each framework-specific GUI template repository.

## 📋 Repository Naming

- [ ] `wogd-juce-template-gui-vue`
- [ ] `wogd-juce-template-gui-react`
- [ ] `wogd-juce-template-gui-angular`
- [ ] `wogd-juce-template-gui-vanilla`
- [ ] `wogd-juce-template-gui-svelte`

## 📦 Required Files (All Frameworks)

- [ ] `package.json` with correct name and scripts
- [ ] `index.html` entry point
- [ ] `.gitignore` (node_modules, dist, etc.)
- [ ] `README.md` with framework-specific setup
- [ ] `tsconfig.json` (if using TypeScript)
- [ ] Build configuration file

## 🎨 Vue.js Template

```
wogd-juce-template-gui-vue/
├── package.json
├── index.html
├── vite.config.ts
├── tsconfig.json
├── .gitignore
├── README.md
├── src/
│   ├── main.ts
│   ├── App.vue
│   ├── router/
│   │   └── index.ts
│   ├── services/
│   │   └── pluginService.ts
│   └── views/
│       └── PluginView.vue
└── public/
```

### package.json
```json
{
  "name": "wogd-juce-template-gui-vue",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --port 5173",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0"
  }
}
```

## ⚛️ React Template

```
wogd-juce-template-gui-react/
├── package.json
├── index.html
├── vite.config.ts
├── tsconfig.json
├── .gitignore
├── README.md
├── src/
│   ├── main.tsx
│   ├── App.tsx
│   ├── services/
│   │   └── pluginService.ts
│   └── components/
│       └── PluginView.tsx
└── public/
```

### package.json
```json
{
  "name": "wogd-juce-template-gui-react",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --port 5173",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.2.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0"
  }
}
```

## 🅰️ Angular Template

```
wogd-juce-template-gui-angular/
├── package.json
├── angular.json
├── tsconfig.json
├── .gitignore
├── README.md
├── src/
│   ├── main.ts
│   ├── index.html
│   ├── app/
│   │   ├── app.component.ts
│   │   ├── app.routes.ts
│   │   ├── services/
│   │   │   └── plugin.service.ts
│   │   └── components/
│   │       └── plugin-view/
│   │           ├── plugin-view.component.ts
│   │           └── plugin-view.component.html
│   └── styles.css
└── public/
```

### package.json
```json
{
  "name": "wogd-juce-template-gui-angular",
  "version": "1.0.0",
  "scripts": {
    "start": "ng serve --port 4200",
    "build": "ng build",
    "watch": "ng build --watch"
  },
  "dependencies": {
    "@angular/animations": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/compiler": "^17.0.0",
    "@angular/core": "^17.0.0",
    "@angular/platform-browser": "^17.0.0",
    "@angular/router": "^17.0.0",
    "rxjs": "^7.8.0",
    "tslib": "^2.6.0",
    "zone.js": "^0.14.0"
  },
  "devDependencies": {
    "@angular-devkit/build-angular": "^17.0.0",
    "@angular/cli": "^17.0.0",
    "@angular/compiler-cli": "^17.0.0",
    "typescript": "~5.2.0"
  }
}
```

## 📝 Vanilla JS Template

```
wogd-juce-template-gui-vanilla/
├── package.json
├── index.html
├── vite.config.js
├── .gitignore
├── README.md
├── src/
│   ├── main.js
│   ├── pluginService.js
│   └── styles.css
└── public/
```

### package.json
```json
{
  "name": "wogd-juce-template-gui-vanilla",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite --port 5173",
    "build": "vite build",
    "preview": "vite preview"
  },
  "devDependencies": {
    "vite": "^5.0.0"
  }
}
```

## 🔌 Required Plugin Communication API

All templates must implement:

### 1. Plugin Service
```typescript
class PluginService {
  sendParameter(id: string, value: number): void
  getParameter(id: string): Promise<number>
  getPluginInfo(): Promise<PluginInfo>
}
```

### 2. WebSocket/IPC Communication
```typescript
// Connect to plugin backend
const ws = new WebSocket('ws://localhost:...')
// OR use window.webkit.messageHandlers (for WebView2)
```

### 3. Basic UI Components
- Parameter controls (sliders, knobs)
- Preset management
- Plugin info display

## ✅ Testing Checklist

For each template:

- [ ] `npm install` works without errors
- [ ] `npm run dev` starts dev server on correct port
- [ ] `npm run build` creates dist/ folder
- [ ] Hot reload works during development
- [ ] Build output works in production
- [ ] Plugin communication works
- [ ] TypeScript types are correct (if applicable)
- [ ] No console errors in browser
- [ ] Responsive design works

## 📚 Documentation Requirements

Each repository README should include:

- [ ] Framework-specific setup instructions
- [ ] Development workflow
- [ ] Build process
- [ ] Plugin communication API
- [ ] Troubleshooting section
- [ ] Link back to main template repository

## 🚀 Deployment

After creating all repositories:

1. [ ] Update `framework-templates.json` with correct URLs
2. [ ] Test setup.ps1 with each framework
3. [ ] Test migrate-framework.ps1 between frameworks
4. [ ] Update main README with multi-framework support
5. [ ] Create release notes

## 🔗 Repository URLs (Update as needed)

- Vue.js: `https://github.com/artqcid/wogd-juce-template-gui-vue.git`
- React: `https://github.com/artqcid/wogd-juce-template-gui-react.git`
- Angular: `https://github.com/artqcid/wogd-juce-template-gui-angular.git`
- Vanilla: `https://github.com/artqcid/wogd-juce-template-gui-vanilla.git`
