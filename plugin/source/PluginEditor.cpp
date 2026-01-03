#include "PluginEditor.h"
#include "../build/juce_binarydata_Assets/JuceLibraryCode/BinaryData.h"
#include <juce_audio_processors/juce_audio_processors.h>
#include <juce_core/juce_core.h>
#include <juce_gui_extra/juce_gui_extra.h>

PluginEditor::PluginEditor (PluginProcessor& p)
    : AudioProcessorEditor (&p), processorRef (p), webView { juce::WebBrowserComponent::Options {}.withBackend (juce::WebBrowserComponent::Options::Backend::webview2).withWinWebView2Options (juce::WebBrowserComponent::Options::WinWebView2 {}.withUserDataFolder (juce::File::getSpecialLocation (juce::File::SpecialLocationType::tempDirectory))).withNativeIntegrationEnabled() }
{
    juce::ignoreUnused (processorRef);

    // Initialize WebView for embedded GUI
    addAndMakeVisible (webView);

// Load Vue.js GUI - Dev server in Debug, embedded files in Release
#if defined(DEBUG) || defined(_DEBUG)
    webView.goToURL ("http://localhost:4200/");
    DBG ("🔧 Debug Mode: Loading GUI from dev server (localhost:5173)");
#else
    webView.goToURL ("/");
    webView.setResourceProvider ([] (const juce::String& path) {
        return resourceFromBinaryData (path);
    });
    DBG ("📦 Release Mode: Loading GUI from BinaryData resources");
#endif

    setSize (800, 600);
    setResizable (true, true);
    setResizeLimits (400, 300, 1920, 1080);
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
    webView.setBounds (getLocalBounds());
}

// Simple helper to get MIME type from file extension
static juce::String getMimeTypeForFile (const juce::String& fileName)
{
    if (fileName.endsWithIgnoreCase (".html") || fileName.endsWithIgnoreCase (".htm"))
        return juce::String ("text/html");
    if (fileName.endsWithIgnoreCase (".js"))
        return juce::String ("application/javascript");
    if (fileName.endsWithIgnoreCase (".css"))
        return juce::String ("text/css");
    if (fileName.endsWithIgnoreCase (".json"))
        return juce::String ("application/json");
    if (fileName.endsWithIgnoreCase (".png"))
        return juce::String ("image/png");
    if (fileName.endsWithIgnoreCase (".jpg") || fileName.endsWithIgnoreCase (".jpeg"))
        return juce::String ("image/jpeg");
    if (fileName.endsWithIgnoreCase (".svg"))
        return juce::String ("image/svg+xml");
    if (fileName.endsWithIgnoreCase (".ico"))
        return juce::String ("image/x-icon");
    if (fileName.endsWithIgnoreCase (".woff"))
        return juce::String ("font/woff");
    if (fileName.endsWithIgnoreCase (".woff2"))
        return juce::String ("font/woff2");
    if (fileName.endsWithIgnoreCase (".ttf"))
        return juce::String ("font/ttf");
    if (fileName.endsWithIgnoreCase (".otf"))
        return juce::String ("font/otf");
    if (fileName.endsWithIgnoreCase (".mp3"))
        return juce::String ("audio/mpeg");
    if (fileName.endsWithIgnoreCase (".wav"))
        return juce::String ("audio/wav");
    // Add more as needed
    return juce::String ("application/octet-stream");
}

static juce::WebBrowserComponent::Resource resourceFromBinaryData (const juce::String& path)
{
    // Map URL to BinaryData resource name
    juce::String resourceName = path;
    if (resourceName.isEmpty() || resourceName == "/")
        resourceName = "pamplejuce.png"; // fallback to the only resource available
    else if (resourceName.startsWithChar ('/'))
        resourceName = resourceName.substring (1);

    // Replace / with _ for BinaryData symbol if needed (not needed for current resource)

    int dataSize = 0;
    const char* data = BinaryData::getNamedResource (resourceName.toRawUTF8(), dataSize);
    if (data && dataSize > 0)
    {
        std::vector<std::byte> bytes (reinterpret_cast<const std::byte*> (data), reinterpret_cast<const std::byte*> (data) + dataSize);
        return juce::WebBrowserComponent::Resource { std::move (bytes), getMimeTypeForFile (resourceName) };
    }
    return {};
}

