#!/usr/bin/env pwsh
# Framework Migration Helper
# This script helps migrate existing projects to different GUI frameworks

param(
    [Parameter(Mandatory=$false)]
    [string]$Framework
)

# Color output functions
function Write-Success { param($Message) Write-Host "✓ $Message" -ForegroundColor Green }
function Write-Error { param($Message) Write-Host "✗ $Message" -ForegroundColor Red }
function Write-Info { param($Message) Write-Host "ℹ $Message" -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host "⚠ $Message" -ForegroundColor Yellow }

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     GUI Framework Migration Tool                    ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "project-config.json")) {
    Write-Error "project-config.json not found. Run this script from the project root."
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Load framework templates
$frameworkConfigPath = "framework-templates.json"
if (-not (Test-Path $frameworkConfigPath)) {
    Write-Error "framework-templates.json not found."
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

$frameworkConfig = Get-Content $frameworkConfigPath -Raw | ConvertFrom-Json

# Show current framework
$projectConfig = Get-Content "project-config.json" -Raw | ConvertFrom-Json
$currentFramework = $projectConfig.gui.framework
$currentPort = $projectConfig.gui.devPort

Write-Info "Current GUI Framework: $currentFramework (Port: $currentPort)"
Write-Host ""

# Framework selection if not provided
if (-not $Framework) {
    Write-Host "Select new GUI Framework:" -ForegroundColor Yellow
    Write-Host "  1. Vue.js"
    Write-Host "  2. React"
    Write-Host "  3. Angular"
    Write-Host "  4. Vanilla JavaScript"
    Write-Host "  5. Custom"
    Write-Host ""
    
    $choice = Read-Host "Enter choice (1-5)"
    
    switch ($choice) {
        "1" { $Framework = "vue" }
        "2" { $Framework = "react" }
        "3" { $Framework = "angular" }
        "4" { $Framework = "vanilla" }
        "5" { $Framework = "custom" }
        default {
            Write-Error "Invalid choice!"
            Write-Host "Press any key to exit..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }
    }
}

# Get framework details
if ($Framework -eq "custom") {
    $guiRepo = Read-Host "GUI Repository URL"
    $devPort = Read-Host "Dev Server Port [default: 5173]"
    if ([string]::IsNullOrWhiteSpace($devPort)) { $devPort = 5173 }
    $devScript = Read-Host "Dev Script Name [default: dev]"
    if ([string]::IsNullOrWhiteSpace($devScript)) { $devScript = "dev" }
} else {
    $frameworkDetails = $frameworkConfig.frameworks.$Framework
    if (-not $frameworkDetails) {
        Write-Error "Framework '$Framework' not found in configuration."
        Write-Host "Press any key to exit..." -ForegroundColor Gray
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
    
    $guiRepo = $frameworkDetails.repository
    $devPort = $frameworkDetails.devPort
    $devScript = $frameworkDetails.devScript
}

Write-Host ""
Write-Info "Migration Plan:"
Write-Host "  From: $currentFramework → To: $Framework"
Write-Host "  Repository: $guiRepo"
Write-Host "  Dev Port: $currentPort → $devPort"
Write-Host ""

$confirm = Read-Host "Proceed with migration? (y/n)"
if ($confirm -ne 'y') {
    Write-Warning "Migration cancelled."
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 0
}

Write-Host ""
Write-Info "Starting migration..."
Write-Host ""

# Step 1: Remove existing GUI submodule
Write-Host "Step 1/5: Removing current GUI submodule..." -ForegroundColor Cyan
if (Test-Path "gui") {
    git submodule deinit -f gui 2>$null
    git rm -f gui 2>$null
    Remove-Item -Recurse -Force .git/modules/gui -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force gui -ErrorAction SilentlyContinue
    Write-Success "Old GUI removed"
} else {
    Write-Info "No existing GUI submodule found"
}
Write-Host ""

# Step 2: Add new GUI submodule
Write-Host "Step 2/5: Adding new GUI submodule..." -ForegroundColor Cyan
$output = git submodule add $guiRepo gui 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to add GUI submodule!"
    Write-Host "Error details: $output" -ForegroundColor Red
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}
Write-Success "New GUI submodule added"
Write-Host ""

# Step 3: Initialize submodule
Write-Host "Step 3/5: Initializing GUI submodule..." -ForegroundColor Cyan
git submodule update --init --recursive
Write-Success "Submodule initialized"
Write-Host ""

# Step 4: Update project-config.json
Write-Host "Step 4/5: Updating project-config.json..." -ForegroundColor Cyan
$projectConfig.gui.framework = $Framework
$projectConfig.gui.repository = $guiRepo
$projectConfig.gui.devPort = [int]$devPort
$projectConfig.gui.devScript = $devScript

$json = $projectConfig | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText("project-config.json", $json, [System.Text.Encoding]::UTF8)
Write-Success "Configuration updated"
Write-Host ""

# Step 5: Update PluginEditor.cpp with new port
Write-Host "Step 5/5: Updating PluginEditor.cpp..." -ForegroundColor Cyan
$editorPath = "plugin/source/PluginEditor.cpp"
if (Test-Path $editorPath) {
    $editorContent = Get-Content $editorPath -Raw
    $editorContent = $editorContent -replace 'http://localhost:\d+', "http://localhost:$devPort"
    Set-Content $editorPath -Value $editorContent
    Write-Success "PluginEditor updated with new port: $devPort"
} else {
    Write-Warning "PluginEditor.cpp not found, skipping port update"
}
Write-Host ""

# Commit changes
Write-Host "Committing changes..." -ForegroundColor Cyan
git add -A 2>&1 | Out-Null
$commitOutput = git commit -m "Migrate GUI framework from $currentFramework to $Framework" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Success "Changes committed to git"
} else {
    Write-Warning "Git commit failed or nothing to commit"
    Write-Host "Output: $commitOutput" -ForegroundColor Gray
}

Write-Host ""
Write-Success "Migration complete!"
Write-Host ""
Write-Info "Next steps:"
Write-Host "  1. cd gui; npm install"
Write-Host "  2. npm run $devScript"
Write-Host "  3. Rebuild plugin: cd plugin; cmake --build build"
Write-Host ""

# Keep window open
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
