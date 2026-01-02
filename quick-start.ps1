# WOGD JUCE Template - Quick Start
# This script checks prerequisites, optionally installs VS Code extensions, and runs first-time setup

param(
    [switch]$SkipExtensions,
    [switch]$NoInteractive
)

# Color output functions
function Write-Success { param($Message) Write-Host "✓ $Message" -ForegroundColor Green }
function Write-Error { param($Message) Write-Host "✗ $Message" -ForegroundColor Red }
function Write-Info { param($Message) Write-Host "ℹ $Message" -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host "⚠ $Message" -ForegroundColor Yellow }

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     WOGD JUCE Template - Quick Start Setup          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check if running in correct directory
if (-not (Test-Path "template.code-workspace")) {
    Write-Error "This script must be run from the project root directory"
    Write-Info "Current directory: $PWD"
    exit 1
}

# Step 1: Check Prerequisites
Write-Host "━━━ Step 1: Checking Prerequisites ━━━" -ForegroundColor Yellow
Write-Host ""

$allPrerequisitesMet = $true

# Check Git
Write-Host "Checking Git... " -NoNewline
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    $gitVersion = git --version
    Write-Success "Found: $gitVersion"
} else {
    Write-Error "Not found - Please install Git from https://git-scm.com/"
    $allPrerequisitesMet = $false
}

# Check CMake
Write-Host "Checking CMake... " -NoNewline
$cmake = Get-Command cmake -ErrorAction SilentlyContinue
if ($cmake) {
    $cmakeVersion = cmake --version | Select-Object -First 1
    Write-Success "Found: $cmakeVersion"
} else {
    Write-Error "Not found - Please install CMake 3.25+ from https://cmake.org/"
    $allPrerequisitesMet = $false
}

# Check Node.js
Write-Host "Checking Node.js... " -NoNewline
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    $nodeVersion = node --version
    Write-Success "Found: $nodeVersion"
} else {
    Write-Error "Not found - Please install Node.js from https://nodejs.org/"
    $allPrerequisitesMet = $false
}

# Check npm
Write-Host "Checking npm... " -NoNewline
$npm = Get-Command npm -ErrorAction SilentlyContinue
if ($npm) {
    $npmVersion = npm --version
    Write-Success "Found: v$npmVersion"
} else {
    Write-Error "Not found - npm should be installed with Node.js"
    $allPrerequisitesMet = $false
}

# Check Visual Studio
Write-Host "Checking Visual Studio... " -NoNewline
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path $vswhere) {
    $vsPath = & $vswhere -latest -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
    if ($vsPath) {
        $vsVersion = & $vswhere -latest -property catalog_productDisplayVersion
        Write-Success "Found: Visual Studio $vsVersion"
    } else {
        Write-Warning "Visual Studio found but C++ tools not installed"
        Write-Info "Install 'Desktop development with C++' workload"
        $allPrerequisitesMet = $false
    }
} else {
    Write-Warning "Visual Studio not detected via vswhere"
    Write-Info "Please install Visual Studio 2019+ with C++ tools"
    Write-Info "Or ensure your compiler is available in PATH"
}

# Check VS Code
Write-Host "Checking VS Code... " -NoNewline
$code = Get-Command code -ErrorAction SilentlyContinue
if ($code) {
    Write-Success "Found in PATH"
} else {
    Write-Warning "Not found in PATH - VS Code may not be installed or not added to PATH"
    Write-Info "Install from https://code.visualstudio.com/"
}

Write-Host ""

if (-not $allPrerequisitesMet) {
    Write-Error "Some prerequisites are missing. Please install them and run this script again."
    Write-Host ""
    if (-not $NoInteractive) {
        Read-Host "Press Enter to exit"
    }
    exit 1
}

Write-Success "All prerequisites met!"
Write-Host ""

# Step 2: VS Code Extensions (optional)
if (-not $SkipExtensions -and $code) {
    Write-Host "━━━ Step 2: VS Code Extensions ━━━" -ForegroundColor Yellow
    Write-Host ""
    
    $installExtensions = $true
    if (-not $NoInteractive) {
        $response = Read-Host "Do you want to install recommended VS Code extensions? (Y/n)"
        $installExtensions = ($response -eq "" -or $response -eq "Y" -or $response -eq "y")
    }
    
    if ($installExtensions) {
        $extensions = @(
            "llvm-vs-code-extensions.vscode-clangd",
            "ms-vscode.cpptools",
            "ms-vscode.cmake-tools",
            "Vue.volar",
            "esbenp.prettier-vscode",
            "ms-vscode.powershell"
        )
        
        Write-Info "Installing VS Code extensions..."
        foreach ($ext in $extensions) {
            Write-Host "  Installing $ext... " -NoNewline
            $result = & code --install-extension $ext 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Done"
            } else {
                Write-Warning "Failed or already installed"
            }
        }
        Write-Host ""
    } else {
        Write-Info "Skipping extension installation"
        Write-Host ""
    }
} else {
    Write-Info "Skipping VS Code extensions (not available or --SkipExtensions used)"
    Write-Host ""
}

# Step 3: Environment Variables
Write-Host "━━━ Step 3: Environment Variables ━━━" -ForegroundColor Yellow
Write-Host ""

if (Test-Path ".env") {
    Write-Info "Found existing .env file"
} else {
    Write-Info "No .env file found"
    if (Test-Path ".env.example") {
        Write-Info "You can copy .env.example to .env and customize it"
        Write-Info "This is optional - the project will work without it using defaults"
    }
}
Write-Host ""

# Step 4: Run First Time Setup
Write-Host "━━━ Step 4: Running First Time Setup ━━━" -ForegroundColor Yellow
Write-Host ""

$runSetup = $true
if (-not $NoInteractive) {
    $response = Read-Host "Ready to run first-time setup? This will initialize submodules, install dependencies, configure CMake, and build the plugin. Continue? (Y/n)"
    $runSetup = ($response -eq "" -or $response -eq "Y" -or $response -eq "y")
}

if ($runSetup) {
    Write-Info "Starting setup process..."
    Write-Host ""
    
    # Run the main setup script
    & .\setup.ps1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Success "Setup completed successfully!"
    } else {
        Write-Host ""
        Write-Error "Setup encountered errors. Please check the output above."
        Write-Info "You can run setup.ps1 again to retry"
    }
} else {
    Write-Info "Skipping setup. You can run setup.ps1 manually later."
}

Write-Host ""
Write-Host "━━━ Next Steps ━━━" -ForegroundColor Yellow
Write-Host ""
Write-Info "1. Open VS Code: code template.code-workspace"
Write-Info "2. Start GUI dev server: Run task 'GUI Start Dev Server'"
Write-Info "3. Build plugin: Run task 'PLUGIN CMake Build (Incremental)'"
Write-Info "4. Debug plugin: Press F5 in VS Code"
Write-Host ""
Write-Info "📚 Documentation:"
Write-Info "   - README.md - Project overview and setup"
Write-Info "   - plugin/BUILD_WITH_GUI.md - GUI integration guide"
Write-Info "   - docs/WEBVIEW2_SETUP.md - WebView2 setup instructions"
Write-Info "   - CONTRIBUTING.md - Contribution guidelines"
Write-Host ""
Write-Success "Happy coding! 🎵"
Write-Host ""

if (-not $NoInteractive) {
    Read-Host "Press Enter to exit"
}
