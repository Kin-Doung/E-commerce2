<template>
  <aside class="w-64 bg-white shadow-lg h-screen flex flex-col border-r border-gray-200">
    <!-- Header -->
    <div class="p-6 border-b border-gray-200">
      <div class="flex items-center">
        <div class="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center mr-3">
          <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
          </svg>
        </div>
        <div>
          <h1 class="text-xl font-bold text-gray-900">AquaPure</h1>
          <p class="text-xs text-gray-500">Admin Panel</p>
        </div>
      </div>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 overflow-y-auto py-4">
      <div class="px-3">
        <!-- Main Navigation -->
        <div class="mb-8">
          <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3">
            Main
          </p>
          <ul class="space-y-1">
            <li
              v-for="item in mainItems"
              :key="item.id"
              class="relative"
            >
              <router-link
                :to="item.path"
                class="group flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-all duration-200"
                :class="{
                  'bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-md': isActive(item.id),
                  'text-gray-700 hover:bg-gray-100 hover:text-gray-900': !isActive(item.id),
                }"
                @click="setActiveItem(item.id)"
              >
                <component 
                  :is="iconComponent(item.icon)" 
                  class="h-5 w-5 mr-3 transition-colors duration-200"
                  :class="{
                    'text-white': isActive(item.id),
                    'text-gray-400 group-hover:text-gray-600': !isActive(item.id)
                  }"
                />
                <span class="truncate">{{ item.name }}</span>
                <span 
                  v-if="item.badge" 
                  class="ml-auto inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-white/20 text-white': isActive(item.id),
                    'bg-red-100 text-red-800': !isActive(item.id)
                  }"
                >
                  {{ item.badge }}
                </span>
              </router-link>
            </li>
          </ul>
        </div>

        <!-- Management Section -->
        <div class="mb-8">
          <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3">
            Management
          </p>
          <ul class="space-y-1">
            <li
              v-for="item in managementItems"
              :key="item.id"
              class="relative"
            >
              <router-link
                :to="item.path"
                class="group flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-all duration-200"
                :class="{
                  'bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-md': isActive(item.id),
                  'text-gray-700 hover:bg-gray-100 hover:text-gray-900': !isActive(item.id),
                }"
                @click="setActiveItem(item.id)"
              >
                <component 
                  :is="iconComponent(item.icon)" 
                  class="h-5 w-5 mr-3 transition-colors duration-200"
                  :class="{
                    'text-white': isActive(item.id),
                    'text-gray-400 group-hover:text-gray-600': !isActive(item.id)
                  }"
                />
                <span class="truncate">{{ item.name }}</span>
                <span 
                  v-if="item.badge" 
                  class="ml-auto inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium"
                  :class="{
                    'bg-white/20 text-white': isActive(item.id),
                    'bg-yellow-100 text-yellow-800': !isActive(item.id)
                  }"
                >
                  {{ item.badge }}
                </span>
              </router-link>
            </li>
          </ul>
        </div>

        <!-- System Section -->
        <div>
          <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider mb-3">
            System
          </p>
          <ul class="space-y-1">
            <li
              v-for="item in systemItems"
              :key="item.id"
              class="relative"
            >
              <router-link
                :to="item.path"
                class="group flex items-center px-3 py-2 text-sm font-medium rounded-lg transition-all duration-200"
                :class="{
                  'bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-md': isActive(item.id),
                  'text-gray-700 hover:bg-gray-100 hover:text-gray-900': !isActive(item.id),
                }"
                @click="setActiveItem(item.id)"
              >
                <component 
                  :is="iconComponent(item.icon)" 
                  class="h-5 w-5 mr-3 transition-colors duration-200"
                  :class="{
                    'text-white': isActive(item.id),
                    'text-gray-400 group-hover:text-gray-600': !isActive(item.id)
                  }"
                />
                <span class="truncate">{{ item.name }}</span>
              </router-link>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <!-- Footer -->
    <div class="p-4 border-t border-gray-200">
      <div class="flex items-center">
        <div class="w-8 h-8 bg-gray-200 rounded-full flex items-center justify-center mr-3">
          <UserIcon class="w-4 h-4 text-gray-600" />
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-medium text-gray-900 truncate">{{ currentUser.name || 'Admin User' }}</p>
          <p class="text-xs text-gray-500 truncate">{{ currentUser.role || 'Administrator' }}</p>
        </div>
        <button 
          @click="logout"
          class="p-1 text-gray-400 hover:text-gray-600 transition-colors duration-200"
          title="Logout"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
          </svg>
        </button>
      </div>
    </div>
  </aside>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  HomeIcon,
  BarChart2Icon,
  UsersIcon,
  ArchiveIcon,
  PackageIcon,
  SettingsIcon,
  ListIcon,
  ShoppingCartIcon,
  TruckIcon,
  CreditCardIcon,
  BellIcon,
  UserIcon,
  ShieldIcon,
  HelpCircleIcon,
} from "lucide-vue-next"

const route = useRoute()
const router = useRouter()

// Props
const props = defineProps({
  items: {
    type: Array,
    default: () => []
  }
})

// Reactive state
const activeItem = ref('')
const currentUser = ref({
  name: '',
  role: ''
})

// Navigation items organized by category
const mainItems = computed(() => [
  {
    id: 'dashboard',
    name: 'Dashboard',
    path: '/admin/dashboard',
    icon: 'HomeIcon'
  },
  {
    id: 'analytics',
    name: 'Analytics',
    path: '/admin/analytics',
    icon: 'BarChart2Icon'
  },
  {
    id: 'orders',
    name: 'Orders',
    path: '/admin/orders',
    icon: 'ShoppingCartIcon',
    badge: getOrdersBadge()
  }
])

const managementItems = computed(() => [
  {
    id: 'products',
    name: 'Products',
    path: '/admin/products',
    icon: 'PackageIcon'
  },
  {
    id: 'inventory',
    name: 'Inventory',
    path: '/admin/inventory',
    icon: 'ArchiveIcon',
    badge: getInventoryBadge()
  },
  {
    id: 'customers',
    name: 'Customers',
    path: '/admin/customers',
    icon: 'UsersIcon'
  },
  {
    id: 'stocks',
    name: 'Stocks',
    path: '/admin/stocks',
    icon: 'TruckIcon'
  },
  {
    id: 'categories',
    name: 'Categories',
    path: '/admin/categories',
    icon: 'ListIcon'
  }
])

const systemItems = computed(() => [
  {
    id: 'notifications',
    name: 'Notifications',
    path: '/admin/notifications',
    icon: 'BellIcon'
  },
  {
    id: 'security',
    name: 'Security',
    path: '/admin/security',
    icon: 'ShieldIcon'
  },
  {
    id: 'settings',
    name: 'Settings',
    path: '/admin/settings',
    icon: 'SettingsIcon'
  },
  {
    id: 'help',
    name: 'Help & Support',
    path: '/admin/help',
    icon: 'HelpCircleIcon'
  }
])

// Icon mapping
const iconComponent = (iconName) => {
  const icons = {
    HomeIcon,
    BarChart2Icon,
    ArchiveIcon,
    UsersIcon,
    PackageIcon,
    SettingsIcon,
    ListIcon,
    ShoppingCartIcon,
    TruckIcon,
    CreditCardIcon,
    BellIcon,
    UserIcon,
    ShieldIcon,
    HelpCircleIcon,
  }
  return icons[iconName] || HomeIcon
}

// Helper functions
const isActive = (itemId) => {
  return activeItem.value === itemId || route.name === itemId
}

const setActiveItem = (itemId) => {
  activeItem.value = itemId
}

// Badge functions - these would typically fetch from API
const getOrdersBadge = () => {
  // This would typically come from an API call or store
  // Return null if no badge needed
  return null
}

const getInventoryBadge = () => {
  // This would typically come from an API call or store
  // Return null if no badge needed
  return null
}

// User management
const fetchCurrentUser = async () => {
  try {
    // Replace with actual API call
    // const response = await api.getCurrentUser()
    // currentUser.value = response.data
    
    // For now, get from localStorage or default
    const userData = localStorage.getItem('currentUser')
    if (userData) {
      currentUser.value = JSON.parse(userData)
    }
  } catch (error) {
    console.error('Error fetching current user:', error)
  }
}

const logout = async () => {
  try {
    // Replace with actual logout API call
    // await api.logout()
    
    // Clear local storage
    localStorage.removeItem('currentUser')
    localStorage.removeItem('authToken')
    
    // Redirect to login
    router.push('/login')
  } catch (error) {
    console.error('Error during logout:', error)
  }
}

// Lifecycle
onMounted(() => {
  // Set initial active item based on current route
  activeItem.value = route.name || 'dashboard'
  
  // Fetch current user data
  fetchCurrentUser()
})
</script>

<style scoped>

nav::-webkit-scrollbar {
  width: 4px;
}

nav::-webkit-scrollbar-track {
  background: transparent;
}

nav::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 2px;
}

nav::-webkit-scrollbar-thumb:hover {
  background: #d1d5db;
}

/* Smooth transitions */
.router-link-active {
  @apply bg-gradient-to-r from-blue-500 to-purple-600 text-white shadow-md;
}
</style>