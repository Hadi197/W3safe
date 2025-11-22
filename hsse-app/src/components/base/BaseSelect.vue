<template>
  <div class="form-group">
    <label v-if="label" :for="id" class="label">
      {{ label }}
      <span v-if="required" class="text-danger-500">*</span>
    </label>
    <select
      :id="id"
      :value="modelValue"
      :disabled="disabled"
      :required="required"
      :class="selectClasses"
      @change="handleChange"
      @blur="$emit('blur')"
    >
      <option v-if="placeholder" value="" disabled class="text-gray-400">{{ placeholder }}</option>
      <option
        v-for="option in options"
        :key="optionValue(option)"
        :value="optionValue(option)"
        class="text-gray-900"
      >
        {{ optionLabel(option) }}
      </option>
    </select>
    <p v-if="error" class="mt-1 text-sm text-danger-600">{{ error }}</p>
    <p v-if="hint && !error" class="mt-1 text-sm text-gray-500">{{ hint }}</p>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

interface Props {
  modelValue: string | number
  options: any[]
  label?: string
  placeholder?: string
  disabled?: boolean
  required?: boolean
  error?: string
  hint?: string
  id?: string
  valueKey?: string
  labelKey?: string
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'Pilih...',
  disabled: false,
  required: false,
  valueKey: 'value',
  labelKey: 'label'
})

const emit = defineEmits<{
  (e: 'update:modelValue', value: string | number): void
  (e: 'blur'): void
}>()

const selectClasses = computed(() => [
  'input-field',
  'cursor-pointer',
  'text-gray-900',
  'font-medium',
  {
    'border-danger-500 focus:ring-danger-500': props.error,
    'bg-gray-100 cursor-not-allowed': props.disabled
  }
])

const optionValue = (option: any) => {
  return typeof option === 'object' ? option[props.valueKey] : option
}

const optionLabel = (option: any) => {
  return typeof option === 'object' ? option[props.labelKey] : option
}

const handleChange = (event: Event) => {
  const target = event.target as HTMLSelectElement
  emit('update:modelValue', target.value)
}
</script>
