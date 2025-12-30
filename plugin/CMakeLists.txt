cmake_minimum_required(VERSION 3.25)

# This tells cmake we have goodies in the /cmake folder
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# Load project configuration from central JSON file
# Edit ../project-config.json to change project settings
include(ProjectConfig)

# Modern concise way to add dependencies to your project
include(CPM)

# Change me! Set the plugin formats you want built
# Valid choices: AAX Unity VST VST3 AU AUv3 Standalone
set(FORMATS Standalone AU VST3 AUv3)

# Force JUCE to work with sccache
# instruct MSVC to embed debug info (/Z7) instead of emitting a .pdb
set(CMAKE_POLICY_DEFAULT_CMP0141        NEW      CACHE STRING "" FORCE)
set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded CACHE STRING "" FORCE)

# For simplicity, the name of the CMake project is also the name of the target
project(${PROJECT_NAME} VERSION ${PROJECT_VERSION})

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
    PRODUCT_NAME "${PRODUCT_NAME}")

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

# MacOS only: Cleans up folder and target organization on Xcode.
# include(XcodePrettify)

# This is where you can set preprocessor definitions for JUCE and your plugin
target_compile_definitions(SharedCode
    INTERFACE

    # WebView2 support enabled for embedded GUI
    JUCE_WEB_BROWSER=1
    JUCE_USE_CURL=0
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
