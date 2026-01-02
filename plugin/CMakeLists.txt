cmake_minimum_required(VERSION 3.25)

# Enable clangd support (compile_commands.json)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")
# Load project configuration from central JSON file
# Edit ../project-config.json to change project settings
include(ProjectConfig)

# Modern concise way to add dependencies to your project
include(CPM)

# Change me! Set the plugin formats you want built
# Valid choices: AAX Unity VST VST3 AU AUv3 Standalone
set(FORMATS Standalone AU VST3 AUv3)


# Enable sccache for clang-cl if available
find_program(SCCACHE_PROGRAM sccache)
if(SCCACHE_PROGRAM)
    message(STATUS "Using sccache: ${SCCACHE_PROGRAM}")
    set(CMAKE_C_COMPILER_LAUNCHER   "${SCCACHE_PROGRAM}" CACHE STRING "" FORCE)
    set(CMAKE_CXX_COMPILER_LAUNCHER "${SCCACHE_PROGRAM}" CACHE STRING "" FORCE)
endif()

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
# EDIT::::::::::::: we dont wont checkout in project Folder, instead use central repo
# Use JUCE from environment variable or fallback to local submodule
# Set JUCE_DIR environment variable to point to your central JUCE repository
if(NOT DEFINED JUCE_DIR OR JUCE_DIR STREQUAL "")
    # First check environment variable
    if(DEFINED ENV{JUCE_DIR})
        set(JUCE_DIR "$ENV{JUCE_DIR}" CACHE PATH "Path to JUCE repository" FORCE)
    else()
        # Fallback to local submodule (for CI/CD)
        set(JUCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/JUCE" CACHE PATH "Path to JUCE repository")
    endif()
endif()

if (NOT EXISTS "${JUCE_DIR}/CMakeLists.txt")
    message(FATAL_ERROR "JUCE not found at ${JUCE_DIR}. Set JUCE_DIR environment variable to your JUCE repository.")
endif()

message(STATUS "Using JUCE from: ${JUCE_DIR}")

add_subdirectory(${JUCE_DIR} juce)

# Use CLAP from environment variable or fallback to CPM download
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

if (NOT EXISTS "${CLAP_JUCE_EXTENSIONS_DIR}/CMakeLists.txt")
    message(FATAL_ERROR "clap-juce-extensions not found at ${CLAP_JUCE_EXTENSIONS_DIR}. Set CLAP_JUCE_EXTENSIONS_DIR environment variable to your clap-juce-extensions repository.")
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
        # This allows us to use a custom WebView2 SDK location
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

# This adds the melatonin inspector module
# add_subdirectory(modules/melatonin_inspector)

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
    NEEDS_WEBVIEW2 TRUE)

# This lets us use our code in both the JUCE targets and our Test target
# Without running into ODR violations
add_library(SharedCode INTERFACE)

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
if(WIN32 AND TARGET WebView2)
    target_link_libraries(SharedCode INTERFACE WebView2)
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
