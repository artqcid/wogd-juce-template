<template>
  <div class="parameter-slider">
    <label :for="id" class="slider-label">
      {{ name }}
      <span class="slider-value">{{ displayValue }}</span>
    </label>
    <input
      :id="id"
      type="range"
      :min="min"
      :max="max"
      :step="step"
      :value="value"
      @input="onInput"
      class="slider"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { pluginService } from '@/services/pluginService'

interface Props {
  id: string
  name: string
  value: number
  min?: number
  max?: number
  step?: number
}

const props = withDefaults(defineProps<Props>(), {
  min: 0,
  max: 1,
  step: 0.01
})

const displayValue = computed(() => {
  return props.value.toFixed(2)
})

const onInput = (event: Event) => {
  const target = event.target as HTMLInputElement
  const newValue = parseFloat(target.value)
  
  // Sende Parameter-Änderung an Plugin
  pluginService.setParameter(props.id, newValue)
}
</script>

<style scoped>
.parameter-slider {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 16px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  transition: background 0.2s;
}

.parameter-slider:hover {
  background: rgba(255, 255, 255, 0.08);
}

.slider-label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  font-weight: 500;
  color: #fff;
  user-select: none;
}

.slider-value {
  font-family: 'Courier New', monospace;
  color: #4fc3f7;
  font-size: 13px;
}

.slider {
  width: 100%;
  height: 6px;
  border-radius: 3px;
  background: rgba(255, 255, 255, 0.1);
  outline: none;
  -webkit-appearance: none;
  appearance: none;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #4fc3f7;
  cursor: pointer;
  transition: all 0.15s ease;
}

.slider::-webkit-slider-thumb:hover {
  background: #81d4fa;
  transform: scale(1.2);
}

.slider::-moz-range-thumb {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: #4fc3f7;
  cursor: pointer;
  border: none;
  transition: all 0.15s ease;
}

.slider::-moz-range-thumb:hover {
  background: #81d4fa;
  transform: scale(1.2);
}
</style>
