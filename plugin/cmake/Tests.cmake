# This sets up the Tests target

# Collect all test files
file(GLOB_RECURSE TestFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.h")

# Only create Tests target if test files exist
if(TestFiles)
    # Use CPM to get Catch2
    CPMAddPackage("gh:catchorg/Catch2@3.7.1")

    # Create the test executable
    add_executable(Tests ${TestFiles})
    
    # Link against our SharedCode and Catch2
    target_link_libraries(Tests PRIVATE SharedCode Catch2::Catch2WithMain)
    
    # Add the tests directory to include paths
    target_include_directories(Tests PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/tests")
    
    # Copy plugin definitions so tests can use JucePlugin_Name etc.
    target_compile_definitions(Tests PRIVATE
        JucePlugin_Name="${PRODUCT_NAME}"
        JucePlugin_Manufacturer="${COMPANY_NAME}"
    )
    
    # Set C++23
    target_compile_features(Tests PRIVATE cxx_std_23)
endif()
