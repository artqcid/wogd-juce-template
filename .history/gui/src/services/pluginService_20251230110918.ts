/**
 * WebView2 Service for Plugin Communication
 * Uses native WebView2 Message-Passing API
 * 
 * No WebSockets needed - direct communication between C++ and JavaScript!
 */

class PluginService {
  private messageHandler: ((message: any) => void) | null = null

  /**
   * Checks if running in WebView2 environment
   */
  isInWebView2(): boolean {
    return !!(window as any).chrome?.webview
  }

  /**
   * Sends a message to the plugin
   */
  sendMessage(message: any): void {
    if (this.isInWebView2()) {
      ;(window as any).chrome.webview.postMessage(JSON.stringify(message))
    } else {
      console.log('[Dev Mode] Would send to plugin:', message)
    }
  }

  /**
   * Registers a message handler for incoming plugin messages
   */
  onMessage(handler: (message: any) => void): void {
    this.messageHandler = handler

    if (this.isInWebView2()) {
      ;(window as any).chrome.webview.addEventListener('message', (event: MessageEvent) => {
        try {
          const message = JSON.parse(event.data)
          this.messageHandler?.(message)
        } catch (e) {
          console.error('Failed to parse message from plugin:', e)
        }
      })
    }
  }

  /**
   * Sends parameter change to plugin
   */
  setParameter(paramId: string, value: number): void {
    this.sendMessage({
      type: 'setParameter',
      data: { id: paramId, value }
    })
  }

  /**
   * Requests all parameters from plugin
   */
  requestParameters(): void {
    this.sendMessage({
      type: 'getParameters'
    })
  }
}

export const pluginService = new PluginService()
