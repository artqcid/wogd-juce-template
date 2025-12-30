/**
 * WebView2 Service für Plugin-Kommunikation
 * Nutzt die native WebView2 Message-Passing API
 * 
 * Keine WebSockets nötig - direkte Kommunikation zwischen C++ und JavaScript!
 */

export interface PluginParameter {
  id: string
  name: string
  value: number
  min: number
  max: number
}

export interface PluginMessage {
  type: 'parameter' | 'state' | 'ready'
  data: any
}

class PluginService {
  private isWebView2: boolean = false
  private messageHandlers: Map<string, Set<(data: any) => void>> = new Map()

  constructor() {
    this.checkWebView2Environment()
    this.setupMessageListener()
  }

  /**
   * Prüft ob wir in einem WebView2 Container laufen
   */
  private checkWebView2Environment() {
    // @ts-ignore - window.chrome.webview ist nur in WebView2 verfügbar
    this.isWebView2 = typeof window.chrome !== 'undefined' && 
                      typeof window.chrome.webview !== 'undefined'
    
    if (this.isWebView2) {
      console.log('✅ WebView2 Umgebung erkannt')
    } else {
      console.log('⚠️ Läuft im Browser (Dev-Modus) - Mock-Daten werden verwendet')
    }
  }

  /**
   * Listener für Nachrichten vom Plugin (C++)
   */
  private setupMessageListener() {
    if (this.isWebView2) {
      // @ts-ignore
      window.chrome.webview.addEventListener('message', (event: MessageEvent) => {
        try {
          const message: PluginMessage = event.data
          console.log('📨 Nachricht vom Plugin:', message)
          this.notifyHandlers(message.type, message.data)
        } catch (error) {
          console.error('Fehler beim Verarbeiten der Plugin-Nachricht:', error)
        }
      })
    }
  }

  /**
   * Sendet Nachricht an das Plugin (C++)
   */
  send(type: string, data: any) {
    const message: PluginMessage = { type: type as any, data }
    
    if (this.isWebView2) {
      // @ts-ignore
      window.chrome.webview.postMessage(message)
      console.log('📤 Gesendet an Plugin:', message)
    } else {
      // Dev-Modus: Mock-Response
      console.log('🔧 Dev-Modus - Mock Response:', message)
      this.mockPluginResponse(type, data)
    }
  }

  /**
   * Parameter im Plugin setzen
   */
  setParameter(id: string, value: number) {
    this.send('setParameter', { id, value })
  }

  /**
   * Parameter vom Plugin abfragen
   */
  getParameter(id: string) {
    this.send('getParameter', { id })
  }

  /**
   * Alle Parameter abfragen
   */
  getAllParameters() {
    this.send('getAllParameters', {})
  }

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
