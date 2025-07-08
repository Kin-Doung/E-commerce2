<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6 mb-6">
        <div class="flex items-center justify-between">
          <div>
            <h1 class="text-3xl font-bold text-gray-900 flex items-center">
              <svg class="h-8 w-8 text-green-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
              </svg>
              Inventory Management
            </h1>
            <p class="text-gray-600 mt-2">Track and manage your inventory levels</p>
          </div>
          <div class="flex items-center space-x-4">
            <div class="text-right">
              <p class="text-2xl font-bold text-green-600">{{ inventoryItems.length }}</p>
              <p class="text-sm text-gray-500">Total Items</p>
            </div>
            <button 
              @click="openAddModal" 
              class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200 flex items-center"
            >
              <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
              </svg>
              Add Inventory Item
            </button>
          </div>
        </div>
      </div>

      <!-- Stats Cards -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-blue-100 rounded-lg">
              <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Total Products</p>
              <p class="text-2xl font-bold text-gray-900">{{ totalProducts }}</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-green-100 rounded-lg">
              <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Total Quantity</p>
              <p class="text-2xl font-bold text-gray-900">{{ totalQuantity }}</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-yellow-100 rounded-lg">
              <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Low Stock</p>
              <p class="text-2xl font-bold text-gray-900">{{ lowStockCount }}</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-purple-100 rounded-lg">
              <svg class="h-6 w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Avg. Stock</p>
              <p class="text-2xl font-bold text-gray-900">{{ averageStock }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Search and Filter Section -->
      <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6 mb-6">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between space-y-4 md:space-y-0">
          <div class="relative flex-1 max-w-md">
            <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search inventory items..."
              class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors"
            />
          </div>
          <div class="flex items-center space-x-4">
            <select 
              v-model="stockFilter" 
              class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500"
            >
              <option value="">All Stock Levels</option>
              <option value="low">Low Stock (< 10)</option>
              <option value="medium">Medium Stock (10-50)</option>
              <option value="high">High Stock (> 50)</option>
            </select>
            <button 
              @click="fetchInventory" 
              class="p-3 text-gray-600 hover:text-green-600 hover:bg-green-50 rounded-lg transition-colors"
              :disabled="loading"
            >
              <svg class="h-5 w-5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="bg-white rounded-lg shadow-sm border border-gray-200 p-12">
        <div class="text-center">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-green-600 mx-auto mb-4"></div>
          <p class="text-gray-600">Loading inventory...</p>
        </div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-6 mb-6">
        <div class="flex items-center">
          <svg class="h-6 w-6 text-red-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <div>
            <h3 class="text-red-800 font-medium">Error Loading Inventory</h3>
            <p class="text-red-600 mt-1">{{ error }}</p>
          </div>
        </div>
      </div>

      <!-- Inventory Table -->
      <div v-else-if="filteredInventory.length > 0" class="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200">
          <h3 class="text-lg font-semibold text-gray-900">Inventory Items</h3>
          <p class="text-sm text-gray-600 mt-1">{{ filteredInventory.length }} items found</p>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Product
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Quantity
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Stock Level
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Stock ID
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr 
                v-for="(item, index) in filteredInventory" 
                :key="item.id || index"
                class="hover:bg-gray-50 transition-colors"
              >
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="flex items-center">
                    <div class="h-10 w-10 bg-gray-200 rounded-lg flex items-center justify-center">
                      <svg class="h-5 w-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                      </svg>
                    </div>
                    <div class="ml-4">
                      <div class="text-sm font-medium text-gray-900">
                        {{ item.product?.name || `Product #${item.product_id}` }}
                      </div>
                      <div class="text-sm text-gray-500">ID: {{ item.product_id }}</div>
                    </div>
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{{ item.quantity }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="getStockLevelClass(item.quantity)">
                    {{ getStockLevelText(item.quantity) }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                  {{ item.stock_id }}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <div class="relative">
                    <button 
                      @click="toggleMenu(index)"
                      class="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg transition-colors"
                    >
                      <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/>
                      </svg>
                    </button>
                    
                    <!-- Dropdown Menu -->
                    <div 
                      v-if="activeMenuIndex === index"
                      class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 z-10"
                    >
                      <div class="py-1">
                        <button
                          @click="showInventory(item)"
                          class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                        >
                          <svg class="h-4 w-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                          </svg>
                          View Details
                        </button>
                        <button
                          @click="editInventory(item)"
                          class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                        >
                          <svg class="h-4 w-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                          </svg>
                          Edit Item
                        </button>
                        <button
                          @click="deleteInventory(item.id)"
                          class="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
                        >
                          <svg class="h-4 w-4 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                          </svg>
                          Delete Item
                        </button>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="bg-white rounded-lg shadow-sm border border-gray-200 p-12">
        <div class="text-center">
          <svg class="h-16 w-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
          </svg>
          <h3 class="text-lg font-medium text-gray-900 mb-2">No Inventory Items Found</h3>
          <p class="text-gray-600 mb-6">Get started by adding your first inventory item.</p>
          <button 
            @click="openAddModal"
            class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200"
          >
            Add Your First Item
          </button>
        </div>
      </div>

      <!-- Add/Edit Modal -->
      <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
          <div class="p-6 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <h2 class="text-xl font-bold text-gray-900">
                {{ isEditing ? 'Edit Inventory Item' : 'Add New Inventory Item' }}
              </h2>
              <button 
                @click="closeModal"
                class="text-gray-400 hover:text-gray-600 transition-colors"
              >
                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            </div>
          </div>

          <form @submit.prevent="handleSubmit" class="p-6 space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Product ID</label>
              <input
                v-model="currentInventory.product_id"
                type="number"
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors"
                placeholder="Enter product ID"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
              <input
                v-model="currentInventory.quantity"
                type="number"
                min="0"
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors"
                placeholder="Enter quantity"
              />
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Stock ID</label>
              <input
                v-model="currentInventory.stock_id"
                type="text"
                required
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors"
                placeholder="Enter stock ID"
              />
            </div>

            <div class="flex justify-end space-x-4 pt-4">
              <button
                type="button"
                @click="closeModal"
                class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200"
              >
                Cancel
              </button>
              <button
                type="submit"
                :disabled="loading"
                class="px-6 py-3 bg-green-600 hover:bg-green-700 text-white rounded-lg font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
              >
                <span v-if="loading" class="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></span>
                {{ isEditing ? 'Update Item' : 'Add Item' }}
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- View Details Modal -->
      <div v-if="showDetailModal && selectedInventory" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
          <div class="p-6 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <h2 class="text-xl font-bold text-gray-900">Inventory Details</h2>
              <button 
                @click="showDetailModal = false"
                class="text-gray-400 hover:text-gray-600 transition-colors"
              >
                <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            </div>
          </div>

          <div class="p-6 space-y-4">
            <div class="flex items-center justify-center mb-6">
              <div class="h-16 w-16 bg-green-100 rounded-full flex items-center justify-center">
                <svg class="h-8 w-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                </svg>
              </div>
            </div>

            <div class="space-y-3">
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="font-medium text-gray-700">Item ID:</span>
                <span class="text-gray-900">{{ selectedInventory.id }}</span>
              </div>
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="font-medium text-gray-700">Product ID:</span>
                <span class="text-gray-900">{{ selectedInventory.product_id }}</span>
              </div>
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="font-medium text-gray-700">Product Name:</span>
                <span class="text-gray-900">{{ selectedInventory.product?.name || 'N/A' }}</span>
              </div>
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="font-medium text-gray-700">Quantity:</span>
                <span class="text-gray-900 font-semibold">{{ selectedInventory.quantity }}</span>
              </div>
              <div class="flex justify-between items-center py-2 border-b border-gray-100">
                <span class="font-medium text-gray-700">Stock Level:</span>
                <span :class="getStockLevelClass(selectedInventory.quantity)">
                  {{ getStockLevelText(selectedInventory.quantity) }}
                </span>
              </div>
              <div class="flex justify-between items-center py-2">
                <span class="font-medium text-gray-700">Stock ID:</span>
                <span class="text-gray-900">{{ selectedInventory.stock_id }}</span>
              </div>
            </div>

            <div class="flex justify-end pt-4">
              <button
                @click="showDetailModal = false"
                class="px-6 py-3 bg-gray-600 hover:bg-gray-700 text-white rounded-lg font-medium transition-colors duration-200"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Success Toast -->
      <div v-if="showToast" class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 flex items-center">
        <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        {{ toastMessage }}
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'

// Reactive state
const inventoryItems = ref([])
const searchQuery = ref('')
const stockFilter = ref('')
const loading = ref(false)
const error = ref(null)
const showModal = ref(false)
const showDetailModal = ref(false)
const isEditing = ref(false)
const activeMenuIndex = ref(null)
const selectedInventory = ref(null)
const showToast = ref(false)
const toastMessage = ref('')

const currentInventory = ref({
  id: null,
  product_id: '',
  quantity: '',
  stock_id: ''
})

const BASE_URL = 'http://127.0.0.1:8000/api/inventories'

// Computed properties
const filteredInventory = computed(() => {
  let filtered = inventoryItems.value

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(item => 
      item.product?.name?.toLowerCase().includes(query) ||
      item.product_id.toString().includes(query) ||
      item.stock_id.toLowerCase().includes(query)
    )
  }

  if (stockFilter.value) {
    filtered = filtered.filter(item => {
      const quantity = parseInt(item.quantity)
      switch (stockFilter.value) {
        case 'low': return quantity < 10
        case 'medium': return quantity >= 10 && quantity <= 50
        case 'high': return quantity > 50
        default: return true
      }
    })
  }

  return filtered
})

const totalProducts = computed(() => {
  return new Set(inventoryItems.value.map(item => item.product_id)).size
})

const totalQuantity = computed(() => {
  return inventoryItems.value.reduce((sum, item) => sum + parseInt(item.quantity || 0), 0)
})

const lowStockCount = computed(() => {
  return inventoryItems.value.filter(item => parseInt(item.quantity) < 10).length
})

const averageStock = computed(() => {
  if (inventoryItems.value.length === 0) return 0
  return Math.round(totalQuantity.value / inventoryItems.value.length)
})

// Methods
const fetchInventory = async () => {
  try {
    loading.value = true
    error.value = null
    const response = await fetch(BASE_URL)
    if (!response.ok) throw new Error('Failed to fetch inventory')
    const data = await response.json()
    inventoryItems.value = Array.isArray(data) ? data : [data]
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const openAddModal = () => {
  resetForm()
  isEditing.value = false
  showModal.value = true
}

const resetForm = () => {
  currentInventory.value = {
    id: null,
    product_id: '',
    quantity: '',
    stock_id: ''
  }
}

const handleSubmit = async () => {
  try {
    loading.value = true
    const method = isEditing.value ? 'PUT' : 'POST'
    const url = isEditing.value ? `${BASE_URL}/${currentInventory.value.id}` : BASE_URL
    
    const response = await fetch(url, {
      method,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        product_id: currentInventory.value.product_id,
        quantity: currentInventory.value.quantity,
        stock_id: currentInventory.value.stock_id
      })
    })
    
    if (!response.ok) throw new Error(`Failed to ${isEditing.value ? 'update' : 'add'} inventory item`)
    const data = await response.json()
    
    if (isEditing.value) {
      const index = inventoryItems.value.findIndex(i => i.id === data.id)
      if (index !== -1) inventoryItems.value[index] = data
      showToastMessage('Inventory item updated successfully!')
    } else {
      inventoryItems.value.push(data)
      showToastMessage('Inventory item added successfully!')
    }
    
    closeModal()
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const editInventory = (item) => {
  currentInventory.value = { ...item }
  isEditing.value = true
  showModal.value = true
  activeMenuIndex.value = null
}

const deleteInventory = async (id) => {
  if (!confirm('Are you sure you want to delete this inventory item?')) return
  
  try {
    loading.value = true
    const response = await fetch(`${BASE_URL}/${id}`, { method: 'DELETE' })
    if (!response.ok) throw new Error('Failed to delete inventory item')
    
    inventoryItems.value = inventoryItems.value.filter(i => i.id !== id)
    showToastMessage('Inventory item deleted successfully!')
    activeMenuIndex.value = null
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const showInventory = (item) => {
  selectedInventory.value = item
  showDetailModal.value = true
  activeMenuIndex.value = null
}

const toggleMenu = (index) => {
  activeMenuIndex.value = activeMenuIndex.value === index ? null : index
}

const closeModal = () => {
  showModal.value = false
  isEditing.value = false
  resetForm()
  error.value = null
}

const getStockLevelClass = (quantity) => {
  const qty = parseInt(quantity)
  if (qty < 10) return 'inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800'
  if (qty <= 50) return 'inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800'
  return 'inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800'
}

const getStockLevelText = (quantity) => {
  const qty = parseInt(quantity)
  if (qty < 10) return 'Low Stock'
  if (qty <= 50) return 'Medium Stock'
  return 'High Stock'
}

const showToastMessage = (message) => {
  toastMessage.value = message
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 3000)
}

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (!event.target.closest('.relative')) {
    activeMenuIndex.value = null
  }
}

// Lifecycle
onMounted(() => {
  fetchInventory()
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>