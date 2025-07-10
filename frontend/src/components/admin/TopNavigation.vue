<template>
  <header class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-40">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="nav flex justify-between items-center py-4">
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
              @keydown.escape="closeSearch"
              @keydown.enter="handleEnterSearch"
              type="search"
              placeholder="Search orders, customers, products..."
              class="pl-10 pr-4 py-2.5 w-80 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors bg-gray-50 focus:bg-white"
            />
            
            <!-- Loading indicator -->
            <div v-if="isSearching" class="absolute inset-y-0 right-0 pr-3 flex items-center">
              <svg class="animate-spin h-4 w-4 text-gray-400" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
              </svg>
            </div>
            
            <!-- Search Results Dropdown -->
            <div v-if="showSearchResults && (searchQuery.length > 0 || searchResults.length > 0)" class="absolute top-full left-0 right-0 mt-1 bg-white rounded-lg shadow-lg border border-gray-200 z-50">
              <div class="p-2">
                <!-- Search Categories -->
                <div v-if="searchQuery.length > 0 && !isSearching" class="mb-2">
                  <div class="flex flex-wrap gap-2 mb-3">
                    <button
                      v-for="category in searchCategories"
                      :key="category.key"
                      @click="setSearchCategory(category.key)"
                      :class="[
                        'px-3 py-1 text-xs rounded-full border transition-colors',
                        selectedCategory === category.key
                          ? 'bg-blue-100 text-blue-700 border-blue-300'
                          : 'bg-gray-100 text-gray-600 border-gray-300 hover:bg-gray-200'
                      ]"
                    >
                      {{ category.label }}
                    </button>
                  </div>
                </div>
                
                <!-- Search Results -->
                <div v-if="searchResults.length > 0 && !isSearching">
                  <!-- Group results by category -->
                  <div v-for="(group, categoryKey) in groupedResults" :key="categoryKey" class="mb-4 last:mb-0">
                    <h4 v-if="Object.keys(groupedResults).length > 1" class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2 px-2">
                      {{ getCategoryLabel(categoryKey) }}
                    </h4>
                    <div
                      v-for="result in group"
                      :key="`${result.type}-${result.id}`"
                      @click="selectSearchResult(result)"
                      class="flex items-center p-3 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors"
                    >
                      <div class="w-8 h-8 rounded-full flex items-center justify-center mr-3"
                           :class="getResultTypeClass(result.type)">
                        <svg class="h-4 w-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="getResultIcon(result.type)"/>
                        </svg>
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-sm font-medium text-gray-900 truncate">{{ result.title }}</p>
                        <p class="text-xs text-gray-500 truncate">{{ result.subtitle }}</p>
                        <div v-if="result.metadata" class="flex items-center mt-1 space-x-2">
                          <span v-for="(value, key) in result.metadata" :key="key" class="text-xs text-gray-400">
                            {{ key }}: {{ value }}
                          </span>
                        </div>
                      </div>
                      <div v-if="result.status" class="ml-2">
                        <span :class="getStatusClass(result.status)" class="px-2 py-1 text-xs rounded-full">
                          {{ result.status }}
                        </span>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Loading state -->
                <div v-else-if="isSearching" class="p-4 text-center">
                  <svg class="animate-spin h-6 w-6 text-gray-400 mx-auto mb-2" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
                  </svg>
                  <p class="text-sm text-gray-500">Searching...</p>
                </div>
                
                <!-- No results -->
                <div v-else-if="searchQuery.length > 0 && searchResults.length === 0" class="p-4 text-center">
                  <svg class="h-8 w-8 text-gray-300 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                  </svg>
                  <p class="text-sm text-gray-500 mb-2">No results found for "{{ searchQuery }}"</p>
                  <button
                    @click="clearSearch"
                    class="text-xs text-blue-600 hover:text-blue-800 font-medium"
                  >
                    Clear search
                  </button>
                </div>
                
                <!-- Recent searches -->
                <div v-else-if="searchQuery.length === 0 && recentSearches.length > 0" class="p-2">
                  <h4 class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2 px-2">Recent Searches</h4>
                  <div
                    v-for="search in recentSearches"
                    :key="search.id"
                    @click="selectRecentSearch(search)"
                    class="flex items-center p-2 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors"
                  >
                    <svg class="h-4 w-4 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <span class="text-sm text-gray-700 flex-1">{{ search.query }}</span>
                    <button
                      @click.stop="removeRecentSearch(search.id)"
                      class="text-gray-400 hover:text-gray-600 p-1"
                    >
                      <svg class="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                      </svg>
                    </button>
                  </div>
                </div>
                
                <!-- Search suggestions -->
                <div v-else-if="searchQuery.length === 0 && searchSuggestions.length > 0" class="p-2">
                  <h4 class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2 px-2">Suggestions</h4>
                  <div
                    v-for="suggestion in searchSuggestions"
                    :key="suggestion.id"
                    @click="selectSuggestion(suggestion)"
                    class="flex items-center p-2 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors"
                  >
                    <svg class="h-4 w-4 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                    </svg>
                    <span class="text-sm text-gray-700">{{ suggestion.text }}</span>
                  </div>
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
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { useAuthStore } from '@/stores/auth';
import { storeToRefs } from 'pinia';

// Initialize Pinia store
const authStore = useAuthStore();
const { 
  user, 
  searchResults, 
  searchCategories, 
  recentSearches, 
  searchSuggestions, 
  notifications, 
  toasts, 
  isSearching, 
  isOnline, 
  unreadNotifications, 
  globalSearch, 
  showQuickAdd 
} = storeToRefs(authStore);

// Reactive state
const searchQuery = ref('');
const showSearchResults = ref(false);
const showNotifications = ref(false);
const showUserMenu = ref(false);
const isRefreshing = ref(false);
const selectedCategory = ref('all');
const searchTimeout = ref(null);
const currentPage = ref('Overview'); // Default value for currentPage

// Computed user data from auth store
const userName = computed(() => user.value?.name || 'Admin User');
const userEmail = computed(() => user.value?.email || 'admin@aquapure.com');
const userRole = computed(() => user.value?.role || 'Administrator');

// Computed user initials
const userInitials = computed(() => {
  return userName.value.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
});

// Group search results by category
const groupedResults = computed(() => {
  if (!searchResults.value?.length) return {};

  const filtered = selectedCategory.value === 'all' 
    ? searchResults.value 
    : searchResults.value.filter(result => result.type === selectedCategory.value.slice(0, -1));

  return filtered.reduce((groups, result) => {
    const category = result.type;
    if (!groups[category]) {
      groups[category] = [];
    }
    groups[category].push(result);
    return groups;
  }, {});
});

// Watch for search query changes
watch(globalSearch, (newValue) => {
  searchQuery.value = newValue;
});

// Close dropdowns when clicking outside
const closeDropdowns = (event) => {
  if (!event.target.closest('.relative')) {
    showSearchResults.value = false;
    showNotifications.value = false;
    showUserMenu.value = false;
  }
};

// Lifecycle hooks
onMounted(() => {
  document.addEventListener('click', closeDropdowns);
});

onUnmounted(() => {
  document.removeEventListener('click', closeDropdowns);
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }
});

// Methods
const handleSearch = () => {
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }
  searchTimeout.value = setTimeout(() => {
    authStore.updateGlobalSearch(searchQuery.value);
  }, 300);
};

const handleEnterSearch = () => {
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }
  authStore.search({
    query: searchQuery.value,
    category: selectedCategory.value,
  });
};

const selectSearchResult = (result) => {
  authStore.selectSearchResult(result);
  showSearchResults.value = false;
  searchQuery.value = '';
};

const selectRecentSearch = (search) => {
  searchQuery.value = search.query;
  authStore.selectRecentSearch(search);
  handleSearch();
};

const removeRecentSearch = (id) => {
  authStore.removeRecentSearch(id);
};

const selectSuggestion = (suggestion) => {
  searchQuery.value = suggestion.text;
  authStore.selectSuggestion(suggestion);
  handleSearch();
};

const clearSearch = () => {
  searchQuery.value = '';
  authStore.clearSearch();
};

const closeSearch = () => {
  showSearchResults.value = false;
};

const setSearchCategory = (category) => {
  selectedCategory.value = category;
  authStore.setSearchCategory(category);
  if (searchQuery.value) {
    handleSearch();
  }
};

const toggleNotifications = () => {
  showNotifications.value = !showNotifications.value;
  authStore.updateShowNotifications(showNotifications.value);
};

const toggleUserMenu = () => {
  showUserMenu.value = !showUserMenu.value;
  authStore.updateShowUserMenu(showUserMenu.value);
};

const toggleQuickAdd = () => {
  authStore.updateShowQuickAdd(!showQuickAdd.value);
};

const refreshData = async () => {
  isRefreshing.value = true;
  await authStore.refreshData();
  setTimeout(() => {
    isRefreshing.value = false;
  }, 1000);
};

const markAllAsRead = () => {
  authStore.markAllAsRead();
};

const clearAllNotifications = () => {
  authStore.clearAllNotifications();
};

const handleNotificationClick = (notification) => {
  authStore.notificationClick(notification);
};

const removeNotification = (id) => {
  authStore.removeNotification(id);
};

const removeToast = (id) => {
  authStore.removeToast(id);
};

const openUserProfile = () => {
  authStore.openUserProfile();
  showUserMenu.value = false;
};

const openSettings = () => {
  authStore.openSettings();
  showUserMenu.value = false;
};

const viewActivityLog = () => {
  authStore.viewActivityLog();
  showUserMenu.value = false;
};

const exportData = () => {
  authStore.exportData();
  showUserMenu.value = false;
};

const logout = () => {
  authStore.logout();
  showUserMenu.value = false;
};

const formatDate = (date) => {
  if (!date) return '';
  return new Date(date).toLocaleString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: 'numeric',
    hour12: true,
  });
};

const getCategoryLabel = (categoryKey) => {
  const category = searchCategories.value.find(cat => cat.key === categoryKey + 's');
  return category ? category.label : categoryKey.charAt(0).toUpperCase() + categoryKey.slice(1);
};

const getResultTypeClass = (type) => {
  const classes = {
    order: 'bg-blue-500',
    customer: 'bg-green-500',
    product: 'bg-purple-500',
    user: 'bg-orange-500',
    invoice: 'bg-yellow-500',
    report: 'bg-indigo-500',
  };
  return classes[type] || 'bg-gray-500';
};

const getResultIcon = (type) => {
  const icons = {
    order: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
    customer: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z',
    product: 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
    user: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z',
    invoice: 'M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
    report: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
  };
  return icons[type] || icons.order;
};

const getStatusClass = (status) => {
  const classes = {
    active: 'bg-green-100 text-green-800',
    inactive: 'bg-gray-100 text-gray-800',
    pending: 'bg-yellow-100 text-yellow-800',
    completed: 'bg-blue-100 text-blue-800',
    cancelled: 'bg-red-100 text-red-800',
  };
  return classes[status] || 'bg-gray-100 text-gray-800';
};

const getToastClass = (type) => {
  const classes = {
    success: 'border-green-500 text-green-600',
    error: 'border-red-500 text-red-600',
    info: 'border-blue-500 text-blue-600',
    warning: 'border-yellow-500 text-yellow-600',
  };
  return classes[type] || classes.info;
};

const getToastIcon = (type) => {
  const icons = {
    success: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
    error: 'M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    info: 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
    warning: 'M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
  };
  return icons[type] || icons.info;
};
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