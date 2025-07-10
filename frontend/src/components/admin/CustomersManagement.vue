<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>
      <div class="customer max-w-7xl mx-auto">
        <!-- Header Section -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8">
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-4xl font-bold text-gray-900 flex items-center">
                <svg class="h-10 w-10 text-emerald-600 mr-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                Customer Management
              </h2>
              <p class="text-lg text-gray-600 mt-2">Manage your customer database efficiently</p>
            </div>
            <div class="flex items-center space-x-4">
              <div class="text-right">
                <p class="text-3xl font-bold text-emerald-600">{{ customers.length }}</p>
                <p class="text-sm text-gray-500">Total Customers</p>
              </div>
              <button @click="toggleAddForm" class="px-6 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 transition-colors duration-200 flex items-center font-medium shadow-sm">
                <svg v-if="!showAddForm" class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                </svg>
                <svg v-else class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
                {{ showAddForm ? "Close Form" : "Add Customer" }}
              </button>
            </div>
          </div>
        </div>

        <!-- Error Message -->
        <div v-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-8">
          <div class="flex items-center">
            <svg class="h-5 w-5 text-red-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <p class="text-red-800 font-medium">{{ error }}</p>
          </div>
        </div>

        <!-- Add Customer Form -->
        <div v-if="showAddForm" class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8">
          <div class="flex items-center mb-6">
            <div class="p-3 bg-green-100 rounded-full mr-4">
              <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
              </svg>
            </div>
            <h3 class="text-2xl font-bold text-gray-900">Add New Customer</h3>
          </div>
          <form @submit.prevent="addCustomer" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Customer Name</label>
                <input v-model="newCustomer.name" placeholder="Enter customer name" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors" required />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                <input v-model="newCustomer.email" placeholder="Enter email address" type="email" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors" required />
              </div>
            </div>
            <div class="flex justify-end space-x-4 pt-6 border-t border-gray-200">
              <button type="button" @click="cancelAdd" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200">Cancel</button>
              <button type="submit" class="px-6 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center" :disabled="loading">
                <span v-if="loading" class="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></span>
                Add Customer
              </button>
            </div>
          </form>
        </div>

        <!-- Table Controls -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6 mb-8">
          <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between space-y-4 lg:space-y-0">
            <div class="flex flex-col sm:flex-row sm:items-center space-y-4 sm:space-y-0 sm:space-x-4">
              <div class="relative">
                <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input v-model="searchQuery" type="text" placeholder="Search customers..." class="pl-10 pr-4 py-3 w-80 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors" />
              </div>
              <div v-if="selectedCustomers.length > 0" class="flex items-center space-x-2">
                <span class="text-sm text-gray-600">{{ selectedCustomers.length }} selected</span>
                <button @click="bulkDelete" class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors text-sm font-medium">Delete Selected</button>
              </div>
            </div>
            <div class="flex items-center space-x-4">
              <div class="flex items-center space-x-2">
                <span class="text-sm text-gray-600">Sort by:</span>
                <select v-model="sortBy" @change="applySorting" class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500">
                  <option value="name">Name</option>
                  <option value="email">Email</option>
                  <option value="id">ID</option>
                  <option value="role">Role</option>
                </select>
                <button @click="toggleSortOrder" class="p-2 text-gray-600 hover:text-emerald-600 hover:bg-emerald-50 rounded-lg transition-colors">
                  <svg class="h-5 w-5" :class="{ 'rotate-180': sortOrder === 'desc' }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h13M3 8h9m-9 4h6m4 0l4-4m0 0l4 4m-4-4v12" />
                  </svg>
                </button>
              </div>
              <div class="flex items-center space-x-2">
                <span class="text-sm text-gray-600">Show:</span>
                <select v-model="itemsPerPage" class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500">
                  <option value="10">10</option>
                  <option value="25">25</option>
                  <option value="50">50</option>
                  <option value="100">100</option>
                </select>
              </div>
              <button @click="fetchCustomers" class="p-3 text-gray-600 hover:text-emerald-600 hover:bg-emerald-50 rounded-lg transition-colors" :disabled="loading">
                <svg class="h-5 w-5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loading && !customers.length" class="bg-white rounded-xl shadow-sm border border-gray-200 p-12">
          <div class="text-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600 mx-auto mb-4"></div>
            <p class="text-gray-600">Loading customers...</p>
          </div>
        </div>

        <!-- Customers Table -->
        <div v-else-if="paginatedCustomers.length > 0" class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-4 text-left">
                    <input type="checkbox" :checked="isAllSelected" @change="toggleSelectAll" class="h-4 w-4 text-emerald-600 focus:ring-emerald-500 border-gray-300 rounded" />
                  </th>
                  <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <button @click="setSortBy('id')" class="flex items-center space-x-1 hover:text-gray-700 transition-colors">
                      <span>ID</span>
                      <svg v-if="sortBy === 'id'" class="h-4 w-4" :class="{ 'rotate-180': sortOrder === 'desc' }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                      </svg>
                    </button>
                  </th>
                  <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
                  <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <button @click="setSortBy('name')" class="flex items-center space-x-1 hover:text-gray-700 transition-colors">
                      <span>Name</span>
                      <svg v-if="sortBy === 'name'" class="h-4 w-4" :class="{ 'rotate-180': sortOrder === 'desc' }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                      </svg>
                    </button>
                  </th>
                  <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <button @click="setSortBy('email')" class="flex items-center space-x-1 hover:text-gray-700 transition-colors">
                      <span>Email</span>
                      <svg v-if="sortBy === 'email'" class="h-4 w-4" :class="{ 'rotate-180': sortOrder === 'desc' }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                      </svg>
                    </button>
                  </th>
                  <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    <button @click="setSortBy('role')" class="flex items-center space-x-1 hover:text-gray-700 transition-colors">
                      <span>Role</span>
                      <svg v-if="sortBy === 'role'" class="h-4 w-4" :class="{ 'rotate-180': sortOrder === 'desc' }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                      </svg>
                    </button>
                  </th>
                  <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-6 py-4 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="customer in paginatedCustomers" :key="customer.id" class="hover:bg-gray-50 transition-colors duration-150" :class="{ 'bg-emerald-50': selectedCustomers.includes(customer.id) }">
                  <td class="px-6 py-4 whitespace-nowrap">
                    <input type="checkbox" :value="customer.id" v-model="selectedCustomers" class="h-4 w-4 text-emerald-600 focus:ring-emerald-500 border-gray-300 rounded" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#{{ customer.id }}</td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="h-10 w-10 bg-gradient-to-r from-emerald-500 to-teal-500 rounded-full flex items-center justify-center">
                      <span class="text-white font-semibold text-sm">{{ getInitials(customer.name) }}</span>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm font-medium text-gray-900">{{ customer.name }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-600">{{ customer.email }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="text-sm text-gray-600">{{ customer.role }}</div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      <svg class="w-2 h-2 mr-1" fill="currentColor" viewBox="0 0 8 8">
                        <circle cx="4" cy="4" r="3" />
                      </svg>
                      Active
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                    <div class="relative inline-block text-left">
                      <button @click="toggleActionMenu(customer.id)" class="inline-flex items-center justify-center w-8 h-8 bg-white border border-gray-300 rounded-full shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-emerald-500 transition-colors" :class="{ 'bg-gray-50 ring-2 ring-emerald-500': activeMenuId === customer.id }">
                        <svg class="w-4 h-4 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z" />
                        </svg>
                      </button>
                      <div v-if="activeMenuId === customer.id" class="absolute right-0 z-20 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 py-1">
                        <button @click="viewCustomer(customer)" class="flex items-center w-full px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 transition-colors duration-150">
                          <svg class="h-4 w-4 mr-3 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                          </svg>
                          <span>View Details</span>
                        </button>
                        <button @click="editCustomer(customer)" class="flex items-center w-full px-4 py-3 text-sm text-gray-700 hover:bg-gray-50 transition-colors duration-150">
                          <svg class="h-4 w-4 mr-3 text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                          </svg>
                          <span>Edit Customer</span>
                        </button>
                        <div class="border-t border-gray-100 my-1"></div>
                        <button @click="deleteCustomer(customer.id)" class="flex items-center w-full px-4 py-3 text-sm text-red-600 hover:bg-red-50 transition-colors duration-150">
                          <svg class="h-4 w-4 mr-3 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                          </svg>
                          <span>Delete Customer</span>
                        </button>
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="bg-white px-6 py-4 border-t border-gray-200">
            <div class="flex items-center justify-between">
              <div class="text-sm text-gray-700">
                Showing {{ startIndex + 1 }} to {{ endIndex }} of {{ filteredCustomers.length }} results
              </div>
              <div class="flex items-center space-x-2">
                <button @click="previousPage" :disabled="currentPage === 1" class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">Previous</button>
                <div class="flex items-center space-x-1">
                  <button v-for="page in visiblePages" :key="page" @click="goToPage(page)" :class="['px-3 py-2 text-sm font-medium rounded-lg transition-colors', page === currentPage ? 'bg-emerald-600 text-white' : 'text-gray-500 bg-white border border-gray-300 hover:bg-gray-50']">{{ page }}</button>
                </div>
                <button @click="nextPage" :disabled="currentPage === totalPages" class="px-3 py-2 text-sm font-medium text-gray-500 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors">Next</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else class="bg-white rounded-xl shadow-sm border border-gray-200 p-12">
          <div class="text-center">
            <svg class="h-16 w-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.3156-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
            <h3 class="text-lg font-medium text-gray-900 mb-2">No Customers Found</h3>
            <p class="text-gray-600 mb-6">Get started by adding your first customer.</p>
            <button @click="showAddForm = true" class="bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200">Add Your First Customer</button>
          </div>
        </div>

        <!-- Edit Customer Modal -->
        <div v-if="isEditing" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div class="bg-white rounded-xl shadow-xl w-full max-w-md">
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-xl font-bold text-gray-900">Edit Customer</h2>
                <button @click="cancelEdit" class="text-gray-400 hover:text-gray-600 transition-colors">
                  <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
            </div>
            <form @submit.prevent="saveCustomer" class="p-6 space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Customer Name</label>
                <input v-model="editedCustomer.name" placeholder="Enter customer name" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors" required />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
                <input v-model="editedCustomer.email" placeholder="Enter email address" type="email" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors" required />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Role</label>
                <input v-model="editedCustomer.role" placeholder="Enter role" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-colors" />
              </div>
              <div class="flex justify-end space-x-4 pt-4">
                <button type="button" @click="cancelEdit" class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200">Cancel</button>
                <button type="submit" class="px-6 py-3 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center" :disabled="loading">
                  <span v-if="loading" class="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"></span>
                  Save Changes
                </button>
              </div>
            </form>
          </div>
        </div>

        <!-- View Customer Modal -->
        <div v-if="isViewing" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div class="bg-white rounded-xl shadow-xl w-full max-w-md">
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-xl font-bold text-gray-900">Customer Details</h2>
                <button @click="isViewing = false" class="text-gray-400 hover:text-gray-600 transition-colors">
                  <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>
            </div>
            <div class="p-6 space-y-4">
              <div class="flex items-center justify-center mb-6">
                <div class="h-16 w-16 bg-emerald-100 rounded-full flex items-center justify-center">
                  <span class="text-emerald-600 font-bold text-xl">{{ getInitials(selectedCustomer.name) }}</span>
                </div>
              </div>
              <div class="space-y-3">
                <div class="flex justify-between items-center py-2 border-b border-gray-100">
                  <span class="font-medium text-gray-700">Customer ID:</span>
                  <span class="text-gray-900">#{{ selectedCustomer.id }}</span>
                </div>
                <div class="flex justify-between items-center py-2 border-b border-gray-100">
                  <span class="font-medium text-gray-700">Name:</span>
                  <span class="text-gray-900 font-semibold">{{ selectedCustomer.name }}</span>
                </div>
                <div class="flex justify-between items-center py-2 border-b border-gray-100">
                  <span class="font-medium text-gray-700">Email:</span>
                  <span class="text-gray-900">{{ selectedCustomer.email }}</span>
                </div>
                <div class="flex justify-between items-center py-2 border-b border-gray-100">
                  <span class="font-medium text-gray-700">Role:</span>
                  <span class="text-gray-900">{{ selectedCustomer.role }}</span>
                </div>
                <div class="flex justify-between items-center py-2">
                  <span class="font-medium text-gray-700">Status:</span>
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    <svg class="w-2 h-2 mr-1" fill="currentColor" viewBox="0 0 8 8">
                      <circle cx="4" cy="4" r="3" />
                    </svg>
                    Active
                  </span>
                </div>
              </div>
              <div class="flex justify-end pt-4">
                <button @click="isViewing = false" class="px-6 py-3 bg-gray-600 hover:bg-gray-700 text-white rounded-lg font-medium transition-colors duration-200">Close</button>
              </div>
            </div>
          </div>
        </div>

        <!-- Success Toast -->
        <div v-if="showToast" class="fixed bottom-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 flex items-center">
          <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          {{ toastMessage }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from "vue";

// Base URL for the API
const API_URL = "http://127.0.0.1:8000/api/users";

// Reactive state
const customers = ref([]);
const newCustomer = ref({ name: "", email: "" });
const isEditing = ref(false);
const isViewing = ref(false);
const editedCustomer = ref({ id: null, name: "", email: "", role: "" });
const selectedCustomer = ref({ id: null, name: "", email: "", role: "" });
const error = ref(null);
const loading = ref(false);
const showAddForm = ref(false);
const showToast = ref(false);
const toastMessage = ref("");
const searchQuery = ref("");
const itemsPerPage = ref(10);
const currentPage = ref(1);
const selectedCustomers = ref([]);
const sortBy = ref("name");
const sortOrder = ref("asc");
const activeMenuId = ref(null);

// Computed properties
const filteredCustomers = computed(() => {
  let filtered = customers.value;
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (customer) =>
        customer.name.toLowerCase().includes(query) ||
        customer.email.toLowerCase().includes(query) ||
        customer.id.toString().includes(query) ||
        customer.role.toLowerCase().includes(query)
    );
  }
  filtered.sort((a, b) => {
    let aValue = a[sortBy.value];
    let bValue = b[sortBy.value];
    if (typeof aValue === "string") {
      aValue = aValue.toLowerCase();
      bValue = bValue.toLowerCase();
    }
    if (sortOrder.value === "asc") {
      return aValue < bValue ? -1 : aValue > bValue ? 1 : 0;
    } else {
      return aValue > bValue ? -1 : aValue < bValue ? 1 : 0;
    }
  });
  return filtered;
});

const totalPages = computed(() => {
  return Math.ceil(filteredCustomers.value.length / itemsPerPage.value);
});

const paginatedCustomers = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredCustomers.value.slice(start, end);
});

const startIndex = computed(() => {
  return (currentPage.value - 1) * itemsPerPage.value;
});

const endIndex = computed(() => {
  return Math.min(startIndex.value + itemsPerPage.value, filteredCustomers.value.length);
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

const isAllSelected = computed(() => {
  return paginatedCustomers.value.length > 0 && paginatedCustomers.value.every((customer) => selectedCustomers.value.includes(customer.id));
});

// Methods
const fetchCustomers = async () => {
  try {
    loading.value = true;
    error.value = null;
    const response = await fetch(API_URL);
    if (!response.ok) throw new Error("Failed to fetch customers");
    const data = await response.json();
    customers.value = data.map(({ id, name, email, role }) => ({ id, name, email, role }));
  } catch (err) {
    console.error("API fetch failed, using mock data:", err.message);
    customers.value = [
      {
        id: 3,
        name: "Aurora Stephenson",
        email: "yong@yong12gamil.com",
        role: "user",
      },
    ];
    error.value = "Using mock data due to API failure";
  } finally {
    loading.value = false;
  }
};

const toggleAddForm = () => {
  showAddForm.value = !showAddForm.value;
  if (showAddForm.value) {
    resetNewCustomer();
  }
};

const addCustomer = async () => {
  if (newCustomer.value.name && newCustomer.value.email) {
    try {
      loading.value = true;
      error.value = null;
      const response = await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...newCustomer.value, role: "user" }),
      });
      if (!response.ok) throw new Error("Failed to add customer");
      const data = await response.json();
      customers.value.push({
        id: data.id,
        name: data.name,
        email: data.email,
        role: data.role || "user",
      });
      resetNewCustomer();
      showAddForm.value = false;
      showToastMessage("Customer added successfully!");
    } catch (err) {
      error.value = "Failed to add customer: " + err.message;
    } finally {
      loading.value = false;
    }
  } else {
    error.value = "Name and email are required";
  }
};

const cancelAdd = () => {
  showAddForm.value = false;
  resetNewCustomer();
  error.value = null;
};

const resetNewCustomer = () => {
  newCustomer.value = { name: "", email: "" };
};

const editCustomer = (customer) => {
  isEditing.value = true;
  editedCustomer.value = { ...customer };
  activeMenuId.value = null;
};

const saveCustomer = async () => {
  const index = customers.value.findIndex((c) => c.id === editedCustomer.value.id);
  if (index !== -1) {
    try {
      loading.value = true;
      error.value = null;
      const response = await fetch(`${API_URL}/${editedCustomer.value.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(editedCustomer.value),
      });
      if (!response.ok) throw new Error("Failed to update customer");
      const data = await response.json();
      customers.value[index] = {
        id: data.id,
        name: data.name,
        email: data.email,
        role: data.role || customers.value[index].role,
      };
      isEditing.value = false;
      editedCustomer.value = { id: null, name: "", email: "", role: "" };
      showToastMessage("Customer updated successfully!");
    } catch (err) {
      error.value = "Failed to update customer: " + err.message;
    } finally {
      loading.value = false;
    }
  }
};

const cancelEdit = () => {
  isEditing.value = false;
  editedCustomer.value = { id: null, name: "", email: "", role: "" };
  error.value = null;
};

const viewCustomer = (customer) => {
  selectedCustomer.value = { ...customer };
  isViewing.value = true;
  activeMenuId.value = null;
};

const deleteCustomer = async (id) => {
  if (confirm("Are you sure you want to delete this customer?")) {
    try {
      loading.value = true;
      const response = await fetch(`${API_URL}/${id}`, {
        method: "DELETE",
      });
      if (!response.ok) throw new Error("Failed to delete customer");
      customers.value = customers.value.filter((c) => c.id !== id);
      selectedCustomers.value = selectedCustomers.value.filter((cId) => cId !== id);
      activeMenuId.value = null;
      showToastMessage("Customer deleted successfully!");
    } catch (err) {
      error.value = "Failed to delete customer: " + err.message;
    } finally {
      loading.value = false;
    }
  }
};

const bulkDelete = async () => {
  if (confirm(`Are you sure you want to delete ${selectedCustomers.value.length} customers?`)) {
    try {
      loading.value = true;
      const deletePromises = selectedCustomers.value.map((id) => fetch(`${API_URL}/${id}`, { method: "DELETE" }));
      await Promise.all(deletePromises);
      customers.value = customers.value.filter((c) => !selectedCustomers.value.includes(c.id));
      selectedCustomers.value = [];
      showToastMessage(`${deletePromises.length} customers deleted successfully!`);
    } catch (err) {
      error.value = "Failed to delete customers: " + err.message;
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

const showToastMessage = (message) => {
  toastMessage.value = message;
  showToast.value = true;
  setTimeout(() => {
    showToast.value = false;
  }, 3000);
};

const toggleActionMenu = (customerId) => {
  activeMenuId.value = activeMenuId.value === customerId ? null : customerId;
};

const toggleSelectAll = () => {
  if (isAllSelected.value) {
    selectedCustomers.value = selectedCustomers.value.filter((id) => !paginatedCustomers.value.some((customer) => customer.id === id));
  } else {
    const currentPageIds = paginatedCustomers.value.map((customer) => customer.id);
    selectedCustomers.value = [...new Set([...selectedCustomers.value, ...currentPageIds])];
  }
};

const setSortBy = (field) => {
  if (sortBy.value === field) {
    sortOrder.value = sortOrder.value === "asc" ? "desc" : "asc";
  } else {
    sortBy.value = field;
    sortOrder.value = "asc";
  }
  currentPage.value = 1;
};

const toggleSortOrder = () => {
  sortOrder.value = sortOrder.value === "asc" ? "desc" : "asc";
};

const applySorting = () => {
  currentPage.value = 1;
};

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

const handleClickOutside = (event) => {
  if (!event.target.closest(".relative")) {
    activeMenuId.value = null;
  }
};

onMounted(() => {
  fetchCustomers();
  document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);
});
</script>

<style scoped>
.container {
  display: flex;
}
.customer {
  margin-right: -20px;
  width: 85%;
}
.overflow-x-auto::-webkit-scrollbar {
  height: 4px;
}
.overflow-x-auto::-webkit-scrollbar-track {
  background: #f1f5f9;
}
.overflow-x-auto::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 2px;
}
.overflow-x-auto::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}
tbody tr:hover {
  background-color: #f9fafb;
}
* {
  transition: all 0.2s ease-in-out;
}
.relative > div {
  animation: slideDown 0.2s ease-out;
}
@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>