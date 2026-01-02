# Set compile options for SharedCode target

target_compile_features(SharedCode INTERFACE cxx_std_17)

# Disable JUCE's default /W4 and /external:W0 on MSVC
target_compile_options(SharedCode INTERFACE
    $<$<CXX_COMPILER_ID:MSVC>:/W3>
    $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-unsafe-buffer-usage -Wno-padded>
)

# Enable fast math
if (MSVC)
    target_compile_options(SharedCode INTERFACE /fp:fast)
else()
    target_compile_options(SharedCode INTERFACE -ffast-math)
endif()
