#include "PluginEditor.h"

PluginEditor::PluginEditor (PluginProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p)
{
    juce::ignoreUnused (processorRef);

    // Initialize WebView for GUI using JUCE's WebBrowserComponent
    #if JUCE_WINDOWS || JUCE_MAC || JUCE_LINUX
    webView = std::make_unique<juce::WebBrowserComponent>();
    addAndMakeVisible (webView.get());
    
    // Load Vue.js GUI - Dev server in Debug, built files in Release
    #if defined(DEBUG) || defined(_DEBUG)
        webView->goToURL("http://localhost:5173");
    #else
        // In Release: Load from embedded resources or file system
        // TODO: Implement GUI file embedding and loading
        auto guiPath = juce::File::getSpecialLocation(juce::File::currentApplicationFile)
            .getParentDirectory().getChildFile("gui/dist/index.html");
        webView->goToURL("file:///" + guiPath.getFullPathName());
    #endif
    #endif

    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize (800, 600);
}

PluginEditor::~PluginEditor()
{
}

void PluginEditor::paint (juce::Graphics& g)
{
    // WebView handles rendering, just fill background
    g.fillAll (juce::Colours::black);
}

void PluginEditor::resized()
{
    auto area = getLocalBounds();
    
    // WebView takes all space
    #if JUCE_WINDOWS || JUCE_MAC || JUCE_LINUX
    if (webView)
        webView->setBounds(area);
    #endif
}

void PluginEditor::updateGUIParameter(const juce::String& paramId, float value)
{
    // TODO: WebBrowserComponent doesn't have built-in message passing
    // Need to implement JavaScript communication via evaluateJavascript or similar
    juce::ignoreUnused(paramId, value);
}
