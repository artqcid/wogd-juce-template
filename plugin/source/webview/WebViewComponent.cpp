#include "WebViewComponent.h"

#if JUCE_WINDOWS
    #include <wrl.h>
    #include <wil/com.h>
    #include "WebView2.h"
    using namespace Microsoft::WRL;
#endif

//==============================================================================
class WebViewComponent::Impl
{
public:
    Impl(WebViewComponent* owner) : owner(owner) {}
    
    ~Impl()
    {
        cleanup();
    }

    void loadURL(const juce::String& url)
    {
        #if JUCE_WINDOWS
        if (webViewController)
        {
            webViewController->Navigate(url.toWideCharPointer());
        }
        else
        {
            pendingURL = url;
        }
        #else
        DBG("WebView2 ist nur auf Windows verfügbar");
        #endif
    }

    void loadHTML(const juce::String& html)
    {
        #if JUCE_WINDOWS
        if (webViewController)
        {
            webViewController->NavigateToString(html.toWideCharPointer());
        }
        #endif
    }

    void sendMessage(const juce::String& message)
    {
        #if JUCE_WINDOWS
        if (webViewController)
        {
            webViewController->PostWebMessageAsJson(message.toWideCharPointer());
            DBG("📤 Nachricht an JavaScript: " + message);
        }
        #endif
    }

    void initialize(HWND parentWindow)
    {
        #if JUCE_WINDOWS
        // WebView2 Environment erstellen
        CreateCoreWebView2EnvironmentWithOptions(nullptr, nullptr, nullptr,
            Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
                [this, parentWindow](HRESULT result, ICoreWebView2Environment* env) -> HRESULT
                {
                    if (FAILED(result))
                    {
                        DBG("Fehler beim Erstellen der WebView2 Environment");
                        return result;
                    }

                    // WebView2 Controller erstellen
                    env->CreateCoreWebView2Controller(parentWindow,
                        Callback<ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                            [this](HRESULT result, ICoreWebView2Controller* controller) -> HRESULT
                            {
                                if (FAILED(result))
                                {
                                    DBG("Fehler beim Erstellen des WebView2 Controllers");
                                    return result;
                                }

                                webViewController = controller;
                                controller->get_CoreWebView2(&webView);

                                // Message Handler registrieren
                                webView->add_WebMessageReceived(
                                    Callback<ICoreWebView2WebMessageReceivedEventHandler>(
                                        [this](ICoreWebView2*, ICoreWebView2WebMessageReceivedEventArgs* args) -> HRESULT
                                        {
                                            LPWSTR messageRaw;
                                            args->get_WebMessageAsJson(&messageRaw);
                                            juce::String message(messageRaw);
                                            CoTaskMemFree(messageRaw);

                                            DBG("📨 Nachricht von JavaScript: " + message);
                                            
                                            if (owner->onMessageReceived)
                                            {
                                                juce::MessageManager::callAsync([this, message]()
                                                {
                                                    if (owner->onMessageReceived)
                                                        owner->onMessageReceived(message);
                                                });
                                            }
                                            
                                            return S_OK;
                                        }
                                    ).Get(),
                                    nullptr);

                                // Dev Tools erlauben (für Entwicklung)
                                ICoreWebView2Settings* settings;
                                webView->get_Settings(&settings);
                                settings->put_AreDevToolsEnabled(TRUE);
                                settings->put_AreDefaultContextMenusEnabled(TRUE);

                                // Pending URL laden
                                if (pendingURL.isNotEmpty())
                                {
                                    loadURL(pendingURL);
                                    pendingURL = juce::String();
                                }

                                return S_OK;
                            }
                        ).Get());

                    return S_OK;
                }
            ).Get());
        #endif
    }

    void cleanup()
    {
        #if JUCE_WINDOWS
        if (webViewController)
        {
            webViewController->Close();
            webViewController = nullptr;
        }
        webView = nullptr;
        #endif
    }

    void updateBounds(juce::Rectangle<int> bounds)
    {
        #if JUCE_WINDOWS
        if (webViewController)
        {
            RECT rect;
            rect.left = bounds.getX();
            rect.top = bounds.getY();
            rect.right = bounds.getRight();
            rect.bottom = bounds.getBottom();
            webViewController->put_Bounds(rect);
        }
        #endif
    }

private:
    WebViewComponent* owner;
    juce::String pendingURL;

    #if JUCE_WINDOWS
    ICoreWebView2Controller* webViewController = nullptr;
    ICoreWebView2* webView = nullptr;
    #endif
};

//==============================================================================
WebViewComponent::WebViewComponent()
    : pimpl(std::make_unique<Impl>(this))
{
    #if JUCE_WINDOWS
    // WebView2 initialisieren wenn Component sichtbar wird
    #endif
}

WebViewComponent::~WebViewComponent() = default;

void WebViewComponent::loadURL(const juce::String& url)
{
    pimpl->loadURL(url);
}

void WebViewComponent::loadHTML(const juce::String& html)
{
    pimpl->loadHTML(html);
}

void WebViewComponent::sendMessage(const juce::String& jsonMessage)
{
    pimpl->sendMessage(jsonMessage);
}

void WebViewComponent::paint(juce::Graphics& g)
{
    g.fillAll(juce::Colours::black);
}

void WebViewComponent::resized()
{
    #if JUCE_WINDOWS
    auto hwnd = (HWND)getWindowHandle();
    if (hwnd)
    {
        pimpl->initialize(hwnd);
        pimpl->updateBounds(getLocalBounds());
    }
    #endif
}
