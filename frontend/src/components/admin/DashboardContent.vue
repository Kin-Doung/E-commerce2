<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="dashboard max-w-7xl mx-auto">
        <!-- Header Section -->
        <div
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8"
        >
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-4xl font-bold text-gray-900 flex items-center">
                <svg
                  class="h-10 w-10 text-purple-600 mr-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
                  />
                </svg>
                Admin Dashboard
              </h2>
              <p class="text-lg text-gray-600 mt-2">
                Welcome to the Admin Dashboard. Monitor key metrics and manage
                your business operations.
              </p>
            </div>
            <div class="flex items-center space-x-4">
              <!-- Cart Button -->
              <button
                @click="showCartModal = true"
                class="relative px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center"
              >
                <svg
                  class="h-5 w-5 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-1.5 6M7 13l-1.5-6m0 0h15M17 21a2 2 0 100-4 2 2 0 000 4zM9 21a2 2 0 100-4 2 2 0 000 4z"
                  />
                </svg>
                Cart
                <span
                  v-if="allCarts.length > 0"
                  class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full h-5 w-5 flex items-center justify-center"
                >
                  {{ allCarts.length }}
                </span>
              </button>

              <div class="text-right">
                <p class="text-sm text-gray-500">Last Updated</p>
                <p class="text-lg font-semibold text-gray-900">
                  {{ currentTime }}
                </p>
              </div>
              <button
                @click="refreshDashboard"
                class="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors flex items-center"
                :disabled="loading"
              >
                <svg
                  class="h-4 w-4 mr-2"
                  :class="{ 'animate-spin': loading }"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                  />
                </svg>
                Refresh
              </button>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div
          v-if="loading && !dataLoaded"
          class="flex justify-center items-center py-12"
        >
          <div class="flex items-center space-x-2">
            <svg
              class="animate-spin w-8 h-8 text-purple-600"
              fill="none"
              viewBox="0 0 24 24"
            >
              <circle
                class="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                stroke-width="4"
              />
              <path
                class="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
              />
            </svg>
            <span class="text-gray-600 text-lg">Loading dashboard data...</span>
          </div>
        </div>

        <!-- Error State -->
        <div
          v-if="error && !dataLoaded"
          class="bg-red-50 border border-red-200 rounded-lg p-6 mb-8"
        >
          <div class="flex items-center">
            <svg
              class="w-6 h-6 text-red-600 mr-3"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"
              />
            </svg>
            <div>
              <h3 class="text-red-800 font-medium">
                Failed to load dashboard data
              </h3>
              <p class="text-red-600 text-sm mt-1">{{ error }}</p>
              <button
                @click="refreshDashboard"
                class="mt-2 text-red-600 hover:text-red-800 text-sm font-medium"
              >
                Try Again
              </button>
            </div>
          </div>
        </div>

        <!-- Key Metrics Grid -->
        <div
          v-if="dataLoaded"
          class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6 mb-8"
        >
          <!-- Total Orders -->
          <div
            class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer"
            @click="showOrderDetails"
          >
            <div class="flex items-center justify-between">
              <div>
                <h3
                  class="text-sm font-medium text-gray-500 uppercase tracking-wide"
                >
                  Total Orders
                </h3>
                <p class="mt-2 text-3xl font-bold text-gray-900">
                  {{ metrics.totalOrders.toLocaleString() }}
                </p>
                <div class="mt-2 flex items-center">
                  <svg
                    class="h-4 w-4 text-green-500 mr-1"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
                    />
                  </svg>
                  <span class="text-sm font-medium text-green-600"
                    >+{{ metrics.ordersGrowth }}%</span
                  >
                  <span class="text-sm text-gray-500 ml-1">vs last month</span>
                </div>
              </div>
              <div class="p-3 bg-green-100 rounded-full">
                <svg
                  class="w-8 h-8 text-green-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"
                  />
                </svg>
              </div>
            </div>
          </div>

          <!-- Active Carts -->
          <div
            class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer"
            @click="showCartModal = true"
          >
            <div class="flex items-center justify-between">
              <div>
                <h3
                  class="text-sm font-medium text-gray-500 uppercase tracking-wide"
                >
                  Active Carts
                </h3>
                <p class="mt-2 text-3xl font-bold text-gray-900">
                  {{ activeCarts.length }}
                </p>
                <div class="mt-2 flex items-center">
                  <svg
                    class="h-4 w-4 text-blue-500 mr-1"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
                    />
                  </svg>
                  <span class="text-sm font-medium text-blue-600"
                    >{{ abandonedCarts.length }} abandoned</span
                  >
                </div>
              </div>
              <div class="p-3 bg-blue-100 rounded-full">
                <svg
                  class="w-8 h-8 text-blue-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-1.5 6M7 13l-1.5-6m0 0h15"
                  />
                </svg>
              </div>
            </div>
          </div>

          <!-- Active Customers -->
          <div
            class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer"
            @click="showCustomerDetails"
          >
            <div class="flex items-center justify-between">
              <div>
                <h3
                  class="text-sm font-medium text-gray-500 uppercase tracking-wide"
                >
                  Active Customers
                </h3>
                <p class="mt-2 text-3xl font-bold text-gray-900">
                  {{ metrics.activeCustomers.toLocaleString() }}
                </p>
                <div class="mt-2 flex items-center">
                  <svg
                    class="h-4 w-4 text-blue-500 mr-1"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
                    />
                  </svg>
                  <span class="text-sm font-medium text-blue-600"
                    >+{{ metrics.customersGrowth }}%</span
                  >
                  <span class="text-sm text-gray-500 ml-1">this week</span>
                </div>
              </div>
              <div class="p-3 bg-blue-100 rounded-full">
                <svg
                  class="w-8 h-8 text-blue-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                  />
                </svg>
              </div>
            </div>
          </div>

          <!-- Pending Tasks -->
          <div
            class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer"
            @click="showTaskDetails"
          >
            <div class="flex items-center justify-between">
              <div>
                <h3
                  class="text-sm font-medium text-gray-500 uppercase tracking-wide"
                >
                  Pending Tasks
                </h3>
                <p class="mt-2 text-3xl font-bold text-gray-900">
                  {{ metrics.pendingTasks }}
                </p>
                <div class="mt-2 flex items-center">
                  <svg
                    class="h-4 w-4 text-yellow-500 mr-1"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"
                    />
                  </svg>
                  <span class="text-sm font-medium text-yellow-600"
                    >{{ metrics.urgentTasks }} urgent</span
                  >
                </div>
              </div>
              <div class="p-3 bg-yellow-100 rounded-full">
                <svg
                  class="w-8 h-8 text-yellow-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
            </div>
          </div>

          <!-- Monthly Revenue -->
          <div
            class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow cursor-pointer"
            @click="showRevenueDetails"
          >
            <div class="flex items-center justify-between">
              <div>
                <h3
                  class="text-sm font-medium text-gray-500 uppercase tracking-wide"
                >
                  Monthly Revenue
                </h3>
                <p class="mt-2 text-3xl font-bold text-gray-900">
                  ${{ metrics.monthlyRevenue.toLocaleString() }}
                </p>
                <div class="mt-2 flex items-center">
                  <svg
                    class="h-4 w-4 text-purple-500 mr-1"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
                    />
                  </svg>
                  <span class="text-sm font-medium text-purple-600"
                    >+{{ metrics.revenueGrowth }}%</span
                  >
                  <span class="text-sm text-gray-500 ml-1">vs target</span>
                </div>
              </div>
              <div class="p-3 bg-purple-100 rounded-full">
                <svg
                  class="w-8 h-8 text-purple-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"
                  />
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Charts Section -->
        <div
          v-if="dataLoaded"
          class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8"
        >
          <!-- Sales Chart -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between mb-6">
              <h3 class="text-lg font-semibold text-gray-900">
                Sales Overview
              </h3>
              <div class="flex space-x-2">
                <button
                  v-for="period in chartPeriods"
                  :key="period.value"
                  @click="selectedChartPeriod = period.value"
                  :class="[
                    'px-3 py-1 text-sm rounded-md transition-colors',
                    selectedChartPeriod === period.value
                      ? 'bg-purple-600 text-white'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200',
                  ]"
                >
                  {{ period.label }}
                </button>
              </div>
            </div>
            <div class="relative">
              <canvas id="salesChart" class="h-64"></canvas>
            </div>
          </div>

          <!-- Cart Status Chart -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center justify-between mb-6">
              <h3 class="text-lg font-semibold text-gray-900">Cart Status</h3>
              <button
                @click="fetchCartData"
                class="text-blue-600 hover:text-blue-700 text-sm font-medium"
              >
                Refresh
              </button>
            </div>
            <div class="relative">
              <canvas id="cartPieChart" class="h-64"></canvas>
            </div>
            <div class="mt-4 space-y-2">
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <div class="w-3 h-3 bg-green-500 rounded-full mr-2"></div>
                  <span class="text-sm text-gray-600">Active Carts</span>
                </div>
                <span class="text-sm font-medium text-gray-900">{{
                  activeCarts.length
                }}</span>
              </div>
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <div class="w-3 h-3 bg-red-500 rounded-full mr-2"></div>
                  <span class="text-sm text-gray-600">Abandoned Carts</span>
                </div>
                <span class="text-sm font-medium text-gray-900">{{
                  abandonedCarts.length
                }}</span>
              </div>
              <div class="flex items-center justify-between">
                <div class="flex items-center">
                  <div class="w-3 h-3 bg-blue-500 rounded-full mr-2"></div>
                  <span class="text-sm text-gray-600">Completed Orders</span>
                </div>
                <span class="text-sm font-medium text-gray-900">{{
                  metrics.totalOrders
                }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Orders -->
        <div
          v-if="dataLoaded"
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-8"
        >
          <div class="flex items-center justify-between mb-6">
            <h3 class="text-lg font-semibold text-gray-900">Recent Orders</h3>
            <button
              class="text-purple-600 hover:text-purple-700 text-sm font-medium"
            >
              View All
            </button>
          </div>
          <div
            v-if="recentOrders.length === 0"
            class="text-center py-8 text-gray-500"
          >
            <svg
              class="mx-auto w-12 h-12 text-gray-400 mb-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"
              />
            </svg>
            <p class="text-lg font-medium">No recent orders</p>
            <p class="text-sm">
              Orders will appear here once customers start placing them
            </p>
          </div>
          <div v-else class="space-y-4">
            <div
              v-for="order in recentOrders"
              :key="order.id"
              class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
              @click="showOrderDetail(order)"
            >
              <div class="flex items-center">
                <div
                  class="flex-shrink-0 w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center"
                >
                  <span class="text-purple-600 font-semibold"
                    >#{{ order.id }}</span
                  >
                </div>
                <div class="ml-4">
                  <p class="text-sm font-medium text-gray-900">
                    {{ order.customer }}
                  </p>
                  <p class="text-sm text-gray-500">{{ order.product }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="text-sm font-medium text-gray-900">
                  ${{ order.amount.toLocaleString() }}
                </p>
                <span
                  :class="[
                    'text-xs px-2 py-1 rounded-full font-medium',
                    order.status === 'completed'
                      ? 'bg-green-100 text-green-800'
                      : order.status === 'pending'
                      ? 'bg-yellow-100 text-yellow-800'
                      : 'bg-red-100 text-red-800',
                  ]"
                >
                  {{ order.status }}
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Cart Modal -->
        <div
          v-if="showCartModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-4xl w-full max-h-[90vh] overflow-hidden"
          >
            <div
              class="flex items-center justify-between p-6 border-b border-gray-200"
            >
              <h3 class="text-xl font-semibold text-gray-900">
                Cart Management
              </h3>
              <button
                @click="showCartModal = false"
                class="text-gray-400 hover:text-gray-600"
              >
                <svg
                  class="w-6 h-6"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>

            <div class="p-6 overflow-y-auto max-h-[70vh]">
              <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                <div class="bg-blue-50 p-4 rounded-lg">
                  <h4 class="text-sm font-medium text-blue-900 mb-2">
                    Active Carts
                  </h4>
                  <p class="text-2xl font-bold text-blue-900">
                    {{ activeCarts.length }}
                  </p>
                </div>
                <div class="bg-red-50 p-4 rounded-lg">
                  <h4 class="text-sm font-medium text-red-900 mb-2">
                    Abandoned Carts
                  </h4>
                  <p class="text-2xl font-bold text-red-900">
                    {{ abandonedCarts.length }}
                  </p>
                </div>
                <div class="bg-green-50 p-4 rounded-lg">
                  <h4 class="text-sm font-medium text-green-900 mb-2">
                    Total Value
                  </h4>
                  <p class="text-2xl font-bold text-green-900">
                    ${{ totalCartValue.toFixed(2) }}
                  </p>
                </div>
              </div>

              <div class="space-y-4">
                <h4 class="text-lg font-semibold text-gray-900">All Carts</h4>
                <div
                  v-if="allCarts.length === 0"
                  class="text-center py-8 text-gray-500"
                >
                  <svg
                    class="mx-auto w-12 h-12 text-gray-400 mb-4"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-1.5 6M7 13l-1.5-6m0 0h15"
                    />
                  </svg>
                  <p class="text-lg font-medium">No carts found</p>
                  <p class="text-sm">
                    Carts will appear here when customers add items
                  </p>
                </div>
                <div v-else class="space-y-3">
                  <div
                    v-for="cart in allCarts"
                    :key="cart.id"
                    class="flex items-center justify-between p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
                  >
                    <div class="flex items-center">
                      <div
                        class="w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center mr-4"
                      >
                        <svg
                          class="w-6 h-6 text-gray-600"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-1.5 6M7 13l-1.5-6m0 0h15"
                          />
                        </svg>
                      </div>
                      <div>
                        <p class="text-sm font-medium text-gray-900">
                          Cart #{{ cart.id }}
                        </p>
                        <p class="text-sm text-gray-500">
                          {{ cart.user_name || `User #${cart.user_id}` }}
                        </p>
                        <p class="text-xs text-gray-400">
                          {{ cart.items_count }} items •
                          {{ formatTime(cart.updated_at) }}
                        </p>
                      </div>
                    </div>
                    <div class="text-right">
                      <p class="text-sm font-medium text-gray-900">
                        ${{ cart.total_value.toFixed(2) }}
                      </p>
                      <span
                        :class="[
                          'text-xs px-2 py-1 rounded-full font-medium',
                          cart.status === 'active'
                            ? 'bg-green-100 text-green-800'
                            : 'bg-red-100 text-red-800',
                        ]"
                      >
                        {{ cart.status }}
                      </span>
                      <div class="mt-2 space-x-2">
                        <button
                          @click="viewCartDetails(cart)"
                          class="text-xs text-blue-600 hover:text-blue-800"
                        >
                          View
                        </button>
                        <button
                          @click="deleteCart(cart.id)"
                          class="text-xs text-red-600 hover:text-red-800"
                        >
                          Delete
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Toast Notification -->
        <div
          v-if="showToast"
          class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 flex items-center"
        >
          <svg
            class="h-5 w-5 mr-2"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
          {{ toastMessage }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from "vue";
import axios from "axios";
import { Chart } from "chart.js/auto";

// Base API URL - Update this to match your backend
const API_BASE_URL = "http://127.0.0.1:8000/api";

// Reactive state
const loading = ref(false);
const dataLoaded = ref(false);
const error = ref("");
const selectedChartPeriod = ref("7d");
const showToast = ref(false);
const toastMessage = ref("");
const currentTime = ref("");
const showCartModal = ref(false);

// Data arrays - start empty, no fake data
const allCarts = ref([]);
const activeCarts = ref([]);
const abandonedCarts = ref([]);
const recentOrders = ref([]);
const products = ref([]);
const users = ref([]);
const orders = ref([]);

// Metrics object - starts with zeros
const metrics = ref({
  totalOrders: 0,
  ordersGrowth: 0,
  activeCustomers: 0,
  customersGrowth: 0,
  pendingTasks: 0,
  urgentTasks: 0,
  monthlyRevenue: 0,
  revenueGrowth: 0,
});

const chartData = ref({ labels: [], data: [] });

// Chart periods
const chartPeriods = [
  { label: "7D", value: "7d" },
  { label: "30D", value: "30d" },
  { label: "3M", value: "3m" },
  { label: "1Y", value: "1y" },
];

// Computed properties
const totalCartValue = computed(() => {
  return allCarts.value.reduce((sum, cart) => sum + cart.total_value, 0);
});

// Utility functions
const parseDate = (dateStr) => {
  if (/\d{2}-\d{2}-\d{4}/.test(dateStr)) {
    return new Date(dateStr.replace(/(\d{2})-(\d{2})-(\d{4})/, "$2/$1/$3"));
  }
  return new Date(dateStr);
};

const formatTime = (dateStr) => {
  return parseDate(dateStr).toLocaleString("en-US", {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const updateTime = () => {
  const now = new Date();
  currentTime.value = now.toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
    hour12: true,
  });
};

// API functions
const fetchCartData = async () => {
  try {
    const response = await axios.get(`${API_BASE_URL}/carts`);
    const carts = response.data.data || response.data;

    allCarts.value = carts.map((cart) => ({
      id: cart.id,
      user_id: cart.user_id,
      user_name: cart.user?.name || null,
      items_count: cart.cart_items?.length || 0,
      total_value:
        cart.cart_items?.reduce(
          (sum, item) => sum + item.quantity * item.price,
          0
        ) || 0,
      status: cart.status || "active",
      updated_at: cart.updated_at,
      created_at: cart.created_at,
    }));

    activeCarts.value = allCarts.value.filter(
      (cart) => cart.status === "active"
    );
    abandonedCarts.value = allCarts.value.filter(
      (cart) => cart.status === "abandoned"
    );

    initPieChart();
  } catch (error) {
    console.error("Error fetching cart data:", error);
    showToastMessage("Failed to load cart data");
  }
};

const fetchDashboardData = async () => {
  loading.value = true;
  error.value = "";

  try {
    // Fetch all data in parallel
    const [usersResponse, ordersResponse, productsResponse] = await Promise.all(
      [
        axios.get(`${API_BASE_URL}/users`).catch(() => ({ data: [] })),
        axios.get(`${API_BASE_URL}/orders`).catch(() => ({ data: [] })),
        axios.get(`${API_BASE_URL}/products`).catch(() => ({ data: [] })),
      ]
    );

    users.value = usersResponse.data.data || usersResponse.data || [];
    orders.value = ordersResponse.data.data || ordersResponse.data || [];
    products.value = productsResponse.data.data || productsResponse.data || [];

    // Calculate metrics from real data
    calculateMetrics();

    // Fetch cart data
    await fetchCartData();

    // Fetch chart data
    await fetchChartData();

    dataLoaded.value = true;
  } catch (err) {
    console.error("Error fetching dashboard data:", err);
    error.value =
      err.response?.data?.message ||
      err.message ||
      "Failed to load dashboard data";
  } finally {
    loading.value = false;
  }
};

const calculateMetrics = () => {
  // Calculate metrics from real data
  metrics.value.totalOrders = orders.value.length;

  // Get unique customers from orders
  const uniqueCustomers = [
    ...new Set(orders.value.map((order) => order.user_id)),
  ];
  metrics.value.activeCustomers = uniqueCustomers.length;

  // Calculate pending tasks (orders without completed status)
  metrics.value.pendingTasks = orders.value.filter(
    (order) => !order.order_items?.some((item) => item.status === "completed")
  ).length;

  // Calculate monthly revenue
  const currentMonth = new Date().getMonth() + 1;
  const currentYear = new Date().getFullYear();

  metrics.value.monthlyRevenue = orders.value
    .filter((order) => {
      const orderDate = parseDate(order.created_at);
      return (
        orderDate.getMonth() + 1 === currentMonth &&
        orderDate.getFullYear() === currentYear
      );
    })
    .reduce((sum, order) => sum + Number(order.total || 0), 0);

  // Calculate growth percentages (simplified - you might want to implement proper comparison)
  metrics.value.ordersGrowth = Math.floor(Math.random() * 20); // Placeholder
  metrics.value.customersGrowth = Math.floor(Math.random() * 15); // Placeholder
  metrics.value.revenueGrowth = Math.floor(Math.random() * 25); // Placeholder
  metrics.value.urgentTasks = Math.floor(metrics.value.pendingTasks * 0.3); // Placeholder

  // Set recent orders
  recentOrders.value = orders.value.slice(0, 5).map((order) => ({
    id: order.id,
    customer:
      users.value.find((u) => u.id === order.user_id)?.name ||
      "Unknown Customer",
    product:
      products.value.find((p) => p.id === order.order_items?.[0]?.product_id)
        ?.name || "Unknown Product",
    amount: Number(order.total || 0),
    status: order.order_items?.[0]?.status || "pending",
  }));
};

const fetchChartData = async () => {
  try {
    const now = new Date();
    let days;
    switch (selectedChartPeriod.value) {
      case "7d":
        days = 7;
        break;
      case "30d":
        days = 30;
        break;
      case "3m":
        days = 90;
        break;
      case "1y":
        days = 365;
        break;
      default:
        days = 7;
    }

    const dateMap = new Map();
    for (let i = 0; i < days; i++) {
      const date = new Date(now);
      date.setDate(now.getDate() - i);
      const dateStr = date.toISOString().split("T")[0];
      dateMap.set(dateStr, 0);
    }

    orders.value.forEach((order) => {
      const orderDate = parseDate(order.created_at).toISOString().split("T")[0];
      if (dateMap.has(orderDate)) {
        dateMap.set(
          orderDate,
          dateMap.get(orderDate) + Number(order.total || 0)
        );
      }
    });

    chartData.value = {
      labels: Array.from(dateMap.keys())
        .reverse()
        .map((date) => {
          const d = new Date(date);
          return `${d.getDate()}/${d.getMonth() + 1}`;
        }),
      data: Array.from(dateMap.values()).reverse(),
    };

    initChart();
  } catch (error) {
    console.error("Error fetching chart data:", error);
  }
};

// Chart instances
let chartInstance = null;
let pieChartInstance = null;

const initChart = () => {
  const ctx = document.getElementById("salesChart")?.getContext("2d");
  if (!ctx) return;

  if (chartInstance) {
    chartInstance.destroy();
    chartInstance = null;
  }

  chartInstance = new Chart(ctx, {
    type: "bar",
    data: {
      labels: chartData.value.labels || [],
      datasets: [
        {
          label: "Sales",
          data: chartData.value.data || [],
          backgroundColor: "rgba(147, 51, 234, 0.6)",
          borderColor: "rgba(147, 51, 234, 1)",
          borderWidth: 1,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: (value) => `$${value.toLocaleString()}`,
          },
        },
      },
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: (context) => `$${context.raw.toLocaleString()}`,
          },
        },
      },
    },
  });
};

const initPieChart = () => {
  const ctx = document.getElementById("cartPieChart")?.getContext("2d");
  if (!ctx) return;

  if (pieChartInstance) {
    pieChartInstance.destroy();
    pieChartInstance = null;
  }

  const activeCount = activeCarts.value.length;
  const abandonedCount = abandonedCarts.value.length;
  const completedCount = metrics.value.totalOrders;

  pieChartInstance = new Chart(ctx, {
    type: "pie",
    data: {
      labels: ["Active Carts", "Abandoned Carts", "Completed Orders"],
      datasets: [
        {
          data: [activeCount, abandonedCount, completedCount],
          backgroundColor: ["#10B981", "#EF4444", "#3B82F6"],
          borderColor: ["#059669", "#DC2626", "#2563EB"],
          borderWidth: 2,
        },
      ],
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: (context) => {
              const label = context.label || "";
              const value = context.raw || 0;
              const total = context.dataset.data.reduce((a, b) => a + b, 0);
              const percentage =
                total > 0 ? ((value / total) * 100).toFixed(1) : 0;
              return `${label}: ${value} (${percentage}%)`;
            },
          },
        },
      },
    },
  });
};

// Event handlers
const refreshDashboard = async () => {
  await fetchDashboardData();
  showToastMessage("Dashboard refreshed successfully!");
};

const viewCartDetails = (cart) => {
  showToastMessage(`Viewing details for Cart #${cart.id}`);
};

const deleteCart = async (cartId) => {
  if (confirm("Are you sure you want to delete this cart?")) {
    try {
      await axios.delete(`${API_BASE_URL}/carts/${cartId}`);
      await fetchCartData();
      showToastMessage("Cart deleted successfully!");
    } catch (error) {
      console.error("Error deleting cart:", error);
      showToastMessage("Failed to delete cart");
    }
  }
};

const showOrderDetails = () => {
  showToastMessage("Opening order details...");
};

const showCustomerDetails = () => {
  showToastMessage("Opening customer analytics...");
};

const showTaskDetails = () => {
  showToastMessage("Opening task manager...");
};

const showRevenueDetails = () => {
  showToastMessage("Opening revenue reports...");
};

const showOrderDetail = (order) => {
  showToastMessage(`Opening order #${order.id} details...`);
};

const showToastMessage = (message) => {
  toastMessage.value = message;
  showToast.value = true;
  setTimeout(() => {
    showToast.value = false;
  }, 3000);
};

// Watchers
watch(selectedChartPeriod, () => {
  fetchChartData();
});

// Lifecycle
let timeInterval;

onMounted(() => {
  updateTime();
  timeInterval = setInterval(updateTime, 1000);
  fetchDashboardData();
});

onUnmounted(() => {
  if (timeInterval) clearInterval(timeInterval);
  if (chartInstance) {
    chartInstance.destroy();
    chartInstance = null;
  }
  if (pieChartInstance) {
    pieChartInstance.destroy();
    pieChartInstance = null;
  }
});
</script>

<style scoped>
.container{
  display: flex;
}
.dashboard {
  width: 85%;
  margin-right: -20px;
}
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