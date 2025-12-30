#include "PluginEditor.h"
#include "webview/WebViewComponent.h"

PluginEditor::PluginEditor (PluginProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p)
{
    juce::ignoreUnused (processorRef);

    // Initialize WebView2 Component for embedded GUI
    #if JUCE_WINDOWS
    webView = std::make_unique<WebViewComponent>();
    addAndMakeVisible (webView.get());
    
    // Load Vue.js GUI - Dev server in Debug, embedded files in Release
    #if defined(DEBUG) || defined(_DEBUG)
        webView->loadURL("http://localhost:5173");
        DBG("🔧 Debug Mode: Loading GUI from dev server (localhost:5173)");
    #else
        // In Release: Load from embedded BinaryData resources
        webView->loadEmbeddedGUI();
        DBG("📦 Release Mode: Loading GUI from embedded resources");
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
    #if JUCE_WINDOWS
    if (webView)
    {
        // Send parameter update to GUI via WebView2 message passing
        juce::var messageObj = new juce::DynamicObject();
        messageObj.getDynamicObject()->setProperty("type", "parameter");
        juce::var dataObj = new juce::DynamicObject();
        dataObj.getDynamicObject()->setProperty("id", paramId);
        dataObj.getDynamicObject()->setProperty("value", value);
        messageObj.getDynamicObject()->setProperty("data", dataObj);
        
        webView->sendMessage(juce::JSON::toString(messageObj));
    }
    #else
    juce::ignoreUnused(paramId, value);
    #endif
}
