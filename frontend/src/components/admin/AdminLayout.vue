<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Top Navigation -->
    <TopNavigation
      :global-search="globalSearch"
      @update:globalSearch="updateGlobalSearch"
      :show-notifications="showNotifications"
      @update:showNotifications="updateShowNotifications"
      :show-user-menu="showUserMenu"
      @update:showUserMenu="updateShowUserMenu"
      :show-quick-add="showQuickAdd"
      @update:showQuickAdd="updateShowQuickAdd"
      :notifications="notifications"
      :unread-notifications="unreadNotifications"
      :toasts="toasts"
      :is-online="isOnline"
      :last-updated="lastUpdated"
      @mark-all-as-read="markAllAsRead"
      @clear-all-notifications="clearAllNotifications"
      @notification-click="notificationClick"
      @remove-notification="removeNotification"
      @export-data="exportData"
      @refresh-data="refreshData"
      @open-user-profile="openUserProfile"
      @open-settings="openSettings"
      @view-activity-log="viewActivityLog"
      @logout="logout"
      @search="search"
      @select-search-result="selectSearchResult"
    />
    <!-- Main Layout -->
    <div class="flex">
      <!-- Sidebar -->
      <Sidebar :items="sidebarItems" />
      <!-- Main Content -->
      <main class="flex-1 p-6">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import TopNavigation from '../admin/TopNavigation.vue'
import Sidebar from '../admin/Sidebar.vue'

// Define reactive props
const globalSearch = ref('')
const showNotifications = ref(false)
const showUserMenu = ref(false)
const showQuickAdd = ref(false)
const notifications = ref([{ id: 1, message: 'New order received', read: false }])
const unreadNotifications = ref(1)
const toasts = ref([{ id: 1, message: 'Data updated', type: 'success' }])
const isOnline = ref(true)
const lastUpdated = ref(new Date().toISOString())

// Emit functions (implement as needed)
const updateGlobalSearch = (value) => { globalSearch.value = value }
const updateShowNotifications = (value) => { showNotifications.value = value }
const updateShowUserMenu = (value) => { showUserMenu.value = value }
const updateShowQuickAdd = (value) => { showQuickAdd.value = value }
const markAllAsRead = () => { notifications.value.forEach(n => n.read = true); unreadNotifications.value = 0 }
const clearAllNotifications = () => { notifications.value = []; unreadNotifications.value = 0 }
const notificationClick = (id) => { console.log('Notification clicked:', id) }
const removeNotification = (id) => { notifications.value = notifications.value.filter(n => n.id !== id) }
const exportData = () => { console.log('Export data') }
const refreshData = () => { lastUpdated.value = new Date().toISOString() }
const openUserProfile = () => { console.log('Open user profile') }
const openSettings = () => { console.log('Open settings') }
const viewActivityLog = () => { console.log('View activity log') }
const logout = () => { console.log('Logout') }
const search = (query) => { console.log('Search:', query) }
const selectSearchResult = (result) => { console.log('Selected result:', result) }

const sidebarItems = ref([
  { id: 'AdminDashboard', name: 'Dashboard', icon: 'HomeIcon', path: '/admin/dashboard' },
  { id: 'Analytics', name: 'Analytics', icon: 'BarChart2Icon', path: '/admin/analytics' },
  { id: 'Customers', name: 'Customers', icon: 'UsersIcon', path: '/admin/customers' },
  { id: 'Products', name: 'Products', icon: 'PackageIcon', path: '/admin/products' },
  { id: 'Settings', name: 'Settings', icon: 'SettingsIcon', path: '/admin/settings' },
])
</script>

<style scoped>
/* Add any custom styles here if needed */
</style>