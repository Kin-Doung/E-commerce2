<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Top Navigation Bar -->
    <nav class="bg-white shadow-sm border-b border-gray-200 fixed w-full top-0 z-50">
      <div class="px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <!-- Left side -->
          <div class="flex items-center space-x-4">
            <button @click="sidebarOpen = !sidebarOpen" class="lg:hidden p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100">
              <MenuIcon class="h-6 w-6" />
            </button>
            <div class="flex items-center space-x-2">
              <DropletIcon class="h-8 w-8 text-blue-600" />
              <span class="text-xl font-bold text-blue-900">AquaPure Admin</span>
            </div>
          </div>

          <!-- Right side -->
          <div class="flex items-center space-x-4">
            <!-- Global Search -->
            <div class="hidden md:block relative">
              <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <input
                type="search"
                placeholder="Search orders, customers, products..."
                class="pl-10 pr-4 py-2 w-80 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                v-model="globalSearch"
                @input="handleGlobalSearch"
              />
              <!-- Search Results Dropdown -->
              <div v-if="searchResults.length > 0 && globalSearch" class="absolute top-full left-0 right-0 mt-1 bg-white border border-gray-200 rounded-lg shadow-lg z-50 max-h-64 overflow-y-auto">
                <div class="p-2">
                  <div v-for="result in searchResults" :key="result.id" @click="selectSearchResult(result)" class="p-2 hover:bg-gray-50 rounded cursor-pointer">
                    <div class="flex items-center space-x-3">
                      <div :class="`p-1 rounded ${result.type === 'order' ? 'bg-blue-100' : result.type === 'customer' ? 'bg-green-100' : 'bg-purple-100'}`">
                        <component :is="result.type === 'order' ? ShoppingCartIcon : result.type === 'customer' ? UsersIcon : PackageIcon" class="h-4 w-4" />
                      </div>
                      <div>
                        <p class="text-sm font-medium text-gray-900">{{ result.title }}</p>
                        <p class="text-xs text-gray-500">{{ result.subtitle }}</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Quick Actions -->
            <div class="flex items-center space-x-2">
              <button @click="showQuickAdd = true" class="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg" title="Quick Add">
                <PlusIcon class="h-5 w-5" />
              </button>
              <button @click="exportData" class="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg" title="Export Data">
                <DownloadIcon class="h-5 w-5" />
              </button>
              <button @click="refreshData" class="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg" title="Refresh">
                <RefreshCwIcon class="h-5 w-5" :class="{ 'animate-spin': isRefreshing }" />
              </button>
            </div>

            <!-- Notifications -->
            <div class="relative">
              <button @click="showNotifications = !showNotifications" class="p-2 text-gray-400 hover:text-gray-500 relative">
                <BellIcon class="h-6 w-6" />
                <span v-if="unreadNotifications > 0" class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center animate-pulse">
                  {{ unreadNotifications }}
                </span>
              </button>
              
              <!-- Notifications Dropdown -->
              <div v-if="showNotifications" class="absolute right-0 mt-2 w-96 bg-white rounded-lg shadow-lg border border-gray-200 z-50">
                <div class="p-4 border-b border-gray-200 flex items-center justify-between">
                  <h3 class="text-lg font-semibold text-gray-900">Notifications</h3>
                  <div class="flex space-x-2">
                    <button @click="markAllAsRead" class="text-sm text-blue-600 hover:text-blue-700">Mark all read</button>
                    <button @click="clearAllNotifications" class="text-sm text-red-600 hover:text-red-700">Clear all</button>
                  </div>
                </div>
                <div class="max-h-80 overflow-y-auto">
                  <div v-if="notifications.length === 0" class="p-8 text-center text-gray-500">
                    <BellIcon class="h-12 w-12 mx-auto mb-2 text-gray-300" />
                    <p>No notifications</p>
                  </div>
                  <div v-for="notification in notifications" :key="notification.id" 
                       @click="handleNotificationClick(notification)"
                       :class="`p-4 border-b border-gray-100 hover:bg-gray-50 cursor-pointer transition-colors ${!notification.read ? 'bg-blue-50' : ''}`">
                    <div class="flex items-start space-x-3">
                      <div :class="`p-2 rounded-full ${getNotificationColor(notification.type)}`">
                        <component :is="getNotificationIcon(notification.type)" class="h-4 w-4" />
                      </div>
                      <div class="flex-1 min-w-0">
                        <p :class="`text-sm ${!notification.read ? 'font-semibold' : 'font-medium'} text-gray-900`">{{ notification.title }}</p>
                        <p class="text-sm text-gray-500 truncate">{{ notification.message }}</p>
                        <p class="text-xs text-gray-400 mt-1">{{ formatTimeAgo(notification.time) }}</p>
                      </div>
                      <button @click.stop="removeNotification(notification.id)" class="text-gray-400 hover:text-gray-600">
                        <XIcon class="h-4 w-4" />
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- User Menu -->
            <div class="relative">
              <button @click="showUserMenu = !showUserMenu" class="flex items-center space-x-2 p-2 rounded-lg hover:bg-gray-100">
                <div class="w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center">
                  <span class="text-white text-sm font-medium">{{ authStore.user?.name?.charAt(0) || 'A' }}</span>
                </div>
                <ChevronDownIcon class="h-4 w-4 text-gray-500" />
              </button>
              
              <!-- User Dropdown -->
              <div v-if="showUserMenu" class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 z-50">
                <div class="p-4 border-b border-gray-200">
                  <p class="text-sm font-medium text-gray-900">{{ authStore.user?.name || 'Admin User' }}</p>
                  <p class="text-sm text-gray-500">{{ authStore.user?.email || 'admin@aquapure.com' }}</p>
                </div>
                <div class="py-2">
                  <button @click="openUserProfile" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                    <UserIcon class="inline h-4 w-4 mr-2" />Profile
                  </button>
                  <button @click="openSettings" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                    <SettingsIcon class="inline h-4 w-4 mr-2" />Settings
                  </button>
                  <button @click="viewActivityLog" class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                    <ClockIcon class="inline h-4 w-4 mr-2" />Activity Log
                  </button>
                  <hr class="my-2" />
                  <button @click="logout" class="block w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50">
                    <LogOutIcon class="inline h-4 w-4 mr-2" />Logout
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <div class="flex">
      <!-- Sidebar -->
      <div :class="`${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} lg:translate-x-0 fixed lg:static inset-y-0 left-0 z-40 w-64 bg-white shadow-lg border-r border-gray-200 transition-transform duration-300 ease-in-out pt-16 lg:pt-0`">
        <div class="flex flex-col h-full">
          <div class="flex-1 flex flex-col pt-5 pb-4 overflow-y-auto">
            <nav class="mt-5 flex-1 px-2 space-y-1">
              <button
                v-for="item in sidebarItems"
                :key="item.name"
                @click="setActiveTab(item.id)"
                :class="`${
                  activeTab === item.id
                    ? 'bg-blue-100 border-blue-500 text-blue-700 border-r-2'
                    : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                } group flex items-center px-2 py-2 text-sm font-medium rounded-l-md w-full text-left transition-colors`"
              >
                <component :is="item.icon" :class="`${activeTab === item.id ? 'text-blue-500' : 'text-gray-400 group-hover:text-gray-500'} mr-3 h-5 w-5`" />
                {{ item.name }}
                <span v-if="item.badge" :class="`ml-auto inline-block py-0.5 px-2 text-xs rounded-full ${item.badgeColor || 'bg-gray-100 text-gray-600'}`">
                  {{ item.badge }}
                </span>
              </button>
            </nav>
          </div>
        </div>
      </div>

      <!-- Main Content -->
      <div class="flex-1 lg:ml-0">
        <main class="flex-1 relative overflow-y-auto focus:outline-none">
          <div class="py-6">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
              <!-- Page Header -->
              <div class="mb-8 flex items-center justify-between">
                <div>
                  <h1 class="text-2xl font-bold text-gray-900">{{ getCurrentTabName() }}</h1>
                  <p class="mt-1 text-sm text-gray-500">{{ getCurrentTabDescription() }}</p>
                </div>
                <div class="flex items-center space-x-3">
                  <span class="text-sm text-gray-500">Last updated: {{ lastUpdated }}</span>
                  <div :class="`h-2 w-2 rounded-full ${isOnline ? 'bg-green-500' : 'bg-red-500'}`" :title="isOnline ? 'Online' : 'Offline'"></div>
                </div>
              </div>

              <!-- Dashboard Content -->
              <div v-if="activeTab === 'dashboard'">
                <!-- Real-time Stats -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                  <div v-for="(stat, index) in dashboardStats" :key="index" class="bg-white overflow-hidden shadow rounded-lg hover:shadow-md transition-shadow">
                    <div class="p-5">
                      <div class="flex items-center">
                        <div class="flex-shrink-0">
                          <component :is="stat.icon" :class="`h-6 w-6 ${stat.color}`" />
                        </div>
                        <div class="ml-5 w-0 flex-1">
                          <dl>
                            <dt class="text-sm font-medium text-gray-500 truncate">{{ stat.name }}</dt>
                            <dd class="flex items-baseline">
                              <div class="text-2xl font-semibold text-gray-900">{{ stat.value }}</div>
                              <div :class="`ml-2 flex items-baseline text-sm font-semibold ${stat.changeType === 'increase' ? 'text-green-600' : stat.changeType === 'decrease' ? 'text-red-600' : 'text-gray-600'}`">
                                <component :is="stat.changeType === 'increase' ? TrendingUpIcon : stat.changeType === 'decrease' ? TrendingDownIcon : MinusIcon" class="self-center flex-shrink-0 h-4 w-4" />
                                <span class="ml-1">{{ stat.change }}</span>
                              </div>
                            </dd>
                          </dl>
                        </div>
                      </div>
                    </div>
                    <div class="bg-gray-50 px-5 py-3">
                      <div class="text-sm">
                        <a href="#" class="font-medium text-blue-600 hover:text-blue-500">View details</a>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Quick Actions & Recent Activity -->
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
                  <!-- Quick Actions -->
                  <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-6">
                      <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Quick Actions</h3>
                      <div class="space-y-3">
                        <button @click="quickAddOrder" class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                          <PlusIcon class="h-4 w-4 mr-2" />
                          Add New Order
                        </button>
                        <button @click="quickAddProduct" class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                          <PackageIcon class="h-4 w-4 mr-2" />
                          Add Product
                        </button>
                        <button @click="quickAddCustomer" class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                          <UsersIcon class="h-4 w-4 mr-2" />
                          Add Customer
                        </button>
                        <button @click="generateReport" class="w-full flex items-center justify-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                          <FileTextIcon class="h-4 w-4 mr-2" />
                          Generate Report
                        </button>
                      </div>
                    </div>
                  </div>

                  <!-- Recent Activity -->
                  <div class="lg:col-span-2 bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-6">
                      <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Recent Activity</h3>
                      <div class="flow-root">
                        <ul class="-mb-8">
                          <li v-for="(activity, index) in recentActivity" :key="activity.id">
                            <div class="relative pb-8">
                              <span v-if="index !== recentActivity.length - 1" class="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200"></span>
                              <div class="relative flex space-x-3">
                                <div>
                                  <span :class="`h-8 w-8 rounded-full flex items-center justify-center ring-8 ring-white ${activity.iconBackground}`">
                                    <component :is="activity.icon" class="h-4 w-4 text-white" />
                                  </span>
                                </div>
                                <div class="min-w-0 flex-1 pt-1.5 flex justify-between space-x-4">
                                  <div>
                                    <p class="text-sm text-gray-500">{{ activity.content }}</p>
                                  </div>
                                  <div class="text-right text-sm whitespace-nowrap text-gray-500">
                                    {{ formatTimeAgo(activity.time) }}
                                  </div>
                                </div>
                              </div>
                            </div>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Charts Row -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                  <!-- Sales Chart -->
                  <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-6">
                      <div class="flex items-center justify-between mb-4">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">Sales Overview</h3>
                        <select v-model="salesPeriod" class="text-sm border-gray-300 rounded-md">
                          <option value="7d">Last 7 days</option>
                          <option value="30d">Last 30 days</option>
                          <option value="90d">Last 90 days</option>
                        </select>
                      </div>
                      <div class="h-64 bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg flex items-center justify-center">
                        <div class="text-center">
                          <BarChart3Icon class="h-12 w-12 text-blue-400 mx-auto mb-2" />
                          <p class="text-blue-600 font-medium">Sales Chart</p>
                          <p class="text-sm text-blue-500">{{ salesData.length }} data points</p>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Top Products -->
                  <div class="bg-white overflow-hidden shadow rounded-lg">
                    <div class="p-6">
                      <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Top Products</h3>
                      <div class="space-y-4">
                        <div v-for="(product, index) in topProducts" :key="product.id" class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
                          <div class="flex items-center space-x-3">
                            <span class="text-sm font-medium text-gray-500 w-6">{{ index + 1 }}.</span>
                            <img :src="product.image" :alt="product.name" class="h-10 w-10 rounded object-cover" />
                            <div>
                              <p class="text-sm font-medium text-gray-900">{{ product.name }}</p>
                              <p class="text-sm text-gray-500">${{ product.price.toFixed(2) }}</p>
                            </div>
                          </div>
                          <div class="text-right">
                            <p class="text-sm font-medium text-gray-900">{{ product.sales }} sold</p>
                            <p class="text-sm text-green-600">${{ (product.sales * product.price).toFixed(2) }}</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Orders Management -->
              <div v-if="activeTab === 'orders'">
                <div class="bg-white shadow rounded-lg">
                  <!-- Orders Header with Advanced Controls -->
                  <div class="px-6 py-4 border-b border-gray-200">
                    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between space-y-4 lg:space-y-0">
                      <div>
                        <h2 class="text-lg font-medium text-gray-900">Orders Management</h2>
                        <p class="mt-1 text-sm text-gray-500">{{ filteredOrders.length }} orders found</p>
                      </div>
                      <div class="flex flex-col sm:flex-row space-y-2 sm:space-y-0 sm:space-x-3">
                        <!-- Search -->
                        <div class="relative">
                          <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
                          <input
                            type="search"
                            placeholder="Search orders..."
                            class="pl-10 pr-4 py-2 w-64 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            v-model="orderSearch"
                          />
                        </div>
                        <!-- Filters -->
                        <select v-model="orderFilter" class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500">
                          <option value="all">All Orders</option>
                          <option value="pending">Pending</option>
                          <option value="processing">Processing</option>
                          <option value="shipped">Shipped</option>
                          <option value="completed">Completed</option>
                          <option value="cancelled">Cancelled</option>
                        </select>
                        <!-- Date Range -->
                        <input type="date" v-model="dateFrom" class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500" />
                        <input type="date" v-model="dateTo" class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500" />
                        <!-- Actions -->
                        <div class="flex space-x-2">
                          <button @click="exportOrders" class="inline-flex items-center px-3 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                            <DownloadIcon class="h-4 w-4 mr-2" />
                            Export
                          </button>
                          <button @click="showAddOrderModal = true" class="inline-flex items-center px-3 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                            <PlusIcon class="h-4 w-4 mr-2" />
                            Add Order
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Bulk Actions Bar -->
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
                        <button @click="applyBulkAction" :disabled="!bulkAction" class="px-3 py-1 bg-blue-600 text-white text-sm rounded-md hover:bg-blue-700 disabled:opacity-50">
                          Apply
                        </button>
                        <button @click="clearSelection" class="px-3 py-1 border border-blue-300 text-blue-700 text-sm rounded-md hover:bg-blue-100">
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
                              @change="toggleAllOrders"
                              class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
                            />
                          </th>
                          <th @click="sortOrders('id')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
                            Order
                            <component :is="getSortIcon('id')" class="inline h-4 w-4 ml-1" />
                          </th>
                          <th @click="sortOrders('customer_name')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
                            Customer
                            <component :is="getSortIcon('customer_name')" class="inline h-4 w-4 ml-1" />
                          </th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Products</th>
                          <th @click="sortOrders('total')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
                            Total
                            <component :is="getSortIcon('total')" class="inline h-4 w-4 ml-1" />
                          </th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                          <th @click="sortOrders('created_at')" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100">
                            Date
                            <component :is="getSortIcon('created_at')" class="inline h-4 w-4 ml-1" />
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
                              @change="toggleOrderSelection(order.id)"
                              class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" 
                            />
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm font-medium text-gray-900">#{{ order.id }}</div>
                            <div class="text-sm text-gray-500">{{ order.items_count }} items</div>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                              <div class="h-8 w-8 rounded-full bg-gray-200 flex items-center justify-center">
                                <span class="text-sm font-medium text-gray-600">{{ order.customer_name.charAt(0) }}</span>
                              </div>
                              <div class="ml-3">
                                <div class="text-sm font-medium text-gray-900">{{ order.customer_name }}</div>
                                <div class="text-sm text-gray-500">{{ order.customer_email }}</div>
                              </div>
                            </div>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex -space-x-2">
                              <img v-for="(product, index) in order.products.slice(0, 3)" :key="index" 
                                   :src="product.image" :alt="product.name"
                                   class="h-8 w-8 rounded-full border-2 border-white object-cover" />
                              <div v-if="order.products.length > 3" class="h-8 w-8 rounded-full bg-gray-100 border-2 border-white flex items-center justify-center">
                                <span class="text-xs font-medium text-gray-600">+{{ order.products.length - 3 }}</span>
                              </div>
                            </div>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            ${{ order.total.toFixed(2) }}
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap">
                            <select 
                              :value="order.status" 
                              @change="updateOrderStatus(order.id, $event.target.value)"
                              :class="`text-sm rounded-full px-3 py-1 font-semibold border-0 focus:ring-2 focus:ring-blue-500 ${getStatusSelectColor(order.status)}`"
                            >
                              <option value="pending">Pending</option>
                              <option value="processing">Processing</option>
                              <option value="shipped">Shipped</option>
                              <option value="completed">Completed</option>
                              <option value="cancelled">Cancelled</option>
                            </select>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{ formatDate(order.created_at) }}
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <div class="flex space-x-2">
                              <button @click="viewOrder(order)" class="text-blue-600 hover:text-blue-900" title="View">
                                <EyeIcon class="h-4 w-4" />
                              </button>
                              <button @click="editOrder(order)" class="text-green-600 hover:text-green-900" title="Edit">
                                <EditIcon class="h-4 w-4" />
                              </button>
                              <button @click="duplicateOrder(order)" class="text-purple-600 hover:text-purple-900" title="Duplicate">
                                <CopyIcon class="h-4 w-4" />
                              </button>
                              <button @click="deleteOrder(order.id)" class="text-red-600 hover:text-red-900" title="Delete">
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
                      <button @click="previousPage" :disabled="currentPage === 1" class="relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50">
                        Previous
                      </button>
                      <button @click="nextPage" :disabled="currentPage === totalPages" class="ml-3 relative inline-flex items-center px-4 py-2 border border-gray-300 text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50">
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
                        <select v-model="itemsPerPage" class="text-sm border-gray-300 rounded-md">
                          <option :value="10">10 per page</option>
                          <option :value="25">25 per page</option>
                          <option :value="50">50 per page</option>
                          <option :value="100">100 per page</option>
                        </select>
                      </div>
                      <div>
                        <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px">
                          <button @click="previousPage" :disabled="currentPage === 1" class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50">
                            <ChevronLeftIcon class="h-5 w-5" />
                          </button>
                          <button 
                            v-for="page in visiblePages" 
                            :key="page"
                            @click="goToPage(page)"
                            :class="`relative inline-flex items-center px-4 py-2 border text-sm font-medium ${
                              page === currentPage 
                                ? 'z-10 bg-blue-50 border-blue-500 text-blue-600' 
                                : 'bg-white border-gray-300 text-gray-500 hover:bg-gray-50'
                            }`"
                          >
                            {{ page }}
                          </button>
                          <button @click="nextPage" :disabled="currentPage === totalPages" class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50">
                            <ChevronRightIcon class="h-5 w-5" />
                          </button>
                        </nav>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Products Management -->
              <div v-if="activeTab === 'products'">
                <div class="bg-white shadow rounded-lg">
                  <div class="px-6 py-4 border-b border-gray-200">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                      <div>
                        <h2 class="text-lg font-medium text-gray-900">Products Management</h2>
                        <p class="mt-1 text-sm text-gray-500">{{ filteredProducts.length }} products in inventory</p>
                      </div>
                      <div class="mt-4 sm:mt-0 flex space-x-3">
                        <div class="relative">
                          <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
                          <input
                            type="search"
                            placeholder="Search products..."
                            class="pl-10 pr-4 py-2 w-64 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            v-model="productSearch"
                          />
                        </div>
                        <select v-model="productFilter" class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500">
                          <option value="all">All Products</option>
                          <option value="in-stock">In Stock</option>
                          <option value="low-stock">Low Stock</option>
                          <option value="out-of-stock">Out of Stock</option>
                        </select>
                        <button @click="exportProducts" class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                          <DownloadIcon class="h-4 w-4 mr-2" />
                          Export
                        </button>
                        <button @click="showAddProductModal = true" class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                          <PlusIcon class="h-4 w-4 mr-2" />
                          Add Product
                        </button>
                      </div>
                    </div>
                  </div>

                  <div class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                      <div v-for="product in filteredProducts" :key="product.id" class="border border-gray-200 rounded-lg overflow-hidden hover:shadow-md transition-shadow">
                        <div class="relative">
                          <img :src="product.image" :alt="product.name" class="w-full h-48 object-cover" />
                          <div class="absolute top-2 right-2">
                            <span :class="`px-2 py-1 text-xs font-semibold rounded-full ${getStockStatusColor(product.stock_quantity)}`">
                              {{ getStockStatus(product.stock_quantity) }}
                            </span>
                          </div>
                        </div>
                        <div class="p-4">
                          <h3 class="text-lg font-medium text-gray-900 mb-2 truncate">{{ product.name }}</h3>
                          <p class="text-sm text-gray-500 mb-3 line-clamp-2">{{ product.description }}</p>
                          <div class="flex items-center justify-between mb-3">
                            <span class="text-2xl font-bold text-gray-900">${{ product.price.toFixed(2) }}</span>
                            <span class="text-sm text-gray-500">{{ product.stock_quantity }} in stock</span>
                          </div>
                          <div class="flex space-x-2">
                            <button @click="viewProduct(product)" class="flex-1 bg-blue-600 text-white px-3 py-2 rounded-md text-sm hover:bg-blue-700 transition-colors">
                              View
                            </button>
                            <button @click="editProduct(product)" class="px-3 py-2 border border-gray-300 rounded-md text-sm hover:bg-gray-50 transition-colors">
                              <EditIcon class="h-4 w-4" />
                            </button>
                            <button @click="duplicateProduct(product)" class="px-3 py-2 border border-gray-300 rounded-md text-sm hover:bg-gray-50 transition-colors">
                              <CopyIcon class="h-4 w-4" />
                            </button>
                            <button @click="deleteProduct(product.id)" class="px-3 py-2 border border-red-300 text-red-600 rounded-md text-sm hover:bg-red-50 transition-colors">
                              <TrashIcon class="h-4 w-4" />
                            </button>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Customers Management -->
              <div v-if="activeTab === 'customers'">
                <div class="bg-white shadow rounded-lg">
                  <div class="px-6 py-4 border-b border-gray-200">
                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
                      <div>
                        <h2 class="text-lg font-medium text-gray-900">Customers Management</h2>
                        <p class="mt-1 text-sm text-gray-500">{{ filteredCustomers.length }} customers registered</p>
                      </div>
                      <div class="mt-4 sm:mt-0 flex space-x-3">
                        <div class="relative">
                          <SearchIcon class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
                          <input
                            type="search"
                            placeholder="Search customers..."
                            class="pl-10 pr-4 py-2 w-64 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                            v-model="customerSearch"
                          />
                        </div>
                        <select v-model="customerFilter" class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500">
                          <option value="all">All Customers</option>
                          <option value="active">Active</option>
                          <option value="inactive">Inactive</option>
                          <option value="vip">VIP</option>
                        </select>
                        <button @click="exportCustomers" class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                          <DownloadIcon class="h-4 w-4 mr-2" />
                          Export
                        </button>
                        <button @click="showAddCustomerModal = true" class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                          <PlusIcon class="h-4 w-4 mr-2" />
                          Add Customer
                        </button>
                      </div>
                    </div>
                  </div>
                  
                  <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                      <thead class="bg-gray-50">
                        <tr>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Orders</th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Total Spent</th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Last Order</th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                          <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                        </tr>
                      </thead>
                      <tbody class="bg-white divide-y divide-gray-200">
                        <tr v-for="customer in filteredCustomers" :key="customer.id" class="hover:bg-gray-50">
                          <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                              <div class="h-10 w-10 rounded-full bg-gray-200 flex items-center justify-center">
                                <span class="text-sm font-medium text-gray-600">{{ customer.name.charAt(0) }}</span>
                              </div>
                              <div class="ml-4">
                                <div class="text-sm font-medium text-gray-900">{{ customer.name }}</div>
                                <div class="text-sm text-gray-500">{{ customer.email }}</div>
                              </div>
                            </div>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ customer.orders_count }}</td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${{ customer.total_spent.toFixed(2) }}</td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ formatDate(customer.last_order_date) }}</td>
                          <td class="px-6 py-4 whitespace-nowrap">
                            <span :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getCustomerStatusColor(customer.status)}`">
                              {{ customer.status }}
                            </span>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                            <div class="flex space-x-2">
                              <button @click="viewCustomer(customer)" class="text-blue-600 hover:text-blue-900" title="View">
                                <EyeIcon class="h-4 w-4" />
                              </button>
                              <button @click="editCustomer(customer)" class="text-green-600 hover:text-green-900" title="Edit">
                                <EditIcon class="h-4 w-4" />
                              </button>
                              <button @click="emailCustomer(customer)" class="text-purple-600 hover:text-purple-900" title="Email">
                                <MailIcon class="h-4 w-4" />
                              </button>
                              <button @click="deleteCustomer(customer.id)" class="text-red-600 hover:text-red-900" title="Delete">
                                <TrashIcon class="h-4 w-4" />
                              </button>
                            </div>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <!-- Analytics -->
              <div v-if="activeTab === 'analytics'">
                <div class="space-y-6">
                  <!-- Analytics Header -->
                  <div class="flex items-center justify-between">
                    <div>
                      <h2 class="text-2xl font-bold text-gray-900">Analytics Dashboard</h2>
                      <p class="text-gray-600">Comprehensive insights into your business performance</p>
                    </div>
                    <div class="flex space-x-3">
                      <select v-model="analyticsTimeframe" class="rounded-md border-gray-300 text-sm focus:border-blue-500 focus:ring-blue-500">
                        <option value="7d">Last 7 days</option>
                        <option value="30d">Last 30 days</option>
                        <option value="90d">Last 90 days</option>
                        <option value="1y">Last year</option>
                      </select>
                      <button @click="exportAnalytics" class="inline-flex items-center px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                        <DownloadIcon class="h-4 w-4 mr-2" />
                        Export Report
                      </button>
                    </div>
                  </div>

                  <!-- Key Metrics -->
                  <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                    <div v-for="metric in analyticsMetrics" :key="metric.name" class="bg-white overflow-hidden shadow rounded-lg">
                      <div class="p-5">
                        <div class="flex items-center">
                          <div class="flex-shrink-0">
                            <component :is="metric.icon" :class="`h-6 w-6 ${metric.color}`" />
                          </div>
                          <div class="ml-5 w-0 flex-1">
                            <dl>
                              <dt class="text-sm font-medium text-gray-500 truncate">{{ metric.name }}</dt>
                              <dd class="flex items-baseline">
                                <div class="text-2xl font-semibold text-gray-900">{{ metric.value }}</div>
                                <div :class="`ml-2 flex items-baseline text-sm font-semibold ${metric.trend === 'up' ? 'text-green-600' : metric.trend === 'down' ? 'text-red-600' : 'text-gray-600'}`">
                                  <component :is="metric.trend === 'up' ? TrendingUpIcon : metric.trend === 'down' ? TrendingDownIcon : MinusIcon" class="self-center flex-shrink-0 h-4 w-4" />
                                  <span class="ml-1">{{ metric.change }}</span>
                                </div>
                              </dd>
                            </dl>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- Charts Grid -->
                  <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Revenue Chart -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                      <div class="p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Revenue Trend</h3>
                        <div class="h-64 bg-gradient-to-br from-green-50 to-green-100 rounded-lg flex items-center justify-center">
                          <div class="text-center">
                            <LineChartIcon class="h-12 w-12 text-green-400 mx-auto mb-2" />
                            <p class="text-green-600 font-medium">Revenue Chart</p>
                            <p class="text-sm text-green-500">Trending upward</p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Orders Chart -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                      <div class="p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Order Volume</h3>
                        <div class="h-64 bg-gradient-to-br from-blue-50 to-blue-100 rounded-lg flex items-center justify-center">
                          <div class="text-center">
                            <BarChart3Icon class="h-12 w-12 text-blue-400 mx-auto mb-2" />
                            <p class="text-blue-600 font-medium">Orders Chart</p>
                            <p class="text-sm text-blue-500">{{ recentOrders.length }} total orders</p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Customer Growth -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                      <div class="p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Customer Growth</h3>
                        <div class="h-64 bg-gradient-to-br from-purple-50 to-purple-100 rounded-lg flex items-center justify-center">
                          <div class="text-center">
                            <UsersIcon class="h-12 w-12 text-purple-400 mx-auto mb-2" />
                            <p class="text-purple-600 font-medium">Customer Growth</p>
                            <p class="text-sm text-purple-500">{{ customers.length }} total customers</p>
                          </div>
                        </div>
                      </div>
                    </div>

                    <!-- Product Performance -->
                    <div class="bg-white overflow-hidden shadow rounded-lg">
                      <div class="p-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900 mb-4">Product Performance</h3>
                        <div class="space-y-3">
                          <div v-for="(product, index) in topProducts.slice(0, 5)" :key="product.id" class="flex items-center justify-between">
                            <div class="flex items-center space-x-3">
                              <span class="text-sm font-medium text-gray-500 w-4">{{ index + 1 }}.</span>
                              <img :src="product.image" :alt="product.name" class="h-8 w-8 rounded object-cover" />
                              <span class="text-sm font-medium text-gray-900 truncate">{{ product.name }}</span>
                            </div>
                            <div class="text-right">
                              <p class="text-sm font-medium text-gray-900">{{ product.sales }}</p>
                              <p class="text-xs text-gray-500">sold</p>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Settings -->
              <div v-if="activeTab === 'settings'">
                <div class="space-y-6">
                  <!-- General Settings -->
                  <div class="bg-white shadow rounded-lg">
                    <div class="px-6 py-4 border-b border-gray-200">
                      <h2 class="text-lg font-medium text-gray-900">General Settings</h2>
                      <p class="mt-1 text-sm text-gray-500">Manage your store configuration and preferences</p>
                    </div>
                    
                    <div class="p-6">
                      <form @submit.prevent="saveSettings" class="space-y-6">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                          <!-- Store Information -->
                          <div class="space-y-4">
                            <h3 class="text-lg font-medium text-gray-900">Store Information</h3>
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Store Name</label>
                              <input type="text" v-model="settings.storeName" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
                            </div>
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Store Email</label>
                              <input type="email" v-model="settings.storeEmail" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
                            </div>
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Store Phone</label>
                              <input type="tel" v-model="settings.storePhone" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
                            </div>
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Store Address</label>
                              <textarea v-model="settings.storeAddress" rows="3" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"></textarea>
                            </div>
                          </div>

                          <!-- Notification Settings -->
                          <div class="space-y-4">
                            <h3 class="text-lg font-medium text-gray-900">Notification Settings</h3>
                            <div class="space-y-3">
                              <div class="flex items-center justify-between">
                                <div>
                                  <label class="text-sm font-medium text-gray-700">Email notifications for new orders</label>
                                  <p class="text-sm text-gray-500">Receive email when new orders are placed</p>
                                </div>
                                <input type="checkbox" v-model="settings.emailNewOrders" class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                              </div>
                              <div class="flex items-center justify-between">
                                <div>
                                  <label class="text-sm font-medium text-gray-700">Low stock alerts</label>
                                  <p class="text-sm text-gray-500">Get notified when products are running low</p>
                                </div>
                                <input type="checkbox" v-model="settings.lowStockAlerts" class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                              </div>
                              <div class="flex items-center justify-between">
                                <div>
                                  <label class="text-sm font-medium text-gray-700">Weekly sales reports</label>
                                  <p class="text-sm text-gray-500">Receive weekly performance summaries</p>
                                </div>
                                <input type="checkbox" v-model="settings.weeklySalesReports" class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                              </div>
                              <div class="flex items-center justify-between">
                                <div>
                                  <label class="text-sm font-medium text-gray-700">Customer review notifications</label>
                                  <p class="text-sm text-gray-500">Get notified of new customer reviews</p>
                                </div>
                                <input type="checkbox" v-model="settings.reviewNotifications" class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                              </div>
                            </div>
                          </div>
                        </div>

                        <!-- Business Settings -->
                        <div class="border-t border-gray-200 pt-6">
                          <h3 class="text-lg font-medium text-gray-900 mb-4">Business Settings</h3>
                          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Currency</label>
                              <select v-model="settings.currency" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500">
                                <option value="USD">USD ($)</option>
                                <option value="EUR">EUR (€)</option>
                                <option value="GBP">GBP (£)</option>
                                <option value="CAD">CAD ($)</option>
                              </select>
                            </div>
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Tax Rate (%)</label>
                              <input type="number" v-model="settings.taxRate" step="0.01" min="0" max="100" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
                            </div>
                            <div>
                              <label class="block text-sm font-medium text-gray-700 mb-1">Low Stock Threshold</label>
                              <input type="number" v-model="settings.lowStockThreshold" min="0" class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500" />
                            </div>
                          </div>
                        </div>

                        <!-- Save Button -->
                        <div class="pt-6 border-t border-gray-200">
                          <div class="flex justify-end space-x-3">
                            <button type="button" @click="resetSettings" class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                              Reset
                            </button>
                            <button type="submit" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                              Save Settings
                            </button>
                          </div>
                        </div>
                      </form>
                    </div>
                  </div>

                  <!-- Security Settings -->
                  <div class="bg-white shadow rounded-lg">
                    <div class="px-6 py-4 border-b border-gray-200">
                      <h2 class="text-lg font-medium text-gray-900">Security Settings</h2>
                      <p class="mt-1 text-sm text-gray-500">Manage security and access controls</p>
                    </div>
                    
                    <div class="p-6 space-y-6">
                      <div class="flex items-center justify-between">
                        <div>
                          <h3 class="text-sm font-medium text-gray-900">Two-Factor Authentication</h3>
                          <p class="text-sm text-gray-500">Add an extra layer of security to your account</p>
                        </div>
                        <button class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
                          Enable 2FA
                        </button>
                      </div>
                      
                      <div class="flex items-center justify-between">
                        <div>
                          <h3 class="text-sm font-medium text-gray-900">Session Timeout</h3>
                          <p class="text-sm text-gray-500">Automatically log out after period of inactivity</p>
                        </div>
                        <select class="border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500">
                          <option value="30">30 minutes</option>
                          <option value="60">1 hour</option>
                          <option value="120">2 hours</option>
                          <option value="480">8 hours</option>
                        </select>
                      </div>
                      
                      <div class="flex items-center justify-between">
                        <div>
                          <h3 class="text-sm font-medium text-gray-900">Login Notifications</h3>
                          <p class="text-sm text-gray-500">Get notified of new login attempts</p>
                        </div>
                        <input type="checkbox" checked class="rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </main>
      </div>
    </div>

    <!-- Modals -->
    <!-- Order Detail Modal -->
    <div v-if="selectedOrder" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="selectedOrder = null">
      <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white" @click.stop>
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-medium text-gray-900">Order #{{ selectedOrder.id }}</h3>
          <button @click="selectedOrder = null" class="text-gray-400 hover:text-gray-600">
            <XIcon class="h-6 w-6" />
          </button>
        </div>
        
        <div class="space-y-6">
          <!-- Order Status -->
          <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <h4 class="font-medium text-gray-900">Order Status</h4>
              <p class="text-sm text-gray-600">Current status of this order</p>
            </div>
            <span :class="`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${getStatusColor(selectedOrder.status)}`">
              {{ selectedOrder.status }}
            </span>
          </div>

          <!-- Customer & Order Info -->
          <div class="grid grid-cols-2 gap-6">
            <div>
              <h4 class="font-medium text-gray-900 mb-3">Customer Information</h4>
              <div class="space-y-2">
                <p class="text-sm"><span class="font-medium">Name:</span> {{ selectedOrder.customer_name }}</p>
                <p class="text-sm"><span class="font-medium">Email:</span> {{ selectedOrder.customer_email }}</p>
                <p class="text-sm"><span class="font-medium">Phone:</span> +1 (555) 123-4567</p>
              </div>
            </div>
            <div>
              <h4 class="font-medium text-gray-900 mb-3">Order Details</h4>
              <div class="space-y-2">
                <p class="text-sm"><span class="font-medium">Total:</span> ${{ selectedOrder.total.toFixed(2) }}</p>
                <p class="text-sm"><span class="font-medium">Items:</span> {{ selectedOrder.items_count }}</p>
                <p class="text-sm"><span class="font-medium">Date:</span> {{ formatDate(selectedOrder.created_at) }}</p>
              </div>
            </div>
          </div>
          
          <!-- Products -->
          <div>
            <h4 class="font-medium text-gray-900 mb-3">Products Ordered</h4>
            <div class="space-y-3">
              <div v-for="product in selectedOrder.products" :key="product.id" class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div class="flex items-center space-x-3">
                  <img :src="product.image" :alt="product.name" class="h-12 w-12 rounded object-cover" />
                  <div>
                    <p class="text-sm font-medium text-gray-900">{{ product.name }}</p>
                    <p class="text-sm text-gray-500">Qty: {{ product.quantity }} × ${{ product.price.toFixed(2) }}</p>
                  </div>
                </div>
                <p class="text-sm font-medium text-gray-900">${{ (product.quantity * product.price).toFixed(2) }}</p>
              </div>
            </div>
          </div>

          <!-- Actions -->
          <div class="flex justify-end space-x-3 pt-4 border-t border-gray-200">
            <button @click="printOrder(selectedOrder)" class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
              <PrinterIcon class="h-4 w-4 inline mr-2" />
              Print
            </button>
            <button @click="editOrder(selectedOrder)" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
              <EditIcon class="h-4 w-4 inline mr-2" />
              Edit Order
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Add Modal -->
    <div v-if="showQuickAdd" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="showQuickAdd = false">
      <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white" @click.stop>
        <div class="flex items-center justify-between mb-4">
          <h3 class="text-lg font-medium text-gray-900">Quick Add</h3>
          <button @click="showQuickAdd = false" class="text-gray-400 hover:text-gray-600">
            <XIcon class="h-6 w-6" />
          </button>
        </div>
        
        <div class="space-y-3">
          <button @click="quickAddOrder" class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
            <ShoppingCartIcon class="h-5 w-5 mr-3" />
            Add New Order
          </button>
          <button @click="quickAddProduct" class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
            <PackageIcon class="h-5 w-5 mr-3" />
            Add New Product
          </button>
          <button @click="quickAddCustomer" class="w-full flex items-center justify-center px-4 py-3 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50">
            <UsersIcon class="h-5 w-5 mr-3" />
            Add New Customer
          </button>
        </div>
      </div>
    </div>

    <!-- Edit Order Modal -->
    <div v-if="showEditOrderModal && editingOrder" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="closeEditOrderModal">
      <div class="relative top-10 mx-auto p-6 border w-11/12 md:w-3/4 lg:w-2/3 xl:w-1/2 shadow-lg rounded-md bg-white max-h-screen overflow-y-auto" @click.stop>
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-xl font-semibold text-gray-900">Edit Order #{{ editingOrder.id }}</h3>
          <button @click="closeEditOrderModal" class="text-gray-400 hover:text-gray-600">
            <XIcon class="h-6 w-6" />
          </button>
        </div>
        
        <form @submit.prevent="saveOrderChanges" class="space-y-6">
          <!-- Customer Information -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Customer Name</label>
              <input 
                type="text" 
                v-model="editingOrder.customer_name" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Customer Email</label>
              <input 
                type="email" 
                v-model="editingOrder.customer_email" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                required
              />
            </div>
          </div>

          <!-- Order Status -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Order Status</label>
            <select 
              v-model="editingOrder.status" 
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="pending">Pending</option>
              <option value="processing">Processing</option>
              <option value="shipped">Shipped</option>
              <option value="completed">Completed</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>

          <!-- Products in Order -->
          <div>
            <div class="flex items-center justify-between mb-4">
              <h4 class="text-lg font-medium text-gray-900">Products in Order</h4>
              <button 
                type="button" 
                @click="addProductToOrder" 
                class="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700"
              >
                <PlusIcon class="h-4 w-4 mr-2" />
                Add Product
              </button>
            </div>
            
            <div class="space-y-3">
              <div 
                v-for="(product, index) in editingOrder.products" 
                :key="index" 
                class="flex items-center justify-between p-4 border border-gray-200 rounded-lg"
              >
                <div class="flex items-center space-x-4 flex-1">
                  <img :src="product.image" :alt="product.name" class="h-12 w-12 rounded object-cover" />
                  <div class="flex-1">
                    <select 
                      v-model="product.id" 
                      @change="updateProductInOrder(index, $event.target.value)"
                      class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 mb-2"
                    >
                      <option v-for="availableProduct in products" :key="availableProduct.id" :value="availableProduct.id">
                        {{ availableProduct.name }} - ${{ availableProduct.price.toFixed(2) }}
                      </option>
                    </select>
                    <div class="flex items-center space-x-4">
                      <div>
                        <label class="block text-xs font-medium text-gray-500">Quantity</label>
                        <input 
                          type="number" 
                          v-model.number="product.quantity" 
                          min="1" 
                          class="w-20 border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                          @input="calculateOrderTotal"
                        />
                      </div>
                      <div>
                        <label class="block text-xs font-medium text-gray-500">Price</label>
                        <input 
                          type="number" 
                          v-model.number="product.price" 
                          step="0.01" 
                          min="0" 
                          class="w-24 border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                          @input="calculateOrderTotal"
                        />
                      </div>
                      <div>
                        <label class="block text-xs font-medium text-gray-500">Subtotal</label>
                        <span class="text-sm font-medium text-gray-900">${{ (product.quantity * product.price).toFixed(2) }}</span>
                      </div>
                    </div>
                  </div>
                </div>
                <button 
                  type="button" 
                  @click="removeProductFromOrder(index)" 
                  class="ml-4 text-red-600 hover:text-red-900"
                >
                  <TrashIcon class="h-5 w-5" />
                </button>
              </div>
            </div>
          </div>

          <!-- Order Total -->
          <div class="bg-gray-50 p-4 rounded-lg">
            <div class="flex justify-between items-center">
              <span class="text-lg font-medium text-gray-900">Order Total:</span>
              <span class="text-xl font-bold text-gray-900">${{ editingOrder.total.toFixed(2) }}</span>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200">
            <button 
              type="button" 
              @click="closeEditOrderModal" 
              class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              type="submit" 
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              Save Changes
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Edit Product Modal -->
    <div v-if="showEditProductModal && editingProduct" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="closeEditProductModal">
      <div class="relative top-10 mx-auto p-6 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white max-h-screen overflow-y-auto" @click.stop>
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-xl font-semibold text-gray-900">Edit Product</h3>
          <button @click="closeEditProductModal" class="text-gray-400 hover:text-gray-600">
            <XIcon class="h-6 w-6" />
          </button>
        </div>
        
        <form @submit.prevent="saveProductChanges" class="space-y-6">
          <!-- Product Image -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Product Image</label>
            <div class="flex items-center space-x-4">
              <img :src="editingProduct.image" :alt="editingProduct.name" class="h-20 w-20 rounded-lg object-cover" />
              <div class="flex-1">
                <input 
                  type="url" 
                  v-model="editingProduct.image" 
                  placeholder="Image URL"
                  class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                />
                <p class="text-xs text-gray-500 mt-1">Enter a valid image URL</p>
              </div>
            </div>
          </div>

          <!-- Product Name -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Product Name</label>
            <input 
              type="text" 
              v-model="editingProduct.name" 
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              required
            />
          </div>

          <!-- Product Description -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
            <textarea 
              v-model="editingProduct.description" 
              rows="4"
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              required
            ></textarea>
          </div>

          <!-- Price and Stock -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Price ($)</label>
              <input 
                type="number" 
                v-model.number="editingProduct.price" 
                step="0.01" 
                min="0" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Stock Quantity</label>
              <input 
                type="number" 
                v-model.number="editingProduct.stock_quantity" 
                min="0" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                required
              />
            </div>
          </div>

          <!-- Product Category -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Category</label>
            <select 
              v-model="editingProduct.category" 
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="filters">Water Filters</option>
              <option value="dispensers">Water Dispensers</option>
              <option value="bottles">Water Bottles</option>
              <option value="purifiers">Water Purifiers</option>
              <option value="accessories">Accessories</option>
            </select>
          </div>

          <!-- Product Status -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
            <div class="flex items-center space-x-6">
              <label class="flex items-center">
                <input 
                  type="radio" 
                  v-model="editingProduct.status" 
                  value="active" 
                  class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300"
                />
                <span class="ml-2 text-sm text-gray-700">Active</span>
              </label>
              <label class="flex items-center">
                <input 
                  type="radio" 
                  v-model="editingProduct.status" 
                  value="inactive" 
                  class="focus:ring-blue-500 h-4 w-4 text-blue-600 border-gray-300"
                />
                <span class="ml-2 text-sm text-gray-700">Inactive</span>
              </label>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200">
            <button 
              type="button" 
              @click="closeEditProductModal" 
              class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              type="submit" 
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              Save Changes
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Edit Customer Modal -->
    <div v-if="showEditCustomerModal && editingCustomer" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="closeEditCustomerModal">
      <div class="relative top-10 mx-auto p-6 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white max-h-screen overflow-y-auto" @click.stop>
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-xl font-semibold text-gray-900">Edit Customer</h3>
          <button @click="closeEditCustomerModal" class="text-gray-400 hover:text-gray-600">
            <XIcon class="h-6 w-6" />
          </button>
        </div>
        
        <form @submit.prevent="saveCustomerChanges" class="space-y-6">
          <!-- Customer Avatar -->
          <div class="flex items-center space-x-4">
            <div class="h-16 w-16 rounded-full bg-gray-200 flex items-center justify-center">
              <span class="text-xl font-medium text-gray-600">{{ editingCustomer.name.charAt(0) }}</span>
            </div>
            <div>
              <h4 class="text-lg font-medium text-gray-900">Customer Profile</h4>
              <p class="text-sm text-gray-500">Update customer information</p>
            </div>
          </div>

          <!-- Personal Information -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
              <input 
                type="text" 
                v-model="editingCustomer.name" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
              <input 
                type="email" 
                v-model="editingCustomer.email" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
                required
              />
            </div>
          </div>

          <!-- Contact Information -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
              <input 
                type="tel" 
                v-model="editingCustomer.phone" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">Customer Status</label>
              <select 
                v-model="editingCustomer.status" 
                class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
                <option value="vip">VIP</option>
              </select>
            </div>
          </div>

          <!-- Address Information -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Address</label>
            <textarea 
              v-model="editingCustomer.address" 
              rows="3"
              placeholder="Enter customer address"
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
            ></textarea>
          </div>

          <!-- Customer Notes -->
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Notes</label>
            <textarea 
              v-model="editingCustomer.notes" 
              rows="3"
              placeholder="Add any notes about this customer"
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
            ></textarea>
          </div>

          <!-- Customer Statistics (Read-only) -->
          <div class="bg-gray-50 p-4 rounded-lg">
            <h4 class="text-sm font-medium text-gray-900 mb-3">Customer Statistics</h4>
            <div class="grid grid-cols-3 gap-4">
              <div class="text-center">
                <div class="text-2xl font-bold text-blue-600">{{ editingCustomer.orders_count }}</div>
                <div class="text-sm text-gray-500">Total Orders</div>
              </div>
              <div class="text-center">
                <div class="text-2xl font-bold text-green-600">${{ editingCustomer.total_spent.toFixed(2) }}</div>
                <div class="text-sm text-gray-500">Total Spent</div>
              </div>
              <div class="text-center">
                <div class="text-2xl font-bold text-purple-600">{{ formatDate(editingCustomer.last_order_date) }}</div>
                <div class="text-sm text-gray-500">Last Order</div>
              </div>
            </div>
          </div>

          <!-- Action Buttons -->
          <div class="flex justify-end space-x-3 pt-6 border-t border-gray-200">
            <button 
              type="button" 
              @click="closeEditCustomerModal" 
              class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              type="submit" 
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
            >
              Save Changes
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Add Product to Order Modal -->
    <div v-if="showAddProductToOrderModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50" @click="closeAddProductToOrderModal">
      <div class="relative top-20 mx-auto p-6 border w-11/12 md:w-1/2 shadow-lg rounded-md bg-white" @click.stop>
        <div class="flex items-center justify-between mb-6">
          <h3 class="text-lg font-semibold text-gray-900">Add Product to Order</h3>
          <button @click="closeAddProductToOrderModal" class="text-gray-400 hover:text-gray-600">
            <XIcon class="h-6 w-6" />
          </button>
        </div>
        
        <form @submit.prevent="confirmAddProductToOrder" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Select Product</label>
            <select 
              v-model="newProductForOrder.id" 
              @change="updateNewProductDetails"
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              required
            >
              <option value="">Choose a product...</option>
              <option v-for="product in products" :key="product.id" :value="product.id">
                {{ product.name }} - ${{ product.price.toFixed(2) }} ({{ product.stock_quantity }} in stock)
              </option>
            </select>
          </div>

          <div v-if="newProductForOrder.id">
            <label class="block text-sm font-medium text-gray-700 mb-2">Quantity</label>
            <input 
              type="number" 
              v-model.number="newProductForOrder.quantity" 
              min="1" 
              :max="getProductStock(newProductForOrder.id)"
              class="w-full border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
              required
            />
            <p class="text-sm text-gray-500 mt-1">Available: {{ getProductStock(newProductForOrder.id) }} units</p>
          </div>

          <div class="flex justify-end space-x-3 pt-4">
            <button 
              type="button" 
              @click="closeAddProductToOrderModal" 
              class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
            >
              Cancel
            </button>
            <button 
              type="submit" 
              :disabled="!newProductForOrder.id"
              class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 disabled:opacity-50"
            >
              Add Product
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Toast Notifications -->
    <div class="fixed bottom-4 right-4 z-50 space-y-2">
      <div v-for="toast in toasts" :key="toast.id" 
           :class="`max-w-sm w-full bg-white shadow-lg rounded-lg pointer-events-auto ring-1 ring-black ring-opacity-5 overflow-hidden transform transition-all duration-300 ${toast.show ? 'translate-x-0 opacity-100' : 'translate-x-full opacity-0'}`">
        <div class="p-4">
          <div class="flex items-start">
            <div class="flex-shrink-0">
              <component :is="getToastIcon(toast.type)" :class="`h-6 w-6 ${getToastColor(toast.type)}`" />
            </div>
            <div class="ml-3 w-0 flex-1 pt-0.5">
              <p class="text-sm font-medium text-gray-900">{{ toast.title }}</p>
              <p class="mt-1 text-sm text-gray-500">{{ toast.message }}</p>
            </div>
            <div class="ml-4 flex-shrink-0 flex">
              <button @click="removeToast(toast.id)" class="bg-white rounded-md inline-flex text-gray-400 hover:text-gray-500 focus:outline-none">
                <XIcon class="h-5 w-5" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import {
  MenuIcon, DropletIcon, SearchIcon, BellIcon, ChevronDownIcon, XIcon,
  BarChart3Icon, ShoppingCartIcon, PackageIcon, UsersIcon, SettingsIcon,
  TrendingUpIcon, TrendingDownIcon, DollarSignIcon, EyeIcon, EditIcon,
  TrashIcon, DownloadIcon, PlusIcon, MailIcon, ChevronLeftIcon,
  ChevronRightIcon, LineChartIcon, FileTextIcon, UserIcon, ClockIcon,
  LogOutIcon, RefreshCwIcon, CopyIcon, PrinterIcon, MinusIcon,
  CheckCircleIcon, AlertCircleIcon, InfoIcon
} from 'lucide-vue-next'
import { useAuthStore } from '../stores/auth'
import button from '@/components/ui/button.vue'

const router = useRouter()
const authStore = useAuthStore()

// Reactive state
const sidebarOpen = ref(false)
const activeTab = ref('dashboard')
const showNotifications = ref(false)
const showUserMenu = ref(false)
const showQuickAdd = ref(false)
const globalSearch = ref('')
const searchResults = ref([])
const isRefreshing = ref(false)
const isOnline = ref(true)
const lastUpdated = ref(new Date().toLocaleTimeString())

// Edit modals state
const showEditOrderModal = ref(false)
const showEditProductModal = ref(false)
const showEditCustomerModal = ref(false)
const showAddProductToOrderModal = ref(false)

// Editing objects
const editingOrder = ref(null)
const editingProduct = ref(null)
const editingCustomer = ref(null)
const newProductForOrder = ref({ id: '', quantity: 1 })

// Notifications
const notifications = ref([
  {
    id: 1,
    type: 'order',
    title: 'New Order Received',
    message: 'Order #12350 from John Doe - $389.97',
    time: new Date(Date.now() - 5 * 60 * 1000),
    read: false
  },
  {
    id: 2,
    type: 'alert',
    title: 'Low Stock Alert',
    message: 'Professional Water Purifier has only 5 units left',
    time: new Date(Date.now() - 15 * 60 * 1000),
    read: false
  },
  {
    id: 3,
    type: 'success',
    title: 'Sales Milestone',
    message: 'Monthly sales target achieved!',
    time: new Date(Date.now() - 2 * 60 * 60 * 1000),
    read: true
  },
  {
    id: 4,
    type: 'info',
    title: 'System Update',
    message: 'New features available in the dashboard',
    time: new Date(Date.now() - 4 * 60 * 60 * 1000),
    read: true
  }
])

const toasts = ref([])

// Orders management
const orderSearch = ref('')
const orderFilter = ref('all')
const dateFrom = ref('')
const dateTo = ref('')
const selectedOrders = ref([])
const bulkAction = ref('')
const currentPage = ref(1)
const itemsPerPage = ref(10)
const sortField = ref('id')
const sortDirection = ref('desc')
const selectedOrder = ref(null)
const showAddOrderModal = ref(false)

// Products management
const productSearch = ref('')
const productFilter = ref('all')
const showAddProductModal = ref(false)

// Customers management
const customerSearch = ref('')
const customerFilter = ref('all')
const showAddCustomerModal = ref(false)

// Analytics
const analyticsTimeframe = ref('30d')
const salesPeriod = ref('30d')

// Settings
const settings = ref({
  storeName: 'AquaPure',
  storeEmail: 'info@aquapure.com',
  storePhone: '+1 (555) 123-4567',
  storeAddress: '123 Water Street, Clean City, CC 12345',
  currency: 'USD',
  taxRate: 8.25,
  lowStockThreshold: 10,
  emailNewOrders: true,
  lowStockAlerts: true,
  weeklySalesReports: true,
  reviewNotifications: false
})

// Sidebar items
const sidebarItems = ref([
  { id: 'dashboard', name: 'Dashboard', icon: BarChart3Icon },
  { id: 'orders', name: 'Orders', icon: ShoppingCartIcon, badge: '12', badgeColor: 'bg-blue-100 text-blue-600' },
  { id: 'products', name: 'Products', icon: PackageIcon, badge: '156' },
  { id: 'customers', name: 'Customers', icon: UsersIcon, badge: '1.2k' },
  { id: 'analytics', name: 'Analytics', icon: TrendingUpIcon },
  { id: 'settings', name: 'Settings', icon: SettingsIcon }
])

// Dashboard stats
const dashboardStats = ref([
  {
    name: 'Total Revenue',
    value: '$45,231.89',
    change: '+20.1%',
    changeType: 'increase',
    icon: DollarSignIcon,
    color: 'text-green-600'
  },
  {
    name: 'Orders',
    value: '2,350',
    change: '+15.3%',
    changeType: 'increase',
    icon: ShoppingCartIcon,
    color: 'text-blue-600'
  },
  {
    name: 'Customers',
    value: '1,234',
    change: '+8.2%',
    changeType: 'increase',
    icon: UsersIcon,
    color: 'text-purple-600'
  },
  {
    name: 'Products',
    value: '156',
    change: '+2.4%',
    changeType: 'increase',
    icon: PackageIcon,
    color: 'text-orange-600'
  }
])

// Analytics metrics
const analyticsMetrics = ref([
  {
    name: 'Conversion Rate',
    value: '3.24%',
    change: '+0.5%',
    trend: 'up',
    icon: TrendingUpIcon,
    color: 'text-green-600'
  },
  {
    name: 'Avg. Order Value',
    value: '$127.50',
    change: '+$12.30',
    trend: 'up',
    icon: DollarSignIcon,
    color: 'text-blue-600'
  },
  {
    name: 'Cart Abandonment',
    value: '68.2%',
    change: '-2.1%',
    trend: 'down',
    icon: ShoppingCartIcon,
    color: 'text-red-600'
  },
  {
    name: 'Customer Satisfaction',
    value: '4.8/5',
    change: '+0.2',
    trend: 'up',
    icon: UsersIcon,
    color: 'text-green-600'
  }
])

// Recent activity
const recentActivity = ref([
  {
    id: 1,
    content: 'New order #12350 placed by John Doe',
    time: new Date(Date.now() - 5 * 60 * 1000),
    icon: ShoppingCartIcon,
    iconBackground: 'bg-blue-500'
  },
  {
    id: 2,
    content: 'Product "AquaPure Premium Filter" updated',
    time: new Date(Date.now() - 15 * 60 * 1000),
    icon: PackageIcon,
    iconBackground: 'bg-green-500'
  },
  {
    id: 3,
    content: 'Customer Jane Smith registered',
    time: new Date(Date.now() - 30 * 60 * 1000),
    icon: UsersIcon,
    iconBackground: 'bg-purple-500'
  },
  {
    id: 4,
    content: 'Low stock alert for Professional Purifier',
    time: new Date(Date.now() - 45 * 60 * 1000),
    icon: AlertCircleIcon,
    iconBackground: 'bg-red-500'
  }
])

// Mock data
const recentOrders = ref([
  {
    id: 12345,
    customer_name: 'John Doe',
    customer_email: 'john@example.com',
    items_count: 3,
    total: 389.97,
    status: 'completed',
    created_at: '2024-01-15T10:30:00Z',
    products: [
      { id: 1, name: 'AquaPure Premium Filter', price: 89.99, quantity: 2, image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=100&h=100&fit=crop' },
      { id: 2, name: 'Crystal Clear Dispenser', price: 299.99, quantity: 1, image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop' }
    ]
  },
  {
    id: 12346,
    customer_name: 'Jane Smith',
    customer_email: 'jane@example.com',
    items_count: 1,
    total: 89.99,
    status: 'processing',
    created_at: '2024-01-15T09:15:00Z',
    products: [
      { id: 1, name: 'AquaPure Premium Filter', price: 89.99, quantity: 1, image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=100&h=100&fit=crop' }
    ]
  },
  {
    id: 12347,
    customer_name: 'Mike Johnson',
    customer_email: 'mike@example.com',
    items_count: 2,
    total: 149.98,
    status: 'shipped',
    created_at: '2024-01-14T16:45:00Z',
    products: [
      { id: 3, name: 'Eco Water Bottle Set', price: 24.99, quantity: 2, image: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=100&h=100&fit=crop' },
      { id: 1, name: 'AquaPure Premium Filter', price: 89.99, quantity: 1, image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=100&h=100&fit=crop' }
    ]
  },
  {
    id: 12348,
    customer_name: 'Sarah Wilson',
    customer_email: 'sarah@example.com',
    items_count: 1,
    total: 449.99,
    status: 'pending',
    created_at: '2024-01-14T14:20:00Z',
    products: [
      { id: 4, name: 'Professional Water Purifier', price: 449.99, quantity: 1, image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=100&h=100&fit=crop' }
    ]
  },
  {
    id: 12349,
    customer_name: 'David Brown',
    customer_email: 'david@example.com',
    items_count: 3,
    total: 179.97,
    status: 'cancelled',
    created_at: '2024-01-13T11:30:00Z',
    products: [
      { id: 3, name: 'Eco Water Bottle Set', price: 24.99, quantity: 3, image: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=100&h=100&fit=crop' },
      { id: 1, name: 'AquaPure Premium Filter', price: 89.99, quantity: 1, image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=100&h=100&fit=crop' }
    ]
  }
])

const products = ref([
  {
    id: 1,
    name: 'AquaPure Premium Filter',
    price: 89.99,
    stock_quantity: 15,
    description: 'Advanced multi-stage filtration system that removes 99.9% of contaminants while preserving essential minerals.',
    image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=400&h=400&fit=crop',
    category: 'filters',
    status: 'active'
  },
  {
    id: 2,
    name: 'Crystal Clear Water Dispenser',
    price: 299.99,
    stock_quantity: 8,
    description: 'Premium water dispenser with hot and cold water options, perfect for office and home use.',
    image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop',
    category: 'dispensers',
    status: 'active'
  },
  {
    id: 3,
    name: 'Eco-Friendly Water Bottle Set',
    price: 24.99,
    stock_quantity: 25,
    description: 'Set of 4 BPA-free water bottles made from recycled materials, perfect for active lifestyles.',
    image: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=400&h=400&fit=crop',
    category: 'bottles',
    status: 'active'
  },
  {
    id: 4,
    name: 'Professional Water Purifier',
    price: 449.99,
    stock_quantity: 5,
    description: 'Industrial-grade water purification system designed for maximum efficiency and reliability.',
    image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=400&fit=crop',
    category: 'purifiers',
    status: 'active'
  },
  {
    id: 5,
    name: 'Portable Water Filter Bottle',
    price: 39.99,
    stock_quantity: 0,
    description: 'Compact and lightweight water filter bottle perfect for travel and outdoor activities.',
    image: 'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=400&h=400&fit=crop',
    category: 'bottles',
    status: 'active'
  },
  {
    id: 6,
    name: 'Smart Water Quality Monitor',
    price: 129.99,
    stock_quantity: 12,
    description: 'Advanced IoT device that monitors water quality in real-time with mobile app integration.',
    image: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=400&fit=crop',
    category: 'accessories',
    status: 'active'
  }
])

const customers = ref([
  {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com',
    orders_count: 5,
    total_spent: 1247.95,
    last_order_date: '2024-01-15T10:30:00Z',
    status: 'active',
    phone: '+1 (555) 123-4567',
    address: '123 Main St, Anytown, USA',
    notes: 'Preferred customer, always pays on time'
  },
  {
    id: 2,
    name: 'Jane Smith',
    email: 'jane@example.com',
    orders_count: 3,
    total_spent: 567.89,
    last_order_date: '2024-01-12T14:20:00Z',
    status: 'active',
    phone: '+1 (555) 234-5678',
    address: '456 Oak Ave, Somewhere, USA',
    notes: 'Interested in eco-friendly products'
  },
  {
    id: 3,
    name: 'Mike Johnson',
    email: 'mike@example.com',
    orders_count: 8,
    total_spent: 2156.78,
    last_order_date: '2024-01-14T16:45:00Z',
    status: 'vip',
    phone: '+1 (555) 345-6789',
    address: '789 Pine St, Elsewhere, USA',
    notes: 'VIP customer, bulk orders for office'
  },
  {
    id: 4,
    name: 'Sarah Wilson',
    email: 'sarah@example.com',
    orders_count: 2,
    total_spent: 234.56,
    last_order_date: '2024-01-10T09:15:00Z',
    status: 'inactive',
    phone: '+1 (555) 456-7890',
    address: '321 Elm Dr, Nowhere, USA',
    notes: 'Has not ordered in a while'
  }
])

const topProducts = ref([
  { id: 1, name: 'AquaPure Premium Filter', sales: 245, price: 89.99, image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=100&h=100&fit=crop' },
  { id: 2, name: 'Crystal Clear Dispenser', sales: 189, price: 299.99, image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop' },
  { id: 3, name: 'Eco Water Bottle Set', sales: 156, price: 24.99, image: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=100&h=100&fit=crop' },
  { id: 4, name: 'Professional Purifier', sales: 98, price: 449.99, image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=100&h=100&fit=crop' },
  { id: 5, name: 'Smart Water Monitor', sales: 67, price: 129.99, image: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=100&h=100&fit=crop' }
])

const salesData = ref([
  { date: '2024-01-01', sales: 1200 },
  { date: '2024-01-02', sales: 1350 },
  { date: '2024-01-03', sales: 1100 },
  { date: '2024-01-04', sales: 1450 },
  { date: '2024-01-05', sales: 1600 },
  { date: '2024-01-06', sales: 1300 },
  { date: '2024-01-07', sales: 1750 }
])

// Computed properties
const unreadNotifications = computed(() => {
  return notifications.value.filter(n => !n.read).length
})

const filteredOrders = computed(() => {
  let filtered = recentOrders.value

  // Filter by search
  if (orderSearch.value) {
    const search = orderSearch.value.toLowerCase()
    filtered = filtered.filter(order => 
      order.id.toString().includes(search) ||
      order.customer_name.toLowerCase().includes(search) ||
      order.customer_email.toLowerCase().includes(search)
    )
  }

  // Filter by status
  if (orderFilter.value !== 'all') {
    filtered = filtered.filter(order => order.status === orderFilter.value)
  }

  // Filter by date range
  if (dateFrom.value) {
    filtered = filtered.filter(order => new Date(order.created_at) >= new Date(dateFrom.value))
  }
  if (dateTo.value) {
    filtered = filtered.filter(order => new Date(order.created_at) <= new Date(dateTo.value))
  }

  // Sort
  filtered.sort((a, b) => {
    let aVal = a[sortField.value]
    let bVal = b[sortField.value]
    
    if (typeof aVal === 'string') {
      aVal = aVal.toLowerCase()
      bVal = bVal.toLowerCase()
    }
    
    if (sortDirection.value === 'asc') {
      return aVal > bVal ? 1 : -1
    } else {
      return aVal < bVal ? 1 : -1
    }
  })

  return filtered
})

const filteredProducts = computed(() => {
  let filtered = products.value

  if (productSearch.value) {
    const search = productSearch.value.toLowerCase()
    filtered = filtered.filter(product => 
      product.name.toLowerCase().includes(search) ||
      product.description.toLowerCase().includes(search)
    )
  }

  if (productFilter.value !== 'all') {
    switch (productFilter.value) {
      case 'in-stock':
        filtered = filtered.filter(product => product.stock_quantity > 10)
        break
      case 'low-stock':
        filtered = filtered.filter(product => product.stock_quantity > 0 && product.stock_quantity <= 10)
        break
      case 'out-of-stock':
        filtered = filtered.filter(product => product.stock_quantity === 0)
        break
    }
  }

  return filtered
})

const filteredCustomers = computed(() => {
  let filtered = customers.value

  if (customerSearch.value) {
    const search = customerSearch.value.toLowerCase()
    filtered = filtered.filter(customer => 
      customer.name.toLowerCase().includes(search) ||
      customer.email.toLowerCase().includes(search)
    )
  }

  if (customerFilter.value !== 'all') {
    filtered = filtered.filter(customer => customer.status === customerFilter.value)
  }

  return filtered
})

const totalPages = computed(() => {
  return Math.ceil(filteredOrders.value.length / itemsPerPage.value)
})

const paginatedOrders = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value
  const end = start + itemsPerPage.value
  return filteredOrders.value.slice(start, end)
})

const visiblePages = computed(() => {
  const pages = []
  const total = totalPages.value
  const current = currentPage.value
  
  if (total <= 7) {
    for (let i = 1; i <= total; i++) {
      pages.push(i)
    }
  } else {
    if (current <= 4) {
      for (let i = 1; i <= 5; i++) {
        pages.push(i)
      }
      pages.push('...')
      pages.push(total)
    } else if (current >= total - 3) {
      pages.push(1)
      pages.push('...')
      for (let i = total - 4; i <= total; i++) {
        pages.push(i)
      }
    } else {
      pages.push(1)
      pages.push('...')
      for (let i = current - 1; i <= current + 1; i++) {
        pages.push(i)
      }
      pages.push('...')
      pages.push(total)
    }
  }
  
  return pages
})

// Methods
const getCurrentTabName = () => {
  const tab = sidebarItems.value.find(item => item.id === activeTab.value)
  return tab ? tab.name : 'Dashboard'
}

const getCurrentTabDescription = () => {
  const descriptions = {
    dashboard: 'Overview of your store performance and key metrics',
    orders: 'Manage and track all customer orders',
    products: 'Manage your product inventory and details',
    customers: 'View and manage customer information',
    analytics: 'Detailed analytics and performance reports',
    settings: 'Configure your store settings and preferences'
  }
  return descriptions[activeTab.value] || ''
}

const setActiveTab = (tab) => {
  activeTab.value = tab
  sidebarOpen.value = false
}

// Search functionality
const handleGlobalSearch = () => {
  if (!globalSearch.value) {
    searchResults.value = []
    return
  }

  const search = globalSearch.value.toLowerCase()
  const results = []

  // Search orders
  recentOrders.value.forEach(order => {
    if (order.id.toString().includes(search) || 
        order.customer_name.toLowerCase().includes(search) ||
        order.customer_email.toLowerCase().includes(search)) {
      results.push({
        id: order.id,
        type: 'order',
        title: `Order #${order.id}`,
        subtitle: `${order.customer_name} - $${order.total.toFixed(2)}`
      })
    }
  })

  // Search customers
  customers.value.forEach(customer => {
    if (customer.name.toLowerCase().includes(search) || 
        customer.email.toLowerCase().includes(search)) {
      results.push({
        id: customer.id,
        type: 'customer',
        title: customer.name,
        subtitle: customer.email
      })
    }
  })

  // Search products
  products.value.forEach(product => {
    if (product.name.toLowerCase().includes(search) || 
        product.description.toLowerCase().includes(search)) {
      results.push({
        id: product.id,
        type: 'product',
        title: product.name,
        subtitle: `$${product.price.toFixed(2)} - ${product.stock_quantity} in stock`
      })
    }
  })

  searchResults.value = results.slice(0, 10)
}

const selectSearchResult = (result) => {
  switch (result.type) {
    case 'order':
      activeTab.value = 'orders'
      const order = recentOrders.value.find(o => o.id === result.id)
      if (order) viewOrder(order)
      break
    case 'customer':
      activeTab.value = 'customers'
      break
    case 'product':
      activeTab.value = 'products'
      break
  }
  globalSearch.value = ''
  searchResults.value = []
}

// Notification functions
const markAllAsRead = () => {
  notifications.value.forEach(notification => {
    notification.read = true
  })
}

const clearAllNotifications = () => {
  notifications.value = []
}

const handleNotificationClick = (notification) => {
  notification.read = true
  // Handle navigation based on notification type
  switch (notification.type) {
    case 'order':
      activeTab.value = 'orders'
      break
    case 'alert':
      activeTab.value = 'products'
      break
  }
  showNotifications.value = false
}

const removeNotification = (id) => {
  const index = notifications.value.findIndex(n => n.id === id)
  if (index > -1) {
    notifications.value.splice(index, 1)
  }
}

const getNotificationIcon = (type) => {
  switch (type) {
    case 'order': return ShoppingCartIcon
    case 'alert': return AlertCircleIcon
    case 'success': return CheckCircleIcon
    case 'info': return InfoIcon
    default: return BellIcon
  }
}

const getNotificationColor = (type) => {
  switch (type) {
    case 'order': return 'bg-blue-100 text-blue-600'
    case 'alert': return 'bg-red-100 text-red-600'
    case 'success': return 'bg-green-100 text-green-600'
    case 'info': return 'bg-gray-100 text-gray-600'
    default: return 'bg-gray-100 text-gray-600'
  }
}

// Order management functions
const viewOrder = (order) => {
  selectedOrder.value = order
}

const editOrder = (order) => {
  editingOrder.value = JSON.parse(JSON.stringify(order)) // Deep clone
  showEditOrderModal.value = true
}

const duplicateOrder = (order) => {
  const newOrder = {
    ...order,
    id: Math.max(...recentOrders.value.map(o => o.id)) + 1,
    status: 'pending',
    created_at: new Date().toISOString()
  }
  recentOrders.value.unshift(newOrder)
  showToast('success', 'Order Duplicated', `Order #${newOrder.id} has been created`)
}

const deleteOrder = (orderId) => {
  if (confirm('Are you sure you want to delete this order?')) {
    const index = recentOrders.value.findIndex(order => order.id === orderId)
    if (index > -1) {
      recentOrders.value.splice(index, 1)
      showToast('success', 'Order Deleted', 'Order has been successfully deleted')
    }
  }
}

const updateOrderStatus = (orderId, newStatus) => {
  const order = recentOrders.value.find(o => o.id === orderId)
  if (order) {
    order.status = newStatus
    showToast('success', 'Status Updated', `Order #${orderId} status changed to ${newStatus}`)
  }
}

const printOrder = (order) => {
  showToast('info', 'Print Order', `Printing order #${order.id}...`)
}

// Edit order functions
const closeEditOrderModal = () => {
  showEditOrderModal.value = false
  editingOrder.value = null
}

const saveOrderChanges = () => {
  const index = recentOrders.value.findIndex(order => order.id === editingOrder.value.id)
  if (index > -1) {
    recentOrders.value[index] = { ...editingOrder.value }
    showToast('success', 'Order Updated', `Order #${editingOrder.value.id} has been updated`)
    closeEditOrderModal()
  }
}

const addProductToOrder = () => {
  newProductForOrder.value = { id: '', quantity: 1 }
  showAddProductToOrderModal.value = true
}

const closeAddProductToOrderModal = () => {
  showAddProductToOrderModal.value = false
  newProductForOrder.value = { id: '', quantity: 1 }
}

const updateNewProductDetails = () => {
  const product = products.value.find(p => p.id == newProductForOrder.value.id)
  if (product) {
    newProductForOrder.value.name = product.name
    newProductForOrder.value.price = product.price
    newProductForOrder.value.image = product.image
  }
}

const getProductStock = (productId) => {
  const product = products.value.find(p => p.id == productId)
  return product ? product.stock_quantity : 0
}

const confirmAddProductToOrder = () => {
  const product = products.value.find(p => p.id == newProductForOrder.value.id)
  if (product) {
    const newProduct = {
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: newProductForOrder.value.quantity,
      image: product.image
    }
    editingOrder.value.products.push(newProduct)
    calculateOrderTotal()
    closeAddProductToOrderModal()
    showToast('success', 'Product Added', `${product.name} added to order`)
  }
}

const updateProductInOrder = (index, productId) => {
  const product = products.value.find(p => p.id == productId)
  if (product) {
    editingOrder.value.products[index] = {
      ...editingOrder.value.products[index],
      id: product.id,
      name: product.name,
      price: product.price,
      image: product.image
    }
    calculateOrderTotal()
  }
}

const removeProductFromOrder = (index) => {
  editingOrder.value.products.splice(index, 1)
  calculateOrderTotal()
}

const calculateOrderTotal = () => {
  if (editingOrder.value && editingOrder.value.products) {
    const total = editingOrder.value.products.reduce((sum, product) => {
      return sum + (product.quantity * product.price)
    }, 0)
    editingOrder.value.total = total
    editingOrder.value.items_count = editingOrder.value.products.reduce((sum, product) => sum + product.quantity, 0)
  }
}

// Product management functions
const viewProduct = (product) => {
  showToast('info', 'View Product', `Viewing ${product.name}`)
}

const editProduct = (product) => {
  editingProduct.value = JSON.parse(JSON.stringify(product))
  showEditProductModal.value = true
}

const duplicateProduct = (product) => {
  const newProduct = {
    ...product,
    id: Math.max(...products.value.map(p => p.id)) + 1,
    name: `${product.name} (Copy)`
  }
  products.value.push(newProduct)
  showToast('success', 'Product Duplicated', `${newProduct.name} has been created`)
}

const deleteProduct = (productId) => {
  if (confirm('Are you sure you want to delete this product?')) {
    const index = products.value.findIndex(product => product.id === productId)
    if (index > -1) {
      products.value.splice(index, 1)
      showToast('success', 'Product Deleted', 'Product has been successfully deleted')
    }
  }
}

const closeEditProductModal = () => {
  showEditProductModal.value = false
  editingProduct.value = null
}

const saveProductChanges = () => {
  const index = products.value.findIndex(product => product.id === editingProduct.value.id)
  if (index > -1) {
    products.value[index] = { ...editingProduct.value }
    showToast('success', 'Product Updated', `${editingProduct.value.name} has been updated`)
    closeEditProductModal()
  }
}

// Customer management functions
const viewCustomer = (customer) => {
  showToast('info', 'View Customer', `Viewing ${customer.name}`)
}

const editCustomer = (customer) => {
  editingCustomer.value = JSON.parse(JSON.stringify(customer))
  showEditCustomerModal.value = true
}

const emailCustomer = (customer) => {
  showToast('info', 'Email Customer', `Opening email to ${customer.email}`)
}

const deleteCustomer = (customerId) => {
  if (confirm('Are you sure you want to delete this customer?')) {
    const index = customers.value.findIndex(customer => customer.id === customerId)
    if (index > -1) {
      customers.value.splice(index, 1)
      showToast('success', 'Customer Deleted', 'Customer has been successfully deleted')
    }
  }
}

const closeEditCustomerModal = () => {
  showEditCustomerModal.value = false
  editingCustomer.value = null
}

const saveCustomerChanges = () => {
  const index = customers.value.findIndex(customer => customer.id === editingCustomer.value.id)
  if (index > -1) {
    customers.value[index] = { ...editingCustomer.value }
    showToast('success', 'Customer Updated', `${editingCustomer.value.name} has been updated`)
    closeEditCustomerModal()
  }
}

// Bulk actions
const toggleOrderSelection = (orderId) => {
  const index = selectedOrders.value.indexOf(orderId)
  if (index > -1) {
    selectedOrders.value.splice(index, 1)
  } else {
    selectedOrders.value.push(orderId)
  }
}

const toggleAllOrders = () => {
  if (selectedOrders.value.length === filteredOrders.value.length) {
    selectedOrders.value = []
  } else {
    selectedOrders.value = filteredOrders.value.map(order => order.id)
  }
}

const clearSelection = () => {
  selectedOrders.value = []
  bulkAction.value = ''
}

const applyBulkAction = () => {
  if (!bulkAction.value || selectedOrders.value.length === 0) return

  switch (bulkAction.value) {
    case 'mark-processing':
      selectedOrders.value.forEach(orderId => {
        const order = recentOrders.value.find(o => o.id === orderId)
        if (order) order.status = 'processing'
      })
      showToast('success', 'Bulk Update', `${selectedOrders.value.length} orders marked as processing`)
      break
    case 'mark-shipped':
      selectedOrders.value.forEach(orderId => {
        const order = recentOrders.value.find(o => o.id === orderId)
        if (order) order.status = 'shipped'
      })
      showToast('success', 'Bulk Update', `${selectedOrders.value.length} orders marked as shipped`)
      break
    case 'mark-completed':
      selectedOrders.value.forEach(orderId => {
        const order = recentOrders.value.find(o => o.id === orderId)
        if (order) order.status = 'completed'
      })
      showToast('success', 'Bulk Update', `${selectedOrders.value.length} orders marked as completed`)
      break
    case 'export-selected':
      exportOrders(selectedOrders.value)
      break
    case 'delete':
      if (confirm(`Are you sure you want to delete ${selectedOrders.value.length} orders?`)) {
        selectedOrders.value.forEach(orderId => {
          const index = recentOrders.value.findIndex(o => o.id === orderId)
          if (index > -1) recentOrders.value.splice(index, 1)
        })
        showToast('success', 'Bulk Delete', `${selectedOrders.value.length} orders deleted`)
      }
      break
  }

  clearSelection()
}

// Pagination
const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--
  }
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++
  }
}

const goToPage = (page) => {
  if (page !== '...' && page >= 1 && page <= totalPages.value) {
    currentPage.value = page
  }
}

// Sorting
const sortOrders = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortField.value = field
    sortDirection.value = 'desc'
  }
}

const getSortIcon = (field) => {
  if (sortField.value !== field) return MinusIcon
  return sortDirection.value === 'asc' ? TrendingUpIcon : TrendingDownIcon
}

// Export functions
const exportData = () => {
  showToast('info', 'Export Started', 'Preparing data export...')
}

const exportOrders = (orderIds = null) => {
  const ordersToExport = orderIds ? 
    recentOrders.value.filter(order => orderIds.includes(order.id)) : 
    filteredOrders.value
  showToast('success', 'Export Complete', `${ordersToExport.length} orders exported`)
}

const exportProducts = () => {
  showToast('success', 'Export Complete', `${filteredProducts.value.length} products exported`)
}

const exportCustomers = () => {
  showToast('success', 'Export Complete', `${filteredCustomers.value.length} customers exported`)
}

const exportAnalytics = () => {
  showToast('success', 'Export Complete', 'Analytics report exported')
}

// Quick actions
const quickAddOrder = () => {
  showQuickAdd.value = false
  showAddOrderModal.value = true
  showToast('info', 'Add Order', 'Opening new order form...')
}

const quickAddProduct = () => {
  showQuickAdd.value = false
  showAddProductModal.value = true
  showToast('info', 'Add Product', 'Opening new product form...')
}

const quickAddCustomer = () => {
  showQuickAdd.value = false
  showAddCustomerModal.value = true
  showToast('info', 'Add Customer', 'Opening new customer form...')
}

const generateReport = () => {
  showToast('info', 'Generate Report', 'Generating comprehensive report...')
}

// Utility functions
const refreshData = () => {
  isRefreshing.value = true
  setTimeout(() => {
    isRefreshing.value = false
    lastUpdated.value = new Date().toLocaleTimeString()
    showToast('success', 'Data Refreshed', 'All data has been updated')
  }, 1000)
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const formatTimeAgo = (date) => {
  const now = new Date()
  const diffInMinutes = Math.floor((now - new Date(date)) / (1000 * 60))
  
  if (diffInMinutes < 1) return 'Just now'
  if (diffInMinutes < 60) return `${diffInMinutes}m ago`
  
  const diffInHours = Math.floor(diffInMinutes / 60)
  if (diffInHours < 24) return `${diffInHours}h ago`
  
  const diffInDays = Math.floor(diffInHours / 24)
  return `${diffInDays}d ago`
}

const getStatusColor = (status) => {
  switch (status) {
    case 'completed': return 'bg-green-100 text-green-800'
    case 'processing': return 'bg-blue-100 text-blue-800'
    case 'shipped': return 'bg-purple-100 text-purple-800'
    case 'pending': return 'bg-yellow-100 text-yellow-800'
    case 'cancelled': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

const getStatusSelectColor = (status) => {
  switch (status) {
    case 'completed': return 'bg-green-100 text-green-800'
    case 'processing': return 'bg-blue-100 text-blue-800'
    case 'shipped': return 'bg-purple-100 text-purple-800'
    case 'pending': return 'bg-yellow-100 text-yellow-800'
    case 'cancelled': return 'bg-red-100 text-red-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

const getStockStatus = (quantity) => {
  if (quantity === 0) return 'Out of Stock'
  if (quantity <= 10) return 'Low Stock'
  return 'In Stock'
}

const getStockStatusColor = (quantity) => {
  if (quantity === 0) return 'bg-red-100 text-red-800'
  if (quantity <= 10) return 'bg-yellow-100 text-yellow-800'
  return 'bg-green-100 text-green-800'
}

const getCustomerStatusColor = (status) => {
  switch (status) {
    case 'active': return 'bg-green-100 text-green-800'
    case 'inactive': return 'bg-gray-100 text-gray-800'
    case 'vip': return 'bg-purple-100 text-purple-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}

// Settings functions
const saveSettings = () => {
  showToast('success', 'Settings Saved', 'Your settings have been updated successfully')
}

const resetSettings = () => {
  if (confirm('Are you sure you want to reset all settings to default?')) {
    // Reset to default values
    settings.value = {
      storeName: 'AquaPure',
      storeEmail: 'info@aquapure.com',
      storePhone: '+1 (555) 123-4567',
      storeAddress: '123 Water Street, Clean City, CC 12345',
      currency: 'USD',
      taxRate: 8.25,
      lowStockThreshold: 10,
      emailNewOrders: true,
      lowStockAlerts: true,
      weeklySalesReports: true,
      reviewNotifications: false
    }
    showToast('info', 'Settings Reset', 'All settings have been reset to default values')
  }
}

// User menu functions
const openUserProfile = () => {
  showUserMenu.value = false
  showToast('info', 'User Profile', 'Opening user profile...')
}

const openSettings = () => {
  showUserMenu.value = false
  activeTab.value = 'settings'
}

const viewActivityLog = () => {
  showUserMenu.value = false
  showToast('info', 'Activity Log', 'Opening activity log...')
}

const logout = () => {
  if (confirm('Are you sure you want to logout?')) {
    authStore.logout()
    router.push('/admin/login')
  }
}

// Toast notification system
const showToast = (type, title, message) => {
  const id = Date.now()
  const toast = {
    id,
    type,
    title,
    message,
    show: false
  }
  
  toasts.value.push(toast)
  
  // Trigger animation
  setTimeout(() => {
    toast.show = true
  }, 100)
  
  // Auto remove after 5 seconds
  setTimeout(() => {
    removeToast(id)
  }, 5000)
}

const removeToast = (id) => {
  const index = toasts.value.findIndex(toast => toast.id === id)
  if (index > -1) {
    toasts.value[index].show = false
    setTimeout(() => {
      toasts.value.splice(index, 1)
    }, 300)
  }
}

const getToastIcon = (type) => {
  switch (type) {
    case 'success': return CheckCircleIcon
    case 'error': return AlertCircleIcon
    case 'warning': return AlertCircleIcon
    case 'info': return InfoIcon
    default: return InfoIcon
  }
}

const getToastColor = (type) => {
  switch (type) {
    case 'success': return 'text-green-600'
    case 'error': return 'text-red-600'
    case 'warning': return 'text-yellow-600'
    case 'info': return 'text-blue-600'
    default: return 'text-gray-600'
  }
}

// Lifecycle hooks
onMounted(() => {
  // Check authentication
  if (!authStore.isAuthenticated) {
    router.push('/admin/login')
    return
  }

  // Set up real-time updates
  const interval = setInterval(() => {
    lastUpdated.value = new Date().toLocaleTimeString()
  }, 30000)

  // Cleanup
  onUnmounted(() => {
    clearInterval(interval)
  })

  // Close dropdowns when clicking outside
  const handleClickOutside = (event) => {
    if (!event.target.closest('.relative')) {
      showNotifications.value = false
      showUserMenu.value = false
      showQuickAdd.value = false
    }
  }

  document.addEventListener('click', handleClickOutside)
  onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside)
  })

  // Keyboard shortcuts
  const handleKeydown = (event) => {
    if (event.ctrlKey || event.metaKey) {
      switch (event.key) {
        case 'k':
          event.preventDefault()
          document.querySelector('input[type="search"]')?.focus()
          break
        case 'n':
          event.preventDefault()
          showQuickAdd.value = true
          break
      }
    }
  }

  document.addEventListener('keydown', handleKeydown)
  onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
  })
})

// Watch for changes
watch(orderSearch, () => {
  currentPage.value = 1
})

watch(orderFilter, () => {
  currentPage.value = 1
})

watch(itemsPerPage, () => {
  currentPage.value = 1
})
</script>
