<template>
  <input
    :type="type"
    :class="computedClass"
    v-bind="attrs"
    ref="inputRef"
  />
</template>

<script setup lang="ts">
import { computed, ref, useAttrs } from 'vue'

const props = defineProps<{
  class?: string
  type?: string
}>()

const attrs = useAttrs()
const inputRef = ref<HTMLInputElement | null>(null)

function cn(...classes: (string | undefined)[]) {
  return classes.filter(Boolean).join(' ')
}

const baseClass =
  "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"

const computedClass = computed(() => cn(baseClass, props.class))
const type = computed(() => props.type || 'text')
</script>