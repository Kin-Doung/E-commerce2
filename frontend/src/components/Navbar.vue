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
            About
          </router-link>
          <router-link to="/contact" class="text-gray-700 hover:text-blue-600 transition-colors">
            Contact
          </router-link>
          <router-link to="/faq" class="text-gray-700 hover:text-blue-600 transition-colors">
            FAQ
          </router-link>
        </div>

        <!-- Search, Notifications, Cart, User -->
        <div class="hidden md:flex items-center space-x-4">
          <!-- Search -->
          <div class="relative">
            <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <input type="search" placeholder="Search products..."
              class="pl-10 w-64 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              v-model="searchQuery" @keyup.enter="handleSearch" />
          </div>

          <!-- Notifications -->
          <div v-if="authStore.isAuthenticated" class="relative">
            <button @click="showNotifications = !showNotifications"
              class="relative p-2 text-gray-600 hover:text-blue-600 transition-colors">
              <BellIcon class="h-6 w-6" />
              <span v-if="notificationStore.unreadCount > 0"
                class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                {{ notificationStore.unreadCount }}
              </span>
            </button>

            <!-- Notifications Dropdown -->
            <div v-if="showNotifications"
              class="absolute top-full right-0 mt-2 w-80 bg-white rounded-md shadow-lg border border-gray-200 z-50">
              <div class="p-4 border-b border-gray-200">
                <div class="flex items-center justify-between">
                  <h3 class="text-lg font-semibold text-gray-900">Notifications</h3>
                  <button @click="notificationStore.markAllAsRead" class="text-sm text-blue-600 hover:text-blue-700">
                    Mark all read
                  </button>
                </div>
              </div>
              <div class="max-h-64 overflow-y-auto">
                <div v-for="notification in notificationStore.recentNotifications" :key="notification.id"
                  @click="notificationStore.markAsRead(notification.id)"
                  class="p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer"
                  :class="{ 'bg-blue-50': !notification.is_read }">
                  <p class="text-sm text-gray-900">{{ notification.message }}</p>
                  <p class="text-xs text-gray-500 mt-1">{{ formatDate(notification.sent_date) }}</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Cart -->
          <router-link to="/cart" class="relative">
            <button
              class="p-2 border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500">
              <ShoppingCartIcon class="h-5 w-5" />
              <span v-if="cartStore.itemCount > 0"
                class="absolute -top-2 -right-2 bg-blue-600 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
                {{ cartStore.itemCount }}
              </span>
            </button>
          </router-link>

          <!-- User Menu -->
          <div v-if="authStore.isAuthenticated" class="relative">
            <button @click="showUserMenu = !showUserMenu"
              class="flex items-center space-x-2 p-2 rounded-md hover:bg-gray-50">
              <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center">
                <span class="text-white text-sm font-medium">
                  {{ authStore.user?.email?.charAt(0).toUpperCase() }}
                </span>
              </div>
              <ChevronDownIcon class="h-4 w-4 text-gray-600" />
            </button>

            <!-- User Dropdown -->
            <div v-if="showUserMenu"
              class="absolute top-full right-0 mt-2 w-48 bg-white rounded-md shadow-lg border border-gray-200 z-50">
              <div class="py-2">
                <router-link to="/profile" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                  Profile
                </router-link>
                <router-link to="/orders" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                  Orders
                </router-link>
                <router-link to="/addresses" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                  Addresses
                </router-link>
                <hr class="my-2" />
                <button @click="logout" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                  Logout
                </button>
              </div>
            </div>
          </div>

          <!-- Login/Register -->
          <div v-else class="flex items-center space-x-2">
            <router-link to="/login">
              <button class="px-4 py-2 text-blue-600 hover:text-blue-700 font-medium">
                Login
              </button>
            </router-link>
            <router-link to="/register">
              <button class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md">
                Register
              </button>
            </router-link>
          </div>
        </div>

        <!-- Mobile menu button -->
        <div class="md:hidden">
          <button @click="isOpen = !isOpen"
            class="p-2 rounded-md hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500">
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
            About
          </router-link>
          <router-link to="/contact" class="block px-3 py-2 text-gray-700 hover:text-blue-600" @click="isOpen = false">
            Contact
          </router-link>
          <div class="px-3 py-2">
            <input type="search" placeholder="Search products..."
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" />
          </div>
          <router-link to="/cart" class="block px-3 py-2" @click="isOpen = false">
            <button
              class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50">
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
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  DropletIcon,
  MenuIcon,
  XIcon,
  ShoppingCartIcon,
  SearchIcon,
  BellIcon,
  ChevronDownIcon
} from 'lucide-vue-next'
import { useCartStore } from '../stores/cart'
import { useAuthStore } from '../stores/auth'
import { useProductStore } from '../stores/products'
import { useNotificationStore } from '../stores/notifications'

const router = useRouter()
const cartStore = useCartStore()
const authStore = useAuthStore()
const productStore = useProductStore()
const notificationStore = useNotificationStore()

const isOpen = ref(false)
const searchQuery = ref('')
const showNotifications = ref(false)
const showUserMenu = ref(false)

const handleSearch = () => {
  if (searchQuery.value.trim()) {
    productStore.setFilters({ search: searchQuery.value })
    router.push('/shop')
  }
}

const logout = () => {
  authStore.logout()
  showUserMenu.value = false
  router.push('/')
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString()
}

const handleClickOutside = (event) => {
  if (!event.target.closest('.relative')) {
    showNotifications.value = false
    showUserMenu.value = false
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})

// productStore.fetchCategories() // Uncomment if needed
</script>
