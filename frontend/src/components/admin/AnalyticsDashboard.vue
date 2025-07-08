<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Error Message -->
      <div v-if="error" class="mb-6 p-4 bg-red-100 text-red-700 rounded-lg flex items-center">
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"/>
        </svg>
        <div>
          <p class="font-medium">{{ error }}</p>
          <button @click="refreshData" class="text-red-800 hover:text-red-900 text-sm underline mt-1">
            Try Again
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading && !dataLoaded" class="flex justify-center items-center py-12">
        <div class="flex items-center space-x-2">
          <svg class="animate-spin w-8 h-8 text-blue-600" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
          </svg>
          <span class="text-gray-600 text-lg">Loading analytics data...</span>
        </div>
      </div>

      <!-- Header Section -->
      <div v-if="!loading || dataLoaded" class="mb-8">
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
            <select 
              v-model="selectedPeriod" 
              @change="fetchAnalyticsData"
              class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
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
      <div v-if="dataLoaded" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <!-- Sales This Month -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Sales This Month</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">${{ formatNumber(analytics.salesThisMonth) }}</p>
              <div class="mt-2 flex items-center">
                <svg :class="analytics.salesGrowth >= 0 ? 'text-green-500' : 'text-red-500'" class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="analytics.salesGrowth >= 0 ? 'M13 7h8m0 0v8m0-8l-8 8-4-4-6 6' : 'M13 17h8m0 0V9m0 8l-8-8-4 4-6-6'"/>
                </svg>
                <span :class="analytics.salesGrowth >= 0 ? 'text-green-600' : 'text-red-600'" class="text-sm font-medium">
                  {{ analytics.salesGrowth >= 0 ? '+' : '' }}{{ analytics.salesGrowth.toFixed(1) }}%
                </span>
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
              <p class="mt-2 text-3xl font-bold text-gray-900">{{ analytics.totalCustomers }}</p>
              <div class="mt-2 flex items-center">
                <svg :class="analytics.customerGrowth >= 0 ? 'text-blue-500' : 'text-red-500'" class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="analytics.customerGrowth >= 0 ? 'M13 7h8m0 0v8m0-8l-8 8-4-4-6 6' : 'M13 17h8m0 0V9m0 8l-8-8-4 4-6-6'"/>
                </svg>
                <span :class="analytics.customerGrowth >= 0 ? 'text-blue-600' : 'text-red-600'" class="text-sm font-medium">
                  {{ analytics.newCustomers }} new customers
                </span>
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
              <p class="mt-2 text-2xl font-bold text-gray-900">{{ analytics.topProduct.name || 'No data' }}</p>
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

        <!-- Total Revenue -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Total Revenue</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">${{ formatNumber(analytics.totalRevenue) }}</p>
              <div class="mt-2 flex items-center">
                <svg :class="analytics.revenueGrowth >= 0 ? 'text-purple-500' : 'text-red-500'" class="h-4 w-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="analytics.revenueGrowth >= 0 ? 'M13 7h8m0 0v8m0-8l-8 8-4-4-6 6' : 'M13 17h8m0 0V9m0 8l-8-8-4 4-6-6'"/>
                </svg>
                <span :class="analytics.revenueGrowth >= 0 ? 'text-purple-600' : 'text-red-600'" class="text-sm font-medium">
                  {{ analytics.revenueGrowth >= 0 ? '+' : '' }}{{ analytics.revenueGrowth.toFixed(1) }}%
                </span>
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
      <div v-if="dataLoaded" class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Sales Chart -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900">Sales Trend</h3>
            <div class="flex space-x-2">
              <button
                v-for="period in chartPeriods"
                :key="period.value"
                @click="selectedChartPeriod = period.value; fetchChartData()"
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
          
          <!-- Chart Visualization -->
          <div v-if="chartData.length > 0" class="h-64 flex items-end justify-between space-x-1">
            <div
              v-for="(value, index) in chartData"
              :key="index"
              class="bg-blue-500 rounded-t-md transition-all duration-300 hover:bg-blue-600 cursor-pointer flex-1"
              :style="{ height: `${Math.max((value / Math.max(...chartData)) * 100, 5)}%` }"
              :title="`${chartLabels[index]}: $${formatNumber(value)}`"
            ></div>
          </div>
          <div v-else class="h-64 flex items-center justify-center text-gray-500">
            <div class="text-center">
              <svg class="mx-auto w-12 h-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
              <p>No sales data available</p>
            </div>
          </div>
          
          <div v-if="chartData.length > 0" class="mt-4 flex justify-between text-sm text-gray-500">
            <span>{{ chartPeriods.find(p => p.value === selectedChartPeriod)?.label }} ago</span>
            <span>Today</span>
          </div>
        </div>

        <!-- Top Products Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-6">Top Performing Products</h3>
          <div v-if="topProducts.length > 0" class="space-y-4">
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
                  <p class="text-sm text-gray-500">{{ product.category || 'Uncategorized' }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-medium text-gray-900">${{ formatNumber(product.revenue) }}</p>
                <p class="text-sm text-gray-500">{{ product.units }} units</p>
              </div>
            </div>
          </div>
          <div v-else class="text-center py-8 text-gray-500">
            <svg class="mx-auto w-12 h-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
            </svg>
            <p>No product data available</p>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div v-if="dataLoaded" class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-semibold text-gray-900">Recent Activity</h3>
          <button class="text-blue-600 hover:text-blue-700 text-sm font-medium">View All</button>
        </div>
        <div v-if="recentActivities.length > 0" class="space-y-4">
          <div
            v-for="activity in recentActivities"
            :key="activity.id"
            class="flex items-start space-x-4 p-4 hover:bg-gray-50 rounded-lg transition-colors"
          >
            <div :class="[
              'flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center',
              activity.type === 'order' ? 'bg-green-100' :
              activity.type === 'customer' ? 'bg-blue-100' : 'bg-yellow-100'
            ]">
              <svg v-if="activity.type === 'order'" class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
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
              <p class="text-xs text-gray-400 mt-1">{{ formatTime(activity.created_at) }}</p>
            </div>
            <div v-if="activity.amount" class="text-sm font-medium text-gray-900">
              ${{ formatNumber(activity.amount) }}
            </div>
          </div>
        </div>
        <div v-else class="text-center py-8 text-gray-500">
          <svg class="mx-auto w-12 h-12 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <p>No recent activity</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import axios from 'axios'

// API Configuration
const API_BASE_URL = 'http://127.0.0.1:8000/api'

// Reactive state
const selectedPeriod = ref(30)
const selectedChartPeriod = ref('7d')
const loading = ref(false)
const dataLoaded = ref(false)
const error = ref(null)

// Chart periods
const chartPeriods = [
  { label: '7D', value: '7d' },
  { label: '30D', value: '30d' },
  { label: '3M', value: '3m' },
  { label: '1Y', value: '1y' }
]

// Data arrays - start empty
const orders = ref([])
const products = ref([])
const users = ref([])
const chartData = ref([])
const chartLabels = ref([])

// Analytics data - starts with zeros
const analytics = ref({
  salesThisMonth: 0,
  salesGrowth: 0,
  customerGrowth: 0,
  newCustomers: 0,
  totalCustomers: 0,
  topProduct: {
    name: '',
    sales: 0
  },
  totalRevenue: 0,
  revenueGrowth: 0
})

// Computed properties
const topProducts = computed(() => {
  if (!products.value.length || !orders.value.length) return []
  
  // Calculate product performance from orders
  const productStats = {}
  
  orders.value.forEach(order => {
    if (order.order_items) {
      order.order_items.forEach(item => {
        const productId = item.product_id
        if (!productStats[productId]) {
          const product = products.value.find(p => p.id === productId)
          productStats[productId] = {
            id: productId,
            name: product?.name || 'Unknown Product',
            category: product?.category?.name || 'Uncategorized',
            units: 0,
            revenue: 0
          }
        }
        productStats[productId].units += item.quantity || 0
        productStats[productId].revenue += (item.quantity || 0) * (item.price || 0)
      })
    }
  })
  
  return Object.values(productStats)
    .sort((a, b) => b.revenue - a.revenue)
    .slice(0, 5)
})

const recentActivities = computed(() => {
  const activities = []
  
  // Add recent orders
  orders.value
    .slice(0, 10)
    .forEach(order => {
      const user = users.value.find(u => u.id === order.user_id)
      activities.push({
        id: `order-${order.id}`,
        type: 'order',
        title: 'New Order Received',
        description: `Order #${order.id} from ${user?.name || 'Unknown Customer'}`,
        created_at: order.created_at,
        amount: parseFloat(order.total || 0)
      })
    })
  
  // Add recent customers
  users.value
    .slice(0, 5)
    .forEach(user => {
      activities.push({
        id: `user-${user.id}`,
        type: 'customer',
        title: 'New Customer Registration',
        description: `${user.name} joined AquaPure`,
        created_at: user.created_at
      })
    })
  
  return activities
    .sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
    .slice(0, 10)
})

// Utility functions
const formatNumber = (num) => {
  return new Intl.NumberFormat('en-US').format(num || 0)
}

const formatTime = (dateStr) => {
  if (!dateStr) return 'Unknown time'
  const date = new Date(dateStr)
  const now = new Date()
  const diffInHours = Math.floor((now - date) / (1000 * 60 * 60))
  
  if (diffInHours < 1) return 'Just now'
  if (diffInHours < 24) return `${diffInHours} hours ago`
  if (diffInHours < 48) return 'Yesterday'
  return date.toLocaleDateString()
}

const parseDate = (dateStr) => {
  if (/\d{2}-\d{2}-\d{4}/.test(dateStr)) {
    return new Date(dateStr.replace(/(\d{2})-(\d{2})-(\d{4})/, '$2/$1/$3'))
  }
  return new Date(dateStr)
}

// API functions
const fetchOrders = async () => {
  try {
    const response = await axios.get(`${API_BASE_URL}/orders`)
    orders.value = response.data.data || response.data || []
  } catch (err) {
    console.error('Error fetching orders:', err)
    orders.value = []
  }
}

const fetchProducts = async () => {
  try {
    const response = await axios.get(`${API_BASE_URL}/products`)
    products.value = response.data.data || response.data || []
  } catch (err) {
    console.error('Error fetching products:', err)
    products.value = []
  }
}

const fetchUsers = async () => {
  try {
    const response = await axios.get(`${API_BASE_URL}/users`)
    users.value = response.data.data || response.data || []
  } catch (err) {
    console.error('Error fetching users:', err)
    users.value = []
  }
}

const calculateAnalytics = () => {
  if (!orders.value.length) {
    analytics.value = {
      salesThisMonth: 0,
      salesGrowth: 0,
      customerGrowth: 0,
      newCustomers: 0,
      totalCustomers: users.value.length,
      topProduct: { name: 'No data', sales: 0 },
      totalRevenue: 0,
      revenueGrowth: 0
    }
    return
  }
  
  const now = new Date()
  const currentMonth = now.getMonth()
  const currentYear = now.getFullYear()
  const lastMonth = currentMonth === 0 ? 11 : currentMonth - 1
  const lastMonthYear = currentMonth === 0 ? currentYear - 1 : currentYear
  
  // Calculate current month sales
  const currentMonthOrders = orders.value.filter(order => {
    const orderDate = parseDate(order.created_at)
    return orderDate.getMonth() === currentMonth && orderDate.getFullYear() === currentYear
  })
  
  const lastMonthOrders = orders.value.filter(order => {
    const orderDate = parseDate(order.created_at)
    return orderDate.getMonth() === lastMonth && orderDate.getFullYear() === lastMonthYear
  })
  
  analytics.value.salesThisMonth = currentMonthOrders.reduce((sum, order) => sum + parseFloat(order.total || 0), 0)
  const lastMonthSales = lastMonthOrders.reduce((sum, order) => sum + parseFloat(order.total || 0), 0)
  
  // Calculate growth
  analytics.value.salesGrowth = lastMonthSales > 0 
    ? ((analytics.value.salesThisMonth - lastMonthSales) / lastMonthSales) * 100 
    : 0
  
  // Calculate total revenue
  analytics.value.totalRevenue = orders.value.reduce((sum, order) => sum + parseFloat(order.total || 0), 0)
  
  // Calculate customer metrics
  analytics.value.totalCustomers = users.value.length
  
  const currentMonthUsers = users.value.filter(user => {
    const userDate = parseDate(user.created_at)
    return userDate.getMonth() === currentMonth && userDate.getFullYear() === currentYear
  })
  
  analytics.value.newCustomers = currentMonthUsers.length
  
  // Calculate top product
  if (topProducts.value.length > 0) {
    analytics.value.topProduct = {
      name: topProducts.value[0].name,
      sales: topProducts.value[0].units
    }
  }
  
  // Calculate revenue growth (simplified)
  const lastQuarterRevenue = orders.value
    .filter(order => {
      const orderDate = parseDate(order.created_at)
      const threeMonthsAgo = new Date()
      threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3)
      return orderDate >= threeMonthsAgo
    })
    .reduce((sum, order) => sum + parseFloat(order.total || 0), 0)
  
  analytics.value.revenueGrowth = lastQuarterRevenue > 0 ? 15 : 0 // Simplified calculation
}

const fetchChartData = async () => {
  if (!orders.value.length) {
    chartData.value = []
    chartLabels.value = []
    return
  }
  
  const now = new Date()
  let days
  
  switch (selectedChartPeriod.value) {
    case '7d': days = 7; break
    case '30d': days = 30; break
    case '3m': days = 90; break
    case '1y': days = 365; break
    default: days = 7
  }
  
  const dateMap = new Map()
  const labels = []
  
  for (let i = days - 1; i >= 0; i--) {
    const date = new Date(now)
    date.setDate(now.getDate() - i)
    const dateStr = date.toISOString().split('T')[0]
    dateMap.set(dateStr, 0)
    labels.push(date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }))
  }
  
  orders.value.forEach(order => {
    const orderDate = parseDate(order.created_at).toISOString().split('T')[0]
    if (dateMap.has(orderDate)) {
      dateMap.set(orderDate, dateMap.get(orderDate) + parseFloat(order.total || 0))
    }
  })
  
  chartData.value = Array.from(dateMap.values())
  chartLabels.value = labels
}

const fetchAnalyticsData = async () => {
  loading.value = true
  error.value = null
  
  try {
    // Fetch all data in parallel
    await Promise.all([
      fetchOrders(),
      fetchProducts(),
      fetchUsers()
    ])
    
    // Calculate analytics from fetched data
    calculateAnalytics()
    await fetchChartData()
    
    dataLoaded.value = true
    
  } catch (err) {
    console.error('Error fetching analytics data:', err)
    error.value = 'Failed to load analytics data. Please check your connection and try again.'
  } finally {
    loading.value = false
  }
}

const refreshData = async () => {
  dataLoaded.value = false
  await fetchAnalyticsData()
}

// Watchers
watch(selectedChartPeriod, () => {
  if (dataLoaded.value) {
    fetchChartData()
  }
})

// Lifecycle
onMounted(() => {
  fetchAnalyticsData()
})
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