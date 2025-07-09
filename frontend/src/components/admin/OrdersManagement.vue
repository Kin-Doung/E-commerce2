<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="order max-w-7xl mx-auto">
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
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
                Orders Management
              </h2>
              <p class="text-lg text-gray-600 mt-2">
                Track and manage customer orders efficiently
              </p>
            </div>
            <div class="flex items-center space-x-4">
              <div class="text-right">
                <p class="text-3xl font-bold text-purple-600">
                  {{ orders.length }}
                </p>
                <p class="text-sm text-gray-500">Total Orders</p>
              </div>
              <div class="text-right">
                <p class="text-3xl font-bold text-green-600">
                  ${{ totalRevenue.toFixed(2) }}
                </p>
                <p class="text-sm text-gray-500">Total Revenue</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Search and Filter Section -->
        <div
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-8"
        >
          <div
            class="flex flex-col lg:flex-row lg:items-center lg:justify-between space-y-4 lg:space-y-0"
          >
            <div
              class="flex flex-col sm:flex-row sm:items-center space-y-4 sm:space-y-0 sm:space-x-4"
            >
              <div class="relative">
                <svg
                  class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
                  />
                </svg>
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="Search orders..."
                  class="pl-10 pr-4 py-3 w-80 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 transition-colors"
                />
              </div>
              <select
                v-model="statusFilter"
                class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
              >
                <option value="">All Status</option>
                <option value="pending">Pending</option>
                <option value="processing">Processing</option>
                <option value="shipped">Shipped</option>
                <option value="delivered">Delivered</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </div>
            <div class="flex items-center space-x-4">
              <div class="flex items-center space-x-2">
                <span class="text-sm text-gray-600">Show:</span>
                <select
                  v-model="itemsPerPage"
                  class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="10">10</option>
                  <option value="25">25</option>
                  <option value="50">50</option>
                  <option value="100">100</option>
                </select>
              </div>
              <button
                @click="fetchOrders"
                class="p-3 text-gray-600 hover:text-purple-600 hover:bg-purple-50 rounded-lg transition-colors"
                :disabled="loading"
              >
                <svg
                  class="h-5 w-5"
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
              </button>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div
          v-if="loading && !orders.length"
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-12"
        >
          <div class="text-center">
            <div
              class="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-600 mx-auto mb-4"
            ></div>
            <p class="text-gray-600">Loading orders...</p>
          </div>
        </div>

        <!-- Orders Table -->
        <div
          v-else-if="paginatedOrders.length > 0"
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <!-- Table Header -->
          <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">Orders</h3>
              <div class="flex items-center space-x-4">
                <span class="text-sm text-gray-600">
                  Showing {{ startIndex + 1 }} to {{ endIndex }} of
                  {{ filteredOrders.length }} entries
                </span>
                <div class="flex items-center space-x-2">
                  <button
                    @click="selectAll"
                    class="text-sm text-purple-600 hover:text-purple-800 font-medium"
                    v-if="selectedOrders.length < paginatedOrders.length"
                  >
                    Select All
                  </button>
                  <button
                    @click="clearSelection"
                    class="text-sm text-gray-600 hover:text-gray-800 font-medium"
                    v-if="selectedOrders.length > 0"
                  >
                    Clear ({{ selectedOrders.length }})
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Table Content -->
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left">
                    <input
                      type="checkbox"
                      :checked="
                        selectedOrders.length === paginatedOrders.length &&
                        paginatedOrders.length > 0
                      "
                      @change="toggleSelectAll"
                      class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded"
                    />
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 transition-colors"
                    @click="sortBy('id')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Order ID</span>
                      <svg
                        v-if="sortField === 'id'"
                        class="h-4 w-4"
                        :class="
                          sortDirection === 'asc' ? 'transform rotate-180' : ''
                        "
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M19 9l-7 7-7-7"
                        />
                      </svg>
                    </div>
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 transition-colors"
                    @click="sortBy('user.name')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Customer</span>
                      <svg
                        v-if="sortField === 'user.name'"
                        class="h-4 w-4"
                        :class="
                          sortDirection === 'asc' ? 'transform rotate-180' : ''
                        "
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M19 9l-7 7-7-7"
                        />
                      </svg>
                    </div>
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 transition-colors"
                    @click="sortBy('total')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Total</span>
                      <svg
                        v-if="sortField === 'total'"
                        class="h-4 w-4"
                        :class="
                          sortDirection === 'asc' ? 'transform rotate-180' : ''
                        "
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M19 9l-7 7-7-7"
                        />
                      </svg>
                    </div>
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Status
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 transition-colors"
                    @click="sortBy('updated_at')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Date</span>
                      <svg
                        v-if="sortField === 'updated_at'"
                        class="h-4 w-4"
                        :class="
                          sortDirection === 'asc' ? 'transform rotate-180' : ''
                        "
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M19 9l-7 7-7-7"
                        />
                      </svg>
                    </div>
                  </th>
                  <th
                    class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="(order, index) in paginatedOrders"
                  :key="order.id || index"
                  class="hover:bg-gray-50 transition-colors duration-150"
                  :class="{
                    'bg-purple-50': selectedOrders.includes(order.id || index),
                  }"
                >
                  <td class="px-6 py-4 whitespace-nowrap">
                    <input
                      type="checkbox"
                      :value="order.id || index"
                      v-model="selectedOrders"
                      class="h-4 w-4 text-purple-600 focus:ring-purple-500 border-gray-300 rounded"
                    />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <div
                        class="w-8 h-8 bg-purple-100 rounded-lg flex items-center justify-center mr-3"
                      >
                        <span class="text-purple-600 font-semibold text-sm"
                          >#{{ order.id || index + 1 }}</span
                        >
                      </div>
                      <span class="text-sm font-medium text-gray-900"
                        >Order #{{ order.id || index + 1 }}</span
                      >
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <div
                        class="w-10 h-10 bg-gradient-to-r from-purple-500 to-pink-600 rounded-full flex items-center justify-center mr-3"
                      >
                        <span class="text-white font-semibold text-sm">{{
                          getInitials(order.user?.name || "Unknown")
                        }}</span>
                      </div>
                      <div>
                        <div class="text-sm font-semibold text-gray-900">
                          {{ order.user?.name || "Unknown Customer" }}
                        </div>
                        <div class="text-xs text-gray-500">
                          {{ order.user?.email || "No email" }}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span class="text-lg font-bold text-green-600"
                      >${{ parseFloat(order.total || 0).toFixed(2) }}</span
                    >
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span :class="getStatusClass(order.status || 'pending')">
                      <div
                        class="w-1.5 h-1.5 rounded-full mr-1.5"
                        :class="getStatusDotClass(order.status || 'pending')"
                      ></div>
                      {{ formatStatus(order.status || "pending") }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{
                      formatDate(
                        order.updated_at || order.created_at || new Date()
                      )
                    }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-center">
                    <div class="relative inline-block">
                      <button
                        @click="toggleActionMenu(index)"
                        class="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg transition-colors duration-200"
                        :class="{
                          'bg-gray-100 text-gray-600':
                            activeMenuIndex === index,
                        }"
                      >
                        <svg
                          class="h-5 w-5"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"
                          />
                        </svg>
                      </button>

                      <!-- Action Menu Dropdown -->
                      <div
                        v-if="activeMenuIndex === index"
                        class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 z-20 py-1"
                      >
                        <button
                          @click="viewOrder(order)"
                          class="flex items-center w-full px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 transition-colors duration-150"
                        >
                          <svg
                            class="h-4 w-4 mr-3 text-blue-500"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
                            />
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
                            />
                          </svg>
                          <span>View Details</span>
                        </button>

                        <button
                          @click="updateOrderStatus(order)"
                          class="flex items-center w-full px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 transition-colors duration-150"
                        >
                          <svg
                            class="h-4 w-4 mr-3 text-yellow-500"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                            />
                          </svg>
                          <span>Update Status</span>
                        </button>

                        <div class="border-t border-gray-100 my-1"></div>

                        <button
                          @click="deleteOrder(order.id || index)"
                          class="flex items-center w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 transition-colors duration-150"
                        >
                          <svg
                            class="h-4 w-4 mr-3 text-red-500"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                            />
                          </svg>
                          <span>Delete Order</span>
                        </button>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="px-6 py-4 border-t border-gray-200 bg-gray-50">
            <div class="flex items-center justify-between">
              <div class="text-sm text-gray-700">
                Showing {{ startIndex + 1 }} to {{ endIndex }} of
                {{ filteredOrders.length }} results
              </div>
              <div class="flex items-center space-x-2">
                <button
                  @click="previousPage"
                  :disabled="currentPage === 1"
                  class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  Previous
                </button>
                <div class="flex items-center space-x-1">
                  <button
                    v-for="page in visiblePages"
                    :key="page"
                    @click="goToPage(page)"
                    :class="[
                      'px-3 py-2 text-sm font-medium rounded-lg transition-colors',
                      page === currentPage
                        ? 'bg-purple-600 text-white'
                        : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-50',
                    ]"
                  >
                    {{ page }}
                  </button>
                </div>
                <button
                  @click="nextPage"
                  :disabled="currentPage === totalPages"
                  class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                >
                  Next
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div
          v-else
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-12"
        >
          <div class="text-center">
            <svg
              class="h-16 w-16 text-gray-300 mx-auto mb-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900 mb-2">
              No Orders Found
            </h3>
            <p class="text-gray-600 mb-6">
              No orders match your current search criteria.
            </p>
          </div>
        </div>

        <!-- View Order Modal -->
        <div
          v-if="isShowing"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
        >
          <div
            class="bg-white rounded-xl shadow-xl w-full max-w-2xl max-h-screen overflow-y-auto"
          >
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-2xl font-bold text-gray-900">Order Details</h2>
                <button
                  @click="isShowing = false"
                  class="text-gray-400 hover:text-gray-600 transition-colors"
                >
                  <svg
                    class="h-6 w-6"
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
            </div>

            <div class="p-6 space-y-6">
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <span class="font-medium text-gray-700">Order ID:</span>
                  <p class="text-gray-900">#{{ selectedOrder.id }}</p>
                </div>
                <div>
                  <span class="font-medium text-gray-700">Status:</span>
                  <span
                    :class="getStatusClass(selectedOrder.status || 'pending')"
                    class="ml-2"
                  >
                    {{ formatStatus(selectedOrder.status || "pending") }}
                  </span>
                </div>
                <div>
                  <span class="font-medium text-gray-700">Customer:</span>
                  <p class="text-gray-900">
                    {{ selectedOrder.user?.name || "Unknown" }}
                  </p>
                </div>
                <div>
                  <span class="font-medium text-gray-700">Email:</span>
                  <p class="text-gray-900">
                    {{ selectedOrder.user?.email || "No email" }}
                  </p>
                </div>
                <div>
                  <span class="font-medium text-gray-700">Total:</span>
                  <p class="text-2xl font-bold text-green-600">
                    ${{ parseFloat(selectedOrder.total || 0).toFixed(2) }}
                  </p>
                </div>
                <div>
                  <span class="font-medium text-gray-700">Date:</span>
                  <p class="text-gray-900">
                    {{
                      formatDate(
                        selectedOrder.updated_at || selectedOrder.created_at
                      )
                    }}
                  </p>
                </div>
              </div>

              <div class="flex justify-end pt-4">
                <button
                  @click="isShowing = false"
                  class="px-6 py-3 bg-gray-600 hover:bg-gray-700 text-white rounded-lg font-medium transition-colors duration-200"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Success Toast -->
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
import { ref, computed, onMounted, onUnmounted } from "vue";

// Reactive state
const orders = ref([]);
const searchQuery = ref("");
const statusFilter = ref("");
const selectedOrder = ref({});
const isShowing = ref(false);
const loading = ref(false);
const error = ref(null);
const showToast = ref(false);
const toastMessage = ref("");

// Table state
const selectedOrders = ref([]);
const itemsPerPage = ref(10);
const currentPage = ref(1);
const sortField = ref("id");
const sortDirection = ref("desc");
const activeMenuIndex = ref(null);

// Computed properties
const filteredOrders = computed(() => {
  let filtered = orders.value;

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (order) =>
        order.user?.name?.toLowerCase().includes(query) ||
        order.id?.toString().includes(query) ||
        order.user?.email?.toLowerCase().includes(query)
    );
  }

  if (statusFilter.value) {
    filtered = filtered.filter(
      (order) =>
        (order.status || "pending").toLowerCase() ===
        statusFilter.value.toLowerCase()
    );
  }

  // Apply sorting
  filtered.sort((a, b) => {
    let aVal, bVal;

    if (sortField.value.includes(".")) {
      const keys = sortField.value.split(".");
      aVal = keys.reduce((obj, key) => obj?.[key], a);
      bVal = keys.reduce((obj, key) => obj?.[key], b);
    } else {
      aVal = a[sortField.value];
      bVal = b[sortField.value];
    }

    if (typeof aVal === "string") {
      aVal = aVal.toLowerCase();
      bVal = bVal?.toLowerCase() || "";
    }

    if (sortDirection.value === "asc") {
      return aVal > bVal ? 1 : -1;
    } else {
      return aVal < bVal ? 1 : -1;
    }
  });

  return filtered;
});

const totalPages = computed(() => {
  return Math.ceil(filteredOrders.value.length / itemsPerPage.value);
});

const paginatedOrders = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredOrders.value.slice(start, end);
});

const startIndex = computed(() => {
  return (currentPage.value - 1) * itemsPerPage.value;
});

const endIndex = computed(() => {
  return Math.min(
    startIndex.value + itemsPerPage.value,
    filteredOrders.value.length
  );
});

const visiblePages = computed(() => {
  const pages = [];
  const maxVisible = 5;
  let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2));
  let end = Math.min(totalPages.value, start + maxVisible - 1);

  if (end - start + 1 < maxVisible) {
    start = Math.max(1, end - maxVisible + 1);
  }

  for (let i = start; i <= end; i++) {
    pages.push(i);
  }

  return pages;
});

const totalRevenue = computed(() => {
  return orders.value.reduce(
    (sum, order) => sum + parseFloat(order.total || 0),
    0
  );
});

// Methods
const fetchOrders = async () => {
  try {
    loading.value = true;
    error.value = null;

    // Using fetch instead of axios for pure Vue approach
    const response = await fetch("http://localhost:8000/api/orders");
    if (!response.ok) throw new Error("Failed to fetch orders");

    const data = await response.json();
    orders.value = Array.isArray(data) ? data : [data];
  } catch (err) {
    error.value = err.message;
    console.error("Error fetching orders:", err);
  } finally {
    loading.value = false;
  }
};

const viewOrder = (order) => {
  selectedOrder.value = { ...order };
  isShowing.value = true;
  activeMenuIndex.value = null;
};

const updateOrderStatus = (order) => {
  // Implement status update logic here
  showToastMessage(
    `Status update for order #${order.id} - Feature coming soon!`
  );
  activeMenuIndex.value = null;
};

const deleteOrder = async (id) => {
  if (confirm("Are you sure you want to delete this order?")) {
    try {
      loading.value = true;
      // Implement delete API call here
      orders.value = orders.value.filter((o) => o.id !== id);
      selectedOrders.value = selectedOrders.value.filter(
        (selectedId) => selectedId !== id
      );
      showToastMessage("Order deleted successfully!");
      activeMenuIndex.value = null;
    } catch (err) {
      error.value = err.message;
    } finally {
      loading.value = false;
    }
  }
};

const getInitials = (name) => {
  if (!name) return "U";
  return name
    .split(" ")
    .map((n) => n[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);
};

const getStatusClass = (status) => {
  const classes = {
    pending:
      "inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-800",
    processing:
      "inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-blue-100 text-blue-800",
    shipped:
      "inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-purple-100 text-purple-800",
    delivered:
      "inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800",
    cancelled:
      "inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800",
  };
  return classes[status.toLowerCase()] || classes.pending;
};

const getStatusDotClass = (status) => {
  const classes = {
    pending: "bg-yellow-400",
    processing: "bg-blue-400",
    shipped: "bg-purple-400",
    delivered: "bg-green-400",
    cancelled: "bg-red-400",
  };
  return classes[status.toLowerCase()] || classes.pending;
};

const formatStatus = (status) => {
  return status.charAt(0).toUpperCase() + status.slice(1);
};

const formatDate = (date) => {
  if (!date) return "N/A";
  return new Date(date).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const showToastMessage = (message) => {
  toastMessage.value = message;
  showToast.value = true;
  setTimeout(() => {
    showToast.value = false;
  }, 3000);
};

// Table methods
const sortBy = (field) => {
  if (sortField.value === field) {
    sortDirection.value = sortDirection.value === "asc" ? "desc" : "asc";
  } else {
    sortField.value = field;
    sortDirection.value = "asc";
  }
};

const toggleSelectAll = () => {
  if (selectedOrders.value.length === paginatedOrders.value.length) {
    selectedOrders.value = [];
  } else {
    selectedOrders.value = paginatedOrders.value.map((order) => order.id);
  }
};

const selectAll = () => {
  selectedOrders.value = paginatedOrders.value.map((order) => order.id);
};

const clearSelection = () => {
  selectedOrders.value = [];
};

const toggleActionMenu = (index) => {
  activeMenuIndex.value = activeMenuIndex.value === index ? null : index;
};

// Pagination methods
const goToPage = (page) => {
  currentPage.value = page;
};

const previousPage = () => {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
};

const nextPage = () => {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (!event.target.closest(".relative")) {
    activeMenuIndex.value = null;
  }
};

// Lifecycle
onMounted(() => {
  fetchOrders();
  document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
});
</script>

<style scoped>
.container{
  display: flex;
}
.order{
  width: 85%;
  margin-right: -20px;
}
/* Custom table styles */
.table-hover tbody tr:hover {
  background-color: #f9fafb;
}

/* Custom scrollbar */
.overflow-x-auto::-webkit-scrollbar {
  height: 6px;
}

.overflow-x-auto::-webkit-scrollbar-track {
  background: #f1f5f9;
}

.overflow-x-auto::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 3px;
}

.overflow-x-auto::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}
</style>
