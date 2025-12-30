#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup script for WOGD JUCE Template - Run this once after cloning
.DESCRIPTION
    This script will:
    - Ask for your project name
    - Update project-config.json
    - Optionally rename the workspace file
    - Delete itself when done
#>

Write-Host "🎸 WOGD JUCE Template Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Get project name
$projectName = Read-Host "Enter your project name (e.g., 'MyAwesomePlugin')"
if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "❌ Project name cannot be empty" -ForegroundColor Red
    exit 1
}

# Generate internal name (no spaces)
$internalName = $projectName -replace '\s+', '_'

# Get company name
$companyName = Read-Host "Enter your company name (e.g., 'MyCompany')"
if ([string]::IsNullOrWhiteSpace($companyName)) {
    $companyName = "YourCompany"
}

# Generate bundle ID
$bundleIdBase = $companyName.ToLower() -replace '\s+', ''
$bundleId = "com.$bundleIdBase." + ($projectName.ToLower() -replace '\s+', '')

# Generate plugin codes
Write-Host ""
Write-Host "Plugin codes must be 4 characters:" -ForegroundColor Yellow
$pluginCode = Read-Host "Enter plugin code (4 chars, e.g., 'Mplg')"
if ($pluginCode.Length -ne 4) {
    Write-Host "⚠️ Using default: Plug" -ForegroundColor Yellow
    $pluginCode = "Plug"
}

$manufacturerCode = Read-Host "Enter manufacturer code (4 chars, e.g., 'Ycom')"
if ($manufacturerCode.Length -ne 4) {
    Write-Host "⚠️ Using default: Demo" -ForegroundColor Yellow
    $manufacturerCode = "Demo"
}

Write-Host ""
Write-Host "📝 Configuration:" -ForegroundColor Green
Write-Host "  Project Name: $projectName" -ForegroundColor Gray
Write-Host "  Internal Name: $internalName" -ForegroundColor Gray
Write-Host "  Company: $companyName" -ForegroundColor Gray
Write-Host "  Bundle ID: $bundleId" -ForegroundColor Gray
Write-Host "  Plugin Code: $pluginCode" -ForegroundColor Gray
Write-Host "  Manufacturer Code: $manufacturerCode" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Proceed? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "❌ Setup cancelled" -ForegroundColor Red
    exit 0
}

# Update project-config.json
Write-Host ""
Write-Host "📦 Updating project-config.json..." -ForegroundColor Cyan
$config = @{
    project = @{
        name = $internalName
        displayName = $projectName
        version = "0.0.1"
        company = $companyName
        bundleId = $bundleId
        pluginCode = $pluginCode
        manufacturerCode = $manufacturerCode
    }
} | ConvertTo-Json -Depth 10

Set-Content -Path "project-config.json" -Value $config

# Rename workspace file
$workspaceName = ($projectName -replace '\s+', '-').ToLower()
$newWorkspaceFile = "$workspaceName.code-workspace"

Write-Host "📁 Renaming workspace file to $newWorkspaceFile..." -ForegroundColor Cyan
if (Test-Path "template.code-workspace") {
    Rename-Item -Path "template.code-workspace" -NewName $newWorkspaceFile
}

Write-Host ""
Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Open workspace: code $newWorkspaceFile" -ForegroundColor Gray
Write-Host "  2. Install GUI dependencies: cd gui && npm install" -ForegroundColor Gray
Write-Host "  3. Configure CMake: cd plugin && cmake -B build" -ForegroundColor Gray
Write-Host "  4. Press F5 to build and debug" -ForegroundColor Gray
Write-Host ""

# Ask to delete setup script
$deleteScript = Read-Host "Delete this setup script? (y/n)"
if ($deleteScript -eq 'y') {
    Write-Host "🗑️ Deleting setup script..." -ForegroundColor Cyan
    Remove-Item -Path $PSCommandPath -Force
    Write-Host "✅ Script deleted. Happy coding! 🎉" -ForegroundColor Green
}
