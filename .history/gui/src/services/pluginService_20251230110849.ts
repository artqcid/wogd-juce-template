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

  /**
   * Event-Handler registrieren
   */
  on(event: string, callback: (data: any) => void) {
    if (!this.messageHandlers.has(event)) {
      this.messageHandlers.set(event, new Set())
    }
    this.messageHandlers.get(event)!.add(callback)
  }

  /**
   * Event-Handler entfernen
   */
  off(event: string, callback: (data: any) => void) {
    const handlers = this.messageHandlers.get(event)
    if (handlers) {
      handlers.delete(callback)
    }
  }

  /**
   * Benachrichtige alle registrierten Handler
   */
  private notifyHandlers(event: string, data: any) {
    const handlers = this.messageHandlers.get(event)
    if (handlers) {
      handlers.forEach(callback => callback(data))
    }
  }

  /**
   * Mock-Daten für Entwicklung im Browser
   */
  private mockPluginResponse(type: string, data: any) {
    setTimeout(() => {
      if (type === 'getParameter') {
        this.notifyHandlers('parameter', {
          id: data.id,
          value: Math.random(),
          min: 0,
          max: 1
        })
      } else if (type === 'getAllParameters') {
        this.notifyHandlers('state', {
          parameters: [
            { id: 'gain', name: 'Gain', value: 0.75, min: 0, max: 1 },
            { id: 'pan', name: 'Pan', value: 0.5, min: 0, max: 1 },
            { id: 'freq', name: 'Frequency', value: 440, min: 20, max: 20000 }
          ]
        })
      }
    }, 100)
  }

  /**
   * Gibt zurück ob wir in WebView2 laufen
   */
  isInWebView2(): boolean {
    return this.isWebView2
  }
}

// Singleton Instance
export const pluginService = new PluginService()
