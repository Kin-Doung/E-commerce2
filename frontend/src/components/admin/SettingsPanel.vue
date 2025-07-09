<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="setting max-w-7xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900 mb-2">Settings</h1>
          <p class="text-gray-600">Manage system settings and configurations</p>
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

        <!-- General Settings Tab -->
        <div v-if="activeTab === 'general'" class="space-y-6">
          <!-- Site Information -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Site Information
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Site Name</label
                >
                <input
                  v-model="generalSettings.siteName"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Enter site name"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Site URL</label
                >
                <input
                  v-model="generalSettings.siteUrl"
                  type="url"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="https://example.com"
                />
              </div>

              <div class="md:col-span-2">
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Site Description</label
                >
                <textarea
                  v-model="generalSettings.siteDescription"
                  rows="3"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Enter site description"
                ></textarea>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Admin Email</label
                >
                <input
                  v-model="generalSettings.adminEmail"
                  type="email"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="admin@example.com"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Support Email</label
                >
                <input
                  v-model="generalSettings.supportEmail"
                  type="email"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="support@example.com"
                />
              </div>
            </div>
          </div>

          <!-- Regional Settings -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Regional Settings
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Timezone</label
                >
                <select
                  v-model="generalSettings.timezone"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="UTC">UTC</option>
                  <option value="America/New_York">Eastern Time</option>
                  <option value="America/Chicago">Central Time</option>
                  <option value="America/Denver">Mountain Time</option>
                  <option value="America/Los_Angeles">Pacific Time</option>
                  <option value="Europe/London">London</option>
                  <option value="Europe/Paris">Paris</option>
                  <option value="Asia/Tokyo">Tokyo</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Date Format</label
                >
                <select
                  v-model="generalSettings.dateFormat"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="MM/DD/YYYY">MM/DD/YYYY</option>
                  <option value="DD/MM/YYYY">DD/MM/YYYY</option>
                  <option value="YYYY-MM-DD">YYYY-MM-DD</option>
                  <option value="DD MMM YYYY">DD MMM YYYY</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Currency</label
                >
                <select
                  v-model="generalSettings.currency"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="USD">USD - US Dollar</option>
                  <option value="EUR">EUR - Euro</option>
                  <option value="GBP">GBP - British Pound</option>
                  <option value="JPY">JPY - Japanese Yen</option>
                  <option value="CAD">CAD - Canadian Dollar</option>
                </select>
              </div>
            </div>
          </div>

          <!-- Maintenance Mode -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Maintenance Mode
            </h3>
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Enable Maintenance Mode</label
                  >
                  <p class="text-sm text-gray-500">
                    Put the site in maintenance mode for updates
                  </p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input
                    v-model="generalSettings.maintenanceMode"
                    type="checkbox"
                    class="sr-only peer"
                  />
                  <div
                    class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
                  ></div>
                </label>
              </div>

              <div v-if="generalSettings.maintenanceMode">
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Maintenance Message</label
                >
                <textarea
                  v-model="generalSettings.maintenanceMessage"
                  rows="3"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="We are currently performing maintenance. Please check back later."
                ></textarea>
              </div>
            </div>
          </div>
        </div>

        <!-- Email Settings Tab -->
        <div v-if="activeTab === 'email'" class="space-y-6">
          <!-- SMTP Configuration -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              SMTP Configuration
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >SMTP Host</label
                >
                <input
                  v-model="emailSettings.smtpHost"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="smtp.gmail.com"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >SMTP Port</label
                >
                <input
                  v-model.number="emailSettings.smtpPort"
                  type="number"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="587"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Username</label
                >
                <input
                  v-model="emailSettings.smtpUsername"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="your-email@gmail.com"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Password</label
                >
                <input
                  v-model="emailSettings.smtpPassword"
                  type="password"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="••••••••"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Encryption</label
                >
                <select
                  v-model="emailSettings.smtpEncryption"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                >
                  <option value="tls">TLS</option>
                  <option value="ssl">SSL</option>
                  <option value="none">None</option>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >From Name</label
                >
                <input
                  v-model="emailSettings.fromName"
                  type="text"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Your Company"
                />
              </div>
            </div>

            <div class="mt-6 flex gap-3">
              <button
                @click="testEmailConnection"
                :disabled="isLoading"
                class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400 transition-colors flex items-center gap-2"
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
                {{ isLoading ? "Testing..." : "Test Connection" }}
              </button>
            </div>
          </div>

          <!-- Email Templates -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Email Templates
            </h3>
            <div class="space-y-4">
              <div
                v-for="template in emailTemplates"
                :key="template.id"
                class="border border-gray-200 rounded-lg p-4"
              >
                <div class="flex items-center justify-between mb-3">
                  <div>
                    <h4 class="font-medium text-gray-900">
                      {{ template.name }}
                    </h4>
                    <p class="text-sm text-gray-500">
                      {{ template.description }}
                    </p>
                  </div>
                  <button
                    @click="editEmailTemplate(template)"
                    class="text-blue-600 hover:text-blue-900 transition-colors"
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
                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                      />
                    </svg>
                  </button>
                </div>
                <div class="text-sm text-gray-600">
                  <p><strong>Subject:</strong> {{ template.subject }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- API Settings Tab -->
        <div v-if="activeTab === 'api'" class="space-y-6">
          <!-- API Configuration -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              API Configuration
            </h3>
            <div class="space-y-4">
              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Enable API</label
                  >
                  <p class="text-sm text-gray-500">
                    Allow external applications to access the API
                  </p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input
                    v-model="apiSettings.enabled"
                    type="checkbox"
                    class="sr-only peer"
                  />
                  <div
                    class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
                  ></div>
                </label>
              </div>

              <div v-if="apiSettings.enabled">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2"
                      >Rate Limit (requests/minute)</label
                    >
                    <input
                      v-model.number="apiSettings.rateLimit"
                      type="number"
                      min="1"
                      max="1000"
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2"
                      >API Version</label
                    >
                    <select
                      v-model="apiSettings.version"
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="v1">Version 1.0</option>
                      <option value="v2">Version 2.0</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- API Keys -->
          <div
            v-if="apiSettings.enabled"
            class="bg-white rounded-xl shadow-sm border border-gray-200 p-6"
          >
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-semibold text-gray-900">API Keys</h3>
              <button
                @click="generateApiKey"
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
                    d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                  />
                </svg>
                Generate Key
              </button>
            </div>

            <div class="space-y-3">
              <div
                v-for="key in apiKeys"
                :key="key.id"
                class="flex items-center justify-between p-4 border border-gray-200 rounded-lg"
              >
                <div>
                  <div class="font-medium text-gray-900">{{ key.name }}</div>
                  <div class="text-sm text-gray-500 font-mono">
                    {{ key.key }}
                  </div>
                  <div class="text-xs text-gray-400">
                    Created: {{ formatDate(key.createdAt) }}
                  </div>
                </div>
                <div class="flex gap-2">
                  <button
                    @click="copyApiKey(key.key)"
                    class="text-blue-600 hover:text-blue-900 transition-colors"
                    title="Copy to clipboard"
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
                        d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                      />
                    </svg>
                  </button>
                  <button
                    @click="revokeApiKey(key.id)"
                    class="text-red-600 hover:text-red-900 transition-colors"
                    title="Revoke key"
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
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      />
                    </svg>
                  </button>
                </div>
              </div>

              <div
                v-if="apiKeys.length === 0"
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
                    d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"
                  />
                </svg>
                <p>No API keys generated yet</p>
                <p class="text-sm">
                  Generate your first API key to get started
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Backup Settings Tab -->
        <div v-if="activeTab === 'backup'" class="space-y-6">
          <!-- Backup Configuration -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Backup Configuration
            </h3>
            <div class="space-y-6">
              <div class="flex items-center justify-between">
                <div>
                  <label class="text-sm font-medium text-gray-700"
                    >Automatic Backups</label
                  >
                  <p class="text-sm text-gray-500">
                    Enable scheduled automatic backups
                  </p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input
                    v-model="backupSettings.autoBackup"
                    type="checkbox"
                    class="sr-only peer"
                  />
                  <div
                    class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"
                  ></div>
                </label>
              </div>

              <div
                v-if="backupSettings.autoBackup"
                class="grid grid-cols-1 md:grid-cols-2 gap-6"
              >
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Backup Frequency</label
                  >
                  <select
                    v-model="backupSettings.frequency"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="daily">Daily</option>
                    <option value="weekly">Weekly</option>
                    <option value="monthly">Monthly</option>
                  </select>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Retention Period (days)</label
                  >
                  <input
                    v-model.number="backupSettings.retentionDays"
                    type="number"
                    min="1"
                    max="365"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div class="md:col-span-2">
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Backup Location</label
                  >
                  <select
                    v-model="backupSettings.location"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="local">Local Storage</option>
                    <option value="s3">Amazon S3</option>
                    <option value="google">Google Cloud Storage</option>
                    <option value="dropbox">Dropbox</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- Manual Backup -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Manual Backup
            </h3>
            <div class="flex items-center justify-between">
              <div>
                <p class="text-gray-600">
                  Create a backup of your data immediately
                </p>
                <p class="text-sm text-gray-500">
                  This will include all database records and uploaded files
                </p>
              </div>
              <button
                @click="createManualBackup"
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
                {{ isLoading ? "Creating..." : "Create Backup" }}
              </button>
            </div>
          </div>

          <!-- Backup History -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h3 class="text-lg font-semibold text-gray-900 mb-4">
              Backup History
            </h3>
            <div class="space-y-3">
              <div
                v-for="backup in backupHistory"
                :key="backup.id"
                class="flex items-center justify-between p-4 border border-gray-200 rounded-lg"
              >
                <div>
                  <div class="font-medium text-gray-900">{{ backup.name }}</div>
                  <div class="text-sm text-gray-500">
                    {{ backup.size }} • {{ formatDate(backup.createdAt) }}
                  </div>
                  <div class="text-xs text-gray-400">{{ backup.type }}</div>
                </div>
                <div class="flex gap-2">
                  <button
                    @click="downloadBackup(backup.id)"
                    class="text-blue-600 hover:text-blue-900 transition-colors"
                    title="Download backup"
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
                  </button>
                  <button
                    @click="deleteBackup(backup.id)"
                    class="text-red-600 hover:text-red-900 transition-colors"
                    title="Delete backup"
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
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      />
                    </svg>
                  </button>
                </div>
              </div>

              <div
                v-if="backupHistory.length === 0"
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
                    d="M5 8h14M5 8a2 2 0 110-4h1.586a1 1 0 01.707.293l1.414 1.414a1 1 0 00.707.293H15a2 2 0 012 2v0M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4"
                  />
                </svg>
                <p>No backups available</p>
                <p class="text-sm">Create your first backup to get started</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Save Button (for General and Email tabs) -->
        <div
          v-if="activeTab === 'general' || activeTab === 'email'"
          class="flex justify-end"
        >
          <button
            @click="saveSettings"
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

        <!-- Email Template Modal -->
        <div
          v-if="showEmailTemplateModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="showEmailTemplateModal = false"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  Edit Email Template
                </h3>
                <button
                  @click="showEmailTemplateModal = false"
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

              <form
                v-if="selectedEmailTemplate"
                @submit.prevent="saveEmailTemplate"
                class="space-y-6"
              >
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Template Name</label
                  >
                  <input
                    v-model="selectedEmailTemplate.name"
                    type="text"
                    readonly
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg bg-gray-50"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Subject</label
                  >
                  <input
                    v-model="selectedEmailTemplate.subject"
                    type="text"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Content</label
                  >
                  <textarea
                    v-model="selectedEmailTemplate.content"
                    rows="10"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  ></textarea>
                </div>

                <div class="flex gap-3 pt-4">
                  <button
                    type="submit"
                    :disabled="isLoading"
                    class="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                  >
                    {{ isLoading ? "Saving..." : "Save Template" }}
                  </button>
                  <button
                    type="button"
                    @click="showEmailTemplateModal = false"
                    class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- Generate API Key Modal -->
        <div
          v-if="showApiKeyModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="showApiKeyModal = false"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-md w-full mx-4"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  Generate API Key
                </h3>
                <button
                  @click="showApiKeyModal = false"
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

              <form @submit.prevent="createApiKey" class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Key Name</label
                  >
                  <input
                    v-model="newApiKeyName"
                    type="text"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter a name for this API key"
                  />
                </div>

                <div class="flex gap-3 pt-4">
                  <button
                    type="submit"
                    :disabled="isLoading || !newApiKeyName.trim()"
                    class="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                  >
                    {{ isLoading ? "Generating..." : "Generate Key" }}
                  </button>
                  <button
                    type="button"
                    @click="showApiKeyModal = false"
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
  name: "SettingsManagement",
  data() {
    return {
      activeTab: "general",
      isLoading: false,
      alert: null,
      showEmailTemplateModal: false,
      showApiKeyModal: false,
      selectedEmailTemplate: null,
      newApiKeyName: "",

      tabs: [
        { id: "general", name: "General" },
        { id: "email", name: "Email" },
        { id: "api", name: "API" },
        { id: "backup", name: "Backup" },
      ],

      generalSettings: {
        siteName: "My Application",
        siteUrl: "https://myapp.com",
        siteDescription:
          "A powerful web application for managing your business",
        adminEmail: "admin@myapp.com",
        supportEmail: "support@myapp.com",
        timezone: "UTC",
        dateFormat: "MM/DD/YYYY",
        currency: "USD",
        maintenanceMode: false,
        maintenanceMessage:
          "We are currently performing maintenance. Please check back later.",
      },

      emailSettings: {
        smtpHost: "smtp.gmail.com",
        smtpPort: 587,
        smtpUsername: "",
        smtpPassword: "",
        smtpEncryption: "tls",
        fromName: "My Application",
      },

      emailTemplates: [
        {
          id: 1,
          name: "Welcome Email",
          description: "Sent to new users when they register",
          subject: "Welcome to {{site_name}}!",
          content:
            "Hello {{user_name}},\n\nWelcome to {{site_name}}! We're excited to have you on board.\n\nBest regards,\nThe {{site_name}} Team",
        },
        {
          id: 2,
          name: "Password Reset",
          description: "Sent when users request password reset",
          subject: "Reset your password",
          content:
            "Hello {{user_name}},\n\nYou requested a password reset. Click the link below to reset your password:\n\n{{reset_link}}\n\nIf you didn't request this, please ignore this email.\n\nBest regards,\nThe {{site_name}} Team",
        },
        {
          id: 3,
          name: "Order Confirmation",
          description: "Sent when an order is placed",
          subject: "Order Confirmation #{{order_number}}",
          content:
            "Hello {{user_name}},\n\nThank you for your order! Here are the details:\n\nOrder Number: {{order_number}}\nTotal: {{order_total}}\n\nWe'll send you another email when your order ships.\n\nBest regards,\nThe {{site_name}} Team",
        },
      ],

      apiSettings: {
        enabled: true,
        rateLimit: 100,
        version: "v1",
      },

      apiKeys: [
        {
          id: 1,
          name: "Production API",
          key: "sk_live_1234567890abcdef",
          createdAt: new Date("2024-01-10T10:00:00"),
        },
        {
          id: 2,
          name: "Development API",
          key: "sk_test_abcdef1234567890",
          createdAt: new Date("2024-01-12T14:30:00"),
        },
      ],

      backupSettings: {
        autoBackup: true,
        frequency: "daily",
        retentionDays: 30,
        location: "local",
      },

      backupHistory: [
        {
          id: 1,
          name: "backup_2024_01_15_10_30.zip",
          size: "45.2 MB",
          type: "Automatic Backup",
          createdAt: new Date("2024-01-15T10:30:00"),
        },
        {
          id: 2,
          name: "backup_2024_01_14_10_30.zip",
          size: "44.8 MB",
          type: "Automatic Backup",
          createdAt: new Date("2024-01-14T10:30:00"),
        },
        {
          id: 3,
          name: "manual_backup_2024_01_13_15_45.zip",
          size: "44.5 MB",
          type: "Manual Backup",
          createdAt: new Date("2024-01-13T15:45:00"),
        },
      ],
    };
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

    async saveSettings() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        this.showAlert("success", "Settings saved successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to save settings");
      } finally {
        this.isLoading = false;
      }
    },

    async testEmailConnection() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 2000));

        this.showAlert("success", "Email connection test successful!");
      } catch (error) {
        this.showAlert("error", "Email connection test failed");
      } finally {
        this.isLoading = false;
      }
    },

    editEmailTemplate(template) {
      this.selectedEmailTemplate = { ...template };
      this.showEmailTemplateModal = true;
    },

    async saveEmailTemplate() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        const index = this.emailTemplates.findIndex(
          (t) => t.id === this.selectedEmailTemplate.id
        );
        if (index !== -1) {
          this.emailTemplates[index] = { ...this.selectedEmailTemplate };
        }

        this.showEmailTemplateModal = false;
        this.showAlert("success", "Email template saved successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to save email template");
      } finally {
        this.isLoading = false;
      }
    },

    generateApiKey() {
      this.showApiKeyModal = true;
    },

    async createApiKey() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 1000));

        const newKey = {
          id: Date.now(),
          name: this.newApiKeyName,
          key: "sk_" + Math.random().toString(36).substr(2, 24),
          createdAt: new Date(),
        };

        this.apiKeys.unshift(newKey);
        this.showApiKeyModal = false;
        this.newApiKeyName = "";
        this.showAlert("success", "API key generated successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to generate API key");
      } finally {
        this.isLoading = false;
      }
    },

    async copyApiKey(key) {
      try {
        await navigator.clipboard.writeText(key);
        this.showAlert("success", "API key copied to clipboard!");
      } catch (error) {
        this.showAlert("error", "Failed to copy API key");
      }
    },

    async revokeApiKey(keyId) {
      if (
        !confirm(
          "Are you sure you want to revoke this API key? This action cannot be undone."
        )
      )
        return;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.apiKeys = this.apiKeys.filter((key) => key.id !== keyId);
        this.showAlert("success", "API key revoked successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to revoke API key");
      }
    },

    async createManualBackup() {
      this.isLoading = true;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 3000));

        const newBackup = {
          id: Date.now(),
          name: `manual_backup_${new Date()
            .toISOString()
            .replace(/[:.]/g, "_")
            .slice(0, -5)}.zip`,
          size: "45.7 MB",
          type: "Manual Backup",
          createdAt: new Date(),
        };

        this.backupHistory.unshift(newBackup);
        this.showAlert("success", "Manual backup created successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to create backup");
      } finally {
        this.isLoading = false;
      }
    },

    async downloadBackup(backupId) {
      try {
        // Simulate download
        const backup = this.backupHistory.find((b) => b.id === backupId);
        if (backup) {
          // In a real app, this would trigger an actual download
          this.showAlert("success", `Downloading ${backup.name}...`);
        }
      } catch (error) {
        this.showAlert("error", "Failed to download backup");
      }
    },

    async deleteBackup(backupId) {
      if (
        !confirm(
          "Are you sure you want to delete this backup? This action cannot be undone."
        )
      )
        return;

      try {
        // Simulate API call
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.backupHistory = this.backupHistory.filter(
          (backup) => backup.id !== backupId
        );
        this.showAlert("success", "Backup deleted successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to delete backup");
      }
    },
  },
};
</script>

<style scoped>
.container{
  display: flex;
}
.setting{
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
