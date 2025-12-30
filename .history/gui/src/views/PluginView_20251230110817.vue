<template>
  <div class="plugin-view">
    <div class="header">
      <h1>{{ pluginName }}</h1>
      <div class="status">
        <span :class="['status-indicator', { connected: isConnected }]"></span>
        <span class="status-text">{{ statusText }}</span>
      </div>
    </div>

    <div class="content">
      <!-- Add your plugin UI components here -->
      <p class="hint">Ready to build your plugin UI</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { pluginService } from '@/services/pluginService'

const pluginName = ref('WOGD JUCE Template')
const isConnected = computed(() => pluginService.isInWebView2())

const statusText = computed(() => {
  return isConnected.value ? 'Connected to Plugin' : 'Browser Dev Mode'
})

// Listen for messages from plugin
onMounted(() => {
  pluginService.onMessage((message) => {
    console.log('Message from plugin:', message)
    // Handle plugin messages here
  })
})

onUnmounted(() => {
  // Cleanup if needed
})
</script>

<style scoped>
.plugin-view {
  min-height: 100vh;
  padding: 20px;
  background: linear-gradient(135deg, #1e1e1e 0%, #2d2d2d 100%);
  color: #fff;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.header h1 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
}

.status {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #666;
  transition: background 0.3s;
}

.status-indicator.connected {
  background: #4caf50;
  box-shadow: 0 0 8px rgba(76, 175, 80, 0.6);
}

.status-text {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

.content {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 400px;
}

.hint {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.4);
  text-align: center;
}
</style>
  if (data.parameters) {
    parameters.value = data.parameters
  }
}

onMounted(() => {
  // Event Listener registrieren
  pluginService.on('parameter', handleParameterUpdate)
  pluginService.on('state', handleStateUpdate)

  // Initiale Parameter laden
  pluginService.getAllParameters()
})

onUnmounted(() => {
  // Event Listener aufräumen
  pluginService.off('parameter', handleParameterUpdate)
  pluginService.off('state', handleStateUpdate)
})
</script>

<style scoped>
.plugin-view {
  min-height: 100vh;
  background: linear-gradient(135deg, #1e1e1e 0%, #2d2d2d 100%);
  padding: 32px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 32px;
  padding-bottom: 16px;
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
}

.header h1 {
  color: #fff;
  font-size: 28px;
  margin: 0;
}

.status {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-indicator {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #ff5252;
  animation: pulse 2s infinite;
}

.status-indicator.connected {
  background: #4caf50;
  animation: none;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.status-text {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
}

.parameters-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
  margin-bottom: 32px;
}

.dev-info {
  background: rgba(255, 193, 7, 0.1);
  border: 1px solid rgba(255, 193, 7, 0.3);
  border-radius: 8px;
  padding: 16px;
  color: #ffc107;
  text-align: center;
}

.dev-info p {
  margin: 4px 0;
  font-size: 14px;
}
</style>
