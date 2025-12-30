#pragma once

#include <juce_gui_extra/juce_gui_extra.h>

/**
 * WebView2 Integration für JUCE Plugin
 * 
 * Integriert Microsoft Edge WebView2 in ein JUCE Plugin für moderne Web-basierte UIs.
 * Kommunikation zwischen C++ und JavaScript über postMessage/addEventListener.
 * 
 * Beispiel Nutzung:
 * 
 *   auto webview = std::make_unique<WebViewComponent>();
 *   webview->loadURL("http://localhost:5173"); // Dev-Server
 *   // oder
 *   webview->loadURL("file:///path/to/dist/index.html"); // Production Build
 *   
 *   // Nachricht an JavaScript senden
 *   webview->sendMessage(R"({"type":"parameter","data":{"id":"gain","value":0.75}})");
 *   
 *   // Nachrichten von JavaScript empfangen
 *   webview->onMessageReceived = [this](const juce::String& message) {
 *       auto json = juce::JSON::parse(message);
 *       // Verarbeite JavaScript-Nachricht
 *   };
 */
class WebViewComponent : public juce::Component
{
public:
    WebViewComponent();
    ~WebViewComponent() override;

    /** Lädt eine URL im WebView */
    void loadURL(const juce::String& url);
    
    /** Lädt HTML direkt */
    void loadHTML(const juce::String& html);
    
    /** Sendet JSON-Nachricht an JavaScript (via window.chrome.webview.addEventListener) */
    void sendMessage(const juce::String& jsonMessage);
    
    /** Callback für Nachrichten von JavaScript (via window.chrome.webview.postMessage) */
    std::function<void(const juce::String&)> onMessageReceived;

    void paint(juce::Graphics& g) override;
    void resized() override;

private:
    class Impl;
    std::unique_ptr<Impl> pimpl;
    
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(WebViewComponent)
};
