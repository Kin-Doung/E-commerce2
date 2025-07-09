<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <div class="container">
      <aside></aside>

      <div class="product max-w-7xl mx-auto">
        <!-- Header Section -->
        <div
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-8 mb-8"
        >
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-4xl font-bold text-gray-900 flex items-center">
                <svg
                  class="h-10 w-10 text-blue-600 mr-4"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"
                  />
                </svg>
                Product Management
              </h2>
              <p class="text-lg text-gray-600 mt-2">
                Manage your product catalog and inventory with ease
              </p>
            </div>
            <div class="flex items-center space-x-4">
              <div class="text-right">
                <p class="text-3xl font-bold text-blue-600">
                  {{ products.length }}
                </p>
                <p class="text-sm text-gray-500">Total Products</p>
              </div>
              <button
                @click="toggleAddForm"
                class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors duration-200 flex items-center font-medium shadow-sm"
              >
                <svg
                  v-if="!showAddForm"
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
                <svg
                  v-else
                  class="h-5 w-5 mr-2"
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
                {{ showAddForm ? "Close Form" : "Add Product" }}
              </button>
            </div>
          </div>
        </div>

        <!-- Debug Information -->
        <div v-if="error" class="mb-6 p-4 bg-red-100 text-red-700 rounded-lg">
          <p class="font-medium">Error: {{ error }}</p>
          <p class="text-sm mt-1">{{ debugInfo }}</p>
        </div>

        <!-- Loading Categories -->
        <div
          v-if="loadingCategories"
          class="mb-6 p-4 bg-blue-100 text-blue-700 rounded-lg"
        >
          <p class="font-medium">Loading categories...</p>
        </div>

        <!-- Add Product Form -->
        <div
          v-if="showAddForm"
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
            <h3 class="text-2xl font-bold text-gray-900">Add New Product</h3>
          </div>

          <!-- Progress indicator for upload -->
          <div v-if="uploadProgress > 0 && uploadProgress < 100" class="mb-6">
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm font-medium text-blue-700"
                >Uploading...</span
              >
              <span class="text-sm font-medium text-blue-700"
                >{{ uploadProgress }}%</span
              >
            </div>
            <div class="w-full bg-gray-200 rounded-full h-2">
              <div
                class="bg-blue-600 h-2 rounded-full transition-all duration-300"
                :style="{ width: uploadProgress + '%' }"
              ></div>
            </div>
          </div>

          <form @submit.prevent="addProduct" class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Product Name</label
                >
                <input
                  v-model="newProduct.name"
                  placeholder="Enter product name"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Price</label
                >
                <div class="relative">
                  <span
                    class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-500"
                    >$</span
                  >
                  <input
                    v-model="newProduct.price"
                    placeholder="0.00"
                    type="number"
                    step="0.01"
                    class="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                    required
                  />
                </div>
              </div>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2"
                >Description</label
              >
              <textarea
                v-model="newProduct.description"
                placeholder="Enter product description"
                rows="4"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors resize-none"
                required
              ></textarea>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Product Image</label
                >
                <div class="relative">
                  <input
                    type="file"
                    @change="handleImageUpload"
                    accept="image/*"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                    required
                  />
                </div>
                <!-- Image preview -->
                <div v-if="imagePreview" class="mt-3">
                  <img
                    :src="imagePreview"
                    alt="Preview"
                    class="w-20 h-20 object-cover rounded-lg border border-gray-200"
                  />
                  <p class="text-xs text-gray-500 mt-1">Preview</p>
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Category</label
                >
                <select
                  v-model="newProduct.category_id"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                  required
                >
                  <option value="">Select Category</option>
                  <option
                    v-for="category in categories"
                    :key="category.id"
                    :value="category.id"
                  >
                    {{ category.name }}
                  </option>
                </select>
              </div>
            </div>
            <div
              class="flex justify-end space-x-4 pt-6 border-t border-gray-200"
            >
              <button
                type="button"
                @click="cancelAdd"
                class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200"
                :disabled="loading"
              >
                Cancel
              </button>
              <button
                type="submit"
                class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
                :disabled="loading || uploadProgress > 0"
              >
                <span
                  v-if="loading"
                  class="animate-spin rounded-full h-4 w-4 border-b-2 border-white mr-2"
                ></span>
                {{ loading ? "Creating..." : "Add Product" }}
              </button>
            </div>
          </form>
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
                  placeholder="Search products..."
                  class="pl-10 pr-4 py-3 w-80 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                />
              </div>
              <select
                v-model="categoryFilter"
                class="px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="">All Categories</option>
                <option
                  v-for="category in categories"
                  :key="category.id"
                  :value="category.id"
                >
                  {{ category.name }}
                </option>
              </select>
            </div>
            <div class="flex items-center space-x-4">
              <div class="flex items-center space-x-2">
                <span class="text-sm text-gray-600">Show:</span>
                <select
                  v-model="itemsPerPage"
                  class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                >
                  <option value="10">10</option>
                  <option value="25">25</option>
                  <option value="50">50</option>
                  <option value="100">100</option>
                </select>
              </div>
              <button
                @click="fetchProducts"
                class="p-3 text-gray-600 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
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
          v-if="loading && !products.length"
          class="bg-white rounded-xl shadow-sm border border-gray-200 p-12"
        >
          <div class="text-center">
            <div
              class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto mb-4"
            ></div>
            <p class="text-gray-600">Loading products...</p>
          </div>
        </div>

        <!-- Products Table -->
        <div
          v-else-if="paginatedProducts.length > 0"
          class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden"
        >
          <!-- Table Header -->
          <div class="px-6 py-4 border-b border-gray-200 bg-gray-50">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">Products</h3>
              <div class="flex items-center space-x-4">
                <span class="text-sm text-gray-600">
                  Showing {{ startIndex + 1 }} to {{ endIndex }} of
                  {{ filteredProducts.length }} entries
                </span>
                <div class="flex items-center space-x-2">
                  <button
                    @click="selectAll"
                    class="text-sm text-blue-600 hover:text-blue-800 font-medium"
                    v-if="selectedProducts.length < paginatedProducts.length"
                  >
                    Select All
                  </button>
                  <button
                    @click="clearSelection"
                    class="text-sm text-gray-600 hover:text-gray-800 font-medium"
                    v-if="selectedProducts.length > 0"
                  >
                    Clear ({{ selectedProducts.length }})
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
                        selectedProducts.length === paginatedProducts.length &&
                        paginatedProducts.length > 0
                      "
                      @change="toggleSelectAll"
                      class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                    />
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Image
                  </th>
                  <th
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 transition-colors"
                    @click="sortBy('name')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Product Name</span>
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
                    @click="sortBy('price')"
                  >
                    <div class="flex items-center space-x-1">
                      <span>Price</span>
                      <svg
                        v-if="sortField === 'price'"
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
                    Category
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
                  <th
                    class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr
                  v-for="(product, index) in paginatedProducts"
                  :key="product.id || index"
                  class="hover:bg-gray-50 transition-colors duration-150"
                  :class="{
                    'bg-blue-50': selectedProducts.includes(
                      product.id || index
                    ),
                  }"
                >
                  <td class="px-6 py-4 whitespace-nowrap">
                    <input
                      type="checkbox"
                      :value="product.id || index"
                      v-model="selectedProducts"
                      class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                    />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <img
                      :src="getImageUrl(product.image || product.image_url)"
                      :alt="product.name"
                      class="w-12 h-12 object-cover rounded-lg border border-gray-200"
                      @error="handleImageError"
                    />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <div>
                      <div class="text-sm font-semibold text-gray-900">
                        {{ product.name }}
                      </div>
                      <div class="text-xs text-gray-500">
                        ID: {{ product.id || index + 1 }}
                      </div>
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span class="text-lg font-bold text-blue-600"
                      >${{ parseFloat(product.price || 0).toFixed(2) }}</span
                    >
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-blue-100 text-blue-800"
                    >
                      {{ getCategoryName(product.category_id) }}
                    </span>
                  </td>
                  <td class="px-6 py-4">
                    <div
                      class="text-sm text-gray-600 max-w-xs truncate"
                      :title="product.description"
                    >
                      {{ product.description }}
                    </div>
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap">
                    <span
                      class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800"
                    >
                      <div
                        class="w-1.5 h-1.5 bg-green-400 rounded-full mr-1.5"
                      ></div>
                      In Stock
                    </span>
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
                          @click="viewProduct(product)"
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
                          @click="editProduct(product)"
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
                          <span>Edit Product</span>
                        </button>

                        <div class="border-t border-gray-100 my-1"></div>

                        <button
                          @click="deleteProduct(product.id || index)"
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
                          <span>Delete Product</span>
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
                {{ filteredProducts.length }} results
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
                        ? 'bg-blue-600 text-white'
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
                d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"
              />
            </svg>
            <h3 class="text-lg font-medium text-gray-900 mb-2">
              No Products Found
            </h3>
            <p class="text-gray-600 mb-6">
              Get started by adding your first product to the catalog.
            </p>
            <button
              @click="showAddForm = true"
              class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200"
            >
              Add Your First Product
            </button>
          </div>
        </div>

        <!-- Edit Product Modal -->
        <div
          v-if="isEditing"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
        >
          <div
            class="bg-white rounded-xl shadow-xl w-full max-w-2xl max-h-screen overflow-y-auto"
          >
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-2xl font-bold text-gray-900">Edit Product</h2>
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

            <form @submit.prevent="saveProduct" class="p-6 space-y-6">
              <!-- Current Image Preview -->
              <div
                v-if="editedProduct.image_url || editedProduct.image"
                class="text-center"
              >
                <img
                  :src="getImageUrl(editedProduct.image_url)"
                  :alt="editedProduct.name"
                  class="w-32 h-32 object-cover rounded-lg mx-auto border border-gray-200"
                  @error="handleImageError"
                />
                <p class="text-sm text-gray-500 mt-2">Current Image</p>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Product Name</label
                  >
                  <input
                    v-model="editedProduct.name"
                    placeholder="Enter product name"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                    required
                  />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Price</label
                  >
                  <div class="relative">
                    <span
                      class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-500"
                      >$</span
                    >
                    <input
                      v-model="editedProduct.price"
                      placeholder="0.00"
                      type="number"
                      step="0.01"
                      class="w-full pl-8 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                      required
                    />
                  </div>
                </div>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2"
                  >Description</label
                >
                <textarea
                  v-model="editedProduct.description"
                  placeholder="Enter product description"
                  rows="4"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors resize-none"
                  required
                ></textarea>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Update Image (Optional)</label
                  >
                  <input
                    type="file"
                    @change="handleImageEditUpload"
                    accept="image/*"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                  />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2"
                    >Category</label
                  >
                  <select
                    v-model="editedProduct.category_id"
                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
                    required
                  >
                    <option value="">Select Category</option>
                    <option
                      v-for="category in categories"
                      :key="category.id"
                      :value="category.id"
                    >
                      {{ category.name }}
                    </option>
                  </select>
                </div>
              </div>

              <div
                class="flex justify-end space-x-4 pt-6 border-t border-gray-200"
              >
                <button
                  type="button"
                  @click="cancelEdit"
                  class="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors duration-200"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
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

        <!-- Show Product Modal -->
        <div
          v-if="isShowing"
          class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
        >
          <div
            class="bg-white rounded-xl shadow-xl w-full max-w-4xl max-h-screen overflow-y-auto"
          >
            <div class="p-6 border-b border-gray-200">
              <div class="flex items-center justify-between">
                <h2 class="text-2xl font-bold text-gray-900">
                  Product Details
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
            <div class="p-6">
              <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <div>
                  <img
                    :src="
                      getImageUrl(
                        selectedProduct.image || selectedProduct.image_url
                      )
                    "
                    :alt="selectedProduct.name"
                    class="w-full h-64 object-cover rounded-lg border border-gray-200"
                    @error="handleImageError"
                  />
                </div>
                <div>
                  <h3 class="text-3xl font-bold text-gray-900 mb-4">
                    {{ selectedProduct.name }}
                  </h3>
                  <p class="text-4xl font-bold text-blue-600 mb-4">
                    ${{ parseFloat(selectedProduct.price || 0).toFixed(2) }}
                  </p>
                  <p class="text-gray-600 mb-6">
                    {{ selectedProduct.description }}
                  </p>

                  <div class="space-y-3">
                    <div class="flex items-center">
                      <span class="font-medium text-gray-700 w-24">ID:</span>
                      <span class="text-gray-600">{{
                        selectedProduct.id
                      }}</span>
                    </div>
                    <div class="flex items-center">
                      <span class="font-medium text-gray-700 w-24"
                        >Category:</span
                      >
                      <span class="text-gray-600">{{
                        getCategoryName(selectedProduct.category_id)
                      }}</span>
                    </div>
                    <div class="flex items-center">
                      <span class="font-medium text-gray-700 w-24"
                        >Status:</span
                      >
                      <span
                        class="bg-green-100 text-green-800 text-sm font-medium px-3 py-1 rounded-full"
                        >In Stock</span
                      >
                    </div>
                  </div>
                </div>
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

// API Configuration
const BASE_URL = "http://127.0.0.1:8000/api/products";
const CATEGORIES_URL = "http://127.0.0.1:8000/api/categories";

// Reactive state
const products = ref([]);
const categories = ref([]);
const searchQuery = ref("");
const categoryFilter = ref("");
const newProduct = ref({
  name: "",
  price: "",
  description: "",
  image: null,
  category_id: "",
});
const editedProduct = ref({
  id: null,
  name: "",
  price: "",
  description: "",
  image: null,
  image_url: "",
  category_id: "",
});
const selectedProduct = ref({});
const isEditing = ref(false);
const isShowing = ref(false);
const showAddForm = ref(false);
const loading = ref(false);
const loadingCategories = ref(false);
const error = ref(null);
const debugInfo = ref("");
const showToast = ref(false);
const toastMessage = ref("");
const uploadProgress = ref(0);
const imagePreview = ref(null);

// Table state
const selectedProducts = ref([]);
const itemsPerPage = ref(10);
const currentPage = ref(1);
const sortField = ref("name");
const sortDirection = ref("asc");
const activeMenuIndex = ref(null);

// Computed properties
const filteredProducts = computed(() => {
  let filtered = products.value;

  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(
      (product) =>
        product.name?.toLowerCase().includes(query) ||
        product.description?.toLowerCase().includes(query)
    );
  }

  if (categoryFilter.value) {
    filtered = filtered.filter(
      (product) =>
        product.category_id?.toString() === categoryFilter.value.toString()
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
  return Math.ceil(filteredProducts.value.length / itemsPerPage.value);
});

const paginatedProducts = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage.value;
  const end = start + itemsPerPage.value;
  return filteredProducts.value.slice(start, end);
});

const startIndex = computed(() => {
  return (currentPage.value - 1) * itemsPerPage.value;
});

const endIndex = computed(() => {
  return Math.min(
    startIndex.value + itemsPerPage.value,
    filteredProducts.value.length
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

// Utility functions
const compressImage = (file, maxWidth = 800, quality = 0.8) => {
  return new Promise((resolve) => {
    const canvas = document.createElement("canvas");
    const ctx = canvas.getContext("2d");
    const img = new Image();

    img.onload = () => {
      // Calculate new dimensions
      const ratio = Math.min(maxWidth / img.width, maxWidth / img.height);
      canvas.width = img.width * ratio;
      canvas.height = img.height * ratio;

      // Draw and compress
      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
      canvas.toBlob(resolve, "image/jpeg", quality);
    };

    img.src = URL.createObjectURL(file);
  });
};

const validateForm = () => {
  const { name, price, description, category_id, image } = newProduct.value;

  if (!name?.trim()) {
    throw new Error("Product name is required");
  }
  if (!price || parseFloat(price) <= 0) {
    throw new Error("Valid price is required");
  }
  if (!description?.trim()) {
    throw new Error("Product description is required");
  }
  if (!category_id) {
    throw new Error("Category selection is required");
  }
  if (!image) {
    throw new Error("Product image is required");
  }

  // Validate image size (max 5MB)
  if (image.size > 5 * 1024 * 1024) {
    throw new Error("Image size must be less than 5MB");
  }

  // Validate image type
  if (!image.type.startsWith("image/")) {
    throw new Error("Please select a valid image file");
  }
};

// Methods
const fetchCategories = async () => {
  try {
    loadingCategories.value = true;
    console.log("Fetching categories from:", CATEGORIES_URL);

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000); // 10 second timeout

    const response = await fetch(CATEGORIES_URL, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      signal: controller.signal,
    });

    clearTimeout(timeoutId);
    console.log("Categories response status:", response.status);

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    console.log("Fetched categories:", data);

    categories.value = Array.isArray(data) ? data : data.data || [];
  } catch (err) {
    console.error("Fetch categories error:", err);
    if (err.name === "AbortError") {
      error.value = "Request timeout - please check your connection";
    } else {
      error.value = `Failed to fetch categories: ${err.message}`;
    }
    categories.value = [];
  } finally {
    loadingCategories.value = false;
  }
};

const fetchProducts = async () => {
  try {
    loading.value = true;
    error.value = null;

    console.log("Fetching products from:", BASE_URL);

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 15000); // 15 second timeout

    const response = await fetch(BASE_URL, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
      signal: controller.signal,
    });

    clearTimeout(timeoutId);
    console.log("Response status:", response.status);

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    console.log("Fetched data:", data);

    products.value = Array.isArray(data) ? data : data.data || [];
  } catch (err) {
    console.error("Fetch error:", err);
    if (err.name === "AbortError") {
      error.value = "Request timeout - please check your connection";
    } else {
      error.value = `Failed to fetch products: ${err.message}`;
    }
  } finally {
    loading.value = false;
  }
};

const toggleAddForm = () => {
  showAddForm.value = !showAddForm.value;
  if (showAddForm.value) {
    resetNewProduct();
  }
};

const handleImageUpload = async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  try {
    // Validate file
    if (file.size > 5 * 1024 * 1024) {
      throw new Error("Image size must be less than 5MB");
    }

    if (!file.type.startsWith("image/")) {
      throw new Error("Please select a valid image file");
    }

    // Create preview
    imagePreview.value = URL.createObjectURL(file);

    // Compress image if it's large
    if (file.size > 1024 * 1024) {
      // 1MB
      console.log("Compressing image...");
      const compressedFile = await compressImage(file);
      newProduct.value.image = compressedFile;
      console.log(
        `Image compressed from ${(file.size / 1024 / 1024).toFixed(2)}MB to ${(
          compressedFile.size /
          1024 /
          1024
        ).toFixed(2)}MB`
      );
    } else {
      newProduct.value.image = file;
    }
  } catch (err) {
    error.value = err.message;
    event.target.value = ""; // Clear the input
  }
};

const handleImageEditUpload = async (event) => {
  const file = event.target.files[0];
  if (!file) return;

  try {
    // Validate and compress similar to handleImageUpload
    if (file.size > 5 * 1024 * 1024) {
      throw new Error("Image size must be less than 5MB");
    }

    if (!file.type.startsWith("image/")) {
      throw new Error("Please select a valid image file");
    }

    if (file.size > 1024 * 1024) {
      const compressedFile = await compressImage(file);
      editedProduct.value.image = compressedFile;
    } else {
      editedProduct.value.image = file;
    }
  } catch (err) {
    error.value = err.message;
    event.target.value = "";
  }
};

const addProduct = async () => {
  const startTime = Date.now();

  try {
    loading.value = true;
    error.value = null;
    debugInfo.value = "";
    uploadProgress.value = 0;

    // Validate form
    validateForm();

    const formData = new FormData();
    formData.append("name", newProduct.value.name.trim());
    formData.append("price", parseFloat(newProduct.value.price).toFixed(2));
    formData.append("description", newProduct.value.description.trim());
    formData.append("image", newProduct.value.image);
    formData.append("category_id", newProduct.value.category_id);

    console.log("Adding product with data:", {
      name: newProduct.value.name,
      price: newProduct.value.price,
      description: newProduct.value.description.substring(0, 50) + "...",
      category_id: newProduct.value.category_id,
      imageSize: newProduct.value.image
        ? `${(newProduct.value.image.size / 1024).toFixed(2)}KB`
        : "No image",
    });

    // Simulate progress for better UX
    const progressInterval = setInterval(() => {
      if (uploadProgress.value < 90) {
        uploadProgress.value += Math.random() * 10;
      }
    }, 100);

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 30000); // 30 second timeout for uploads

    const response = await fetch(BASE_URL, {
      method: "POST",
      body: formData,
      signal: controller.signal,
    });

    clearInterval(progressInterval);
    clearTimeout(timeoutId);
    uploadProgress.value = 100;

    console.log("Add response status:", response.status);

    if (!response.ok) {
      const errorData = await response.text();
      console.error("Add error response:", errorData);
      debugInfo.value = `Response: ${response.status} ${response.statusText}`;
      throw new Error(`Failed to add product: ${response.status}`);
    }

    const data = await response.json();
    console.log("Added product:", data);

    // Add to local array for immediate UI update
    products.value.unshift(data); // Add to beginning for better UX

    showAddForm.value = false;
    resetNewProduct();

    const endTime = Date.now();
    const duration = ((endTime - startTime) / 1000).toFixed(2);

    showToastMessage(`Product added successfully in ${duration}s!`);
  } catch (err) {
    console.error("Add product error:", err);

    if (err.name === "AbortError") {
      error.value = "Upload timeout - please try again with a smaller image";
    } else {
      error.value = err.message;
    }

    debugInfo.value = `Error occurred after ${(
      (Date.now() - startTime) /
      1000
    ).toFixed(2)}s`;
  } finally {
    loading.value = false;
    uploadProgress.value = 0;
  }
};

const cancelAdd = () => {
  showAddForm.value = false;
  resetNewProduct();
  error.value = null;
  uploadProgress.value = 0;
};

const resetNewProduct = () => {
  newProduct.value = {
    name: "",
    price: "",
    description: "",
    image: null,
    category_id: "",
  };
  imagePreview.value = null;

  // Clear file input
  const fileInput = document.querySelector('input[type="file"]');
  if (fileInput) {
    fileInput.value = "";
  }
};

const editProduct = (product) => {
  console.log("Editing product:", product);

  isEditing.value = true;
  editedProduct.value = {
    ...product,
    image: null, // Reset file input
  };
  activeMenuIndex.value = null;
  error.value = null;

  console.log("Edit form data:", editedProduct.value);
};

const saveProduct = async () => {
  try {
    loading.value = true;
    error.value = null;

    console.log("Saving product:", editedProduct.value);

    const formData = new FormData();
    formData.append("name", editedProduct.value.name);
    formData.append("price", editedProduct.value.price);
    formData.append("description", editedProduct.value.description);
    formData.append("category_id", editedProduct.value.category_id);

    // Only append image if a new one was selected
    if (editedProduct.value.image) {
      formData.append("image", editedProduct.value.image);
    }

    // Add _method for Laravel to handle PUT request with FormData
    formData.append("_method", "PUT");

    console.log(
      "Sending update request for product ID:",
      editedProduct.value.id
    );

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 30000);

    const response = await fetch(`${BASE_URL}/${editedProduct.value.id}`, {
      method: "POST", // Use POST with _method=PUT for FormData
      body: formData,
      signal: controller.signal,
    });

    clearTimeout(timeoutId);
    console.log("Update response status:", response.status);

    if (!response.ok) {
      const errorData = await response.text();
      console.error("Update error response:", errorData);
      throw new Error(`Failed to update product: ${response.status}`);
    }

    const data = await response.json();
    console.log("Updated product data:", data);

    // Update the product in the local array
    const index = products.value.findIndex((p) => p.id === data.id);
    if (index !== -1) {
      products.value[index] = data;
      console.log("Product updated in local array at index:", index);
    }

    isEditing.value = false;
    showToastMessage("Product updated successfully!");
  } catch (err) {
    console.error("Save product error:", err);
    if (err.name === "AbortError") {
      error.value = "Update timeout - please try again";
    } else {
      error.value = err.message;
    }
  } finally {
    loading.value = false;
  }
};

const cancelEdit = () => {
  isEditing.value = false;
  editedProduct.value = {
    id: null,
    name: "",
    price: "",
    description: "",
    image: null,
    image_url: "",
    category_id: "",
  };
  error.value = null;
};

const deleteProduct = async (id) => {
  if (confirm("Are you sure you want to delete this product?")) {
    try {
      loading.value = true;

      console.log("Deleting product ID:", id);

      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 10000);

      const response = await fetch(`${BASE_URL}/${id}`, {
        method: "DELETE",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        signal: controller.signal,
      });

      clearTimeout(timeoutId);
      console.log("Delete response status:", response.status);

      if (!response.ok) {
        const errorData = await response.text();
        console.error("Delete error response:", errorData);
        throw new Error(`Failed to delete product: ${response.status}`);
      }

      products.value = products.value.filter((p) => p.id !== id);
      selectedProducts.value = selectedProducts.value.filter(
        (selectedId) => selectedId !== id
      );
      showToastMessage("Product deleted successfully!");
      activeMenuIndex.value = null;
    } catch (err) {
      console.error("Delete product error:", err);
      if (err.name === "AbortError") {
        error.value = "Delete timeout - please try again";
      } else {
        error.value = err.message;
      }
    } finally {
      loading.value = false;
    }
  }
};

const viewProduct = (product) => {
  selectedProduct.value = { ...product };
  isShowing.value = true;
  activeMenuIndex.value = null;
};

const getImageUrl = (imagePath) => {
  if (!imagePath) return "https://via.placeholder.com/400x300?text=No+Image";
  if (imagePath.startsWith("http")) return imagePath;
  return `http://127.0.0.1:8000/storage/${imagePath}`;
};

const handleImageError = (event) => {
  event.target.src = "https://via.placeholder.com/400x300?text=Image+Not+Found";
};

const getCategoryName = (categoryId) => {
  if (!categoryId || !categories.value.length) return "Unknown";

  const category = categories.value.find(
    (cat) => cat.id.toString() === categoryId.toString()
  );
  return category ? category.name : "Unknown";
};

const showToastMessage = (message) => {
  toastMessage.value = message;
  showToast.value = true;
  setTimeout(() => {
    showToast.value = false;
  }, 4000); // Show for 4 seconds
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
  if (selectedProducts.value.length === paginatedProducts.value.length) {
    selectedProducts.value = [];
  } else {
    selectedProducts.value = paginatedProducts.value.map(
      (product) => product.id
    );
  }
};

const selectAll = () => {
  selectedProducts.value = paginatedProducts.value.map((product) => product.id);
};

const clearSelection = () => {
  selectedProducts.value = [];
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
onMounted(async () => {
  // Fetch categories first, then products in parallel for better performance
  await fetchCategories();
  fetchProducts(); // Don't await this to make it non-blocking
  document.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  document.removeEventListener("click", handleClickOutside);

  // Clean up any object URLs
  if (imagePreview.value) {
    URL.revokeObjectURL(imagePreview.value);
  }
});
</script>

<style scoped>
.container{
  display: flex;
}
.product{
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

/* Progress bar animation */
@keyframes progress {
  0% {
    width: 0%;
  }
  100% {
    width: 100%;
  }
}
</style>
