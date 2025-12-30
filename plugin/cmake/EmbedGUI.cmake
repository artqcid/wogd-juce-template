# This CMake script embeds the built GUI files into the plugin as BinaryData

# Function to copy GUI build output to assets folder
function(embed_gui_files)
    set(GUI_BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../gui/dist")
    set(GUI_ASSETS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/assets/gui")
    
    # Check if GUI build exists
    if(EXISTS "${GUI_BUILD_DIR}")
        message(STATUS "Found GUI build at: ${GUI_BUILD_DIR}")
        message(STATUS "Copying GUI files to: ${GUI_ASSETS_DIR}")
        
        # Create assets/gui directory if it doesn't exist
        file(MAKE_DIRECTORY "${GUI_ASSETS_DIR}")
        
        # Copy all GUI files to assets/gui
        file(GLOB_RECURSE GUI_FILES "${GUI_BUILD_DIR}/*")
        foreach(GUI_FILE ${GUI_FILES})
            # Get relative path
            file(RELATIVE_PATH REL_PATH "${GUI_BUILD_DIR}" "${GUI_FILE}")
            # Get destination path
            set(DEST_PATH "${GUI_ASSETS_DIR}/${REL_PATH}")
            # Create destination directory
            get_filename_component(DEST_DIR "${DEST_PATH}" DIRECTORY)
            file(MAKE_DIRECTORY "${DEST_DIR}")
            # Copy file
            configure_file("${GUI_FILE}" "${DEST_PATH}" COPYONLY)
        endforeach()
        
        message(STATUS "✓ GUI files embedded successfully")
    else()
        message(WARNING "GUI build not found at ${GUI_BUILD_DIR}")
        message(WARNING "Run 'npm run build' in gui/ folder to create production build")
        message(WARNING "For now, the plugin will load from localhost:5173 in Debug mode")
    endif()
endfunction()

# Call the function if building Release
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    embed_gui_files()
endif()
