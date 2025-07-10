<template>
  <div id="app">
    <!-- Only show Navbar if user is not admin -->
    <Navbar v-if="!isAdmin" />
    
    <router-view />
    
    <!-- Only show Footer if user is not admin -->
    <Footer v-if="!isAdmin" />
  </div>
</template>

<script setup>
import { onMounted, computed } from 'vue'
import Navbar from './components/Navbar.vue'
import Footer from './components/Footer.vue'
import { useCartStore } from './stores/cart'
import { useAuthStore } from './stores/auth' // Assuming you have an auth store

const cartStore = useCartStore()
const authStore = useAuthStore() // Get auth store

// Computed property to check if user is admin
const isAdmin = computed(() => {
  return authStore.user?.role === 'admin' || authStore.isAdmin
})

// Alternative: You can also check based on route
// const route = useRoute()
// const isAdmin = computed(() => {
//   return route.path.startsWith('/admin')
// })

onMounted(() => {
  // Initialize cart from localStorage
  cartStore.loadCart()
  
  // Initialize auth state
  authStore.checkAuth() // Assuming you have this method
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