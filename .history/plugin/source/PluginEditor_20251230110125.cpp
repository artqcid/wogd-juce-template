#include "PluginEditor.h"

PluginEditor::PluginEditor (PluginProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p)
{
    juce::ignoreUnused (processorRef);

    // Initialize WebView for GUI
    #if JUCE_WINDOWS
    webView = std::make_unique<WebViewComponent>();
    addAndMakeVisible (webView.get());
    
    // Load Vue.js GUI - Dev server in Debug, built files in Release
    #if defined(DEBUG) || defined(_DEBUG)
        webView->loadURL("http://localhost:5173");
    #else
        // In Release: Load from embedded resources or file system
        // TODO: Implement GUI file embedding and loading
        auto guiPath = juce::File::getSpecialLocation(juce::File::currentApplicationFile)
            .getParentDirectory().getChildFile("gui/dist/index.html");
        webView->loadURL("file:///" + guiPath.getFullPathName());
    #endif
    
    // Handle messages from JavaScript
    webView->onMessageReceived = [this](const juce::String& message) {
        DBG("Message from GUI: " + message);
        // TODO: Parse JSON and update parameters
        auto json = juce::JSON::parse(message);
        if (json.isObject()) {
            // Handle parameter changes from GUI
        }
    };
    #endif

    addAndMakeVisible (inspectButton);

    // this chunk of code instantiates and opens the melatonin inspector
    inspectButton.onClick = [&] {
        if (!inspector)
        {
            inspector = std::make_unique<melatonin::Inspector> (*this);
            inspector->onClose = [this]() { inspector.reset(); };
        }

        inspector->setVisible (true);
    };

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
    
    // Inspector button in bottom right corner
    auto buttonArea = area.removeFromBottom(40).removeFromRight(150).reduced(5);
    inspectButton.setBounds(buttonArea);
    
    // WebView takes remaining space
    #if JUCE_WINDOWS
    if (webView)
        webView->setBounds(area);
    #endif
}

void PluginEditor::updateGUIParameter(const juce::String& paramId, float value)
{
    #if JUCE_WINDOWS
    if (webView)
    {
        juce::DynamicObject::Ptr json = new juce::DynamicObject();
        json->setProperty("type", "parameter");
        json->setProperty("id", paramId);
        json->setProperty("value", value);
        
        webView->sendMessage(juce::JSON::toString(json.get()));
    }
    #endif
}
