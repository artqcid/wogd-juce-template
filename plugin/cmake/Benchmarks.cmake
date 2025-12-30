# This sets up the Benchmarks target

# Collect all benchmark files
file(GLOB_RECURSE BenchmarkFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks/*.h")

# Only create Benchmarks target if benchmark files exist
if(BenchmarkFiles)
    # Use CPM to get Catch2 (if not already added)
    CPMAddPackage("gh:catchorg/Catch2@3.7.1")

    # Create the benchmark executable
    add_executable(Benchmarks ${BenchmarkFiles})
    
    # Link against our SharedCode and Catch2
    target_link_libraries(Benchmarks PRIVATE SharedCode Catch2::Catch2WithMain)
    
    # Add the benchmarks directory to include paths
    target_include_directories(Benchmarks PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks")
    
    # Set C++23
    target_compile_features(Benchmarks PRIVATE cxx_std_23)
endif()
