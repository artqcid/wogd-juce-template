#include "PluginEditor.h"
#include <juce_core/juce_core.h>
#include <juce_gui_extra/juce_gui_extra.h>
#include "BinaryData.h"

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
        webView.goToURL("http://localhost:5173/");
        DBG("🔧 Debug Mode: Loading GUI from dev server (localhost:5173)");
    #else
        webView.goToURL("/");
        webView.setResourceProvider([](const juce::String& path) {
            return resourceFromBinaryData(path);
        });
        DBG("📦 Release Mode: Loading GUI from BinaryData resources");
    #endif

    setSize (800, 600);
    setResizable(true, true);
    setResizeLimits(400, 300, 1920, 1080);
}

PluginEditor::~PluginEditor()
{
}

void PluginEditor::paint (juce::Graphics& g)
{
    g.fillAll (juce::Colours::black);
}

void PluginEditor::resized()
{
    webView.setBounds(getLocalBounds());
}

static juce::WebBrowserComponent::Resource resourceFromBinaryData(const juce::String& path) {
    // Map URL to BinaryData resource name
    juce::String resourceName = path;
    if (resourceName.isEmpty() || resourceName == "/")
        resourceName = "index.html";
    else if (resourceName.startsWithChar('/'))
        resourceName = resourceName.substring(1);

    // Replace / with _ for BinaryData symbol
    resourceName = resourceName.replaceCharacter('/', '_');

    const char* data = nullptr;
    int dataSize = 0;
    #define TRY_RESOURCE(res) if (resourceName == #res) { data = (const char*)BinaryData::res; dataSize = BinaryData::res##Size; }
    // Add more resources as needed
    TRY_RESOURCE(index_html)
    // TODO: Add more assets (js, css, images) here
    #undef TRY_RESOURCE

    if (data && dataSize > 0)
        return juce::WebBrowserComponent::Resource(juce::MemoryBlock(data, dataSize), juce::URL::getMIMETypeForFile(resourceName));
    return {};
}
