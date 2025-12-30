# This creates a BinaryData target for embedding assets

# Collect all files from assets folder (excluding gui folder for now)
file(GLOB_RECURSE AssetFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/assets/*")

# In Release builds, include GUI files from assets/gui if they exist
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    file(GLOB_RECURSE GuiFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/assets/gui/*")
    if(GuiFiles)
        message(STATUS "📦 Embedding ${CMAKE_CURRENT_SOURCE_DIR}/assets/gui files into plugin binary")
        list(APPEND AssetFiles ${GuiFiles})
    endif()
endif()

# Create the binary data target if we have assets
if(AssetFiles)
    juce_add_binary_data(Assets SOURCES ${AssetFiles})
else()
    # Create an empty target if no assets exist
    add_library(Assets INTERFACE)
endif()
