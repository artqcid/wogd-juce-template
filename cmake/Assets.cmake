# This creates a target that embeds binary data from the assets folder
# into the binary as a JUCE BinaryData target

# Find all files in the assets directory
file(GLOB_RECURSE AssetFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/assets/*")

# Only create the target if there are assets
if(AssetFiles)
    juce_add_binary_data(Assets SOURCES ${AssetFiles})
    # Makes the binary data target available to SharedCode
    target_link_libraries(SharedCode INTERFACE Assets)
else()
    # Create empty interface library if no assets exist
    add_library(Assets INTERFACE)
endif()
