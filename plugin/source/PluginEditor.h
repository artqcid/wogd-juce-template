#pragma once

#include "PluginProcessor.h"
#include "BinaryData.h"
// #include "melatonin_inspector/melatonin_inspector.h"
// #include "webview/WebViewComponent.h"

//==============================================================================
class PluginEditor : public juce::AudioProcessorEditor
{
public:
    explicit PluginEditor (PluginProcessor&);
    ~PluginEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;
    
    // Send parameter updates to GUI
    void updateGUIParameter(const juce::String& paramId, float value);

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    PluginProcessor& processorRef;
    
    // WebView for Vue.js GUI using JUCE's built-in WebBrowserComponent
    std::unique_ptr<juce::WebBrowserComponent> webView;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (PluginEditor)
};
