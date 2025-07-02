<template>
  <nav class="bg-white shadow-lg sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center h-16">
        <!-- Logo -->
        <router-link to="/" class="flex items-center space-x-2">
          <DropletIcon class="h-8 w-8 text-blue-600" />
          <span class="text-2xl font-bold text-blue-900">AquaPure</span>
        </router-link>

        <!-- Desktop Navigation -->
        <div class="hidden md:flex items-center space-x-8">
          <router-link to="/" class="text-gray-700 hover:text-blue-600 transition-colors">
            Home
          </router-link>
          <router-link to="/shop" class="text-gray-700 hover:text-blue-600 transition-colors">
            Shop
          </router-link>
          <router-link to="/about" class="text-gray-700 hover:text-blue-600 transition-colors">
            About Us
          </router-link>
          <router-link to="/contact" class="text-gray-700 hover:text-blue-600 transition-colors">
            Contact
          </router-link>
          <router-link to="/faq" class="text-gray-700 hover:text-blue-600 transition-colors">
            FAQ
          </router-link>
        </div>

        <!-- Search and Cart -->
        <div class="hidden md:flex items-center space-x-4">
          <div class="relative">
            <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <input 
              type="search" 
              placeholder="Search products..." 
              class="pl-10 w-64 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              v-model="searchQuery"
              @keyup.enter="handleSearch"
            />
          </div>
          <router-link to="/cart" class="relative">
            <button class="p-2 border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500">
              <ShoppingCartIcon class="h-5 w-5" />
              <span v-if="cartStore.itemCount > 0" class="absolute -top-2 -right-2 bg-blue-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                {{ cartStore.itemCount }}
              </span>
            </button>
          </router-link>
        </div>

        <!-- Mobile menu button -->
        <div class="md:hidden">
          <button @click="isOpen = !isOpen" class="p-2 rounded-md hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500">
            <MenuIcon v-if="!isOpen" class="h-6 w-6" />
            <XIcon v-else class="h-6 w-6" />
          </button>
        </div>
      </div>

      <!-- Mobile Navigation -->
      <div v-if="isOpen" class="md:hidden">
        <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3 bg-white border-t">
          <router-link to="/" class="block px-3 py-2 text-gray-700 hover:text-blue-600" @click="isOpen = false">
            Home
          </router-link>
          <router-link to="/shop" class="block px-3 py-2 text-gray-700 hover:text-blue-600" @click="isOpen = false">
            Shop
          </router-link>
          <router-link to="/about" class="block px-3 py-2 text-gray-700 hover:text-blue-600" @click="isOpen = false">
            About Us
          </router-link>
          <router-link to="/contact" class="block px-3 py-2 text-gray-700 hover:text-blue-600" @click="isOpen = false">
            Contact
          </router-link>
          <router-link to="/faq" class="block px-3 py-2 text-gray-700 hover:text-blue-600" @click="isOpen = false">
            FAQ
          </router-link>
          <div class="px-3 py-2">
            <input type="search" placeholder="Search products..." class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
          <router-link to="/cart" class="block px-3 py-2" @click="isOpen = false">
            <button class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50">
              <ShoppingCartIcon class="h-5 w-5 mr-2" />
              Cart ({{ cartStore.itemCount }})
            </button>
          </router-link>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { DropletIcon, MenuIcon, XIcon, ShoppingCartIcon, SearchIcon } from 'lucide-vue-next'
import { useCartStore } from '../stores/cart'

const router = useRouter()
const cartStore = useCartStore()
const isOpen = ref(false)
const searchQuery = ref('')

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    router.push({ path: '/shop', query: { search: searchQuery.value } })
  }
}
</script>
