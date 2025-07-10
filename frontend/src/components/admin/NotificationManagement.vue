<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="notification max-w-7xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900 mb-2">
            Notification Management
          </h1>
          <p class="text-gray-600">Manage and send notifications to users</p>
        </div>

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center">
              <div class="p-3 bg-blue-100 rounded-lg">
                <svg
                  class="w-6 h-6 text-blue-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M15 17h5l-5 5v-5zM4 19h6v-2H4v2zM4 15h8v-2H4v2zM4 11h8V9H4v2z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">
                  Total Notifications
                </p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ notifications.length }}
                </p>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center">
              <div class="p-3 bg-green-100 rounded-lg">
                <svg
                  class="w-6 h-6 text-green-600"
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
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Sent</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ sentNotifications }}
                </p>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center">
              <div class="p-3 bg-yellow-100 rounded-lg">
                <svg
                  class="w-6 h-6 text-yellow-600"
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
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Pending</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ pendingNotifications }}
                </p>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center">
              <div class="p-3 bg-red-100 rounded-lg">
                <svg
                  class="w-6 h-6 text-red-600"
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
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Failed</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ failedNotifications }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Alert -->
        <div
          v-if="alert"
          :class="`mb-6 p-4 rounded-lg flex items-center ${
            alert.type === 'success'
              ? 'bg-green-50 text-green-800 border border-green-200'
              : 'bg-red-50 text-red-800 border border-red-200'
          }`"
        >
          <svg
            v-if="alert.type === 'success'"
            class="w-5 h-5 mr-3"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
              clip-rule="evenodd"
            />
          </svg>
          <svg
            v-else
            class="w-5 h-5 mr-3"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
              clip-rule="evenodd"
            />
          </svg>
          {{ alert.message }}
          <button
            @click="alert = null"
            class="ml-auto text-current opacity-70 hover:opacity-100"
          >
            <svg
              class="w-4 h-4"
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

        <!-- Action Buttons and Search -->
        <div
          class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6"
        >
          <div class="relative flex-1 max-w-md">
            <svg
              class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400"
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
              placeholder="Search notifications..."
              class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
          <div class="flex gap-2">
            <select
              v-model="filterStatus"
              class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            >
              <option value="">All Status</option>
              <option value="sent">Sent</option>
              <option value="pending">Pending</option>
              <option value="failed">Failed</option>
            </select>
            <button
              @click="showCreateModal = true"
              class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
            >
              <svg
                class="w-5 h-5"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              Create Notification
            </button>
          </div>
        </div>

        <!-- Notifications Table -->
        <div
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <div class="px-6 py-4 border-b border-gray-200">
            <h3 class="text-lg font-semibold text-gray-900">Notifications</h3>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Title
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Type
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Recipients
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Status
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Created
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="notification in filteredNotifications"
                  :key="notification.id"
                  class="hover:bg-gray-50"
                >
                  <td class="px-6 py-4">
                    <div class="text-sm font-medium text-gray-900">
                      {{ notification.title }}
                    </div>
                    <div class="text-sm text-gray-500 truncate max-w-xs">
                      {{ notification.message }}
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getTypeColor(
                        notification.type
                      )}`"
                    >
                      {{ notification.type }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ notification.recipients }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getStatusColor(
                        notification.status
                      )}`"
                    >
                      {{ notification.status }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(notification.createdAt) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <div class="flex gap-2">
                      <button
                        @click="viewNotification(notification)"
                        class="text-blue-600 hover:text-blue-900 transition-colors"
                      >
                        View
                      </button>
                      <button
                        v-if="notification.status === 'pending'"
                        @click="sendNotification(notification.id)"
                        class="text-green-600 hover:text-green-900 transition-colors"
                      >
                        Send
                      </button>
                      <button
                        @click="deleteNotification(notification.id)"
                        class="text-red-600 hover:text-red-900 transition-colors"
                      >
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
                <tr v-if="filteredNotifications.length === 0">
                  <td colspan="6" class="px-6 py-12 text-center text-gray-500">
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
                        d="M15 17h5l-5 5v-5zM4 19h6v-2H4v2zM4 15h8v-2H4v2zM4 11h8V9H4v2z"
                      />
                    </svg>
                    <p class="text-lg font-medium">No notifications found</p>
                    <p class="text-sm">
                      {{
                        searchQuery
                          ? "Try adjusting your search"
                          : "Create your first notification to get started"
                      }}
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Create/Edit Notification Modal -->
        <div
          v-if="showCreateModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="closeCreateModal"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  Create New Notification
                </h3>
                <button
                  @click="closeCreateModal"
                  class="text-gray-400 hover:text-gray-600 transition-colors"
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

              <form @submit.prevent="createNotification" class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Title</label
                  >
                  <input
                    v-model="newNotification.title"
                    type="text"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter notification title"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Message</label
                  >
                  <textarea
                    v-model="newNotification.message"
                    required
                    rows="4"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter notification message"
                  ></textarea>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2"
                      >Type</label
                    >
                    <select
                      v-model="newNotification.type"
                      required
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="">Select type</option>
                      <option value="info">Info</option>
                      <option value="warning">Warning</option>
                      <option value="success">Success</option>
                      <option value="error">Error</option>
                      <option value="promotion">Promotion</option>
                    </select>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2"
                      >Target Audience</label
                    >
                    <select
                      v-model="newNotification.audience"
                      required
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="">Select audience</option>
                      <option value="all">All Users</option>
                      <option value="customers">Customers Only</option>
                      <option value="premium">Premium Users</option>
                      <option value="new">New Users</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Schedule (Optional)</label
                  >
                  <input
                    v-model="newNotification.scheduledAt"
                    type="datetime-local"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                  <p class="text-sm text-gray-500 mt-1">
                    Leave empty to send immediately
                  </p>
                </div>

                <div class="flex items-center">
                  <input
                    v-model="newNotification.sendEmail"
                    type="checkbox"
                    id="sendEmail"
                    class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <label
                    for="sendEmail"
                    class="ml-2 block text-sm text-gray-900"
                  >
                    Also send as email notification
                  </label>
                </div>

                <div class="flex gap-3 pt-4">
                  <button
                    type="submit"
                    :disabled="isLoading"
                    class="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors flex items-center justify-center gap-2"
                  >
                    <svg
                      v-if="isLoading"
                      class="animate-spin w-4 h-4"
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
                    {{ isLoading ? "Creating..." : "Create Notification" }}
                  </button>
                  <button
                    type="button"
                    @click="closeCreateModal"
                    class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- View Notification Modal -->
        <div
          v-if="showViewModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="showViewModal = false"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-2xl w-full mx-4"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  Notification Details
                </h3>
                <button
                  @click="showViewModal = false"
                  class="text-gray-400 hover:text-gray-600 transition-colors"
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

              <div v-if="selectedNotification" class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >Title</label
                  >
                  <p class="text-lg font-semibold text-gray-900">
                    {{ selectedNotification.title }}
                  </p>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >Message</label
                  >
                  <p class="text-gray-900 whitespace-pre-wrap">
                    {{ selectedNotification.message }}
                  </p>
                </div>

                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >Type</label
                    >
                    <span
                      :class="`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${getTypeColor(
                        selectedNotification.type
                      )}`"
                    >
                      {{ selectedNotification.type }}
                    </span>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >Status</label
                    >
                    <span
                      :class="`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${getStatusColor(
                        selectedNotification.status
                      )}`"
                    >
                      {{ selectedNotification.status }}
                    </span>
                  </div>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >Recipients</label
                  >
                  <p class="text-gray-900">
                    {{ selectedNotification.recipients }}
                  </p>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1"
                    >Created At</label
                  >
                  <p class="text-gray-900">
                    {{ formatDate(selectedNotification.createdAt) }}
                  </p>
                </div>
              </div>

              <div class="flex gap-3 pt-6">
                <button
                  v-if="selectedNotification?.status === 'pending'"
                  @click="sendNotification(selectedNotification.id)"
                  class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors"
                >
                  Send Now
                </button>
                <button
                  @click="showViewModal = false"
                  class="px-6 py-2 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "NotificationManagement",
  data() {
    return {
      notifications: [
        {
          id: 1,
          title: "Welcome to Our Platform",
          message:
            "Thank you for joining us! Explore all the amazing features we have to offer.",
          type: "info",
          status: "sent",
          recipients: "All Users",
          createdAt: new Date("2024-01-15T10:30:00"),
          sendEmail: true,
        },
        {
          id: 2,
          title: "System Maintenance",
          message:
            "We will be performing scheduled maintenance on January 20th from 2:00 AM to 4:00 AM UTC.",
          type: "warning",
          status: "pending",
          recipients: "All Users",
          createdAt: new Date("2024-01-14T15:45:00"),
          sendEmail: false,
        },
        {
          id: 3,
          title: "New Feature Released",
          message:
            "Check out our new dashboard analytics feature! It provides detailed insights into your usage patterns.",
          type: "success",
          status: "sent",
          recipients: "Premium Users",
          createdAt: new Date("2024-01-13T09:15:00"),
          sendEmail: true,
        },
        {
          id: 4,
          title: "Payment Failed",
          message:
            "Your recent payment could not be processed. Please update your payment method.",
          type: "error",
          status: "failed",
          recipients: "Specific Users",
          createdAt: new Date("2024-01-12T14:20:00"),
          sendEmail: true,
        },
        {
          id: 5,
          title: "Special Offer - 50% Off",
          message:
            "Limited time offer! Get 50% off on all premium plans. Use code SAVE50 at checkout.",
          type: "promotion",
          status: "sent",
          recipients: "Customers Only",
          createdAt: new Date("2024-01-11T11:00:00"),
          sendEmail: true,
        },
      ],
      searchQuery: "",
      filterStatus: "",
      showCreateModal: false,
      showViewModal: false,
      selectedNotification: null,
      isLoading: false,
      alert: null,
      newNotification: {
        title: "",
        message: "",
        type: "",
        audience: "",
        scheduledAt: "",
        sendEmail: false,
      },
    };
  },
  computed: {
    filteredNotifications() {
      let filtered = this.notifications;

      if (this.searchQuery) {
        filtered = filtered.filter(
          (notification) =>
            notification.title
              .toLowerCase()
              .includes(this.searchQuery.toLowerCase()) ||
            notification.message
              .toLowerCase()
              .includes(this.searchQuery.toLowerCase())
        );
      }

      if (this.filterStatus) {
        filtered = filtered.filter(
          (notification) => notification.status === this.filterStatus
        );
      }

      return filtered.sort(
        (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
      );
    },
    sentNotifications() {
      return this.notifications.filter((n) => n.status === "sent").length;
    },
    pendingNotifications() {
      return this.notifications.filter((n) => n.status === "pending").length;
    },
    failedNotifications() {
      return this.notifications.filter((n) => n.status === "failed").length;
    },
  },
  methods: {
    getStatusColor(status) {
      const colors = {
        sent: "bg-green-100 text-green-800",
        pending: "bg-yellow-100 text-yellow-800",
        failed: "bg-red-100 text-red-800",
      };
      return colors[status] || "bg-gray-100 text-gray-800";
    },
    getTypeColor(type) {
      const colors = {
        info: "bg-blue-100 text-blue-800",
        warning: "bg-yellow-100 text-yellow-800",
        success: "bg-green-100 text-green-800",
        error: "bg-red-100 text-red-800",
        promotion: "bg-purple-100 text-purple-800",
      };
      return colors[type] || "bg-gray-100 text-gray-800";
    },
    formatDate(date) {
      return new Date(date).toLocaleString();
    },
    showAlert(type, message) {
      this.alert = { type, message };
      setTimeout(() => {
        this.alert = null;
      }, 5000);
    },
    viewNotification(notification) {
      this.selectedNotification = notification;
      this.showViewModal = true;
    },
    async createNotification() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        const newNotification = {
          id: Date.now(),
          ...this.newNotification,
          status: this.newNotification.scheduledAt ? "pending" : "sent",
          recipients: this.getAudienceLabel(this.newNotification.audience),
          createdAt: new Date(),
        };

        this.notifications.unshift(newNotification);
        this.closeCreateModal();
        this.showAlert("success", "Notification created successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to create notification");
      } finally {
        this.isLoading = false;
      }
    },
    getAudienceLabel(audience) {
      const labels = {
        all: "All Users",
        customers: "Customers Only",
        premium: "Premium Users",
        new: "New Users",
      };
      return labels[audience] || audience;
    },
    async sendNotification(id) {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        const notification = this.notifications.find((n) => n.id === id);
        if (notification) {
          notification.status = "sent";
        }

        this.showAlert("success", "Notification sent successfully!");
        this.showViewModal = false;
      } catch (error) {
        this.showAlert("error", "Failed to send notification");
      } finally {
        this.isLoading = false;
      }
    },
    async deleteNotification(id) {
      if (!confirm("Are you sure you want to delete this notification?"))
        return;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.notifications = this.notifications.filter((n) => n.id !== id);
        this.showAlert("success", "Notification deleted successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to delete notification");
      }
    },
    closeCreateModal() {
      this.showCreateModal = false;
      this.newNotification = {
        title: "",
        message: "",
        type: "",
        audience: "",
        scheduledAt: "",
        sendEmail: false,
      };
    },
  },
};
</script>

<style scoped>
.container{
    display: flex;
}
.notification{
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
