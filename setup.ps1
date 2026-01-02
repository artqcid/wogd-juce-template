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

$companyName = Read-Host "Company Name (e.g., 'WordOfGearDevelopment')"
if ([string]::IsNullOrWhiteSpace($companyName)) {
    Write-Host "[ERROR] Company name is required!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

$guiRepoDefault = "https://github.com/artqcid/wogd-juce-template-gui.git"
$guiRepo = Read-Host "GUI Repository URL (press Enter for default template)"
if ([string]::IsNullOrWhiteSpace($guiRepo)) {
    $guiRepo = $guiRepoDefault
}

Write-Host ""
Write-Host "Configuration:" -ForegroundColor Yellow
Write-Host "  Plugin Name: $pluginName"
Write-Host "  Company: $companyName"
Write-Host "  GUI Repo: $guiRepo"
Write-Host ""

$confirm = Read-Host "Proceed with setup? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Setup cancelled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit..."
    exit 0
}

Write-Host ""
Write-Host "Setting up project..." -ForegroundColor Green

# Create safe identifiers (no spaces, special chars)
$pluginId = $pluginName -replace '[^a-zA-Z0-9]', '_'
$pluginIdSpaces = $pluginName -replace '[^a-zA-Z0-9 ]', ''

# Update CMakeLists.txt
Write-Host "  Updating CMakeLists.txt..." -ForegroundColor Gray
$cmakePath = "plugin/CMakeLists.txt"
$cmakeContent = Get-Content $cmakePath -Raw
$cmakeContent = $cmakeContent -replace 'set\(PRODUCT_NAME "WOGD JUCE Template"\)', "set(PRODUCT_NAME `"$pluginIdSpaces`")"
$cmakeContent = $cmakeContent -replace 'set\(COMPANY_NAME "WordOfGearDevelopment"\)', "set(COMPANY_NAME `"$companyName`")"
$cmakeContent = $cmakeContent -replace 'project\(WOGD_JUCE_Template', "project($pluginId"
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
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open template.code-workspace in VS Code"
Write-Host "  2. Run task 'Install GUI Dependencies'"
Write-Host "  3. Run task 'Configure CMake'"
Write-Host "  4. Run task 'Setup & Start Everything'"
Write-Host ""
Write-Host "Happy coding!" -ForegroundColor Magenta

# --- Automatischer Build mit MSVC + Clang ---
Write-Host "" -ForegroundColor Cyan
Write-Host "Automatischer Build mit MSVC 18 + Clang (Ninja)..." -ForegroundColor Cyan

# Lösche build-Ordner
if (Test-Path "build") {
    Write-Host "  Lösche build-Ordner..." -ForegroundColor Gray
    Remove-Item -Recurse -Force "build"
}

# MSVC 18 Umgebung laden
$vcvarsPath = "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"
if (Test-Path $vcvarsPath) {
    Write-Host "  Lade MSVC 18 Umgebung..." -ForegroundColor Gray
    cmd /c "`"$vcvarsPath`" && set" | ForEach-Object {
        if ($_ -match "^(.*?)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            [System.Environment]::SetEnvironmentVariable($name, $value, 'Process')
        }
    }
} else {
    Write-Host "[WARN] vcvars64.bat nicht gefunden! MSVC-Umgebung muss ggf. manuell geladen werden." -ForegroundColor Yellow
}

# CMake-Konfiguration und Build
Write-Host "  Starte cmake --preset ninja-clang..." -ForegroundColor Gray
& cmake --preset ninja-clang
Write-Host "  Starte cmake --build build..." -ForegroundColor Gray
& cmake --build build
Write-Host "Build abgeschlossen!" -ForegroundColor Green
