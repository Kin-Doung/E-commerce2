<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="help max-w-7xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900 mb-2">
            Help & Support Management
          </h1>
          <p class="text-gray-600">
            Manage support tickets, knowledge base, and help resources
          </p>
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
                    d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">Total Tickets</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ tickets.length }}
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
                  {{ pendingTickets }}
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
                <p class="text-sm font-medium text-gray-600">Resolved</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ resolvedTickets }}
                </p>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <div class="flex items-center">
              <div class="p-3 bg-purple-100 rounded-lg">
                <svg
                  class="w-6 h-6 text-purple-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <p class="text-sm font-medium text-gray-600">KB Articles</p>
                <p class="text-2xl font-bold text-gray-900">
                  {{ knowledgeBase.length }}
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

        <!-- Support Tickets Tab -->
        <div v-if="activeTab === 'tickets'" class="space-y-6">
          <!-- Filters and Search -->
          <div
            class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4"
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
                v-model="ticketSearchQuery"
                type="text"
                placeholder="Search tickets..."
                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            <div class="flex gap-2">
              <select
                v-model="ticketStatusFilter"
                class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">All Status</option>
                <option value="open">Open</option>
                <option value="in-progress">In Progress</option>
                <option value="resolved">Resolved</option>
                <option value="closed">Closed</option>
              </select>
              <select
                v-model="ticketPriorityFilter"
                class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">All Priority</option>
                <option value="low">Low</option>
                <option value="medium">Medium</option>
                <option value="high">High</option>
                <option value="urgent">Urgent</option>
              </select>
            </div>
          </div>

          <!-- Tickets Table -->
          <div
            class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
          >
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">
                Support Tickets
              </h3>
            </div>

            <div class="overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                  <tr>
                    <th
                      class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Ticket ID
                    </th>
                    <th
                      class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Subject
                    </th>
                    <th
                      class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Customer
                    </th>
                    <th
                      class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                    >
                      Priority
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
                    v-for="ticket in filteredTickets"
                    :key="ticket.id"
                    class="hover:bg-gray-50"
                  >
                    <td
                      class="px-6 py-4 whitespace-nowrap text-sm font-medium text-blue-600"
                    >
                      #{{ ticket.id }}
                    </td>
                    <td class="px-6 py-4">
                      <div class="text-sm font-medium text-gray-900">
                        {{ ticket.subject }}
                      </div>
                      <div class="text-sm text-gray-500 truncate max-w-xs">
                        {{ ticket.description }}
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <div class="flex items-center">
                        <div
                          class="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center"
                        >
                          <span class="text-sm font-medium text-gray-700">{{
                            ticket.customer.charAt(0).toUpperCase()
                          }}</span>
                        </div>
                        <div class="ml-3">
                          <div class="text-sm font-medium text-gray-900">
                            {{ ticket.customer }}
                          </div>
                          <div class="text-sm text-gray-500">
                            {{ ticket.email }}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span
                        :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getPriorityColor(
                          ticket.priority
                        )}`"
                      >
                        {{ ticket.priority }}
                      </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                      <span
                        :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getStatusColor(
                          ticket.status
                        )}`"
                      >
                        {{ ticket.status }}
                      </span>
                    </td>
                    <td
                      class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                    >
                      {{ formatDate(ticket.createdAt) }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div class="flex gap-2">
                        <button
                          @click="viewTicket(ticket)"
                          class="text-blue-600 hover:text-blue-900 transition-colors"
                        >
                          View
                        </button>
                        <button
                          @click="updateTicketStatus(ticket.id, 'resolved')"
                          v-if="
                            ticket.status !== 'resolved' &&
                            ticket.status !== 'closed'
                          "
                          class="text-green-600 hover:text-green-900 transition-colors"
                        >
                          Resolve
                        </button>
                      </div>
                    </td>
                  </tr>
                  <tr v-if="filteredTickets.length === 0">
                    <td
                      colspan="7"
                      class="px-6 py-12 text-center text-gray-500"
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
                          d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
                        />
                      </svg>
                      <p class="text-lg font-medium">No tickets found</p>
                      <p class="text-sm">
                        {{
                          ticketSearchQuery
                            ? "Try adjusting your search"
                            : "No support tickets available"
                        }}
                      </p>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Knowledge Base Tab -->
        <div v-if="activeTab === 'knowledge'" class="space-y-6">
          <!-- KB Actions -->
          <div
            class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4"
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
                v-model="kbSearchQuery"
                type="text"
                placeholder="Search knowledge base..."
                class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            <div class="flex gap-2">
              <select
                v-model="kbCategoryFilter"
                class="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">All Categories</option>
                <option value="getting-started">Getting Started</option>
                <option value="account">Account</option>
                <option value="billing">Billing</option>
                <option value="technical">Technical</option>
                <option value="troubleshooting">Troubleshooting</option>
              </select>
              <button
                @click="showCreateKBModal = true"
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
                Add Article
              </button>
            </div>
          </div>

          <!-- Knowledge Base Articles -->
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div
              v-for="article in filteredKnowledgeBase"
              :key="article.id"
              class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 hover:shadow-md transition-shadow"
            >
              <div class="flex items-start justify-between mb-4">
                <span
                  :class="`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${getCategoryColor(
                    article.category
                  )}`"
                >
                  {{ article.category }}
                </span>
                <div class="flex gap-1">
                  <button
                    @click="editKBArticle(article)"
                    class="text-gray-400 hover:text-blue-600 transition-colors"
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
                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                      />
                    </svg>
                  </button>
                  <button
                    @click="deleteKBArticle(article.id)"
                    class="text-gray-400 hover:text-red-600 transition-colors"
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

              <h3 class="text-lg font-semibold text-gray-900 mb-2">
                {{ article.title }}
              </h3>
              <p class="text-gray-600 text-sm mb-4 line-clamp-3">
                {{ article.content }}
              </p>

              <div
                class="flex items-center justify-between text-sm text-gray-500"
              >
                <span>{{ article.views }} views</span>
                <span>{{ formatDate(article.updatedAt) }}</span>
              </div>
            </div>

            <div
              v-if="filteredKnowledgeBase.length === 0"
              class="col-span-full text-center py-12"
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
                  d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"
                />
              </svg>
              <p class="text-lg font-medium">No articles found</p>
              <p class="text-sm text-gray-500">
                {{
                  kbSearchQuery
                    ? "Try adjusting your search"
                    : "Create your first knowledge base article"
                }}
              </p>
            </div>
          </div>
        </div>

        <!-- FAQ Management Tab -->
        <div v-if="activeTab === 'faq'" class="space-y-6">
          <!-- FAQ Actions -->
          <div class="flex justify-between items-center">
            <h3 class="text-lg font-semibold text-gray-900">
              Frequently Asked Questions
            </h3>
            <button
              @click="showCreateFAQModal = true"
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
              Add FAQ
            </button>
          </div>

          <!-- FAQ List -->
          <div class="bg-white rounded-xl shadow-sm border border-gray-200">
            <div class="divide-y divide-gray-200">
              <div
                v-for="faq in faqs"
                :key="faq.id"
                class="p-6 hover:bg-gray-50 transition-colors"
              >
                <div class="flex items-start justify-between">
                  <div class="flex-1">
                    <h4 class="text-lg font-medium text-gray-900 mb-2">
                      {{ faq.question }}
                    </h4>
                    <p class="text-gray-600 mb-4">{{ faq.answer }}</p>
                    <div class="flex items-center gap-4 text-sm text-gray-500">
                      <span>Category: {{ faq.category }}</span>
                      <span>Order: {{ faq.order }}</span>
                      <span>Updated: {{ formatDate(faq.updatedAt) }}</span>
                    </div>
                  </div>
                  <div class="flex gap-2 ml-4">
                    <button
                      @click="editFAQ(faq)"
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
                    <button
                      @click="deleteFAQ(faq.id)"
                      class="text-red-600 hover:text-red-900 transition-colors"
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
                          d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                        />
                      </svg>
                    </button>
                  </div>
                </div>
              </div>

              <div
                v-if="faqs.length === 0"
                class="p-12 text-center text-gray-500"
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
                    d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <p class="text-lg font-medium">No FAQs found</p>
                <p class="text-sm">
                  Create your first FAQ to help users find answers quickly
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- View Ticket Modal -->
        <div
          v-if="showTicketModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="showTicketModal = false"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-y-auto"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  Ticket #{{ selectedTicket?.id }}
                </h3>
                <button
                  @click="showTicketModal = false"
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

              <div v-if="selectedTicket" class="space-y-6">
                <!-- Ticket Info -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >Subject</label
                    >
                    <p class="text-lg font-semibold text-gray-900">
                      {{ selectedTicket.subject }}
                    </p>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >Status</label
                    >
                    <select
                      v-model="selectedTicket.status"
                      @change="
                        updateTicketStatus(
                          selectedTicket.id,
                          selectedTicket.status
                        )
                      "
                      class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="open">Open</option>
                      <option value="in-progress">In Progress</option>
                      <option value="resolved">Resolved</option>
                      <option value="closed">Closed</option>
                    </select>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >Priority</label
                    >
                    <span
                      :class="`inline-flex px-3 py-1 text-sm font-semibold rounded-full ${getPriorityColor(
                        selectedTicket.priority
                      )}`"
                    >
                      {{ selectedTicket.priority }}
                    </span>
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1"
                      >Customer</label
                    >
                    <p class="text-gray-900">{{ selectedTicket.customer }}</p>
                    <p class="text-sm text-gray-500">
                      {{ selectedTicket.email }}
                    </p>
                  </div>
                </div>

                <!-- Description -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Description</label
                  >
                  <div class="bg-gray-50 rounded-lg p-4">
                    <p class="text-gray-900 whitespace-pre-wrap">
                      {{ selectedTicket.description }}
                    </p>
                  </div>
                </div>

                <!-- Response Form -->
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Add Response</label
                  >
                  <textarea
                    v-model="ticketResponse"
                    rows="4"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Type your response here..."
                  ></textarea>
                  <div class="flex gap-3 mt-4">
                    <button
                      @click="sendTicketResponse"
                      :disabled="!ticketResponse.trim() || isLoading"
                      class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                    >
                      {{ isLoading ? "Sending..." : "Send Response" }}
                    </button>
                    <button
                      @click="updateTicketStatus(selectedTicket.id, 'resolved')"
                      v-if="selectedTicket.status !== 'resolved'"
                      class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors"
                    >
                      Mark as Resolved
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Create/Edit KB Article Modal -->
        <div
          v-if="showCreateKBModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="closeKBModal"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  {{ editingKBArticle ? "Edit Article" : "Create New Article" }}
                </h3>
                <button
                  @click="closeKBModal"
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

              <form @submit.prevent="saveKBArticle" class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Title</label
                  >
                  <input
                    v-model="newKBArticle.title"
                    type="text"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter article title"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Category</label
                  >
                  <select
                    v-model="newKBArticle.category"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="">Select category</option>
                    <option value="getting-started">Getting Started</option>
                    <option value="account">Account</option>
                    <option value="billing">Billing</option>
                    <option value="technical">Technical</option>
                    <option value="troubleshooting">Troubleshooting</option>
                  </select>
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Content</label
                  >
                  <textarea
                    v-model="newKBArticle.content"
                    required
                    rows="8"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter article content"
                  ></textarea>
                </div>

                <div class="flex gap-3 pt-4">
                  <button
                    type="submit"
                    :disabled="isLoading"
                    class="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                  >
                    {{
                      isLoading
                        ? "Saving..."
                        : editingKBArticle
                        ? "Update Article"
                        : "Create Article"
                    }}
                  </button>
                  <button
                    type="button"
                    @click="closeKBModal"
                    class="px-6 py-3 bg-gray-200 text-gray-800 rounded-lg hover:bg-gray-300 transition-colors"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- Create/Edit FAQ Modal -->
        <div
          v-if="showCreateFAQModal"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
          @click="closeFAQModal"
        >
          <div
            class="bg-white rounded-xl shadow-xl max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto"
            @click.stop
          >
            <div class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h3 class="text-lg font-semibold text-gray-900">
                  {{ editingFAQ ? "Edit FAQ" : "Create New FAQ" }}
                </h3>
                <button
                  @click="closeFAQModal"
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

              <form @submit.prevent="saveFAQ" class="space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Question</label
                  >
                  <input
                    v-model="newFAQ.question"
                    type="text"
                    required
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter the question"
                  />
                </div>

                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Answer</label
                  >
                  <textarea
                    v-model="newFAQ.answer"
                    required
                    rows="6"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Enter the answer"
                  ></textarea>
                </div>

                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2"
                      >Category</label
                    >
                    <select
                      v-model="newFAQ.category"
                      required
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="">Select category</option>
                      <option value="general">General</option>
                      <option value="account">Account</option>
                      <option value="billing">Billing</option>
                      <option value="technical">Technical</option>
                    </select>
                  </div>

                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2"
                      >Display Order</label
                    >
                    <input
                      v-model.number="newFAQ.order"
                      type="number"
                      min="1"
                      required
                      class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      placeholder="1"
                    />
                  </div>
                </div>

                <div class="flex gap-3 pt-4">
                  <button
                    type="submit"
                    :disabled="isLoading"
                    class="flex-1 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 transition-colors"
                  >
                    {{
                      isLoading
                        ? "Saving..."
                        : editingFAQ
                        ? "Update FAQ"
                        : "Create FAQ"
                    }}
                  </button>
                  <button
                    type="button"
                    @click="closeFAQModal"
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
  name: "HelpSupportManagement",
  data() {
    return {
      activeTab: "tickets",
      isLoading: false,
      alert: null,

      // Search and filters
      ticketSearchQuery: "",
      ticketStatusFilter: "",
      ticketPriorityFilter: "",
      kbSearchQuery: "",
      kbCategoryFilter: "",

      // Modals
      showTicketModal: false,
      showCreateKBModal: false,
      showCreateFAQModal: false,

      // Selected items
      selectedTicket: null,
      editingKBArticle: null,
      editingFAQ: null,

      // Form data
      ticketResponse: "",
      newKBArticle: {
        title: "",
        category: "",
        content: "",
      },
      newFAQ: {
        question: "",
        answer: "",
        category: "",
        order: 1,
      },

      tabs: [
        { id: "tickets", name: "Support Tickets" },
        { id: "knowledge", name: "Knowledge Base" },
        { id: "faq", name: "FAQ Management" },
      ],

      tickets: [
        {
          id: 1001,
          subject: "Unable to login to my account",
          description:
            'I have been trying to login to my account for the past hour but keep getting an error message saying "Invalid credentials" even though I am sure my password is correct.',
          customer: "John Smith",
          email: "john.smith@example.com",
          priority: "high",
          status: "open",
          createdAt: new Date("2024-01-15T10:30:00"),
          updatedAt: new Date("2024-01-15T10:30:00"),
        },
        {
          id: 1002,
          subject: "Billing question about subscription",
          description:
            "I was charged twice for my monthly subscription. Can you please help me understand why this happened and process a refund for the duplicate charge?",
          customer: "Sarah Johnson",
          email: "sarah.j@example.com",
          priority: "medium",
          status: "in-progress",
          createdAt: new Date("2024-01-14T14:20:00"),
          updatedAt: new Date("2024-01-15T09:15:00"),
        },
        {
          id: 1003,
          subject: "Feature request: Dark mode",
          description:
            "Would it be possible to add a dark mode option to the application? Many users including myself would find this very helpful for extended usage periods.",
          customer: "Mike Davis",
          email: "mike.davis@example.com",
          priority: "low",
          status: "open",
          createdAt: new Date("2024-01-13T16:45:00"),
          updatedAt: new Date("2024-01-13T16:45:00"),
        },
        {
          id: 1004,
          subject: "Data export not working",
          description:
            "When I try to export my data, the download starts but the file is corrupted and cannot be opened. This has happened multiple times.",
          customer: "Emily Wilson",
          email: "emily.w@example.com",
          priority: "urgent",
          status: "resolved",
          createdAt: new Date("2024-01-12T11:00:00"),
          updatedAt: new Date("2024-01-14T15:30:00"),
        },
        {
          id: 1005,
          subject: "Account deletion request",
          description:
            "I would like to permanently delete my account and all associated data. Please let me know what steps I need to take.",
          customer: "Robert Brown",
          email: "robert.brown@example.com",
          priority: "medium",
          status: "closed",
          createdAt: new Date("2024-01-11T13:20:00"),
          updatedAt: new Date("2024-01-12T10:45:00"),
        },
      ],

      knowledgeBase: [
        {
          id: 1,
          title: "How to Reset Your Password",
          content:
            'If you have forgotten your password, you can reset it by clicking on the "Forgot Password" link on the login page. Enter your email address and we will send you instructions to create a new password.',
          category: "account",
          views: 1250,
          createdAt: new Date("2024-01-10T09:00:00"),
          updatedAt: new Date("2024-01-14T11:30:00"),
        },
        {
          id: 2,
          title: "Getting Started Guide",
          content:
            "Welcome to our platform! This guide will help you get started with the basics. First, complete your profile setup, then explore the main dashboard features.",
          category: "getting-started",
          views: 2100,
          createdAt: new Date("2024-01-08T14:00:00"),
          updatedAt: new Date("2024-01-12T16:20:00"),
        },
        {
          id: 3,
          title: "Understanding Your Bill",
          content:
            "Your monthly bill includes your subscription fee, any additional usage charges, and applicable taxes. You can view detailed billing information in your account settings.",
          category: "billing",
          views: 890,
          createdAt: new Date("2024-01-05T10:15:00"),
          updatedAt: new Date("2024-01-10T14:45:00"),
        },
        {
          id: 4,
          title: "Troubleshooting Connection Issues",
          content:
            "If you are experiencing connection problems, try refreshing your browser, clearing your cache, or checking your internet connection. If the problem persists, contact support.",
          category: "troubleshooting",
          views: 675,
          createdAt: new Date("2024-01-03T11:30:00"),
          updatedAt: new Date("2024-01-08T09:20:00"),
        },
        {
          id: 5,
          title: "API Documentation",
          content:
            "Our API allows you to integrate with third-party applications. You can find complete documentation, examples, and authentication details in this guide.",
          category: "technical",
          views: 445,
          createdAt: new Date("2024-01-01T15:00:00"),
          updatedAt: new Date("2024-01-05T12:10:00"),
        },
      ],

      faqs: [
        {
          id: 1,
          question: "How do I change my email address?",
          answer:
            "You can change your email address by going to Account Settings > Profile > Email Address. Enter your new email and click Save. You will need to verify the new email address.",
          category: "account",
          order: 1,
          createdAt: new Date("2024-01-10T10:00:00"),
          updatedAt: new Date("2024-01-12T14:30:00"),
        },
        {
          id: 2,
          question: "What payment methods do you accept?",
          answer:
            "We accept all major credit cards (Visa, MasterCard, American Express), PayPal, and bank transfers for annual subscriptions.",
          category: "billing",
          order: 2,
          createdAt: new Date("2024-01-09T11:15:00"),
          updatedAt: new Date("2024-01-11T16:45:00"),
        },
        {
          id: 3,
          question: "Is my data secure?",
          answer:
            "Yes, we use industry-standard encryption and security measures to protect your data. All data is encrypted in transit and at rest, and we regularly undergo security audits.",
          category: "technical",
          order: 3,
          createdAt: new Date("2024-01-08T13:20:00"),
          updatedAt: new Date("2024-01-10T09:30:00"),
        },
        {
          id: 4,
          question: "Can I cancel my subscription anytime?",
          answer:
            "Yes, you can cancel your subscription at any time from your account settings. Your access will continue until the end of your current billing period.",
          category: "billing",
          order: 4,
          createdAt: new Date("2024-01-07T15:45:00"),
          updatedAt: new Date("2024-01-09T11:20:00"),
        },
        {
          id: 5,
          question: "How do I contact support?",
          answer:
            "You can contact our support team through the help center, by email at support@example.com, or through the live chat feature available 24/7.",
          category: "general",
          order: 5,
          createdAt: new Date("2024-01-06T12:30:00"),
          updatedAt: new Date("2024-01-08T14:15:00"),
        },
      ],
    };
  },

  computed: {
    pendingTickets() {
      return this.tickets.filter(
        (ticket) => ticket.status === "open" || ticket.status === "in-progress"
      ).length;
    },

    resolvedTickets() {
      return this.tickets.filter(
        (ticket) => ticket.status === "resolved" || ticket.status === "closed"
      ).length;
    },

    filteredTickets() {
      let filtered = this.tickets;

      if (this.ticketSearchQuery) {
        filtered = filtered.filter(
          (ticket) =>
            ticket.subject
              .toLowerCase()
              .includes(this.ticketSearchQuery.toLowerCase()) ||
            ticket.customer
              .toLowerCase()
              .includes(this.ticketSearchQuery.toLowerCase()) ||
            ticket.description
              .toLowerCase()
              .includes(this.ticketSearchQuery.toLowerCase())
        );
      }

      if (this.ticketStatusFilter) {
        filtered = filtered.filter(
          (ticket) => ticket.status === this.ticketStatusFilter
        );
      }

      if (this.ticketPriorityFilter) {
        filtered = filtered.filter(
          (ticket) => ticket.priority === this.ticketPriorityFilter
        );
      }

      return filtered.sort(
        (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
      );
    },

    filteredKnowledgeBase() {
      let filtered = this.knowledgeBase;

      if (this.kbSearchQuery) {
        filtered = filtered.filter(
          (article) =>
            article.title
              .toLowerCase()
              .includes(this.kbSearchQuery.toLowerCase()) ||
            article.content
              .toLowerCase()
              .includes(this.kbSearchQuery.toLowerCase())
        );
      }

      if (this.kbCategoryFilter) {
        filtered = filtered.filter(
          (article) => article.category === this.kbCategoryFilter
        );
      }

      return filtered.sort(
        (a, b) => new Date(b.updatedAt) - new Date(a.updatedAt)
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

    getPriorityColor(priority) {
      const colors = {
        low: "bg-green-100 text-green-800",
        medium: "bg-yellow-100 text-yellow-800",
        high: "bg-orange-100 text-orange-800",
        urgent: "bg-red-100 text-red-800",
      };
      return colors[priority] || "bg-gray-100 text-gray-800";
    },

    getStatusColor(status) {
      const colors = {
        open: "bg-blue-100 text-blue-800",
        "in-progress": "bg-yellow-100 text-yellow-800",
        resolved: "bg-green-100 text-green-800",
        closed: "bg-gray-100 text-gray-800",
      };
      return colors[status] || "bg-gray-100 text-gray-800";
    },

    getCategoryColor(category) {
      const colors = {
        "getting-started": "bg-blue-100 text-blue-800",
        account: "bg-green-100 text-green-800",
        billing: "bg-yellow-100 text-yellow-800",
        technical: "bg-purple-100 text-purple-800",
        troubleshooting: "bg-red-100 text-red-800",
      };
      return colors[category] || "bg-gray-100 text-gray-800";
    },

    viewTicket(ticket) {
      this.selectedTicket = { ...ticket };
      this.showTicketModal = true;
    },

    async updateTicketStatus(ticketId, newStatus) {
      this.isLoading = true;

      try {
        await new Promise((resolve) => setTimeout(resolve, 500));

        const ticket = this.tickets.find((t) => t.id === ticketId);
        if (ticket) {
          ticket.status = newStatus;
          ticket.updatedAt = new Date();
        }

        if (this.selectedTicket && this.selectedTicket.id === ticketId) {
          this.selectedTicket.status = newStatus;
        }

        this.showAlert("success", `Ticket status updated to ${newStatus}`);
      } catch (error) {
        this.showAlert("error", "Failed to update ticket status");
      } finally {
        this.isLoading = false;
      }
    },

    async sendTicketResponse() {
      if (!this.ticketResponse.trim()) return;

      this.isLoading = true;

      try {
        await new Promise((resolve) => setTimeout(resolve, 1000));

        // In a real app, you would send the response via API
        this.showAlert("success", "Response sent successfully!");
        this.ticketResponse = "";
      } catch (error) {
        this.showAlert("error", "Failed to send response");
      } finally {
        this.isLoading = false;
      }
    },

    editKBArticle(article) {
      this.editingKBArticle = article;
      this.newKBArticle = { ...article };
      this.showCreateKBModal = true;
    },

    async saveKBArticle() {
      this.isLoading = true;

      try {
        await new Promise((resolve) => setTimeout(resolve, 1000));

        if (this.editingKBArticle) {
          // Update existing article
          const index = this.knowledgeBase.findIndex(
            (a) => a.id === this.editingKBArticle.id
          );
          if (index !== -1) {
            this.knowledgeBase[index] = {
              ...this.knowledgeBase[index],
              ...this.newKBArticle,
              updatedAt: new Date(),
            };
          }
          this.showAlert("success", "Article updated successfully!");
        } else {
          // Create new article
          const newArticle = {
            id: Date.now(),
            ...this.newKBArticle,
            views: 0,
            createdAt: new Date(),
            updatedAt: new Date(),
          };
          this.knowledgeBase.unshift(newArticle);
          this.showAlert("success", "Article created successfully!");
        }

        this.closeKBModal();
      } catch (error) {
        this.showAlert("error", "Failed to save article");
      } finally {
        this.isLoading = false;
      }
    },

    async deleteKBArticle(articleId) {
      if (!confirm("Are you sure you want to delete this article?")) return;

      try {
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.knowledgeBase = this.knowledgeBase.filter(
          (a) => a.id !== articleId
        );
        this.showAlert("success", "Article deleted successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to delete article");
      }
    },

    closeKBModal() {
      this.showCreateKBModal = false;
      this.editingKBArticle = null;
      this.newKBArticle = {
        title: "",
        category: "",
        content: "",
      };
    },

    editFAQ(faq) {
      this.editingFAQ = faq;
      this.newFAQ = { ...faq };
      this.showCreateFAQModal = true;
    },

    async saveFAQ() {
      this.isLoading = true;

      try {
        await new Promise((resolve) => setTimeout(resolve, 1000));

        if (this.editingFAQ) {
          // Update existing FAQ
          const index = this.faqs.findIndex((f) => f.id === this.editingFAQ.id);
          if (index !== -1) {
            this.faqs[index] = {
              ...this.faqs[index],
              ...this.newFAQ,
              updatedAt: new Date(),
            };
          }
          this.showAlert("success", "FAQ updated successfully!");
        } else {
          // Create new FAQ
          const newFAQItem = {
            id: Date.now(),
            ...this.newFAQ,
            createdAt: new Date(),
            updatedAt: new Date(),
          };
          this.faqs.push(newFAQItem);
          this.faqs.sort((a, b) => a.order - b.order);
          this.showAlert("success", "FAQ created successfully!");
        }

        this.closeFAQModal();
      } catch (error) {
        this.showAlert("error", "Failed to save FAQ");
      } finally {
        this.isLoading = false;
      }
    },

    async deleteFAQ(faqId) {
      if (!confirm("Are you sure you want to delete this FAQ?")) return;

      try {
        await new Promise((resolve) => setTimeout(resolve, 500));

        this.faqs = this.faqs.filter((f) => f.id !== faqId);
        this.showAlert("success", "FAQ deleted successfully!");
      } catch (error) {
        this.showAlert("error", "Failed to delete FAQ");
      }
    },

    closeFAQModal() {
      this.showCreateFAQModal = false;
      this.editingFAQ = null;
      this.newFAQ = {
        question: "",
        answer: "",
        category: "",
        order: 1,
      };
    },
  },
};
</script>

<style scoped>
.container{
    display: flex;
}
.help{
    width: 85%;
    margin-right: -20px;
}
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
