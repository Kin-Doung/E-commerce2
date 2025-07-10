<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="security max-w-7xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900 mb-2">
            Security Management
          </h1>
          <p class="text-gray-600">
            Monitor and manage system security settings
          </p>
        </div>

        <!-- Security Overview Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
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
                    d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Security Score</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ securityScore }}%
                </p>
              </div>
            </div>
          </div>

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
                    d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Active Sessions</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ activeSessions.length }}
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
                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Failed Attempts</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ failedAttempts }}
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
                    d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728L5.636 5.636m12.728 12.728L18.364 5.636M5.636 18.364l12.728-12.728"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Blocked IPs</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ blockedIPs.length }}
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

        <!-- Tabs Navigation -->
        <div class="mb-6">
          <nav class="flex space-x-8">
            <button
              v-for="tab in tabs"
              :key="tab.id"
              @click="activeTab = tab.id"
              :class="`py-2 px-1 border-b-2 font-medium text-sm ${
                activeTab === tab.id
                  ? 'border-blue-500 text-blue-600'
                  : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
              }`"
            >
              {{ tab.name }}
            </button>
          </nav>
        </div>

        <!-- Security Settings Tab -->
        <div v-if="activeTab === 'settings'" class="space-y-6">
          <!-- Password Policy -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Password Policy
            </h3>
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Minimum Password Length</label
                  >
                  <p class="text-sm text-gray-500">
                    Set minimum characters required for passwords
                  </p>
                </div>
                <input
                  v-model.number="securitySettings.minPasswordLength"
                  type="number"
                  min="6"
                  max="32"
                  class="w-20 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Require Special Characters</label
                  >
                  <p class="text-sm text-gray-500">
                    Force users to include special characters
                  </p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input
                    v-model="securitySettings.requireSpecialChars"
                    type="checkbox"
                    class="sr-only peer"
                  />
                  <div
                    class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
                  ></div>
                </label>
              </div>

              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Password Expiry (Days)</label
                  >
                  <p class="text-sm text-gray-500">
                    Force password change after specified days
                  </p>
                </div>
                <input
                  v-model.number="securitySettings.passwordExpiryDays"
                  type="number"
                  min="0"
                  max="365"
                  class="w-20 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>
          </div>

          <!-- Two-Factor Authentication -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Two-Factor Authentication
            </h3>
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Enforce 2FA for Admins</label
                  >
                  <p class="text-sm text-gray-500">
                    Require all admin users to enable 2FA
                  </p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input
                    v-model="securitySettings.enforce2FAForAdmins"
                    type="checkbox"
                    class="sr-only peer"
                  />
                  <div
                    class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
                  ></div>
                </label>
              </div>

              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Allow SMS 2FA</label
                  >
                  <p class="text-sm text-gray-500">
                    Enable SMS-based two-factor authentication
                  </p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input
                    v-model="securitySettings.allowSMS2FA"
                    type="checkbox"
                    class="sr-only peer"
                  />
                  <div
                    class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
                  ></div>
                </label>
              </div>
            </div>
          </div>

          <!-- Session Management -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Session Management
            </h3>
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Session Timeout (Minutes)</label
                  >
                  <p class="text-sm text-gray-500">
                    Auto-logout users after inactivity
                  </p>
                </div>
                <input
                  v-model.number="securitySettings.sessionTimeout"
                  type="number"
                  min="5"
                  max="1440"
                  class="w-20 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>

              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Max Concurrent Sessions</label
                  >
                  <p class="text-sm text-gray-500">
                    Limit simultaneous login sessions per user
                  </p>
                </div>
                <input
                  v-model.number="securitySettings.maxConcurrentSessions"
                  type="number"
                  min="1"
                  max="10"
                  class="w-20 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                />
              </div>
            </div>
          </div>

          <!-- Save Button -->
          <div class="flex justify-end">
            <button
              @click="saveSecuritySettings"
              :disabled="isLoading"
              class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors flex items-center gap-2"
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
              {{ isLoading ? "Saving..." : "Save Settings" }}
            </button>
          </div>
        </div>

        <!-- Active Sessions Tab -->
        <div
          v-if="activeTab === 'sessions'"
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <div
            class="px-6 py-4 border-b border-gray-200 flex justify-between items-center"
          >
            <h3 class="text-lg font-semibold text-gray-900">Active Sessions</h3>
            <button
              @click="refreshSessions"
              class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors flex items-center gap-2"
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
                  d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                />
              </svg>
              Refresh
            </button>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    User
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    IP Address
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Device
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Location
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Last Activity
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
                  v-for="session in activeSessions"
                  :key="session.id"
                  class="hover:bg-gray-50"
                >
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <div
                        class="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center"
                      >
                        <span class="text-sm font-medium text-gray-700">{{
                          session.user.charAt(0).toUpperCase()
                        }}</span>
                      </div>
                      <div class="ml-3">
                        <div class="text-sm font-medium text-gray-900">
                          {{ session.user }}
                        </div>
                        <div class="text-sm text-gray-500">
                          {{ session.role }}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ session.ipAddress }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ session.device }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ session.location }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(session.lastActivity) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <button
                      @click="terminateSession(session.id)"
                      class="text-red-600 hover:text-red-900 transition-colors"
                    >
                      Terminate
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Security Logs Tab -->
        <div
          v-if="activeTab === 'logs'"
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <div
            class="px-6 py-4 border-b border-gray-200 flex justify-between items-center"
          >
            <h3 class="text-lg font-semibold text-gray-900">Security Logs</h3>
            <div class="flex gap-2">
              <select
                v-model="logFilter"
                class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">All Events</option>
                <option value="login">Login Attempts</option>
                <option value="failed">Failed Logins</option>
                <option value="blocked">Blocked IPs</option>
                <option value="admin">Admin Actions</option>
              </select>
              <button
                @click="exportLogs"
                class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors flex items-center gap-2"
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
                    d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
                Export
              </button>
            </div>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Timestamp
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Event Type
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    User/IP
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Description
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Status
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="log in filteredLogs"
                  :key="log.id"
                  class="hover:bg-gray-50"
                >
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ formatDate(log.timestamp) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getEventTypeColor(
                        log.eventType
                      )}`"
                    >
                      {{ log.eventType }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {{ log.userOrIP }}
                  </td>
                  <td class="px-6 py-4 text-sm text-gray-900">
                    {{ log.description }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getStatusColor(
                        log.status
                      )}`"
                    >
                      {{ log.status }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Blocked IPs Tab -->
        <div
          v-if="activeTab === 'blocked'"
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <div
            class="px-6 py-4 border-b border-gray-200 flex justify-between items-center"
          >
            <h3 class="text-lg font-semibold text-gray-900">
              Blocked IP Addresses
            </h3>
            <button
              @click="showBlockIPModal = true"
              class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors flex items-center gap-2"
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
                  d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                />
              </svg>
              Block IP
            </button>
          </div>

          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    IP Address
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Reason
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Blocked Date
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Expires
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
                  v-for="ip in blockedIPs"
                  :key="ip.id"
                  class="hover:bg-gray-50"
                >
                  <td
                    class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                  >
                    {{ ip.address }}
                  </td>
                  <td class="px-6 py-4 text-sm text-gray-900">
                    {{ ip.reason }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(ip.blockedDate) }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ ip.expiresAt ? formatDate(ip.expiresAt) : "Never" }}
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                    <button
                      @click="unblockIP(ip.id)"
                      class="text-green-600 hover:text-green-900 transition-colors"
                    >
                      Unblock
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Block IP Modal -->
        <div
          v-if="showBlockIPModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="showBlockIPModal = false"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-md w-full mx-4"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  Block IP Address
                </h3>
                <button
                  @click="showBlockIPModal = false"
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

              <form @submit.prevent="blockIP" class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >IP Address</label
                  >
                  <input
                    v-model="newBlockedIP.address"
                    type="text"
                    required
                    pattern="^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="192.168.1.1"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Reason</label
                  >
                  <textarea
                    v-model="newBlockedIP.reason"
                    required
                    rows="3"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Reason for blocking this IP address"
                  ></textarea>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Expiry Date (Optional)</label
                  >
                  <input
                    v-model="newBlockedIP.expiresAt"
                    type="datetime-local"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                  <p class="text-sm text-gray-500 mt-1">
                    Leave empty for permanent block
                  </p>
                </div>

                <div class="flex gap-3 pt-4">
                  <button
                    type="submit"
                    :disabled="isLoading"
                    class="flex-1 px-6 py-3 bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:bg-gray-400 transition-colors"
                  >
                    {{ isLoading ? "Blocking..." : "Block IP" }}
                  </button>
                  <button
                    type="button"
                    @click="showBlockIPModal = false"
                    class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
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
  </div>
</template>

<script>
export default {
  name: "SecurityManagement",
  data() {
    return {
      activeTab: "settings",
      isLoading: false,
      alert: null,
      logFilter: "",
      showBlockIPModal: false,

      tabs: [
        { id: "settings", name: "Security Settings" },
        { id: "sessions", name: "Active Sessions" },
        { id: "logs", name: "Security Logs" },
        { id: "blocked", name: "Blocked IPs" },
      ],

      securitySettings: {
        minPasswordLength: 8,
        requireSpecialChars: true,
        passwordExpiryDays: 90,
        enforce2FAForAdmins: true,
        allowSMS2FA: true,
        sessionTimeout: 30,
        maxConcurrentSessions: 3,
      },

      activeSessions: [
        {
          id: 1,
          user: "john.doe@example.com",
          role: "Admin",
          ipAddress: "192.168.1.100",
          device: "Chrome on Windows",
          location: "New York, US",
          lastActivity: new Date("2024-01-15T14:30:00"),
        },
        {
          id: 2,
          user: "jane.smith@example.com",
          role: "User",
          ipAddress: "10.0.0.50",
          device: "Safari on macOS",
          location: "London, UK",
          lastActivity: new Date("2024-01-15T14:25:00"),
        },
        {
          id: 3,
          user: "admin@example.com",
          role: "Super Admin",
          ipAddress: "172.16.0.10",
          device: "Firefox on Linux",
          location: "Tokyo, JP",
          lastActivity: new Date("2024-01-15T14:20:00"),
        },
      ],

      securityLogs: [
        {
          id: 1,
          timestamp: new Date("2024-01-15T14:30:00"),
          eventType: "login",
          userOrIP: "john.doe@example.com",
          description: "Successful login from new device",
          status: "success",
        },
        {
          id: 2,
          timestamp: new Date("2024-01-15T14:25:00"),
          eventType: "failed",
          userOrIP: "192.168.1.200",
          description: "Failed login attempt - invalid password",
          status: "failed",
        },
        {
          id: 3,
          timestamp: new Date("2024-01-15T14:20:00"),
          eventType: "blocked",
          userOrIP: "10.0.0.100",
          description: "IP blocked due to multiple failed attempts",
          status: "blocked",
        },
        {
          id: 4,
          timestamp: new Date("2024-01-15T14:15:00"),
          eventType: "admin",
          userOrIP: "admin@example.com",
          description: "Security settings updated",
          status: "success",
        },
        {
          id: 5,
          timestamp: new Date("2024-01-15T14:10:00"),
          eventType: "login",
          userOrIP: "jane.smith@example.com",
          description: "2FA verification successful",
          status: "success",
        },
      ],

      blockedIPs: [
        {
          id: 1,
          address: "192.168.1.200",
          reason: "Multiple failed login attempts",
          blockedDate: new Date("2024-01-15T10:00:00"),
          expiresAt: new Date("2024-01-22T10:00:00"),
        },
        {
          id: 2,
          address: "10.0.0.100",
          reason: "Suspicious activity detected",
          blockedDate: new Date("2024-01-14T15:30:00"),
          expiresAt: null,
        },
        {
          id: 3,
          address: "172.16.0.50",
          reason: "Brute force attack attempt",
          blockedDate: new Date("2024-01-13T09:15:00"),
          expiresAt: new Date("2024-01-20T09:15:00"),
        },
      ],

      newBlockedIP: {
        address: "",
        reason: "",
        expiresAt: "",
      },
    };
  },
  computed: {
    securityScore() {
      let score = 0;
      if (this.securitySettings.minPasswordLength >= 8) score += 20;
      if (this.securitySettings.requireSpecialChars) score += 20;
      if (this.securitySettings.enforce2FAForAdmins) score += 25;
      if (this.securitySettings.sessionTimeout <= 60) score += 15;
      if (
        this.securitySettings.passwordExpiryDays > 0 &&
        this.securitySettings.passwordExpiryDays <= 90
      )
        score += 20;
      return score;
    },

    failedAttempts() {
      return this.securityLogs.filter((log) => log.status === "failed").length;
    },

    filteredLogs() {
      if (!this.logFilter) return this.securityLogs;
      return this.securityLogs.filter(
        (log) => log.eventType === this.logFilter
      );
    },
  },

  methods: {
    showAlert(type, message) {
      this.alert = { type, message };
      setTimeout(() => {
        this.alert = null;
      }, 5000);
    },

    formatDate(date) {
      return new Date(date).toLocaleString();
    },

    getEventTypeColor(eventType) {
      const colors = {
        login: "bg-green-100 text-green-800",
        failed: "bg-red-100 text-red-800",
        blocked: "bg-yellow-100 text-yellow-800",
        admin: "bg-blue-100 text-blue-800",
      };
      return colors[eventType] || "bg-gray-100 text-gray-800";
    },

    getStatusColor(status) {
      const colors = {
        success: "bg-green-100 text-green-800",
        failed: "bg-red-100 text-red-800",
        blocked: "bg-yellow-100 text-yellow-800",
      };
      return colors[status] || "bg-gray-100 text-gray-800";
    },

    async saveSecuritySettings() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        this.showAlert("success", "Security settings saved successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to save security settings");
      } finally {
        this.isLoading = false;
      }
    },

    async refreshSessions() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.showAlert("success", "Sessions refreshed successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to refresh sessions");
      } finally {
        this.isLoading = false;
      }
    },

    async terminateSession(sessionId) {
      if (!confirm("Are you sure you want to terminate this session?")) return;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.activeSessions = this.activeSessions.filter(
          (session) => session.id !== sessionId
        );
        this.showAlert("success", "Session terminated successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to terminate session");
      }
    },

    async blockIP() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        const newIP = {
          id: Date.now(),
          address: this.newBlockedIP.address,
          reason: this.newBlockedIP.reason,
          blockedDate: new Date(),
          expiresAt: this.newBlockedIP.expiresAt
            ? new Date(this.newBlockedIP.expiresAt)
            : null,
        };

        this.blockedIPs.unshift(newIP);
        this.showBlockIPModal = false;
        this.newBlockedIP = { address: "", reason: "", expiresAt: "" };
        this.showAlert("success", "IP address blocked successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to block IP address");
      } finally {
        this.isLoading = false;
      }
    },

    async unblockIP(ipId) {
      if (!confirm("Are you sure you want to unblock this IP address?")) return;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.blockedIPs = this.blockedIPs.filter((ip) => ip.id !== ipId);
        this.showAlert("success", "IP address unblocked successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to unblock IP address");
      }
    },

    exportLogs() {
      // Simulate log export
      const logs = this.filteredLogs.map((log) => ({
        timestamp: this.formatDate(log.timestamp),
        eventType: log.eventType,
        userOrIP: log.userOrIP,
        description: log.description,
        status: log.status,
      }));

      const csvContent =
        "data:text/csv;charset=utf-8," +
        "Timestamp,Event Type,User/IP,Description,Status\n" +
        logs.map((log) => Object.values(log).join(",")).join("\n");

      const encodedUri = encodeURI(csvContent);
      const link = document.createElement("a");
      link.setAttribute("href", encodedUri);
      link.setAttribute(
        "download",
        `security_logs_${new Date().toISOString().split("T")[0]}.csv`
      );
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      this.showAlert("success", "Security logs exported successfully!");
    },
  },
};
</script>

<style scoped>
.container{
    display: flex;
}
.security{
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

/* Custom toggle switch styles */
.peer:checked ~ .peer-checked\:after\:translate-x-full::after {
  transform: translateX(100%);
}
</style>
