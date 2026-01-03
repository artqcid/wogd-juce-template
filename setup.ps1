#!/usr/bin/env pwsh
# WOGD JUCE Template Setup Script
# This script configures a new plugin project from the template

Write-Host "WOGD JUCE Template Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Get project information
$pluginName = Read-Host "Plugin Name (e.g., 'My Awesome Synth')"
if ([string]::IsNullOrWhiteSpace($pluginName)) {
    Write-Host "[ERROR] Plugin name is required!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

$companyName = Read-Host "Company Name (e.g., 'My Company LLC')"
if ([string]::IsNullOrWhiteSpace($companyName)) {
    Write-Host "[ERROR] Company name is required!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

# Plugin Code (4 characters, at least one uppercase)
do {
    $pluginCode = Read-Host "Plugin Code (4 characters, at least one uppercase, e.g., 'MyAs')"
    if ([string]::IsNullOrWhiteSpace($pluginCode)) {
        Write-Host "[ERROR] Plugin code is required!" -ForegroundColor Red
    } elseif ($pluginCode.Length -ne 4) {
        Write-Host "[ERROR] Plugin code must be exactly 4 characters!" -ForegroundColor Red
    } elseif ($pluginCode -cnotmatch '[A-Z]') {
        Write-Host "[ERROR] Plugin code must contain at least one uppercase letter!" -ForegroundColor Red
    } else {
        break
    }
} while ($true)

# Manufacturer Code (4 characters, first character MUST be uppercase for AU)
do {
    $manufacturerCode = Read-Host "Manufacturer Code (4 characters, first MUST be uppercase, e.g., 'MyCo')"
    if ([string]::IsNullOrWhiteSpace($manufacturerCode)) {
        Write-Host "[ERROR] Manufacturer code is required!" -ForegroundColor Red
    } elseif ($manufacturerCode.Length -ne 4) {
        Write-Host "[ERROR] Manufacturer code must be exactly 4 characters!" -ForegroundColor Red
    } elseif ($manufacturerCode[0] -cnotmatch '[A-Z]') {
        Write-Host "[ERROR] First character of manufacturer code MUST be uppercase (required for AU format)!" -ForegroundColor Red
    } else {
        break
    }
} while ($true)

# GUI Framework Selection
Write-Host ""
Write-Host "GUI Framework Selection:" -ForegroundColor Cyan
Write-Host "Available frameworks: Vue.js, React, Angular, Vanilla JS"
Write-Host ""

# Load framework templates
$frameworkConfigPath = "framework-templates.json"
if (Test-Path $frameworkConfigPath) {
    $frameworkConfig = Get-Content $frameworkConfigPath -Raw | ConvertFrom-Json
    
    Write-Host "Select GUI Framework:" -ForegroundColor Yellow
    Write-Host "  1. Vue.js (default)" -ForegroundColor Green
    Write-Host "  2. React"
    Write-Host "  3. Angular"
    Write-Host "  4. Vanilla JavaScript"
    Write-Host "  5. Custom"
    Write-Host ""
    Write-Host "Template repositories available at:" -ForegroundColor Gray
    Write-Host "  Vue.js:  $($frameworkConfig.frameworks.vue.repository)" -ForegroundColor DarkGray
    Write-Host "  React:   $($frameworkConfig.frameworks.react.repository)" -ForegroundColor DarkGray
    Write-Host "  Angular: $($frameworkConfig.frameworks.angular.repository)" -ForegroundColor DarkGray
    Write-Host "  Vanilla: $($frameworkConfig.frameworks.vanilla.repository)" -ForegroundColor DarkGray
    Write-Host ""
    
    $frameworkChoice = Read-Host "Enter choice (1-5) [default: 1]"
    if ([string]::IsNullOrWhiteSpace($frameworkChoice)) {
        $frameworkChoice = "1"
    }
    
    switch ($frameworkChoice) {
        "1" {
            $selectedFramework = "vue"
            $templateRepo = $frameworkConfig.frameworks.vue.repository
            $devPort = $frameworkConfig.frameworks.vue.devPort
            $devScript = $frameworkConfig.frameworks.vue.devScript
        }
        "2" {
            $selectedFramework = "react"
            $templateRepo = $frameworkConfig.frameworks.react.repository
            $devPort = $frameworkConfig.frameworks.react.devPort
            $devScript = $frameworkConfig.frameworks.react.devScript
        }
        "3" {
            $selectedFramework = "angular"
            $templateRepo = $frameworkConfig.frameworks.angular.repository
            $devPort = $frameworkConfig.frameworks.angular.devPort
            $devScript = $frameworkConfig.frameworks.angular.devScript
        }
        "4" {
            $selectedFramework = "vanilla"
            $templateRepo = $frameworkConfig.frameworks.vanilla.repository
            $devPort = $frameworkConfig.frameworks.vanilla.devPort
            $devScript = $frameworkConfig.frameworks.vanilla.devScript
        }
        "5" {
            $selectedFramework = "custom"
            $templateRepo = "N/A"
            $devPort = Read-Host "Dev Server Port [default: 5173]"
            if ([string]::IsNullOrWhiteSpace($devPort)) {
                $devPort = 5173
            }
            $devScript = Read-Host "Dev Script Name [default: dev]"
            if ([string]::IsNullOrWhiteSpace($devScript)) {
                $devScript = "dev"
            }
        }
        default {
            Write-Host "[ERROR] Invalid choice!" -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }
    }
    
    # Now ask for the developer's own GUI repository
    Write-Host ""
    if ($selectedFramework -ne "custom") {
        Write-Host "Template Repository: $templateRepo" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Please create your own GUI repository from the template above," -ForegroundColor Yellow
        Write-Host "then provide your repository URL below:" -ForegroundColor Yellow
    }
    Write-Host ""
    $guiRepo = Read-Host "Your GUI Repository URL"
    if ([string]::IsNullOrWhiteSpace($guiRepo)) {
        Write-Host "[ERROR] GUI repository URL is required!" -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit 1
    }
    
    Write-Host ""
    Write-Host "Selected Framework: $selectedFramework" -ForegroundColor Green
    Write-Host "Your GUI Repository: $guiRepo" -ForegroundColor Green
    Write-Host "Dev Port: $devPort" -ForegroundColor Gray
    Write-Host "Dev Script: $devScript" -ForegroundColor Gray
    Write-Host ""
} else {
    # Fallback if config file doesn't exist
    Write-Host "[WARNING] framework-templates.json not found, using manual input" -ForegroundColor Yellow
    $guiRepo = Read-Host "GUI Repository URL"
    $devPort = 5173
    $devScript = "dev"
    $selectedFramework = "custom"
}

# Plugin Format Selection
Write-Host ""
Write-Host "Plugin Format Selection:" -ForegroundColor Cyan
Write-Host "Available formats: VST3, AU, AUv3, AAX, Standalone, Unity"
Write-Host ""

# Multi-select prompt with checkboxes
$formatSelection = @{
    "VST3" = $true
    "AU" = $false
    "AUv3" = $true
    "AAX" = $false
    "Standalone" = $true
    "Unity" = $false
}

Write-Host "Select plugin formats (y/n for each, press Enter to accept defaults):" -ForegroundColor Yellow
foreach ($format in $formatSelection.Keys | Sort-Object) {
    $default = if ($formatSelection[$format]) { "Y" } else { "N" }
    $promptText = "  Build ${format}? (y/n) [default: $default]"
    $response = Read-Host $promptText
    if ([string]::IsNullOrWhiteSpace($response)) {
        # Keep default
    } elseif ($response -match '^[Yy]') {
        $formatSelection[$format] = $true
    } else {
        $formatSelection[$format] = $false
    }
}

$selectedFormats = ($formatSelection.GetEnumerator() | Where-Object { $_.Value } | ForEach-Object { $_.Key }) -join ' '
if ([string]::IsNullOrWhiteSpace($selectedFormats)) {
    Write-Host "[ERROR] At least one plugin format must be selected!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Plugin Name: $pluginName"
Write-Host "  Company: $companyName"
Write-Host "  Plugin Code: $pluginCode"
Write-Host "  Manufacturer Code: $manufacturerCode"
Write-Host "  GUI Repo: $guiRepo"
Write-Host "  Plugin Formats: $selectedFormats"
Write-Host ""

# Create safe identifiers (no spaces, special chars)
$pluginId = $pluginName -replace '[^a-zA-Z0-9]', '_'
$pluginIdSpaces = $pluginName -replace '[^a-zA-Z0-9 ]', ''

$configPath = "project-config.json"
if (Test-Path $configPath) {
    Write-Host "  Updating project-config.json..." -ForegroundColor Gray
    $configContent = Get-Content $configPath -Raw | ConvertFrom-Json
    $configContent.project.name = $pluginId
    $configContent.project.displayName = $pluginName
    $configContent.project.company = $companyName
    $configContent.project.pluginCode = $pluginCode
    $configContent.project.manufacturerCode = $manufacturerCode
    
    # Add GUI framework configuration
    if (-not $configContent.gui) {
        $configContent | Add-Member -MemberType NoteProperty -Name "gui" -Value @{}
    }
    $configContent.gui = @{
        framework = $selectedFramework
        repository = $guiRepo
        devPort = [int]$devPort
        devScript = $devScript
    }
    
    $json = $configContent | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($configPath, $json, [System.Text.Encoding]::UTF8)
}

$confirm = Read-Host "Proceed with setup? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit..."
    exit 0
}

Write-Host ""
Write-Host "Setting up project..." -ForegroundColor Green

# Update CMakeLists.txt
Write-Host "  Updating CMakeLists.txt..." -ForegroundColor Gray
$cmakePath = "plugin/CMakeLists.txt"
$cmakeContent = Get-Content $cmakePath -Raw
$cmakeContent = $cmakeContent -replace 'set\(PRODUCT_NAME "WOGD JUCE Template"\)', "set(PRODUCT_NAME `"$pluginIdSpaces`")"
$cmakeContent = $cmakeContent -replace 'set\(COMPANY_NAME "WordOfGearDevelopment"\)', "set(COMPANY_NAME `"$companyName`")"
$cmakeContent = $cmakeContent -replace 'project\(WOGD_JUCE_Template', "project($pluginId"
# Update plugin formats
$cmakeContent = $cmakeContent -replace 'set\(FORMATS [^\)]+\)', "set(FORMATS $selectedFormats)"
Set-Content $cmakePath -Value $cmakeContent

# Update VERSION file
Write-Host "  Updating VERSION..." -ForegroundColor Gray
Set-Content "plugin/VERSION" -Value "0.0.1"

# Update template.code-workspace
Write-Host "  Updating workspace file..." -ForegroundColor Gray
$workspacePath = "template.code-workspace"
$newWorkspacePath = "$pluginId.code-workspace"
if (Test-Path $workspacePath) {
    $workspaceContent = Get-Content $workspacePath -Raw | ConvertFrom-Json
    # Passe den Namen des Root-Ordners an den Projektnamen an
    foreach ($folder in $workspaceContent.folders) {
        if ($folder.path -eq ".") {
            $folder.name = $pluginIdSpaces
        }
    }
    # Speichere Workspace-Datei explizit als UTF-8 mit BOM für Emoji-Kompatibilität
    $json = $workspaceContent | ConvertTo-Json -Depth 10
    [System.IO.File]::WriteAllText($newWorkspacePath, $json, [System.Text.Encoding]::UTF8)
    Remove-Item $workspacePath
    Write-Host "  Renamed workspace: $workspacePath -> $newWorkspacePath (Root-Ordner-Name angepasst)" -ForegroundColor Gray
}

# Remove existing gui submodule if present
Write-Host "  Removing template GUI submodule..." -ForegroundColor Gray
if (Test-Path "gui") {
    git submodule deinit -f gui 2>$null
    git rm -f gui 2>$null
    Remove-Item -Recurse -Force .git/modules/gui -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force gui -ErrorAction SilentlyContinue
}

# Add new GUI submodule
Write-Host "  Adding GUI submodule from $guiRepo..." -ForegroundColor Gray
git submodule add $guiRepo gui
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to add GUI submodule!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

# Initialize and update submodule
Write-Host "  Initializing GUI submodule..." -ForegroundColor Gray
git submodule update --init --recursive

# Commit changes
Write-Host "  Committing changes..." -ForegroundColor Gray
git add -A
git commit -m "Setup: Configure project as '$pluginIdSpaces' by $companyName"

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "  IDE Configuration" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Select your development environment:" -ForegroundColor Yellow
Write-Host "  1. VS Code (default) - Pre-configured workspace"
Write-Host "  2. CLion - CMake-based IDE"
Write-Host "  3. Visual Studio - Windows native IDE"
Write-Host "  4. Xcode - macOS IDE (untested)" -ForegroundColor DarkGray
Write-Host "  5. Command Line Only - No IDE configuration"
Write-Host "  6. Generate All - Create configs for all IDEs"
Write-Host ""

$ideChoice = Read-Host "Enter choice (1-6) [default: 1]"
if ([string]::IsNullOrWhiteSpace($ideChoice)) {
    $ideChoice = "1"
}

switch ($ideChoice) {
    "1" {
        Write-Success "VS Code workspace already configured: $newWorkspacePath"
        Write-Info "Open with: code $newWorkspacePath"
    }
    "2" {
        Write-Success "CLion: CMakePresets.json is already configured"
        Write-Info "Open the 'plugin' folder in CLion"
        Write-Info "CLion will automatically detect CMake presets"
    }
    "3" {
        Write-Host "  Generating Visual Studio configuration..." -ForegroundColor Gray
        
        # Generate .vs/launch.vs.json
        $launchConfig = @{
            version = "0.2.1"
            defaults = @{}
            configurations = @(
                @{
                    type = "default"
                    project = "CMakeLists.txt"
                    projectTarget = "$pluginId`_Standalone.exe"
                    name = "$pluginIdSpaces Standalone"
                }
            )
        }
        
        $vsDir = "plugin/.vs"
        if (-not (Test-Path $vsDir)) {
            New-Item -ItemType Directory -Path $vsDir -Force | Out-Null
        }
        
        $launchConfig | ConvertTo-Json -Depth 10 | Set-Content "$vsDir/launch.vs.json" -Encoding UTF8
        
        Write-Success "Visual Studio configuration generated"
        Write-Info "Open the 'plugin' folder in Visual Studio 2022+"
        Write-Info "Visual Studio will detect CMakePresets.json automatically"
    }
    "4" {
        Write-Host "  Generating Xcode project..." -ForegroundColor Gray
        
        Push-Location plugin
        try {
            $result = cmake -G Xcode -B build-xcode 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Xcode project generated"
                Write-Warning "⚠️  Xcode support is UNTESTED by template authors"
                Write-Info "Open: plugin/build-xcode/$pluginId.xcodeproj"
                Write-Info ""
                Write-Info "This requires macOS and Xcode installed"
                Write-Info "Please report any issues to the template repository"
            } else {
                Write-Error "Failed to generate Xcode project"
                Write-Info "Error: $result"
                Write-Info "Xcode support requires macOS and Xcode Command Line Tools"
            }
        } finally {
            Pop-Location
        }
    }
    "5" {
        Write-Success "CLI-only setup complete"
        Write-Info "See CLI-DEVELOPMENT.md for command-line workflows"
        Write-Info ""
        Write-Info "Quick start commands:"
        Write-Info "  cd plugin && cmake --preset ninja-clang"
        Write-Info "  cmake --build build --config Debug"
        Write-Info "  cd ../gui && npm run dev"
    }
    "6" {
        Write-Host "  Generating all IDE configurations..." -ForegroundColor Gray
        
        # VS Code (already done)
        Write-Success "VS Code: $newWorkspacePath"
        
        # CLion (uses CMakePresets.json)
        Write-Success "CLion: CMakePresets.json configured"
        
        # Visual Studio
        $launchConfig = @{
            version = "0.2.1"
            defaults = @{}
            configurations = @(
                @{
                    type = "default"
                    project = "CMakeLists.txt"
                    projectTarget = "$pluginId`_Standalone.exe"
                    name = "$pluginIdSpaces Standalone"
                }
            )
        }
        
        $vsDir = "plugin/.vs"
        if (-not (Test-Path $vsDir)) {
            New-Item -ItemType Directory -Path $vsDir -Force | Out-Null
        }
        
        $launchConfig | ConvertTo-Json -Depth 10 | Set-Content "$vsDir/launch.vs.json" -Encoding UTF8
        Write-Success "Visual Studio: Configuration generated"
        
        # Xcode (macOS only, untested)
        Push-Location plugin
        try {
            $xcodeResult = cmake -G Xcode -B build-xcode 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Xcode: Project generated (untested)"
            } else {
                Write-Warning "Xcode: Skipped (requires macOS)"
            }
        } finally {
            Pop-Location
        }
        
        Write-Info ""
        Write-Info "All IDE configurations ready!"
    }
    default {
        Write-Warning "Invalid choice, defaulting to VS Code"
        Write-Success "VS Code workspace: $newWorkspacePath"
    }
}

Write-Host ""
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "━━━ Next Steps ━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "You have TWO options to complete the setup:" -ForegroundColor Yellow
Write-Host ""

Write-Host "Option A - Automatic (Recommended for first-time setup):" -ForegroundColor Green
Write-Host "  Run quick-start.ps1 in project root:"
Write-Host "  " -NoNewline
Write-Host ".\quick-start.ps1" -ForegroundColor White -BackgroundColor DarkGray
Write-Host ""
Write-Host "  OR use VS Code task:"
Write-Host "  1. Open $newWorkspacePath in VS Code"
Write-Host "  2. Press Ctrl+Shift+P → 'Tasks: Run Task'"
Write-Host "  3. Select 'PROJECT First Time Setup'"
Write-Host ""
Write-Host "  This will automatically:" -ForegroundColor Gray
Write-Host "    • Initialize GUI submodule"
Write-Host "    • Install GUI dependencies (npm install)"
Write-Host "    • Configure CMake"
Write-Host "    • Build plugin"
Write-Host "    • Start GUI dev server"
Write-Host ""

Write-Host "Option B - Manual (For advanced users):" -ForegroundColor Yellow
Write-Host "  # Initialize submodule"
Write-Host "  git submodule update --init --recursive"
Write-Host ""
Write-Host "  # Install GUI dependencies"
Write-Host "  cd gui && npm install && cd .."
Write-Host ""
Write-Host "  # Configure and build plugin"
Write-Host "  cd plugin"
Write-Host "  cmake --preset ninja-clang"
Write-Host "  cmake --build build --config Debug"
Write-Host "  cd .."
Write-Host ""
Write-Host "  # Start GUI dev server"
Write-Host "  cd gui && npm run dev"
Write-Host ""

Write-Host "━━━ Optional Configuration ━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Environment Variables:" -ForegroundColor Yellow
Write-Host "  Set JUCE_DIR to use a central JUCE installation:"
Write-Host '  $env:JUCE_DIR = "C:/path/to/juce"' -ForegroundColor Gray
Write-Host '  [System.Environment]::SetEnvironmentVariable("JUCE_DIR", "C:/path/to/juce", "User")' -ForegroundColor Gray
Write-Host ""
Write-Host "  JUCE_DIR can point to:"
Write-Host "    • JUCE source directory (containing CMakeLists.txt)"
Write-Host "    • Installed JUCE (containing JUCEConfig.cmake)"
Write-Host ""

Write-Host "Documentation:" -ForegroundColor Yellow
Write-Host "  • README.md - Full project documentation"
Write-Host "  • plugin/BUILD_WITH_GUI.md - GUI integration guide"
Write-Host "  • plugin/docs/WEBVIEW2_SETUP.md - WebView2 setup"
Write-Host ""
Write-Host "Happy coding! 🎵" -ForegroundColor Magenta
Write-Host ""
Read-Host "Press Enter to close..."
