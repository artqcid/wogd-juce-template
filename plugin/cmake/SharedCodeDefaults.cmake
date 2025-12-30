# This file sets some defaults for the SharedCode INTERFACE library

# C++23
target_compile_features(SharedCode INTERFACE cxx_std_23)

# Disable JUCE assertions for Release builds
target_compile_definitions(SharedCode INTERFACE
    $<$<CONFIG:Release>:JUCE_DISABLE_ASSERTIONS=1>
)

# Enable fast math for Release builds
if(MSVC)
    target_compile_options(SharedCode INTERFACE
        $<$<CONFIG:Release>:/fp:fast>
    )
else()
    target_compile_options(SharedCode INTERFACE
        $<$<CONFIG:Release>:-ffast-math>
    )
endif()
