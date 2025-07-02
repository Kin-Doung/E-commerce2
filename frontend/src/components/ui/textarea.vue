<template>
  <textarea
    :class="computedClass"
    v-bind="$attrs"
    ref="textareaRef"
  />
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const props = defineProps<{
  class?: string
}>()

const textareaRef = ref<HTMLTextAreaElement | null>(null)

function cn(...classes: (string | undefined)[]) {
  return classes.filter(Boolean).join(' ')
}

const baseClass = "flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm"

const computedClass = computed(() => cn(baseClass, props.class))
</script>