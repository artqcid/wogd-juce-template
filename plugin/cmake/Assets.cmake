# This creates a BinaryData target for embedding assets

# Collect all files from assets folder
file(GLOB_RECURSE AssetFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/assets/*")

# Create the binary data target if we have assets
if(AssetFiles)
    juce_add_binary_data(Assets SOURCES ${AssetFiles})
else()
    # Create an empty target if no assets exist
    add_library(Assets INTERFACE)
endif()
