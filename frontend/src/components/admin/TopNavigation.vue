```vue
<template>
  <header class="bg-white shadow-sm">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center py-4">
        <!-- Left Section: Search -->
        <div class="flex items-center space-x-4">
          <div class="relative">
            <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <input
              type="search"
              placeholder="Search orders, customers, products..."
              class="pl-10 pr-4 py-2 w-80 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              :value="globalSearch"
              @input="$emit('update:globalSearch', $event.target.value)"
            />
          </div>
        </div>
        <!-- Right Section: Actions and Menus -->
        <div class="flex items-center space-x-4">
          <!-- Quick Add Button -->
          <button
            @click="$emit('update:showQuickAdd', !showQuickAdd)"
            class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
          >
            <PlusIcon class="h-4 w-4 mr-2" />
            Quick Add
          </button>
          <!-- Network Status -->
          <div class="flex items-center space-x-2">
            <div :class="isOnline ? 'bg-green-400' : 'bg-red-400'" class="h-2 w-2 rounded-full"></div>
            <span class="text-sm text-gray-600">{{ isOnline ? 'Online' : 'Offline' }}</span>
          </div>
          <!-- Notifications -->
          <div class="relative">
            <button
              @click="$emit('update:showNotifications', !showNotifications)"
              class="relative p-2 text-gray-600 hover:text-gray-900 focus:outline-none"
            >
              <BellIcon class="h-5 w-5" />
              <span v-if="unreadNotifications > 0" class="absolute top-0 right-0 bg-red-600 text-white text-xs rounded-full h-4 w-4 flex items-center justify-center">
                {{ unreadNotifications }}
              </span>
            </button>
            <!-- Notifications Dropdown -->
            <div v-if="showNotifications" class="absolute right-0 mt-2 w-80 bg-white rounded-md shadow-lg z-10">
              <div class="px-4 py-3 border-b border-gray-200">
                <div class="flex justify-between items-center">
                  <span class="text-sm font-medium text-gray-900">Notifications</span>
                  <div class="flex space-x-2">
                    <button @click="$emit('mark-all-as-read')" class="text-xs text-blue-600 hover:text-blue-800">Mark all as read</button>
                    <button @click="$emit('clear-all-notifications')" class="text-xs text-red-600 hover:text-red-800">Clear all</button>
                  </div>
                </div>
              </div>
              <div class="max-h-60 overflow-y-auto">
                <div
                  v-for="notification in notifications"
                  :key="notification.id"
                  @click="$emit('notification-click', notification)"
                  class="px-4 py-3 border-b border-gray-200 hover:bg-gray-50 cursor-pointer"
                >
                  <div class="flex items-center space-x-3">
                    <div :class="notification.read ? 'bg-gray-300' : 'bg-blue-600'" class="h-2 w-2 rounded-full"></div>
                    <div>
                      <p class="text-sm font-medium text-gray-900">{{ notification.title }}</p>
                      <p class="text-xs text-gray-500">{{ notification.message }}</p>
                      <p class="text-xs text-gray-400">{{ formatDate(notification.created_at) }}</p>
                    </div>
                    <button @click.stop="$emit('remove-notification', notification.id)" class="text-gray-400 hover:text-gray-600">
                      <XIcon class="h-4 w-4" />
                    </button>
                  </div>
                </div>
                <div v-if="notifications.length === 0" class="px-4 py-3 text-sm text-gray-500 text-center">
                  No notifications
                </div>
              </div>
            </div>
          </div>
          <!-- User Menu -->
          <div class="relative">
            <button
              @click="$emit('update:showUserMenu', !showUserMenu)"
              class="flex items-center space-x-2 text-gray-600 hover:text-gray-900 focus:outline-none"
            >
              <UserIcon class="h-5 w-5" />
              <span class="text-sm font-medium">Admin</span>
              <ChevronDownIcon class="h-4 w-4" />
            </button>
            <!-- User Menu Dropdown -->
            <div v-if="showUserMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg z-10">
              <div class="py-1">
                <button @click="$emit('open-user-profile')" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Profile
                </button>
                <button @click="$emit('open-settings')" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Settings
                </button>
                <button @click="$emit('view-activity-log')" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Activity Log
                </button>
                <button @click="$emit('export-data')" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Export Data
                </button>
                <button @click="$emit('refresh-data')" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  Refresh Data
                </button>
                <button @click="$emit('logout')" class="block w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100">
                  Logout
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- Toasts -->
    <div class="fixed bottom-4 right-4 space-y-2">
      <div
        v-for="toast in toasts"
        :key="toast.id"
        class="bg-white shadow-lg rounded-lg p-4 max-w-sm flex items-center space-x-3"
        :class="{
          'border-l-4 border-green-500': toast.type === 'success',
          'border-l-4 border-red-500': toast.type === 'error',
          'border-l-4 border-blue-500': toast.type === 'info'
        }"
      >
        <component :is="toastIcon(toast.type)" class="h-5 w-5" />
        <div>
          <p class="text-sm font-medium text-gray-900">{{ toast.title }}</p>
          <p class="text-sm text-gray-500">{{ toast.message }}</p>
        </div>
        <button @click="$emit('remove-toast', toast.id)" class="text-gray-400 hover:text-gray-600">
          <XIcon class="h-4 w-4" />
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { SearchIcon, PlusIcon, BellIcon, UserIcon, ChevronDownIcon, XIcon, CheckCircleIcon, AlertCircleIcon, InfoIcon } from 'lucide-vue-next'

defineProps({
  globalSearch: String,
  showNotifications: Boolean,
  showUserMenu: Boolean,
  showQuickAdd: Boolean,
  notifications: Array,
  unreadNotifications: Number,
  toasts: Array,
  isOnline: Boolean,
  lastUpdated: String
})

defineEmits([
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

const formatDate = (date) => {
  return new Date(date).toLocaleString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
    hour12: true
  })
}

const toastIcon = (type) => {
  const icons = {
    success: CheckCircleIcon,
    error: AlertCircleIcon,
    info: InfoIcon
  }
  return icons[type] || InfoIcon
}
</script>
```