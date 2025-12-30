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
