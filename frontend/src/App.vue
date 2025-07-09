<template>
  <div id="app">
    <Navbar />
    <router-view />
    <Footer v-if="showFooter" />
  </div>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import Navbar from './components/Navbar.vue'
import Footer from './components/Footer.vue'
import { useCartStore } from './stores/cart'

const cartStore = useCartStore()
const route = useRoute()

const showFooter = computed(() => {
  return route.name !== 'admin-login' && route.name !== 'register' && !route.path.startsWith('/admin')
})

onMounted(() => {
  // Initialize cart from localStorage
  cartStore.loadCart()
})
</script>

<style>
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f5f9;
}

::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* Smooth transitions */
* {
  transition: color 0.2s ease, background-color 0.2s ease, border-color 0.2s ease;
}
</style>
