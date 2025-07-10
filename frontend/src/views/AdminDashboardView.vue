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
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthStore } from "../stores/auth";
import TopNavigation from "../components/admin/TopNavigation.vue";
import Sidebar from "../components/admin/Sidebar.vue";

// Define reactive props
const globalSearch = ref("");
const showNotifications = ref(false);
const showUserMenu = ref(false);
const showQuickAdd = ref(false);
const notifications = ref([]);
const unreadNotifications = ref(0);
const toasts = ref([]);
const isOnline = ref(true);
const lastUpdated = ref(new Date().toISOString());

const router = useRouter();
const authStore = useAuthStore();

// Emit functions (implement as needed)
const updateGlobalSearch = (value) => {
  globalSearch.value = value;
};
// ... other handlers ...

const logout = () => {
  authStore.logout();
  router.push({ name: "admin-login" });
};

const sidebarItems = ref([
  {
    id: "AdminDashboard",
    name: "Dashboard",
    icon: "HomeIcon",
    path: "/admin/dashboard",
  },
  {
    id: "stocks",
    name: "Stocks", 
    icon: "ArchiveIcon",
    path: "/admin/stocks",
  },
  {
    id: "orders",
    name: "Orders", 
    icon: "ShoppingCartIcon",
    path: "/admin/orders",
  },
  {
    id: "Inventory",
    name: "Inventory",
    icon: "TruckIcon",
    path: "/admin/inventory",
  },


  {
    id: "Customers",
    name: "Customers",
    icon: "UsersIcon",
    path: "/admin/customers",
  },
  {
    id: "Categories",
    name: "Categories",
    icon: "ListIcon",
    path: "/admin/categories",
  },
  {
    id: "Products",
    name: "Products",
    icon: "PackageIcon",
    path: "/admin/products",
  },
  {
    id: "Settings",
    name: "Settings",
    icon: "SettingsIcon",
    path: "/admin/settings",
  },


]);
</script>
