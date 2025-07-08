<template>
  <div class="p-4 bg-white rounded shadow">
    <h2 class="text-2xl font-bold text-gray-900">Categories</h2>
    <p class="mt-2 text-gray-600">Manage your product categories.</p>

    <!-- Create Category Button -->
    <button @click="showForm = true; formMode = 'add'; resetForm()" class="mb-4 px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
      Create Category
    </button>

    <!-- Add Form -->
    <div v-if="showForm" class="mt-4">
      <h3 class="text-lg font-semibold">Add New Category</h3>
      <form @submit.prevent="handleSubmit" class="mt-2 space-y-4">
        <input v-model="currentCategory.name" placeholder="Name" class="w-full p-2 border rounded" required />
        <input v-model="currentCategory.stock_id" placeholder="Stock ID" type="number" class="w-full p-2 border rounded" required />
        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700" :disabled="loading">
          Add Category
        </button>
        <button @click="cancelForm" type="button" class="ml-2 px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">Cancel</button>
      </form>
      <p v-if="error" class="mt-2 text-red-600">{{ error }}</p>
    </div>

    <!-- Category List as Table -->
    <div class="mt-6">
      <h3 class="text-lg font-semibold">Category List</h3>
      <table v-if="!loading && categories.length" class="w-full mt-2 border-collapse">
        <thead>
          <tr class="bg-gray-200">
            <th class="p-2 border text-left">ID</th>
            <th class="p-2 border text-left">Name</th>
            <th class="p-2 border text-left">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(category, index) in categories" :key="index" class="border-t">
            <td class="p-2">{{ index + 1 }}</td>
            <td class="p-2">{{ category.name }}</td>
            <td class="p-2 relative">
              <button
                @click="toggleMenu(index)"
                class="px-2 py-1 bg-gray-200 text-gray-800 rounded hover:bg-gray-300"
              >
                ⋮
              </button>
              <div
                v-if="activeMenuIndex === index"
                class="absolute z-10 right-0 mt-2 w-32 bg-white border rounded shadow-lg"
              >
                <button
                  @click="showCategory(category)"
                  class="block w-full text-left px-4 py-2 text-gray-800 hover:bg-gray-100"
                >
                  Show
                </button>
                <button
                  @click="editCategory(category)"
                  class="block w-full text-left px-4 py-2 text-yellow-600 hover:bg-gray-100"
                >
                  Edit
                </button>
                <button
                  @click="deleteCategory(category.id)"
                  class="block w-full text-left px-4 py-2 text-red-600 hover:bg-gray-100"
                >
                  Delete
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <p v-if="!loading && !categories.length" class="mt-2 text-gray-600">No categories available.</p>
      <p v-if="loading" class="mt-2 text-gray-600">Loading categories...</p>
    </div>

    <!-- Edit Category Modal -->
    <div v-if="isEditing" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white p-6 rounded shadow w-full max-w-md">
        <h3 class="text-lg font-semibold mb-4">Edit Category</h3>
        <form @submit.prevent="handleSubmit" class="space-y-4">
          <input v-model="currentCategory.name" placeholder="Name" class="w-full p-2 border rounded" required />
          <input v-model="currentCategory.stock_id" placeholder="Stock ID" type="number" class="w-full p-2 border rounded" required />
          <div class="flex justify-end space-x-2">
            <button type="button" @click="cancelEdit" class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">Cancel</button>
            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700" :disabled="loading">Save</button>
          </div>
        </form>
        <p v-if="error" class="mt-2 text-red-600">{{ error }}</p>
      </div>
    </div>

    <!-- Show Category Modal -->
    <div v-if="isShowing" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white p-6 rounded shadow w-full max-w-md">
        <h3 class="text-lg font-semibold mb-4">Category Details</h3>
        <div class="space-y-2">
          <p><strong>ID:</strong> {{ selectedCategory.id }}</p>
          <p><strong>Name:</strong> {{ selectedCategory.name }}</p>
          <p><strong>Stock ID:</strong> {{ selectedCategory.stock_id }}</p>
        </div>
        <div class="flex justify-end mt-4">
          <button @click="isShowing = false" class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">Close</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// Reactive state
const categories = ref([])
const currentCategory = ref({ id: null, name: '', stock_id: '' })
const selectedCategory = ref({ id: null, name: '', stock_id: '' })
const showForm = ref(false)
const isEditing = ref(false)
const isShowing = ref(false)
const formMode = ref('add')
const activeMenuIndex = ref(null)
const loading = ref(false)
const error = ref(null)

const BASE_URL = 'http://127.0.0.1:8000/api/categories'

// Fetch categories on mount
onMounted(() => {
  fetchCategories()
})

const fetchCategories = async () => {
  try {
    loading.value = true
    const response = await fetch(BASE_URL)
    if (!response.ok) throw new Error('Failed to fetch categories')
    const data = await response.json()
    categories.value = Array.isArray(data) ? data : [data]
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const resetForm = () => {
  currentCategory.value = { id: null, name: '', stock_id: '' }
}

const handleSubmit = async () => {
  try {
    loading.value = true
    const response = await fetch(`${BASE_URL}${formMode.value === 'add' ? '' : '/' + currentCategory.value.id}`, {
      method: formMode.value === 'add' ? 'POST' : 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: currentCategory.value.name, stock_id: currentCategory.value.stock_id })
    })
    if (!response.ok) throw new Error(`Failed to ${formMode.value} category`)
    const data = await response.json()
    if (formMode.value === 'add') {
      categories.value.push(data)
      showForm.value = false
    } else {
      const index = categories.value.findIndex(c => c.id === data.id)
      if (index !== -1) categories.value[index] = data
      isEditing.value = false
    }
    resetForm()
    error.value = null
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const cancelForm = () => {
  showForm.value = false
  resetForm()
  error.value = null
}

const cancelEdit = () => {
  isEditing.value = false
  resetForm()
  error.value = null
}

const editCategory = (category) => {
  isEditing.value = true
  formMode.value = 'edit'
  currentCategory.value = { ...category }
  activeMenuIndex.value = null
}

const deleteCategory = async (id) => {
  if (confirm('Are you sure you want to delete this category?')) {
    try {
      loading.value = true
      const response = await fetch(`${BASE_URL}/${id}`, { method: 'DELETE' })
      if (!response.ok) throw new Error('Failed to delete category')
      categories.value = categories.value.filter(c => c.id !== id)
      error.value = null
    } catch (err) {
      error.value = err.message
    } finally {
      loading.value = false
      activeMenuIndex.value = null
    }
  }
}

const toggleMenu = (index) => {
  activeMenuIndex.value = activeMenuIndex.value === index ? null : index
}

const showCategory = (category) => {
  selectedCategory.value = { ...category }
  isShowing.value = true
  activeMenuIndex.value = null
}
</script>