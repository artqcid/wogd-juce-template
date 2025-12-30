#pragma once

#include "PluginProcessor.h"
#include "BinaryData.h"
#include <juce_gui_extra/juce_gui_extra.h>

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
    
    // Handle messages from GUI
    void handleMessageFromGUI(const juce::String& message);

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    PluginProcessor& processorRef;
    
    // WebView for Vue.js GUI
    juce::WebBrowserComponent webView;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (PluginEditor)
};
