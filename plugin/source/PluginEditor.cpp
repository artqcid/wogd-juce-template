#include "PluginEditor.h"

PluginEditor::PluginEditor (PluginProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p),
      webView{juce::WebBrowserComponent::Options{}
          .withBackend(juce::WebBrowserComponent::Options::Backend::webview2)
          .withWinWebView2Options(
              juce::WebBrowserComponent::Options::WinWebView2{}
                  .withUserDataFolder(juce::File::getSpecialLocation(
                      juce::File::SpecialLocationType::tempDirectory)))
          .withNativeIntegrationEnabled()}
{
    juce::ignoreUnused (processorRef);

    // Initialize WebView for embedded GUI
    addAndMakeVisible (webView);
    
    // Load Vue.js GUI - Dev server in Debug, embedded files in Release
    #if defined(DEBUG) || defined(_DEBUG)
        webView.goToURL("http://localhost:5173");
        DBG("🔧 Debug Mode: Loading GUI from dev server (localhost:5173)");
    #else
        // In Release: Load from embedded BinaryData resources
        // TODO: Implement ResourceProvider for embedded files
        DBG("📦 Release Mode: Embedded resources not yet implemented");
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
    webView.setBounds(area);
}

void PluginEditor::updateGUIParameter(const juce::String& paramId, float value)
{
    // Send parameter update to GUI via WebView message passing
    juce::var messageObj = new juce::DynamicObject();
    messageObj.getDynamicObject()->setProperty("type", "parameter");
    juce::var dataObj = new juce::DynamicObject();
    dataObj.getDynamicObject()->setProperty("id", paramId);
    dataObj.getDynamicObject()->setProperty("value", value);
    messageObj.getDynamicObject()->setProperty("data", dataObj);
    
    webView.evaluateJavascript(
        "window.postMessage(" + juce::JSON::toString(messageObj) + ", '*')",
        nullptr);
}
