
<template>
  <div v-if="activeTab === 'orders'" class="bg-white shadow rounded-lg">
    <!-- Orders Header -->
    <div class="px-6 py-4 border-b border-gray-200">
      <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between space-y-4 lg:space-y-0">
        <div>
          <h2 class="text-lg font-medium text-gray-900">Orders Management</h2>
          <p class="mt-1 text-sm text-gray-500">{{ filteredOrders.length }} orders found</p>
        </div>
        <div class="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-3">
          <div class="relative">
            <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <input
              type="search"
              placeholder="Search orders..."
              class="pl-10 pr-4 py-2 w-64 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              :value="orderSearch"
              @input="$emit('update:orderSearch', $event.target.value)"
            />
          </div>
          <select
            :value="orderFilter"
            @change="$emit('update:orderFilter', $event.target.value)"
            class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500"
          >
            <option value="all">All Orders</option>
            <option value="pending">Pending</option>
            <option value="processing">Processing</option>
            <option value="shipped">Shipped</option>
            <option value="completed">Completed</option>
            <option value="cancelled">Cancelled</option>
          </select>
          <input
            type="date"
            :value="dateFrom"
            @change="$emit('update:dateFrom', $event.target.value)"
            class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500"
          />
          <input
            type="date"
            :value="dateTo"
            @change="$emit('update:dateTo', $event.target.value)"
            class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500"
          />
          <div class="flex space-x-2">
            <button @click="$emit('export-orders')" class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
              <DownloadIcon class="h-4 w-4 mr-2" />
              Export
            </button>
            <button @click="$emit('update:show-add-order-modal', true)" class="inline-flex items-center px-3 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
              <PlusIcon class="h-4 w-4 mr-2" />
              Add Order
            </button>
          </div>
        </div>
      </div>
    </div>
    <!-- Bulk Actions -->
    <div v-if="selectedOrders.length > 0" class="px-6 py-3 bg-blue-50 border-b border-blue-200">
      <div class="flex items-center justify-between">
        <span class="text-sm font-medium text-blue-900">{{ selectedOrders.length }} orders selected</span>
        <div class="flex space-x-2">
          <select v-model="bulkAction" class="text-sm border-blue-300 rounded-md focus:border-blue-500 focus:ring-blue-500">
            <option value="">Bulk Actions</option>
            <option value="mark-processing">Mark as Processing</option>
            <option value="mark-shipped">Mark as Shipped</option>
            <option value="mark-completed">Mark as Completed</option>
            <option value="export-selected">Export Selected</option>
            <option value="delete">Delete</option>
          </select>
          <button @click="$emit('apply-bulk-action')" :disabled="!bulkAction" class="px-3 py-1 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 DISABLED:opacity-50">
            Apply
          </button>
          <button @click="$emit('clear-selection')" class="px-3 py-1 border border-blue-300 text-blue-700 text-sm rounded-md hover:bg-blue-100">
            Clear
          </button>
        </div>
      </div>
    </div>
    <!-- Orders Table -->
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              <input 
                type="checkbox" 
                :checked="selectedOrders.length === filteredOrders.length && filteredOrders.length > 0"
                @change="$emit('toggle-all-orders')"
                class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
              />
            </th>
            <th @click="$emit('sort-orders', 'id')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
              Order
              <component :is="getSortIcon('id')" class="inline h-4 w-4 ml-1" />
            </th>
            <th @click="$emit('sort-orders', 'customer')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
              Customer
              <component :is="getSortIcon('customer')" class="inline h-4 w-4 ml-1" />
            </th>
            <th @click="$emit('sort-orders', 'date')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
              Date
              <component :is="getSortIcon('date')" class="inline h-4 w-4 ml-1" />
            </th>
            <th @click="$emit('sort-orders', 'total')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
              Total
              <component :is="getSortIcon('total')" class="inline h-4 w-4 ml-1" />
            </th>
            <th @click="$emit('sort-orders', 'status')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
              Status
              <component :is="getSortIcon('status')" class="inline h-4 w-4 ml-1" />
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="order in paginatedOrders" :key="order.id" 
              :class="`hover:bg-gray-50 transition-colors ${selectedOrders.includes(order.id) ? 'bg-blue-50' : ''}`">
            <td class="px-6 py-4 whitespace-nowrap">
              <input 
                type="checkbox" 
                :checked="selectedOrders.includes(order.id)"
                @change="$emit('toggle-order-selection', order.id)"
                class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
              />
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm font-medium text-gray-900">#{{ order.id }}</div>
              <div class="text-sm text-gray-500">{{ order.items_count }} items</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm text-gray-900">{{ order.customer.name }}</div>
              <div class="text-sm text-gray-500">{{ order.customer.email }}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ formatDate(order.created_at) }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
              ${{ order.total.toFixed(2) }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span :class="getStatusClass(order.status)">{{ order.status }}</span>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
              <div class="flex space-x-2">
                <button @click="$emit('view-order', order)" class="text-blue-600 hover:text-blue-900" title="View">
                  <EyeIcon class="h-4 w-4" />
                </button>
                <button @click="$emit('edit-order', order)" class="text-green-600 hover:text-green-900" title="Edit">
                  <EditIcon class="h-4 w-4" />
                </button>
                <button @click="$emit('duplicate-order', order)" class="text-purple-600 hover:text-purple-900" title="Duplicate">
                  <CopyIcon class="h-4 w-4" />
                </button>
                <button @click="$emit('delete-order', order.id)" class="text-red-600 hover:text-red-900" title="Delete">
                  <TrashIcon class="h-4 w-4" />
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- Pagination -->
    <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
      <div class="flex-1 flex justify-between sm:hidden">
        <button @click="$emit('previous-page')" :disabled="currentPage === 1" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50">
          Previous
        </button>
        <button @click="$emit('next-page')" :disabled="currentPage === totalPages" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50">
          Next
        </button>
      </div>
      <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
        <div class="flex items-center space-x-2">
          <p class="text-sm text-gray-700">
            Showing <span class="font-medium">{{ (currentPage - 1) * itemsPerPage + 1 }}</span> to 
            <span class="font-medium">{{ Math.min(currentPage * itemsPerPage, filteredOrders.length) }}</span> of 
            <span class="font-medium">{{ filteredOrders.length }}</span> results
          </p>
          <select 
            :value="itemsPerPage" 
            @change="$emit('update:itemsPerPage', parseInt($event.target.value))" 
            class="text-sm border-gray-300 rounded-md"
          >
            <option :value="10">10 per page</option>
            <option :value="25">25 per page</option>
            <option :value="50">50 per page</option>
            <option :value="100">100 per page</option>
          </select>
        </div>
        <div>
          <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
            <button @click="$emit('previous-page')" :disabled="currentPage === 1" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50">
              <ChevronLeftIcon class="h-5 w-5" />
            </button>
            <button 
              v-for="page in visiblePages" 
              :key="page" 
              @click="$emit('update:currentPage', page)" 
              :class="`relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium ${currentPage === page ? 'bg-blue-50 text-blue-600' : 'bg-white text-gray-500 hover:bg-gray-50'}`"
            >
              {{ page }}
            </button>
            <button @click="$emit('next-page')" :disabled="currentPage === totalPages" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50">
              <ChevronRightIcon class="h-5 w-5" />
            </button>
          </nav>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { SearchIcon, DownloadIcon, PlusIcon, EyeIcon, EditIcon, CopyIcon, TrashIcon, ChevronLeftIcon, ChevronRightIcon, ArrowUpIcon, ArrowDownIcon } from 'lucide-vue-next'

defineProps({
  activeTab: String,
  orders: Array,
  filteredOrders: Array,
  paginatedOrders: Array,
  selectedOrders: Array,
  orderSearch: String,
  orderFilter: String,
  dateFrom: String,
  dateTo: String,
  currentPage: Number,
  itemsPerPage: Number,
  totalPages: Number,
  sortColumn: String,
  sortDirection: String
})

defineEmits([
  'export-orders',
  'update:show-add-order-modal',
  'view-order',
  'edit-order',
  'duplicate-order',
  'delete-order',
  'toggle-all-orders',
  'toggle-order-selection',
  'apply-bulk-action',
  'clear-selection',
  'previous-page',
  'next-page',
  'sort-orders',
  'update:itemsPerPage',
  'update:currentPage',
  'update:orderSearch',
  'update:orderFilter',
  'update:dateFrom',
  'update:dateTo'
])

const bulkAction = ref('')

const getStatusClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800 px-2 py-1 rounded-full',
    processing: 'bg-blue-100 text-blue-800 px-2 py-1 rounded-full',
    shipped: 'bg-green-100 text-green-800 px-2 py-1 rounded-full',
    completed: 'bg-gray-100 text-gray-800 px-2 py-1 rounded-full',
    cancelled: 'bg-red-100 text-red-800 px-2 py-1 rounded-full',
  }
  return classes[status.toLowerCase()] || 'bg-gray-100 text-gray-800 px-2 py-1 rounded-full'
}

const getSortIcon = (column) => {
  if (props.sortColumn !== column) return null
  return props.sortDirection === 'asc' ? ArrowUpIcon : ArrowDownIcon
}

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

const visiblePages = computed(() => {
  const pages = []
  const maxPages = 5
  let start = Math.max(1, props.currentPage - Math.floor(maxPages / 2))
  let end = Math.min(props.totalPages, start + maxPages - 1)
  if (end - start + 1 < maxPages) {
    start = Math.max(1, end - maxPages + 1)
  }
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  return pages
})
</script>