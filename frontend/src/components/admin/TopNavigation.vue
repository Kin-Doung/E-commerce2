<template>
  <header class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center py-4">
        <!-- Left Section: Breadcrumb & Search -->
        <div class="flex items-center space-x-6">
          <!-- Breadcrumb -->
          <nav class="flex items-center space-x-2 text-sm">
            <span class="text-gray-500">Dashboard</span>
            <svg class="h-4 w-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
            <span class="text-gray-900 font-medium">{{ currentPage }}</span>
          </nav>
          
          <!-- Search -->
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
              <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
              </svg>
            </div>
            <input
              v-model="searchQuery"
              @input="handleSearch"
              @focus="showSearchResults = true"
              type="search"
              placeholder="Search orders, customers, products..."
              class="pl-10 pr-4 py-2.5 w-80 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors bg-gray-50 focus:bg-white"
            />
            
            <!-- Search Results Dropdown -->
            <div v-if="showSearchResults && searchQuery" class="absolute top-full left-0 right-0 mt-1 bg-white rounded-lg shadow-lg border border-gray-200 z-50">
              <div class="p-2">
                <div v-if="searchResults.length > 0">
                  <div
                    v-for="result in searchResults"
                    :key="result.id"
                    @click="selectSearchResult(result)"
                    class="flex items-center p-3 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors"
                  >
                    <div class="w-8 h-8 rounded-full flex items-center justify-center mr-3"
                         :class="getResultTypeClass(result.type)">
                      <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getResultIcon(result.type)"/>
                      </svg>
                    </div>
                    <div>
                      <p class="text-sm font-medium text-gray-900">{{ result.title }}</p>
                      <p class="text-xs text-gray-500">{{ result.subtitle }}</p>
                    </div>
                  </div>
                </div>
                <div v-else class="p-3 text-sm text-gray-500 text-center">
                  No results found
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Section: Actions and Menus -->
        <div class="flex items-center space-x-4">
          <!-- Quick Actions -->
          <div class="flex items-center space-x-2">
            <button
              @click="toggleQuickAdd"
              class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-lg shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 transition-colors"
            >
              <svg class="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
              </svg>
              Quick Add
            </button>
            
            <button
              @click="refreshData"
              class="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
              :class="{ 'animate-spin': isRefreshing }"
            >
              <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
              </svg>
            </button>
          </div>

          <!-- Network Status -->
          <div class="flex items-center space-x-2 px-3 py-1.5 rounded-full bg-gray-100">
            <div 
              :class="[
                'h-2 w-2 rounded-full',
                isOnline ? 'bg-green-400' : 'bg-red-400',
                { 'animate-pulse': isOnline }
              ]"
            ></div>
            <span class="text-xs font-medium text-gray-600">
              {{ isOnline ? 'Online' : 'Offline' }}
            </span>
          </div>

          <!-- Notifications -->
          <div class="relative">
            <button
              @click="toggleNotifications"
              class="relative p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4.868 19.462A17.173 17.173 0 003 12C3 7.029 7.029 3 12 3s9 4.029 9 9a17.173 17.173 0 00-1.868 7.462"/>
              </svg>
              <span 
                v-if="unreadNotifications > 0" 
                class="absolute -top-1 -right-1 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center font-medium"
              >
                {{ unreadNotifications > 9 ? '9+' : unreadNotifications }}
              </span>
            </button>

            <!-- Notifications Dropdown -->
            <div 
              v-if="showNotifications" 
              class="absolute right-0 mt-2 w-96 bg-white rounded-xl shadow-lg border border-gray-200 z-50"
            >
              <div class="p-4 border-b border-gray-200">
                <div class="flex justify-between items-center">
                  <h3 class="text-lg font-semibold text-gray-900">Notifications</h3>
                  <div class="flex space-x-2">
                    <button 
                      @click="markAllAsRead" 
                      class="text-sm text-blue-600 hover:text-blue-800 font-medium"
                    >
                      Mark all read
                    </button>
                    <button 
                      @click="clearAllNotifications" 
                      class="text-sm text-red-600 hover:text-red-800 font-medium"
                    >
                      Clear all
                    </button>
                  </div>
                </div>
              </div>
              
              <div class="max-h-80 overflow-y-auto">
                <div
                  v-for="notification in notifications"
                  :key="notification.id"
                  @click="handleNotificationClick(notification)"
                  class="p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-colors"
                  :class="{ 'bg-blue-50': !notification.read }"
                >
                  <div class="flex items-start space-x-3">
                    <div 
                      :class="notification.read ? 'bg-gray-300' : 'bg-blue-500'" 
                      class="h-2 w-2 rounded-full mt-2 flex-shrink-0"
                    ></div>
                    <div class="flex-1 min-w-0">
                      <p class="text-sm font-medium text-gray-900">{{ notification.title }}</p>
                      <p class="text-sm text-gray-600 mt-1">{{ notification.message }}</p>
                      <p class="text-xs text-gray-400 mt-2">{{ formatDate(notification.created_at) }}</p>
                    </div>
                    <button 
                      @click.stop="removeNotification(notification.id)" 
                      class="text-gray-400 hover:text-gray-600 p-1"
                    >
                      <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                      </svg>
                    </button>
                  </div>
                </div>
                
                <div v-if="notifications.length === 0" class="p-8 text-center">
                  <svg class="h-12 w-12 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5zM4.868 19.462A17.173 17.173 0 003 12C3 7.029 7.029 3 12 3s9 4.029 9 9a17.173 17.173 0 00-1.868 7.462"/>
                  </svg>
                  <p class="text-sm text-gray-500">No notifications</p>
                </div>
              </div>
            </div>
          </div>

          <!-- User Menu -->
          <div class="relative">
            <button
              @click="toggleUserMenu"
              class="flex items-center space-x-3 p-2 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <div class="w-8 h-8 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center">
                <span class="text-white font-semibold text-sm">{{ userInitials }}</span>
              </div>
              <div class="hidden md:block text-left">
                <p class="text-sm font-medium text-gray-900">{{ userName }}</p>
                <p class="text-xs text-gray-500">{{ userRole }}</p>
              </div>
              <svg class="h-4 w-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
              </svg>
            </button>

            <!-- User Menu Dropdown -->
            <div 
              v-if="showUserMenu" 
              class="absolute right-0 mt-2 w-56 bg-white rounded-xl shadow-lg border border-gray-200 z-50"
            >
              <div class="p-4 border-b border-gray-200">
                <div class="flex items-center space-x-3">
                  <div class="w-10 h-10 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full flex items-center justify-center">
                    <span class="text-white font-semibold">{{ userInitials }}</span>
                  </div>
                  <div>
                    <p class="text-sm font-medium text-gray-900">{{ userName }}</p>
                    <p class="text-xs text-gray-500">{{ userEmail }}</p>
                  </div>
                </div>
              </div>
              
              <div class="py-2">
                <button 
                  @click="openUserProfile" 
                  class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                >
                  <svg class="h-4 w-4 mr-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                  </svg>
                  Profile Settings
                </button>
                
                <button 
                  @click="openSettings" 
                  class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                >
                  <svg class="h-4 w-4 mr-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                  </svg>
                  Preferences
                </button>
                
                <button 
                  @click="viewActivityLog" 
                  class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                >
                  <svg class="h-4 w-4 mr-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                  </svg>
                  Activity Log
                </button>
                
                <button 
                  @click="exportData" 
                  class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                >
                  <svg class="h-4 w-4 mr-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                  </svg>
                  Export Data
                </button>
                
                <div class="border-t border-gray-100 my-2"></div>
                
                <button 
                  @click="logout" 
                  class="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
                >
                  <svg class="h-4 w-4 mr-3 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>
                  </svg>
                  Sign Out
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Toast Notifications -->
    <div class="fixed bottom-4 right-4 space-y-3 z-50">
      <div
        v-for="toast in toasts"
        :key="toast.id"
        class="bg-white shadow-lg rounded-lg p-4 max-w-sm flex items-start space-x-3 border-l-4 transition-all duration-300 transform"
        :class="getToastClass(toast.type)"
      >
        <div class="flex-shrink-0">
          <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getToastIcon(toast.type)"/>
          </svg>
        </div>
        <div class="flex-1 min-w-0">
          <p class="text-sm font-medium text-gray-900">{{ toast.title }}</p>
          <p class="text-sm text-gray-600 mt-1">{{ toast.message }}</p>
        </div>
        <button 
          @click="removeToast(toast.id)" 
          class="flex-shrink-0 text-gray-400 hover:text-gray-600"
        >
          <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

// Props
const props = defineProps({
  globalSearch: {
    type: String,
    default: ''
  },
  showNotifications: {
    type: Boolean,
    default: false
  },
  showUserMenu: {
    type: Boolean,
    default: false
  },
  showQuickAdd: {
    type: Boolean,
    default: false
  },
  notifications: {
    type: Array,
    default: () => []
  },
  unreadNotifications: {
    type: Number,
    default: 0
  },
  toasts: {
    type: Array,
    default: () => []
  },
  isOnline: {
    type: Boolean,
    default: true
  },
  currentPage: {
    type: String,
    default: 'Overview'
  }
})

// Emits
const emit = defineEmits([
  'update:globalSearch',
  'update:showNotifications',
  'update:showUserMenu',
  'update:showQuickAdd',
  'mark-all-as-read',
  'clear-all-notifications',
  'notification-click',
  'remove-notification',
  'remove-toast',
  'export-data',
  'refresh-data',
  'open-user-profile',
  'open-settings',
  'view-activity-log',
  'logout',
  'search',
  'select-search-result'
])

// Reactive state
const searchQuery = ref(props.globalSearch)
const showSearchResults = ref(false)
const showNotifications = ref(props.showNotifications)
const showUserMenu = ref(props.showUserMenu)
const isRefreshing = ref(false)

// User data
const userName = ref('Admin User')
const userEmail = ref('admin@aquapure.com')
const userRole = ref('Administrator')

// Computed
const userInitials = computed(() => {
  return userName.value.split(' ').map(n => n[0]).join('').toUpperCase()
})

// Sample search results
const searchResults = ref([
  { id: 1, type: 'order', title: 'Order #12345', subtitle: 'John Doe - $299.99' },
  { id: 2, type: 'customer', title: 'Jane Smith', subtitle: 'jane@example.com' },
  { id: 3, type: 'product', title: 'AquaPure Filter', subtitle: 'In Stock - $49.99' }
])

// Methods
const handleSearch = () => {
  emit('update:globalSearch', searchQuery.value)
  emit('search', searchQuery.value)
}

const selectSearchResult = (result) => {
  emit('select-search-result', result)
  showSearchResults.value = false
  searchQuery.value = ''
}

const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value
  emit('update:showNotifications', showNotifications.value)
}

const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value
  emit('update:showUserMenu', showUserMenu.value)
}

const toggleQuickAdd = () => {
  emit('update:showQuickAdd', !props.showQuickAdd)
}

const refreshData = async () => {
  isRefreshing.value = true
  emit('refresh-data')
  setTimeout(() => {
    isRefreshing.value = false
  }, 1000)
}

const markAllAsRead = () => {
  emit('mark-all-as-read')
}

const clearAllNotifications = () => {
  emit('clear-all-notifications')
}

const handleNotificationClick = (notification) => {
  emit('notification-click', notification)
}

const removeNotification = (id) => {
  emit('remove-notification', id)
}

const removeToast = (id) => {
  emit('remove-toast', id)
}

const openUserProfile = () => {
  emit('open-user-profile')
  showUserMenu.value = false
}

const openSettings = () => {
  emit('open-settings')
  showUserMenu.value = false
}

const viewActivityLog = () => {
  emit('view-activity-log')
  showUserMenu.value = false
}

const exportData = () => {
  emit('export-data')
  showUserMenu.value = false
}

const logout = () => {
  emit('logout')
  showUserMenu.value = false
}

// Utility functions
const formatDate = (date) => {
  return new Date(date).toLocaleString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
    hour12: true
  })
}

const getResultTypeClass = (type) => {
  const classes = {
    order: 'bg-blue-500',
    customer: 'bg-green-500',
    product: 'bg-purple-500'
  }
  return classes[type] || 'bg-gray-500'
}

const getResultIcon = (type) => {
  const icons = {
    order: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
    customer: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z',
    product: 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4'
  }
  return icons[type] || icons.order
}

const getToastClass = (type) => {
  const classes = {
    success: 'border-green-500 text-green-600',
    error: 'border-red-500 text-red-600',
    info: 'border-blue-500 text-blue-600',
    warning: 'border-yellow-500 text-yellow-600'
  }
  return classes[type] || classes.info
}

const getToastIcon = (type) => {
  const icons = {
    success: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
    error: 'M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    info: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    warning: 'M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
  }
  return icons[type] || icons.info
}

// Close dropdowns when clicking outside
const handleClickOutside = (event) => {
  if (!event.target.closest('.relative')) {
    showSearchResults.value = false
    showNotifications.value = false
    showUserMenu.value = false
  }
}

// Lifecycle
onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>

<style scoped>
/* Custom animations */
@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dropdown-enter-active {
  animation: slideIn 0.2s ease-out;
}

/* Custom scrollbar */
.overflow-y-auto::-webkit-scrollbar {
  width: 4px;
}

.overflow-y-auto::-webkit-scrollbar-track {
  background: #f1f5f9;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 2px;
}

.overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}
</style>