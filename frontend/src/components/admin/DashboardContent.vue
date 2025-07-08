<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Header Section -->
      <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8">
        <div class="flex items-center justify-between">
          <div>
            <h2 class="text-4xl font-bold text-gray-900 flex items-center">
              <svg class="h-10 w-10 text-purple-600 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
              </svg>
              Admin Dashboard
            </h2>
            <p class="text-lg text-gray-600 mt-2">
              Welcome to the AquaPure Admin Dashboard. Monitor key metrics and manage your business operations.
            </p>
          </div>
          <div class="flex items-center space-x-4">
            <div class="text-right">
              <p class="text-sm text-gray-500">Last Updated</p>
              <p class="text-lg font-semibold text-gray-900">{{ currentTime }}</p>
            </div>
            <button 
              @click="refreshDashboard"
              class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors flex items-center"
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
        <!-- Total Orders -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer" @click="showOrderDetails">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Total Orders</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">{{ metrics.totalOrders.toLocaleString() }}</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-green-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span class="text-sm font-medium text-green-600">+{{ metrics.ordersGrowth }}%</span>
                <span class="text-sm text-gray-500 ml-1">vs last month</span>
              </div>
            </div>
            <div class="p-3 bg-green-100 rounded-full">
              <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Active Customers -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer" @click="showCustomerDetails">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Active Customers</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">{{ metrics.activeCustomers.toLocaleString() }}</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-blue-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span class="text-sm font-medium text-blue-600">+{{ metrics.customersGrowth }}%</span>
                <span class="text-sm text-gray-500 ml-1">this week</span>
              </div>
            </div>
            <div class="p-3 bg-blue-100 rounded-full">
              <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Pending Tasks -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer" @click="showTaskDetails">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Pending Tasks</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">{{ metrics.pendingTasks }}</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-yellow-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
                </svg>
                <span class="text-sm font-medium text-yellow-600">{{ metrics.urgentTasks }} urgent</span>
              </div>
            </div>
            <div class="p-3 bg-yellow-100 rounded-full">
              <svg class="w-8 h-8 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
            </div>
          </div>
        </div>

        <!-- Revenue -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer" @click="showRevenueDetails">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-sm font-medium text-gray-500 uppercase tracking-wide">Monthly Revenue</h3>
              <p class="mt-2 text-3xl font-bold text-gray-900">${{ metrics.monthlyRevenue.toLocaleString() }}</p>
              <div class="mt-2 flex items-center">
                <svg class="h-4 w-4 text-purple-500 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"/>
                </svg>
                <span class="text-sm font-medium text-purple-600">+{{ metrics.revenueGrowth }}%</span>
                <span class="text-sm text-gray-500 ml-1">vs target</span>
              </div>
            </div>
            <div class="p-3 bg-purple-100 rounded-full">
              <svg class="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>
              </svg>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts and Analytics Section -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
        <!-- Sales Chart -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900">Sales Overview</h3>
            <div class="flex space-x-2">
              <button 
                v-for="period in chartPeriods" 
                :key="period.value"
                @click="selectedChartPeriod = period.value"
                :class="[
                  'px-3 py-1 text-sm rounded-md transition-colors',
                  selectedChartPeriod === period.value 
                    ? 'bg-purple-100 text-purple-700' 
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
              class="bg-purple-500 rounded-t-md transition-all duration-300 hover:bg-purple-600 cursor-pointer"
              :style="{ height: `${(value / Math.max(...chartData)) * 100}%`, width: '100%' }"
              :title="`Day ${index + 1}: $${value.toLocaleString()}`"
            ></div>
          </div>
          <div class="mt-4 flex justify-between text-sm text-gray-500">
            <span>{{ chartPeriods.find(p => p.value === selectedChartPeriod)?.label }} ago</span>
            <span>Today</span>
          </div>
        </div>

        <!-- Recent Orders -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900">Recent Orders</h3>
            <button class="text-purple-600 hover:text-purple-700 text-sm font-medium">View All</button>
          </div>
          <div class="space-y-4">
            <div 
              v-for="order in recentOrders" 
              :key="order.id"
              class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
              @click="showOrderDetail(order)"
            >
              <div class="flex items-center">
                <div class="flex-shrink-0 w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
                  <span class="text-purple-600 font-semibold">#{{ order.id }}</span>
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium text-gray-900">{{ order.customer }}</p>
                  <p class="text-sm text-gray-500">{{ order.product }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-medium text-gray-900">${{ order.amount.toLocaleString() }}</p>
                <span :class="[
                  'text-xs px-2 py-1 rounded-full font-medium',
                  order.status === 'completed' ? 'bg-green-100 text-green-800' :
                  order.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                  'bg-red-100 text-red-800'
                ]">
                  {{ order.status }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Quick Actions and System Status -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
        <!-- Quick Actions -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-6">Quick Actions</h3>
          <div class="space-y-3">
            <button 
              v-for="action in quickActions" 
              :key="action.id"
              @click="executeAction(action)"
              class="w-full flex items-center p-3 text-left bg-gray-50 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <div :class="[
                'flex-shrink-0 w-8 h-8 rounded-lg flex items-center justify-center mr-3',
                action.color
              ]">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="action.icon"/>
                </svg>
              </div>
              <div>
                <p class="text-sm font-medium text-gray-900">{{ action.title }}</p>
                <p class="text-xs text-gray-500">{{ action.description }}</p>
              </div>
            </button>
          </div>
        </div>

        <!-- System Status -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-6">System Status</h3>
          <div class="space-y-4">
            <div 
              v-for="status in systemStatus" 
              :key="status.name"
              class="flex items-center justify-between"
            >
              <div class="flex items-center">
                <div :class="[
                  'w-3 h-3 rounded-full mr-3',
                  status.status === 'online' ? 'bg-green-500' :
                  status.status === 'warning' ? 'bg-yellow-500' : 'bg-red-500'
                ]"></div>
                <span class="text-sm font-medium text-gray-900">{{ status.name }}</span>
              </div>
              <span class="text-sm text-gray-500">{{ status.uptime }}</span>
            </div>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
          <h3 class="text-lg font-semibold text-gray-900 mb-6">Recent Activity</h3>
          <div class="space-y-4">
            <div 
              v-for="activity in recentActivity" 
              :key="activity.id"
              class="flex items-start space-x-3"
            >
              <div :class="[
                'flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center',
                activity.type === 'order' ? 'bg-green-100 text-green-600' :
                activity.type === 'user' ? 'bg-blue-100 text-blue-600' :
                'bg-yellow-100 text-yellow-600'
              ]">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="activity.icon"/>
                </svg>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium text-gray-900">{{ activity.title }}</p>
                <p class="text-xs text-gray-500">{{ activity.time }}</p>
              </div>
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
const loading = ref(false)
const selectedChartPeriod = ref('7d')
const showToast = ref(false)
const toastMessage = ref('')
const currentTime = ref('')

// Chart periods
const chartPeriods = [
  { label: '7D', value: '7d' },
  { label: '30D', value: '30d' },
  { label: '3M', value: '3m' },
  { label: '1Y', value: '1y' }
]

// Dashboard metrics
const metrics = ref({
  totalOrders: 1247,
  ordersGrowth: 12.5,
  activeCustomers: 856,
  customersGrowth: 8.3,
  pendingTasks: 5,
  urgentTasks: 2,
  monthlyRevenue: 45780,
  revenueGrowth: 15.2
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

// Recent orders data
const recentOrders = ref([
  { id: 1001, customer: 'John Smith', product: 'AquaFilter Pro', amount: 299, status: 'completed' },
  { id: 1002, customer: 'Sarah Johnson', product: 'PureFlow System', amount: 599, status: 'pending' },
  { id: 1003, customer: 'Mike Davis', product: 'CrystalClear Filter', amount: 199, status: 'completed' },
  { id: 1004, customer: 'Emily Brown', product: 'AquaMax Purifier', amount: 399, status: 'processing' },
  { id: 1005, customer: 'David Wilson', product: 'FlowMaster Pro', amount: 799, status: 'completed' }
])

// Quick actions
const quickActions = ref([
  {
    id: 1,
    title: 'Add New Product',
    description: 'Create a new product listing',
    icon: 'M12 6v6m0 0v6m0-6h6m-6 0H6',
    color: 'bg-blue-100 text-blue-600'
  },
  {
    id: 2,
    title: 'Process Orders',
    description: 'Review pending orders',
    icon: 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z',
    color: 'bg-green-100 text-green-600'
  },
  {
    id: 3,
    title: 'Customer Support',
    description: 'Handle customer inquiries',
    icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z',
    color: 'bg-purple-100 text-purple-600'
  },
  {
    id: 4,
    title: 'Generate Reports',
    description: 'Create analytics reports',
    icon: 'M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z',
    color: 'bg-yellow-100 text-yellow-600'
  }
])

// System status
const systemStatus = ref([
  { name: 'API Server', status: 'online', uptime: '99.9%' },
  { name: 'Database', status: 'online', uptime: '99.8%' },
  { name: 'Payment Gateway', status: 'warning', uptime: '98.5%' },
  { name: 'Email Service', status: 'online', uptime: '99.7%' }
])

// Recent activity
const recentActivity = ref([
  {
    id: 1,
    type: 'order',
    title: 'New order received',
    time: '2 minutes ago',
    icon: 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z'
  },
  {
    id: 2,
    type: 'user',
    title: 'New user registered',
    time: '15 minutes ago',
    icon: 'M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z'
  },
  {
    id: 3,
    type: 'system',
    title: 'System backup completed',
    time: '1 hour ago',
    icon: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z'
  },
  {
    id: 4,
    type: 'order',
    title: 'Order #1001 shipped',
    time: '2 hours ago',
    icon: 'M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4'
  }
])

// Methods
const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString('en-US', { 
    hour: '2-digit', 
    minute: '2-digit',
    hour12: true 
  })
}

const refreshDashboard = async () => {
  loading.value = true
  // Simulate API call
  setTimeout(() => {
    // Update metrics with random variations
    metrics.value.totalOrders = Math.floor(Math.random() * 500) + 1000
    metrics.value.activeCustomers = Math.floor(Math.random() * 300) + 700
    metrics.value.pendingTasks = Math.floor(Math.random() * 10) + 1
    metrics.value.monthlyRevenue = Math.floor(Math.random() * 20000) + 40000
    
    loading.value = false
    showToastMessage('Dashboard refreshed successfully!')
  }, 1000)
}

const showOrderDetails = () => {
  showToastMessage('Opening order details...')
}

const showCustomerDetails = () => {
  showToastMessage('Opening customer analytics...')
}

const showTaskDetails = () => {
  showToastMessage('Opening task manager...')
}

const showRevenueDetails = () => {
  showToastMessage('Opening revenue reports...')
}

const showOrderDetail = (order) => {
  showToastMessage(`Opening order #${order.id} details...`)
}

const executeAction = (action) => {
  showToastMessage(`Executing: ${action.title}`)
}

const showToastMessage = (message) => {
  toastMessage.value = message
  showToast.value = true
  setTimeout(() => {
    showToast.value = false
  }, 3000)
}

// Lifecycle
let timeInterval

onMounted(() => {
  updateTime()
  timeInterval = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  if (timeInterval) {
    clearInterval(timeInterval)
  }
})
</script>