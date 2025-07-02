<template>
  <component
    :is="asChild ? 'slot' : 'button'"
    :class="computedClasses"
    v-bind="attrs"
    ref="buttonRef"
  >
    <slot />
  </component>
</template>

<script lang="ts" setup>
import { computed, ref, useAttrs } from 'vue'
import { cva, type VariantProps } from 'class-variance-authority'
import { cn } from "@/components/lib/utils"

const props = defineProps<{
  variant?: 'default' | 'destructive' | 'outline' | 'secondary' | 'ghost' | 'link'
  size?: 'default' | 'sm' | 'lg' | 'icon'
  asChild?: boolean
}>()

const attrs = useAttrs()
const buttonRef = ref<HTMLButtonElement | null>(null)

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default: "bg-primary text-white text-primary-foreground hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

const computedClasses = computed(() =>
  cn(buttonVariants({ variant: props.variant, size: props.size }))
)

const asChild = computed(() => props.asChild ?? false)
</script>
