<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header Section -->
      <div class="mb-8">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-4xl font-bold text-gray-900 flex items-center">
              <svg class="h-10 w-10 text-blue-600 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
              Analytics Dashboard
            </h2>
            <p class="mt-3 text-lg text-gray-600">
              View detailed analytics for AquaPure. Track sales, customer trends, and performance metrics.
            </p>
          </div>
          <div class="flex items-center space-x-4">
            <select v-model="selectedPeriod" class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
              <option value="7">Last 7 days</option>
              <option value="30">Last 30 days</option>
              <option value="90">Last 3 months</option>
              <option value="365">Last year</option>
            </select>
            <button 
              @click="refreshData"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center"
              :disabled="loading"
            >
              <svg class="h-4 w-4 mr-2" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
              </svg>
              Refresh
            </button>
          </div>
        </div>
      </div>

      <!-- Key Metrics Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Sales This Month -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Sales This Month</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">${{ formatNumber(analytics.salesThisMonth) }}</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-green-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span class="text-sm font-medium text-green-600">+{{ analytics.salesGrowth }}%</span>
                <span class="text-sm text-gray-500 ml-1">vs last month</span>
              </div>
            </div>
            <div class="p-3 bg-green-100 rounded-full">
              <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Customer Growth -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Customer Growth</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">+{{ analytics.customerGrowth }}%</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-blue-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span class="text-sm font-medium text-blue-600">{{ analytics.newCustomers }} new customers</span>
              </div>
            </div>
            <div class="p-3 bg-blue-100 rounded-full">
              <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Top Product -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Top Product</h3>
              <p class="mt-2 text-2xl font-bold text-gray-900">{{ analytics.topProduct.name }}</p>
              <div class="mt-2 flex items-center">
                <span class="text-sm font-medium text-yellow-600">{{ analytics.topProduct.sales }} units sold</span>
              </div>
            </div>
            <div class="p-3 bg-yellow-100 rounded-full">
              <svg class="w-8 h-8 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Revenue -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Total Revenue</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">${{ formatNumber(analytics.totalRevenue) }}</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-purple-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span class="text-sm font-medium text-purple-600">+{{ analytics.revenueGrowth }}%</span>
                <span class="text-sm text-gray-500 ml-1">this quarter</span>
              </div>
            </div>
            <div class="p-3 bg-purple-100 rounded-full">
              <svg class="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts and Tables Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Sales Chart -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900">Sales Trend</h3>
            <div class="flex space-x-2">
              <button 
                v-for="period in chartPeriods" 
                :key="period.value"
                @click="selectedChartPeriod = period.value"
                :class="[
                  'px-3 py-1 text-sm rounded-md transition-colors',
                  selectedChartPeriod === period.value 
                    ? 'bg-blue-100 text-blue-700' 
                    : 'text-gray-500 hover:text-gray-700'
                ]"
              >
                {{ period.label }}
              </button>
            </div>
          </div>
          <!-- Simple Chart Visualization -->
          <div class="h-64 flex items-end justify-between space-x-2">
            <div 
              v-for="(value, index) in chartData" 
              :key="index"
              class="bg-blue-500 rounded-t-md transition-all duration-300 hover:bg-blue-600 cursor-pointer"
              :style="{ height: `${(value / Math.max(...chartData)) * 100}%`, width: '100%' }"
              :title="`Day ${index + 1}: $${value}`"
            ></div>
          </div>
          <div class="mt-4 flex justify-between text-sm text-gray-500">
            <span>{{ chartPeriods.find(p => p.value === selectedChartPeriod)?.label }} ago</span>
            <span>Today</span>
          </div>
        </div>

        <!-- Top Products Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-6">Top Performing Products</h3>
          <div class="space-y-4">
            <div 
              v-for="(product, index) in topProducts" 
              :key="product.id"
              class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <div class="flex items-center">
                <div class="flex-shrink-0 w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                  <span class="text-blue-600 font-semibold">{{ index + 1 }}</span>
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium text-gray-900">{{ product.name }}</p>
                  <p class="text-sm text-gray-500">{{ product.category }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-medium text-gray-900">${{ formatNumber(product.revenue) }}</p>
                <p class="text-sm text-gray-500">{{ product.units }} units</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-semibold text-gray-900">Recent Activity</h3>
          <button class="text-blue-600 hover:text-blue-700 text-sm font-medium">View All</button>
        </div>
        <div class="space-y-4">
          <div 
            v-for="activity in recentActivities" 
            :key="activity.id"
            class="flex items-start space-x-4 p-4 hover:bg-gray-50 rounded-lg transition-colors"
          >
            <div :class="[
              'flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center',
              activity.type === 'sale' ? 'bg-green-100' : 
              activity.type === 'customer' ? 'bg-blue-100' : 'bg-yellow-100'
            ]">
              <svg v-if="activity.type === 'sale'" class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
              </svg>
              <svg v-else-if="activity.type === 'customer'" class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
              </svg>
              <svg v-else class="w-5 h-5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
              </svg>
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium text-gray-900">{{ activity.title }}</p>
              <p class="text-sm text-gray-500">{{ activity.description }}</p>
              <p class="text-xs text-gray-400 mt-1">{{ activity.time }}</p>
            </div>
            <div v-if="activity.amount" class="text-sm font-medium text-gray-900">
              ${{ formatNumber(activity.amount) }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

// Reactive state
const selectedPeriod = ref(30)
const selectedChartPeriod = ref('7d')
const loading = ref(false)

// Chart periods
const chartPeriods = [
  { label: '7D', value: '7d' },
  { label: '30D', value: '30d' },
  { label: '3M', value: '3m' },
  { label: '1Y', value: '1y' }
]

// Analytics data
const analytics = ref({
  salesThisMonth: 12500,
  salesGrowth: 8.2,
  customerGrowth: 15,
  newCustomers: 47,
  topProduct: {
    name: 'AquaFilter Pro',
    sales: 156
  },
  totalRevenue: 45780,
  revenueGrowth: 12.5
})

// Chart data (simulated)
const chartData = computed(() => {
  const baseData = {
    '7d': [1200, 1800, 1600, 2100, 1900, 2300, 2500],
    '30d': Array.from({ length: 30 }, (_, i) => Math.floor(Math.random() * 3000) + 1000),
    '3m': Array.from({ length: 90 }, (_, i) => Math.floor(Math.random() * 4000) + 1500),
    '1y': Array.from({ length: 365 }, (_, i) => Math.floor(Math.random() * 5000) + 2000)
  }
  return baseData[selectedChartPeriod.value] || baseData['7d']
})

// Top products data
const topProducts = ref([
  { id: 1, name: 'AquaFilter Pro', category: 'Water Filters', revenue: 8500, units: 156 },
  { id: 2, name: 'PureFlow System', category: 'Filtration Systems', revenue: 6200, units: 89 },
  { id: 3, name: 'CrystalClear Filter', category: 'Water Filters', revenue: 4800, units: 124 },
  { id: 4, name: 'AquaMax Purifier', category: 'Water Purifiers', revenue: 3900, units: 67 },
  { id: 5, name: 'FlowMaster Pro', category: 'Filtration Systems', revenue: 3200, units: 45 }
])

// Recent activities data
const recentActivities = ref([
  {
    id: 1,
    type: 'sale',
    title: 'New Sale Completed',
    description: 'AquaFilter Pro sold to John Smith',
    time: '2 minutes ago',
    amount: 299
  },
  {
    id: 2,
    type: 'customer',
    title: 'New Customer Registration',
    description: 'Sarah Johnson joined AquaPure',
    time: '15 minutes ago'
  },
  {
    id: 3,
    type: 'product',
    title: 'Low Stock Alert',
    description: 'CrystalClear Filter running low (5 units left)',
    time: '1 hour ago'
  },
  {
    id: 4,
    type: 'sale',
    title: 'Bulk Order Received',
    description: 'Corporate order from TechCorp Inc.',
    time: '2 hours ago',
    amount: 2450
  },
  {
    id: 5,
    type: 'customer',
    title: 'Customer Review',
    description: 'Mike Davis left a 5-star review',
    time: '3 hours ago'
  }
])

// Methods
const formatNumber = (num) => {
  return new Intl.NumberFormat('en-US').format(num)
}

const refreshData = async () => {
  loading.value = true
  // Simulate API call
  setTimeout(() => {
    // Update analytics with random variations
    analytics.value.salesThisMonth = Math.floor(Math.random() * 5000) + 10000
    analytics.value.salesGrowth = Math.floor(Math.random() * 20) + 5
    analytics.value.customerGrowth = Math.floor(Math.random() * 25) + 10
    analytics.value.newCustomers = Math.floor(Math.random() * 50) + 20
    loading.value = false
  }, 1000)
}

// Lifecycle
onMounted(() => {
  // Initialize component
})
</script>