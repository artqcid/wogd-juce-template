# WebView2 SDK Setup

This project uses Microsoft WebView2 SDK for embedded web content on Windows.

## Option 1: Central Repository (Recommended)

Use a central WebView2 SDK installation shared across multiple projects:

### Setup Steps

1. **Download WebView2 SDK NuGet Package**
   ```powershell
   # Create a central directory for WebView2 SDK
   New-Item -ItemType Directory -Force -Path "C:\dev\WebView2SDK"
   
   # Download the NuGet package
   Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2/1.0.2792.45" -OutFile "C:\dev\WebView2SDK\webview2.nupkg"
   
   # Extract the package (it's just a zip file)
   Expand-Archive -Path "C:\dev\WebView2SDK\webview2.nupkg" -DestinationPath "C:\dev\WebView2SDK" -Force
   
   # Clean up
   Remove-Item "C:\dev\WebView2SDK\webview2.nupkg"
   ```

2. **Set Environment Variable**
   
   **Windows (PowerShell - User level):**
   ```powershell
   [System.Environment]::SetEnvironmentVariable('WEBVIEW2_SDK_DIR', 'C:\dev\WebView2SDK', 'User')
   ```
   
   **Windows (PowerShell - System level, requires admin):**
   ```powershell
   [System.Environment]::SetEnvironmentVariable('WEBVIEW2_SDK_DIR', 'C:\dev\WebView2SDK', 'Machine')
   ```
   
   **Or manually:**
   - Open Windows Settings → System → About → Advanced system settings
   - Click "Environment Variables"
   - Add new User or System variable:
     - Name: `WEBVIEW2_SDK_DIR`
     - Value: `C:\dev\WebView2SDK`

3. **Restart your terminal/IDE** to apply the environment variable

4. **Verify the setup**
   ```powershell
   echo $env:WEBVIEW2_SDK_DIR
   Test-Path "$env:WEBVIEW2_SDK_DIR\build\native\include\WebView2.h"
   ```

### Expected Directory Structure

The WebView2 SDK directory should have this structure:
```
C:\dev\WebView2SDK\
├── build\
│   └── native\
│       ├── include\
│       │   ├── WebView2.h
│       │   └── WebView2EnvironmentOptions.h
│       ├── x64\
│       │   └── WebView2LoaderStatic.lib
│       └── x86\
│           └── WebView2LoaderStatic.lib
└── [other files...]
```

## Option 2: Automatic Download (Fallback)

If `WEBVIEW2_SDK_DIR` is not set, CMake will automatically download the WebView2 SDK via CPM (CMake Package Manager) during configuration.

This is useful for:
- CI/CD pipelines
- Quick testing
- First-time setup

**Note:** The SDK will be downloaded to `build/_deps/webview2-src/` and needs to be re-downloaded for each clean build.

## Usage in CMake

The CMakeLists.txt handles both options automatically:

1. Checks for `WEBVIEW2_SDK_DIR` environment variable
2. If not found, downloads via CPM
3. Creates a `WebView2` interface library
4. Links it to the project

## Benefits of Central Repository

- **Faster builds**: No re-download after `rm -rf build`
- **Offline development**: Work without internet
- **Version control**: Pin a specific SDK version
- **Multi-project sharing**: One SDK for all projects
- **Consistent builds**: Same SDK across team members

## Updating WebView2 SDK

To update to a newer version:

1. Download the new version from [NuGet](https://www.nuget.org/packages/Microsoft.Web.WebView2/)
2. Extract to your central location
3. Update the version in CMakeLists.txt (fallback URL)

## Troubleshooting

**CMake can't find WebView2.h:**
- Verify `WEBVIEW2_SDK_DIR` is set: `echo $env:WEBVIEW2_SDK_DIR`
- Check the file exists: `Test-Path "$env:WEBVIEW2_SDK_DIR\build\native\include\WebView2.h"`
- Restart your IDE/terminal after setting the environment variable

**Wrong architecture error:**
- Ensure you're building for x64: `cmake -B build -A x64`
- The SDK supports both x86 and x64

**Need a different version:**
- Download from https://www.nuget.org/packages/Microsoft.Web.WebView2/
- Extract to the same location
