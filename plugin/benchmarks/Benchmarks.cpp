
#include "../Source/PluginProcessor.h"
#include <catch2/benchmark/catch_benchmark.hpp>
#include <catch2/catch_test_macros.hpp>


TEST_CASE ("Boot performance")
{
    BENCHMARK ("Processor constructor")
    {
        return PluginProcessor();
    };

    BENCHMARK ("Editor open and close")
    {
        PluginProcessor plugin;
        auto editor = plugin.createEditorIfNeeded();
        plugin.editorBeingDeleted (editor);
        delete editor;
        return 0;
    };
}
