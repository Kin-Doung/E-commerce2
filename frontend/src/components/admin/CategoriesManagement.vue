<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="category max-w-7xl mx-auto">
        <!-- Header Section -->
        <div
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8"
        >
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-4xl font-bold text-gray-900 flex items-center">
                <svg
                  class="h-10 w-10 text-indigo-600 mr-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                  />
                </svg>
                Category Management
              </h2>
              <p class="text-lg text-gray-600 mt-2">
                Organize and manage your product categories efficiently
              </p>
            </div>
            <div class="flex items-center space-x-4">
              <div class="text-right">
                <p class="text-3xl font-bold text-indigo-600">
                  {{ categories.length }}
                </p>
                <p class="text-sm text-gray-500">Total Categories</p>
              </div>
              <button
                @click="openAddForm"
                class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors duration-200 flex items-center font-medium shadow-sm"
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
                    d="M12 6v6m0 0v6m0-6h6m-6 0H6"
                  />
                </svg>
                Add Category
              </button>
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
                  placeholder="Search categories..."
                  class="pl-10 pr-4 py-3 w-80 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors"
                />
              </div>
              <select
                v-model="statusFilter"
                class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              >
                <option value="">All Status</option>
                <option value="active">Active</option>
                <option value="inactive">Inactive</option>
              </select>
            </div>
            <div class="flex items-center space-x-4">
              <div class="flex items-center space-x-2">
                <span class="text-sm text-gray-600">Show:</span>
                <select
                  v-model="itemsPerPage"
                  class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                >
                  <option value="10">10</option>
                  <option value="25">25</option>
                  <option value="50">50</option>
                  <option value="100">100</option>
                </select>
              </div>
              <button
                @click="fetchCategories"
                class="p-3 text-gray-600 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition-colors"
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

        <!-- Add Category Form -->
        <div
          v-if="showForm"
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8"
        >
          <div class="flex items-center mb-6">
            <div class="p-3 bg-green-100 rounded-full mr-4">
              <svg
                class="h-6 w-6 text-green-600"
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
            </div>
            <h3 class="text-2xl font-bold text-gray-900">Add New Category</h3>
          </div>

          <form @submit.prevent="handleSubmit" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Category Name</label
                >
                <input
                  v-model="currentCategory.name"
                  placeholder="Enter category name"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Stock ID</label
                >
                <input
                  v-model="currentCategory.stock_id"
                  placeholder="Enter stock ID"
                  type="number"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors"
                  required
                />
              </div>
            </div>

            <div
              class="flex justify-end space-x-4 pt-6 border-t border-gray-200"
            >
              <button
                type="button"
                @click="cancelForm"
                class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200"
              >
                Cancel
              </button>
              <button
                type="submit"
                class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                :disabled="loading"
              >
                <span
                  v-if="loading"
                  class="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"
                ></span>
                Add Category
              </button>
            </div>
          </form>

          <div
            v-if="error"
            class="mt-4 p-4 bg-red-50 border border-red-200 rounded-lg"
          >
            <div class="flex items-center">
              <svg
                class="h-5 w-5 text-red-600 mr-2"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              <p class="text-red-800 font-medium">{{ error }}</p>
            </div>
          </div>
        </div>

        <!-- Loading State -->
        <div
          v-if="loading && !categories.length"
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-12"
        >
          <div class="text-center">
            <div
              class="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600 mx-auto mb-4"
            ></div>
            <p class="text-gray-600">Loading categories...</p>
          </div>
        </div>

        <!-- Categories Table -->
        <div
          v-else-if="paginatedCategories.length > 0"
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <!-- Table Header -->
          <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">Categories</h3>
              <div class="flex items-center space-x-4">
                <span class="text-sm text-gray-600">
                  Showing {{ startIndex + 1 }} to {{ endIndex }} of
                  {{ filteredCategories.length }} entries
                </span>
                <div class="flex items-center space-x-2">
                  <button
                    @click="selectAll"
                    class="text-sm text-indigo-600 hover:text-indigo-800 font-medium"
                    v-if="
                      selectedCategories.length < paginatedCategories.length
                    "
                  >
                    Select All
                  </button>
                  <button
                    @click="clearSelection"
                    class="text-sm text-gray-600 hover:text-gray-800 font-medium"
                    v-if="selectedCategories.length > 0"
                  >
                    Clear ({{ selectedCategories.length }})
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
                        selectedCategories.length ===
                          paginatedCategories.length &&
                        paginatedCategories.length > 0
                      "
                      @change="toggleSelectAll"
                      class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                    />
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 transition-colors"
                    @click="sortBy('id')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>ID</span>
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
                    @click="sortBy('name')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Category Name</span>
                      <svg
                        v-if="sortField === 'name'"
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
                    @click="sortBy('stock_id')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Stock ID</span>
                      <svg
                        v-if="sortField === 'stock_id'"
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
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Created Date
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
                  v-for="(category, index) in paginatedCategories"
                  :key="category.id || index"
                  class="hover:bg-gray-50 transition-colors duration-150"
                  :class="{
                    'bg-indigo-50': selectedCategories.includes(
                      category.id || index
                    ),
                  }"
                >
                  <td class="px-6 py-4 whitespace-nowrap">
                    <input
                      type="checkbox"
                      :value="category.id || index"
                      v-model="selectedCategories"
                      class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                    />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <div
                        class="w-8 h-8 bg-indigo-100 rounded-lg flex items-center justify-center mr-3"
                      >
                        <span class="text-indigo-600 font-semibold text-sm">{{
                          category.id || index + 1
                        }}</span>
                      </div>
                      <span class="text-sm font-medium text-gray-900"
                        >#{{ category.id || index + 1 }}</span
                      >
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <div
                        class="w-10 h-10 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-lg flex items-center justify-center mr-3"
                      >
                        <svg
                          class="h-5 w-5 text-white"
                          fill="none"
                          stroke="currentColor"
                          viewBox="0 0 24 24"
                        >
                          <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                          />
                        </svg>
                      </div>
                      <div>
                        <div class="text-sm font-semibold text-gray-900">
                          {{ category.name }}
                        </div>
                        <div class="text-xs text-gray-500">Category</div>
                      </div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800"
                    >
                      {{ category.stock_id }}
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800"
                    >
                      <div
                        class="w-1.5 h-1.5 bg-green-400 rounded-full mr-1.5"
                      ></div>
                      Active
                    </span>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {{ formatDate(category.created_at || new Date()) }}
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
                          @click="viewCategory(category)"
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
                          @click="editCategory(category)"
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
                          <span>Edit Category</span>
                        </button>

                        <div class="border-t border-gray-100 my-1"></div>

                        <button
                          @click="deleteCategory(category.id || index)"
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
                          <span>Delete Category</span>
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
                {{ filteredCategories.length }} results
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
                        ? 'bg-indigo-600 text-white'
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
                d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900 mb-2">
              No Categories Found
            </h3>
            <p class="text-gray-600 mb-6">
              Get started by creating your first category.
            </p>
            <button
              @click="openAddForm"
              class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200"
            >
              Create Your First Category
            </button>
          </div>
        </div>

        <!-- Edit Category Modal -->
        <div
          v-if="isEditing"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
        >
          <div class="bg-white rounded-xl shadow-xl w-full max-w-md">
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-xl font-bold text-gray-900">Edit Category</h2>
                <button
                  @click="cancelEdit"
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

            <form @submit.prevent="handleSubmit" class="p-6 space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Category Name</label
                >
                <input
                  v-model="currentCategory.name"
                  placeholder="Enter category name"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Stock ID</label
                >
                <input
                  v-model="currentCategory.stock_id"
                  placeholder="Enter stock ID"
                  type="number"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors"
                  required
                />
              </div>

              <div class="flex justify-end space-x-4 pt-4">
                <button
                  type="button"
                  @click="cancelEdit"
                  class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                  :disabled="loading"
                >
                  <span
                    v-if="loading"
                    class="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"
                  ></span>
                  Save Changes
                </button>
              </div>
            </form>

            <div
              v-if="error"
              class="mx-6 mb-6 p-4 bg-red-50 border border-red-200 rounded-lg"
            >
              <div class="flex items-center">
                <svg
                  class="h-5 w-5 text-red-600 mr-2"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
                <p class="text-red-800 font-medium">{{ error }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Show Category Modal -->
        <div
          v-if="isShowing"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
        >
          <div class="bg-white rounded-xl shadow-xl w-full max-w-md">
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-xl font-bold text-gray-900">
                  Category Details
                </h2>
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

            <div class="p-6 space-y-4">
              <div class="flex items-center justify-center mb-6">
                <div
                  class="h-16 w-16 bg-indigo-100 rounded-full flex items-center justify-center"
                >
                  <svg
                    class="h-8 w-8 text-indigo-600"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                    />
                  </svg>
                </div>
              </div>

              <div class="space-y-3">
                <div
                  class="flex justify-between items-center py-2 border-b border-gray-100"
                >
                  <span class="font-medium text-gray-700">Category ID:</span>
                  <span class="text-gray-900">{{ selectedCategory.id }}</span>
                </div>
                <div
                  class="flex justify-between items-center py-2 border-b border-gray-100"
                >
                  <span class="font-medium text-gray-700">Name:</span>
                  <span class="text-gray-900 font-semibold">{{
                    selectedCategory.name
                  }}</span>
                </div>
                <div
                  class="flex justify-between items-center py-2 border-b border-gray-100"
                >
                  <span class="font-medium text-gray-700">Stock ID:</span>
                  <span class="text-gray-900">{{
                    selectedCategory.stock_id
                  }}</span>
                </div>
                <div class="flex justify-between items-center py-2">
                  <span class="font-medium text-gray-700">Status:</span>
                  <span
                    class="inline-flex px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800"
                  >
                    Active
                  </span>
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
const categories = ref([]);
const searchQuery = ref("");
const statusFilter = ref("");
const currentCategory = ref({ id: null, name: "", stock_id: "" });
const selectedCategory = ref({ id: null, name: "", stock_id: "" });
const showForm = ref(false);
const isEditing = ref(false);
const isShowing = ref(false);
const formMode = ref("add");
const loading = ref(false);
const error = ref(null);
const showToast = ref(false);
const toastMessage = ref("");

// Table state
const selectedCategories = ref([]);
const itemsPerPage = ref(10);
const currentPage = ref(1);
const sortField = ref("id");
const sortDirection = ref("asc");
const activeMenuIndex = ref(null);

const BASE_URL = "http://127.0.0.1:8000/api/categories";

// Computed properties
const filteredCategories = computed(() => {
  let filtered = categories.value;

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (category) =>
        category.name?.toLowerCase().includes(query) ||
        category.stock_id?.toString().includes(query)
    );
  }

  if (statusFilter.value) {
    filtered = filtered.filter(
      (category) =>
        category.status?.toLowerCase() === statusFilter.value.toLowerCase()
    );
  }

  // Apply sorting
  filtered.sort((a, b) => {
    let aVal = a[sortField.value];
    let bVal = b[sortField.value];

    if (typeof aVal === "string") {
      aVal = aVal.toLowerCase();
      bVal = bVal.toLowerCase();
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
  return Math.ceil(filteredCategories.value.length / itemsPerPage.value);
});

const paginatedCategories = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredCategories.value.slice(start, end);
});

const startIndex = computed(() => {
  return (currentPage.value - 1) * itemsPerPage.value;
});

const endIndex = computed(() => {
  return Math.min(
    startIndex.value + itemsPerPage.value,
    filteredCategories.value.length
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

// Methods
const fetchCategories = async () => {
  try {
    loading.value = true;
    error.value = null;
    const response = await fetch(BASE_URL);
    if (!response.ok) throw new Error("Failed to fetch categories");
    const data = await response.json();
    categories.value = Array.isArray(data) ? data : [data];
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const openAddForm = () => {
  showForm.value = true;
  formMode.value = "add";
  resetForm();
};

const resetForm = () => {
  currentCategory.value = { id: null, name: "", stock_id: "" };
  error.value = null;
};

const handleSubmit = async () => {
  try {
    loading.value = true;
    error.value = null;

    const url =
      formMode.value === "add"
        ? BASE_URL
        : `${BASE_URL}/${currentCategory.value.id}`;
    const method = formMode.value === "add" ? "POST" : "PUT";

    const response = await fetch(url, {
      method,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        name: currentCategory.value.name,
        stock_id: currentCategory.value.stock_id,
      }),
    });

    if (!response.ok) throw new Error(`Failed to ${formMode.value} category`);
    const data = await response.json();

    if (formMode.value === "add") {
      categories.value.push(data);
      showForm.value = false;
      showToastMessage("Category added successfully!");
    } else {
      const index = categories.value.findIndex((c) => c.id === data.id);
      if (index !== -1) categories.value[index] = data;
      isEditing.value = false;
      showToastMessage("Category updated successfully!");
    }

    resetForm();
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const cancelForm = () => {
  showForm.value = false;
  resetForm();
};

const cancelEdit = () => {
  isEditing.value = false;
  resetForm();
};

const editCategory = (category) => {
  isEditing.value = true;
  formMode.value = "edit";
  currentCategory.value = { ...category };
  activeMenuIndex.value = null;
};

const viewCategory = (category) => {
  selectedCategory.value = { ...category };
  isShowing.value = true;
  activeMenuIndex.value = null;
};

const deleteCategory = async (id) => {
  if (confirm("Are you sure you want to delete this category?")) {
    try {
      loading.value = true;
      const response = await fetch(`${BASE_URL}/${id}`, { method: "DELETE" });
      if (!response.ok) throw new Error("Failed to delete category");

      categories.value = categories.value.filter((c) => c.id !== id);
      selectedCategories.value = selectedCategories.value.filter(
        (selectedId) => selectedId !== id
      );
      showToastMessage("Category deleted successfully!");
      activeMenuIndex.value = null;
    } catch (err) {
      error.value = err.message;
    } finally {
      loading.value = false;
    }
  }
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
  if (selectedCategories.value.length === paginatedCategories.value.length) {
    selectedCategories.value = [];
  } else {
    selectedCategories.value = paginatedCategories.value.map((cat) => cat.id);
  }
};

const selectAll = () => {
  selectedCategories.value = paginatedCategories.value.map((cat) => cat.id);
};

const clearSelection = () => {
  selectedCategories.value = [];
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

const formatDate = (date) => {
  return new Date(date).toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
  if (!event.target.closest(".relative")) {
    activeMenuIndex.value = null;
  }
};

// Lifecycle
onMounted(() => {
  fetchCategories();
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
.category {
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
