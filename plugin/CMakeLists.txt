cmake_minimum_required(VERSION 3.25)

# Enable clangd support (compile_commands.json)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")
# Load project configuration from central JSON file
# Edit ../project-config.json to change project settings
include(ProjectConfig)

# Modern concise way to add dependencies to your project
include(CPM)


## Setze C++17 als globalen Standard (für alles, inkl. JUCE und eigene Targets)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Change me! Set the plugin formats you want built
# Valid choices: AAX Unity VST VST3 AU AUv3 Standalone
set(FORMATS Standalone AU VST3 AUv3)


## sccache deaktiviert (entfernt)

# instruct MSVC to embed debug info (/Z7) instead of emitting a .pdb
set(CMAKE_POLICY_DEFAULT_CMP0141        NEW      CACHE STRING "" FORCE)
set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded CACHE STRING "" FORCE)

# For simplicity, the name of the CMake project is also the name of the target
if(NOT DEFINED MY_PROJECT_VERSION OR "${MY_PROJECT_VERSION}" STREQUAL "")
    set(MY_PROJECT_VERSION "0.0.1")
endif()
project(${PROJECT_NAME} VERSION ${MY_PROJECT_VERSION})

# JUCE is setup as a submodule in the /JUCE folder
# Locally, you must run `git submodule update --init --recursive` once
# and later `git submodule update --remote --merge` to keep it up to date
# On Github Actions, this is done as a part of actions/checkout

# Setze C++17 explizit für alle nicht-ALIAS-TARGETS (Workaround für JUCE)
get_property(all_targets GLOBAL PROPERTY TARGETS)
foreach(target ${all_targets})
    get_target_property(alias ${target} ALIAS_GLOBAL)
    if(NOT alias)
        set_target_properties(${target} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
    endif()
endforeach()
# EDIT::::::::::::: we dont wont checkout in project Folder, instead use central repo






# JUCE Setup - Hybrid Approach (3 options for maximum flexibility)
# Option 1: Use JUCE from environment variable (for central installation)
if(DEFINED ENV{JUCE_DIR})
    set(JUCE_DIR "$ENV{JUCE_DIR}" CACHE PATH "Path to JUCE directory" FORCE)
    
    # Check if this is a source directory (has CMakeLists.txt) or installed version (has Config files)
    if(EXISTS "${JUCE_DIR}/CMakeLists.txt")
        # JUCE source directory - use add_subdirectory
        add_subdirectory("${JUCE_DIR}" juce EXCLUDE_FROM_ALL)
        message(STATUS "Using JUCE source from environment variable: ${JUCE_DIR}")
    elseif(EXISTS "${JUCE_DIR}/lib/cmake/JUCE/JUCEConfig.cmake" OR EXISTS "${JUCE_DIR}/JUCEConfig.cmake")
        # JUCE installed version - use find_package
        set(CMAKE_PREFIX_PATH "${JUCE_DIR}" ${CMAKE_PREFIX_PATH})
        find_package(JUCE CONFIG REQUIRED)
        message(STATUS "Using installed JUCE from environment variable: ${JUCE_DIR}")
    else()
        message(FATAL_ERROR "JUCE_DIR is set to ${JUCE_DIR} but it doesn't contain JUCE source or installation")
    endif()

# Option 2: Use JUCE from git submodule (for versioned builds)
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../juce/CMakeLists.txt")
    add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../../juce" juce EXCLUDE_FROM_ALL)
    message(STATUS "Using JUCE from git submodule")

# Option 3: Use JUCE from prebuilt installation (legacy fallback)
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../juce-install")
    set(JUCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../juce-install" CACHE PATH "Path to JUCE install directory")
    set(CMAKE_PREFIX_PATH "${JUCE_DIR}" ${CMAKE_PREFIX_PATH})
    find_package(JUCE CONFIG REQUIRED)
    message(STATUS "Using JUCE from prebuilt installation: ${JUCE_DIR}")

# Option 4: Download JUCE automatically via CPM (requires internet)
else()
    message(STATUS "JUCE not found locally, downloading via CPM...")
    CPMAddPackage(
        NAME JUCE
        GITHUB_REPOSITORY juce-framework/JUCE
        GIT_TAG 8.0.4
    )
    message(STATUS "JUCE downloaded and configured via CPM")
endif()

# Use CLAP from environment variable or fallback to CPM download (NACH JUCE)
if(NOT DEFINED CLAP_JUCE_EXTENSIONS_DIR OR CLAP_JUCE_EXTENSIONS_DIR STREQUAL "")
    # First check environment variable
    if(DEFINED ENV{CLAP_JUCE_EXTENSIONS_DIR})
        set(CLAP_JUCE_EXTENSIONS_DIR "$ENV{CLAP_JUCE_EXTENSIONS_DIR}" CACHE PATH "Path to clap-juce-extensions repository" FORCE)
    else()
        # Fallback to CPM download
        CPMAddPackage(
            NAME clap-juce-extensions
            GITHUB_REPOSITORY free-audio/clap-juce-extensions
            GIT_TAG main
        )
        set(CLAP_JUCE_EXTENSIONS_DIR "${clap-juce-extensions_SOURCE_DIR}" CACHE PATH "Path to clap-juce-extensions repository")
    endif()
endif()

message(STATUS "Using clap-juce-extensions from: ${CLAP_JUCE_EXTENSIONS_DIR}")
add_subdirectory(${CLAP_JUCE_EXTENSIONS_DIR} clap-juce-extensions EXCLUDE_FROM_ALL)


# WebView2 SDK for Windows - use central repository or download via CPM
if(WIN32)
    if(NOT DEFINED WEBVIEW2_SDK_DIR OR WEBVIEW2_SDK_DIR STREQUAL "")
        # First check environment variable
        if(DEFINED ENV{WEBVIEW2_SDK_DIR})
            set(WEBVIEW2_SDK_DIR "$ENV{WEBVIEW2_SDK_DIR}" CACHE PATH "Path to WebView2 SDK" FORCE)
        else()
            # Fallback to CPM download
            CPMAddPackage(
                NAME webview2
                VERSION 1.0.2792.45
                URL "https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2/1.0.2792.45"
                DOWNLOAD_ONLY YES
            )
            if(webview2_ADDED)
                set(WEBVIEW2_SDK_DIR "${webview2_SOURCE_DIR}" CACHE PATH "Path to WebView2 SDK")
            endif()
        endif()
    endif()
    if(WEBVIEW2_SDK_DIR)
        # Bypass JUCE's FindWebView2 and set variables directly
        set(WebView2_FOUND TRUE CACHE BOOL "WebView2 found" FORCE)
        set(WebView2_include_dir "${WEBVIEW2_SDK_DIR}/build/native/include" CACHE PATH "WebView2 include directory" FORCE)
        set(WebView2_library "${WEBVIEW2_SDK_DIR}/build/native/x64/WebView2LoaderStatic.lib" CACHE FILEPATH "WebView2 library" FORCE)
        set(WebView2_VERSION "1.0.2792.45" CACHE STRING "WebView2 version" FORCE)
        message(STATUS "Using custom WebView2 SDK from: ${WEBVIEW2_SDK_DIR}")
        message(STATUS "WebView2 include dir: ${WebView2_include_dir}")
        message(STATUS "WebView2 library: ${WebView2_library}")
        # Verify the SDK structure exists
        if(NOT EXISTS "${WebView2_include_dir}/WebView2.h")
            message(FATAL_ERROR "WebView2 SDK not found at ${WEBVIEW2_SDK_DIR}. Expected structure: build/native/include/WebView2.h")
        endif()
        if(NOT EXISTS "${WebView2_library}")
            message(FATAL_ERROR "WebView2 library not found at ${WebView2_library}")
        endif()
        message(STATUS "✓ WebView2 SDK verified successfully")
    else()
        message(FATAL_ERROR "WebView2 SDK not found. Set WEBVIEW2_SDK_DIR environment variable.")
    endif()
endif()

# Add any other modules you want modules here, before the juce_add_plugin call
# juce_add_module(modules/my_module)

# See `docs/CMake API.md` in the JUCE repo for all config options
juce_add_plugin("${PROJECT_NAME}"
    # Icons for the standalone app
    ICON_BIG "${CMAKE_CURRENT_SOURCE_DIR}/packaging/icon.png"

    # Change me!
    COMPANY_NAME "${COMPANY_NAME}"
    BUNDLE_ID "${BUNDLE_ID}"

    # On MacOS, plugin is copied to /Users/yourname/Library/Audio/Plug-Ins/
    COPY_PLUGIN_AFTER_BUILD FALSE

    # Plugin manufacturer code (loaded from project-config.json)
    # A four-character plugin id
    # First character MUST be uppercase for AU formats
    PLUGIN_MANUFACTURER_CODE ${MANUFACTURER_CODE}

    # Plugin code (loaded from project-config.json)
    # A unique four-character plugin id
    # Note: this must have at least one upper-case character
    PLUGIN_CODE ${PLUGIN_CODE}
    FORMATS "${FORMATS}"

    # The name of your final executable
    # This is how it's listed in the DAW
    # This can be different from PROJECT_NAME and can have spaces!
    # You might want to use v${MAJOR_VERSION} here once you go to v2...
    PRODUCT_NAME "${PRODUCT_NAME}"
    
    # WebView support
    NEEDS_WEB_BROWSER TRUE

    NEEDS_WEBVIEW2 FALSE)

# Erzwinge C++20 explizit für das Haupt-Plugin-Target

# Erzwinge C++20 explizit für Haupt-Plugin, Tests und Benchmarks
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 20 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
if(TARGET Tests)
    set_target_properties(Tests PROPERTIES CXX_STANDARD 20 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
endif()
if(TARGET Benchmarks)
    set_target_properties(Benchmarks PROPERTIES CXX_STANDARD 20 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
endif()

# Setze C++20 explizit für alle relevanten JUCE-Module (Workaround für ALIAS/INTERFACE)
foreach(_juce_mod IN ITEMS juce_audio_utils juce_audio_processors juce_dsp juce_gui_basics juce_gui_extra)
    if(TARGET ${_juce_mod})
        get_target_property(_is_alias ${_juce_mod} ALIAS_GLOBAL)
        if(NOT _is_alias)
            set_target_properties(${_juce_mod} PROPERTIES CXX_STANDARD 20 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
        endif()
    endif()
    if(TARGET juce::${_juce_mod})
        get_target_property(_is_alias juce::${_juce_mod} ALIAS_GLOBAL)
        if(NOT _is_alias)
            set_target_properties(juce::${_juce_mod} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED YES CXX_EXTENSIONS NO)
        endif()
    endif()
endforeach()

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

# This lets us use our code in both the JUCE targets and our Test target
# Without running into ODR violations

# INTERFACE-Target für gemeinsamen Code, C++17 explizit setzen
add_library(SharedCode INTERFACE)
target_compile_features(SharedCode INTERFACE cxx_std_17)

clap_juce_extensions_plugin(TARGET "${PROJECT_NAME}"
    CLAP_ID "${BUNDLE_ID}"
    CLAP_FEATURES audio-effect)

# Enable fast math, C++20 and a few other target defaults
include(SharedCodeDefaults)


# Manually list all .h and .cpp files for the plugin
# If you are like me, you'll use globs for your sanity.
# Just ensure you employ CONFIGURE_DEPENDS so the build system picks up changes
# If you want to appease the CMake gods and avoid globs, manually add files like so:
# set(SourceFiles Source/PluginEditor.h Source/PluginProcessor.h Source/PluginEditor.cpp Source/PluginProcessor.cpp)
file(GLOB_RECURSE SourceFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/source/*.h")

target_sources(SharedCode INTERFACE ${SourceFiles})

# Adds a BinaryData target for embedding assets into the binary
include(Assets)

# Embed GUI files for Release builds
# include(EmbedGUI)

# MacOS only: Cleans up folder and target organization on Xcode.
# include(XcodePrettify)

# This is where you can set preprocessor definitions for JUCE and your plugin
target_compile_definitions(SharedCode
    INTERFACE

    # WebView2 support enabled for embedded GUI
    JUCE_WEB_BROWSER=1
    JUCE_USE_CURL=0
    JUCE_USE_WIN_WEBVIEW2_WITH_STATIC_LINKING=1
    JUCE_VST3_CAN_REPLACE_VST2=0

    # Uncomment if you are paying for a an Indie/Pro license or releasing under GPLv3
    # JUCE_DISPLAY_SPLASH_SCREEN=0

    # lets the app known if we're Debug or Release
    CMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}"
    VERSION="${PROJECT_VERSION}"

    # JucePlugin_Name is for some reason doesn't use the nicer PRODUCT_NAME
    PRODUCT_NAME_WITHOUT_VERSION="${PRODUCT_NAME}"
)

# Link to any other modules you added (with juce_add_module) here!
# Usually JUCE modules must have PRIVATE visibility
# See https://github.com/juce-framework/JUCE/blob/master/docs/CMake%20API.md#juce_add_module
# However, with Pamplejuce, you'll link modules to SharedCode with INTERFACE visibility
# This allows the JUCE plugin targets and the Tests target to link against it
target_link_libraries(SharedCode
    INTERFACE
    Assets
    juce_audio_utils
    juce_audio_processors
    juce_dsp
    juce_gui_basics
    juce_gui_extra
    juce::juce_recommended_config_flags
    juce::juce_recommended_lto_flags
    juce::juce_recommended_warning_flags)

# Link WebView2 on Windows
if(WIN32)
    target_include_directories(SharedCode INTERFACE "${WebView2_include_dir}")
    target_link_libraries(SharedCode INTERFACE "${WebView2_library}")
endif()

# Link the JUCE plugin targets our SharedCode target
target_link_libraries("${PROJECT_NAME}" PRIVATE SharedCode)

# IPP support, comment out to disable
# include(PamplejuceIPP)

# Everything related to the tests target
include(Tests)

# A separate target for Benchmarks (keeps the Tests target fast)
include(Benchmarks)

# Output some config for CI (like our PRODUCT_NAME)
include(GitHubENV)
