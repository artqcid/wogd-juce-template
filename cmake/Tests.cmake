# This creates a Test target for running unit tests

# Glob for test files
file(GLOB_RECURSE TestFiles CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp" "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.h")

# Only create test target if test files exist
if(TestFiles)
    # Download Catch2
    CPMAddPackage("gh:catchorg/Catch2@3.7.1")

    # Create the test executable
    juce_add_console_app(Tests PRODUCT_NAME "Tests")

    # Link against SharedCode and Catch2
    target_link_libraries(Tests PRIVATE SharedCode Catch2::Catch2WithMain)

    # Add test files to the target
    target_sources(Tests PRIVATE ${TestFiles})

    # Make binary resources available to tests
    target_compile_definitions(Tests PRIVATE
        DONT_SET_USING_JUCE_NAMESPACE=1
        JucePlugin_Name="${PRODUCT_NAME}"
        JucePlugin_IsMidiEffect=0
        JucePlugin_IsSynth=0
        JucePlugin_WantsMidiInput=0
        JucePlugin_ProducesMidiOutput=0
        JucePlugin_IsMidiEffect=0
        JucePlugin_EditorRequiresKeyboardFocus=0
    )

    # Register tests with CTest
    enable_testing()
    add_test(NAME Tests COMMAND Tests)
endif()
