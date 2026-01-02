# This creates a Benchmarks target for performance testing

# Glob for benchmark files
file(GLOB_RECURSE BenchmarkFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/benchmarks/*.h")

# Only create benchmark target if benchmark files exist
if(BenchmarkFiles)
    # Catch2 should already be downloaded from Tests.cmake
    if(NOT TARGET Catch2::Catch2)
        CPMAddPackage("gh:catchorg/Catch2@3.7.1")
    endif()

    # Create the benchmark executable
    juce_add_console_app(Benchmarks PRODUCT_NAME "Benchmarks")

    # Link against SharedCode and Catch2
    target_link_libraries(Benchmarks PRIVATE SharedCode Catch2::Catch2WithMain)

    # Add benchmark files to the target
    target_sources(Benchmarks PRIVATE ${BenchmarkFiles})

    # Make binary resources available to benchmarks
    target_compile_definitions(Benchmarks PRIVATE
        DONT_SET_USING_JUCE_NAMESPACE=1
        JUCE_STANDALONE_APPLICATION=1
        JucePlugin_Name="${PRODUCT_NAME}"
        JucePlugin_IsSynth=0
        JucePlugin_WantsMidiInput=0
        JucePlugin_ProducesMidiOutput=0
        JucePlugin_IsMidiEffect=0
        JucePlugin_EditorRequiresKeyboardFocus=0
    )
endif()
