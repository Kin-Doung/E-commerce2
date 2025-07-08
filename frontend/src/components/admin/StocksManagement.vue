<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Stock Management</h1>
        <p class="text-gray-600">Manage your inventory efficiently</p>
      </div>

      <!-- Stats Cards -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-blue-100 rounded-lg">
              <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Total Items</p>
              <p class="text-2xl font-bold text-gray-900">{{ stocks.length }}</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-green-100 rounded-lg">
              <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Total Stock</p>
              <p class="text-2xl font-bold text-gray-900">{{ totalStock }}</p>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center">
            <div class="p-3 bg-red-100 rounded-lg">
              <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"/>
              </svg>
            </div>
            <div class="ml-4">
              <p class="text-sm font-medium text-gray-600">Low Stock</p>
              <p class="text-2xl font-bold text-gray-900">{{ lowStockItems }}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading && stocks.length === 0" class="flex justify-center items-center py-12">
        <div class="flex items-center space-x-2">
          <svg class="animate-spin w-6 h-6 text-blue-600" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
          </svg>
          <span class="text-gray-600">Loading stocks...</span>
        </div>
      </div>

      <!-- Alert -->
      <div v-if="alert" :class="`mb-6 p-4 rounded-lg flex items-center ${alert.type === 'success' ? 'bg-green-50 text-green-800 border border-green-200' : 'bg-red-50 text-red-800 border border-red-200'}`">
        <svg v-if="alert.type === 'success'" class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
        </svg>
        <svg v-else class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
        </svg>
        {{ alert.message }}
      </div>

      <!-- Search and Add Button -->
      <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
        <div class="relative flex-1 max-w-md">
          <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
          </svg>
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search stocks..."
            class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
        <button
          v-if="!showForm"
          @click="showForm = true"
          class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
          </svg>
          Add New Stock
        </button>
      </div>

      <!-- Add New Stock Form -->
      <div v-if="showForm" class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-6">
        <div class="flex items-center gap-3 mb-6">
          <svg class="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
          </svg>
          <h2 class="text-lg font-semibold text-gray-900">Add New Stock</h2>
        </div>
        <p class="text-gray-600 mb-6">Add a new item to your inventory</p>
        
        <form @submit.prevent="addStock" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label for="stock-name" class="block text-sm font-medium text-gray-700 mb-2">
                Stock Name
              </label>
              <input
                id="stock-name"
                v-model="newStock.name"
                type="text"
                placeholder="Enter stock name"
                required
                :disabled="isLoading"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100 transition-colors"
              />
              <p v-if="errors.name" class="text-red-600 text-sm mt-1">{{ errors.name }}</p>
            </div>
            
            <div>
              <label for="stock-quantity" class="block text-sm font-medium text-gray-700 mb-2">
                Quantity
              </label>
              <input
                id="stock-quantity"
                v-model.number="newStock.quantity"
                type="number"
                placeholder="Enter quantity"
                required
                min="0"
                :disabled="isLoading"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100 transition-colors"
              />
              <p v-if="errors.quantity" class="text-red-600 text-sm mt-1">{{ errors.quantity }}</p>
            </div>
          </div>
          
          <div class="flex gap-3 pt-4">
            <button
              type="submit"
              :disabled="isLoading"
              class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors flex items-center gap-2"
            >
              <svg v-if="isLoading" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
              </svg>
              {{ isLoading ? "Adding..." : "Add Stock" }}
            </button>
            <button
              type="button"
              @click="cancelForm"
              class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
            >
              Cancel
            </button>
          </div>
        </form>
      </div>

      <!-- Stocks Table -->
      <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden mb-6">
        <div class="px-6 py-4 border-b border-gray-200">
          <h3 class="text-lg font-semibold text-gray-900">Stock Inventory</h3>
        </div>
        
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Quantity</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="(stock, index) in filteredStocks" :key="stock.id" class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ index + 1 }}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900">{{ stock.name }}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ stock.quantity }}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${stock.quantity < 10 ? 'bg-red-100 text-red-800' : stock.quantity < 50 ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}`">
                    {{ stock.quantity < 10 ? 'Low Stock' : stock.quantity < 50 ? 'Medium' : 'In Stock' }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <!-- Actions Dropdown Menu -->
                  <div class="relative inline-block text-left">
                    <button
                      @click="toggleDropdown(stock.id)"
                      :disabled="isLoading"
                      class="inline-flex items-center px-3 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 transition-colors disabled:opacity-50 focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <span class="mr-2">Actions</span>
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                      </svg>
                    </button>

                    <!-- Dropdown Menu -->
                    <div
                      v-if="activeDropdown === stock.id"
                      class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg border border-gray-200 z-50"
                    >
                      <div class="py-1">
                        <!-- View Option -->
                        <button
                          @click="viewStock(stock)"
                          class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                        >
                          <svg class="w-4 h-4 mr-3 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                          </svg>
                          View Details
                        </button>

                        <!-- Edit Option -->
                        <button
                          @click="editStock(stock)"
                          class="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                        >
                          <svg class="w-4 h-4 mr-3 text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                          </svg>
                          Edit Stock
                        </button>

                        <!-- Divider -->
                        <div class="border-t border-gray-100"></div>

                        <!-- Delete Option -->
                        <button
                          @click="deleteStock(stock.id)"
                          class="flex items-center w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
                        >
                          <svg class="w-4 h-4 mr-3 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                          </svg>
                          Delete Stock
                        </button>
                      </div>
                    </div>
                  </div>
                </td>
              </tr>
              <tr v-if="!isLoading && filteredStocks.length === 0">
                <td colspan="5" class="px-6 py-12 text-center text-gray-500">
                  <svg class="mx-auto w-12 h-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"/>
                  </svg>
                  <p class="text-lg font-medium">No stocks found</p>
                  <p class="text-sm">{{ searchQuery ? 'Try adjusting your search' : 'Add your first stock item to get started' }}</p>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Chart Section -->
      <div v-if="filteredStocks.length > 0" class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">Stock Overview</h3>
        <div class="h-64">
          <canvas id="stockChart"></canvas>
        </div>
      </div>

      <!-- View Stock Modal -->
      <div v-if="showViewModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-xl max-w-md w-full mx-4">
          <div class="p-6">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">Stock Details</h3>
              <button
                @click="showViewModal = false"
                class="text-gray-400 hover:text-gray-600 transition-colors"
              >
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            </div>
            
            <div class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Stock Name</label>
                <p class="text-lg font-semibold text-gray-900">{{ viewStockData.name }}</p>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Quantity</label>
                <p class="text-lg font-semibold text-gray-900">{{ viewStockData.quantity }}</p>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <span :class="`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${viewStockData.quantity < 10 ? 'bg-red-100 text-red-800' : viewStockData.quantity < 50 ? 'bg-yellow-100 text-yellow-800' : 'bg-green-100 text-green-800'}`">
                  {{ viewStockData.quantity < 10 ? 'Low Stock' : viewStockData.quantity < 50 ? 'Medium Stock' : 'In Stock' }}
                </span>
              </div>
              
              <div v-if="viewStockData.id">
                <label class="block text-sm font-medium text-gray-700 mb-1">Stock ID</label>
                <p class="text-sm text-gray-600">#{{ viewStockData.id }}</p>
              </div>
            </div>
            
            <div class="flex gap-3 pt-6">
              <button
                @click="editStock(viewStockData)"
                class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
              >
                Edit Stock
              </button>
              <button
                @click="showViewModal = false"
                class="flex-1 px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Edit Modal -->
      <div v-if="showEditModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-xl shadow-xl max-w-md w-full mx-4">
          <div class="p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">Edit Stock</h3>
            <form @submit.prevent="updateStock" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Stock Name</label>
                <input
                  v-model="editStockData.name"
                  type="text"
                  required
                  :disabled="isLoading"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
                <input
                  v-model.number="editStockData.quantity"
                  type="number"
                  required
                  min="0"
                  :disabled="isLoading"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent disabled:bg-gray-100"
                />
              </div>
              <div class="flex gap-3 pt-4">
                <button
                  type="submit"
                  :disabled="isLoading"
                  class="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                >
                  {{ isLoading ? 'Updating...' : 'Update' }}
                </button>
                <button
                  type="button"
                  @click="showEditModal = false"
                  :disabled="isLoading"
                  class="flex-1 px-4 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 disabled:opacity-50 transition-colors"
                >
                  Cancel
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { Chart } from "chart.js/auto";
import { nextTick } from "vue";

export default {
  name: "StockManagement",
  data() {
    return {
      stocks: [],
      filteredStocks: [],
      newStock: {
        name: "",
        quantity: 0,
      },
      editStockData: {
        id: null,
        name: "",
        quantity: 0,
      },
      viewStockData: {
        id: null,
        name: "",
        quantity: 0,
      },
      errors: {
        name: "",
        quantity: "",
      },
      searchQuery: "",
      showEditModal: false,
      showViewModal: false,
      isLoading: false,
      currentPage: 1,
      perPage: 10,
      totalPages: 1,
      apiUrl: "http://127.0.0.1:8000/api/stocks",
      authToken: null,
      alert: null,
      chartInstance: null,
      showForm: false,
      activeDropdown: null, // Track which dropdown is open
    };
  },
  computed: {
    totalStock() {
      return this.filteredStocks.reduce((sum, stock) => sum + stock.quantity, 0);
    },
    lowStockItems() {
      return this.filteredStocks.filter((stock) => stock.quantity < 10).length;
    },
  },
  mounted() {
    this.fetchStocks();
    // Close dropdown when clicking outside
    document.addEventListener('click', this.closeDropdown);
  },
  beforeUnmount() {
    if (this.chartInstance) this.chartInstance.destroy();
    document.removeEventListener('click', this.closeDropdown);
  },
  watch: {
    stocks: {
      handler() {
        this.filterStocks();
        this.renderChart();
      },
      deep: true,
    },
    searchQuery() {
      this.filterStocks();
    },
  },
  methods: {
    toggleDropdown(stockId) {
      this.activeDropdown = this.activeDropdown === stockId ? null : stockId;
    },
    closeDropdown(event) {
      // Close dropdown if clicking outside
      if (!event.target.closest('.relative')) {
        this.activeDropdown = null;
      }
    },
    viewStock(stock) {
      this.viewStockData = {
        id: stock.id,
        name: stock.name,
        quantity: stock.quantity,
      };
      this.showViewModal = true;
      this.activeDropdown = null; // Close dropdown
    },
    showAlert(type, message) {
      this.alert = { type, message };
      setTimeout(() => {
        this.alert = null;
      }, 5000);
    },
    getHeaders() {
      const headers = {
        "Content-Type": "application/json",
      };
      if (this.authToken) {
        headers["Authorization"] = `Bearer ${this.authToken}`;
      }
      return headers;
    },
    async fetchStocks() {
      this.isLoading = true;
      try {
        const response = await fetch(
          `${this.apiUrl}?page=${this.currentPage}&per_page=${this.perPage}`,
          {
            method: "GET",
            headers: this.getHeaders(),
          }
        );
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        this.stocks = data.data || data;
        this.totalPages = data.total ? Math.ceil(data.total / data.per_page) : 1;
      } catch (error) {
        console.error('Error fetching stocks:', error);
        this.showAlert("error", `Failed to load stocks: ${error.message}`);
      } finally {
        this.isLoading = false;
      }
    },
    async addStock() {
      if (!this.validateForm()) return;
      
      this.isLoading = true;
      this.errors = { name: "", quantity: "" };
      
      try {
        const response = await fetch(this.apiUrl, {
          method: "POST",
          headers: this.getHeaders(),
          body: JSON.stringify(this.newStock),
        });
        
        if (!response.ok) {
          if (response.status === 422) {
            const errorData = await response.json();
            this.errors = { ...this.errors, ...errorData.errors };
            return;
          }
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        this.newStock = { name: "", quantity: 0 };
        this.showForm = false;
        await this.fetchStocks();
        this.showAlert("success", "Stock added successfully!");
      } catch (error) {
        console.error('Error adding stock:', error);
        this.showAlert("error", `Failed to add stock: ${error.message}`);
      } finally {
        this.isLoading = false;
      }
    },
    validateForm() {
      this.errors = { name: "", quantity: "" };
      let isValid = true;
      
      if (!this.newStock.name.trim()) {
        this.errors.name = "Stock name is required";
        isValid = false;
      }
      
      if (this.newStock.quantity < 0) {
        this.errors.quantity = "Quantity must be positive";
        isValid = false;
      }
      
      return isValid;
    },
    cancelForm() {
      this.showForm = false;
      this.newStock = { name: "", quantity: 0 };
      this.errors = { name: "", quantity: "" };
    },
    editStock(stock) {
      this.editStockData = {
        id: stock.id,
        name: stock.name,
        quantity: stock.quantity,
      };
      this.showEditModal = true;
      this.showViewModal = false; // Close view modal if open
      this.activeDropdown = null; // Close dropdown
    },
    async updateStock() {
      this.isLoading = true;
      try {
        const response = await fetch(`${this.apiUrl}/${this.editStockData.id}`, {
          method: "PUT",
          headers: this.getHeaders(),
          body: JSON.stringify({
            name: this.editStockData.name,
            quantity: this.editStockData.quantity,
          }),
        });
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        this.showEditModal = false;
        await this.fetchStocks();
        this.showAlert("success", "Stock updated successfully!");
      } catch (error) {
        console.error('Error updating stock:', error);
        this.showAlert("error", `Failed to update stock: ${error.message}`);
      } finally {
        this.isLoading = false;
      }
    },
    async deleteStock(id) {
      this.activeDropdown = null; // Close dropdown
      
      if (!confirm("Are you sure you want to delete this stock?")) return;
      
      this.isLoading = true;
      try {
        const response = await fetch(`${this.apiUrl}/${id}`, {
          method: "DELETE",
          headers: this.getHeaders(),
        });
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        await this.fetchStocks();
        this.showAlert("success", "Stock deleted successfully!");
      } catch (error) {
        console.error('Error deleting stock:', error);
        this.showAlert("error", `Failed to delete stock: ${error.message}`);
      } finally {
        this.isLoading = false;
      }
    },
    filterStocks() {
      this.filteredStocks = this.stocks.filter((stock) =>
        stock.name?.toLowerCase().includes(this.searchQuery?.toLowerCase() || "")
      );
    },
    renderChart() {
      nextTick(() => {
        const ctx = document.getElementById("stockChart")?.getContext("2d");
        if (!ctx || this.filteredStocks.length === 0) return;
        
        if (this.chartInstance) this.chartInstance.destroy();
        
        this.chartInstance = new Chart(ctx, {
          type: "bar",
          data: {
            labels: this.filteredStocks.map((s) => s.name || "Unknown"),
            datasets: [
              {
                label: "Quantity",
                data: this.filteredStocks.map((s) => s.quantity || 0),
                backgroundColor: "#3b82f6",
                borderColor: "#2563eb",
                borderWidth: 1,
                borderRadius: 4,
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { 
              legend: { display: false },
              tooltip: {
                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                titleColor: 'white',
                bodyColor: 'white',
                borderColor: '#3b82f6',
                borderWidth: 1,
              }
            },
            scales: {
              y: { 
                beginAtZero: true,
                grid: {
                  color: 'rgba(0, 0, 0, 0.1)',
                },
                ticks: {
                  color: '#6b7280',
                }
              },
              x: {
                grid: {
                  display: false,
                },
                ticks: {
                  color: '#6b7280',
                }
              }
            },
          },
        });
      });
    },
  },
};
</script>

<style scoped>
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>