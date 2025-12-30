<template>
  <div class="plugin-view">
    <div class="header">
      <h1>🎸 Pamplejuce Plugin</h1>
      <div class="status">
        <span :class="['status-indicator', { connected: isConnected }]"></span>
        <span class="status-text">{{ statusText }}</span>
      </div>
    </div>

    <div class="parameters-grid">
      <ParameterSlider
        v-for="param in parameters"
        :key="param.id"
        :id="param.id"
        :name="param.name"
        :value="param.value"
        :min="param.min"
        :max="param.max"
      />
    </div>

    <div class="dev-info" v-if="!isConnected">
      <p>🔧 Dev-Modus aktiv - Mock-Daten werden angezeigt</p>
      <p>Im WebView2 werden echte Plugin-Parameter angezeigt</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { pluginService, type PluginParameter } from '@/services/pluginService'
import ParameterSlider from '@/components/plugin/ParameterSlider.vue'

const parameters = ref<PluginParameter[]>([])
const isConnected = computed(() => pluginService.isInWebView2())

const statusText = computed(() => {
  return isConnected.value ? 'Verbunden mit Plugin' : 'Browser Dev-Modus'
})

// Event Handler für Parameter-Updates vom Plugin
const handleParameterUpdate = (data: any) => {
  const index = parameters.value.findIndex((p) => p.id === data.id)
  if (index !== -1) {
    parameters.value[index].value = data.value
  }
}

const handleStateUpdate = (data: any) => {
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
