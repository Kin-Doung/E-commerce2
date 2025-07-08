<template>
  <div class="max-w-7xl mx-auto p-8 bg-white rounded shadow">
    <!-- Heading -->
    <h2 class="text-3xl font-bold text-gray-800 mb-2">Product Management</h2>
    <p class="text-gray-600 mb-6">Manage your product catalog below.</p>

    <!-- Create Product Button -->
    <button
      @click="showAddForm = !showAddForm"
      class="mb-6 px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
    >
      {{ showAddForm ? 'Close Form' : 'Create Product' }}
    </button>

    <!-- Add Product Form -->
    <div v-if="showAddForm" class="mb-6 p-4 border rounded bg-gray-50">
      <h3 class="text-xl font-semibold mb-2">Add New Product</h3>
      <form @submit.prevent="addProduct" class="space-y-4">
        <input
          v-model="newProduct.name"
          placeholder="Name"
          class="w-full p-2 border rounded"
          required
        />
        <input
          v-model="newProduct.price"
          placeholder="Price"
          type="number"
          step="0.01"
          class="w-full p-2 border rounded"
          required
        />
        <input
          v-model="newProduct.description"
          placeholder="Description"
          class="w-full p-2 border rounded"
          required
        />
        <input
          type="file"
          @change="handleImageUpload"
          accept="image/*"
          class="w-full p-2 border rounded"
          required
        />
        <input
          v-model="newProduct.category_id"
          placeholder="Category ID"
          type="number"
          class="w-full p-2 border rounded"
          required
        />
        <div class="flex space-x-2">
          <button
            type="submit"
            class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            :disabled="loading"
          >
            Add Product
          </button>
          <button
            type="button"
            @click="cancelAdd"
            class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600"
          >
            Cancel
          </button>
        </div>
      </form>
      <p v-if="error" class="text-red-600 mt-2">{{ error }}</p>
    </div>

    <!-- Products Table -->
    <div class="overflow-x-auto">
      <table class="min-w-full border">
        <thead class="bg-gray-100">
          <tr>
            <th class="text-left p-2">ID</th>
            <th class="text-left p-2">Name</th>
            <th class="text-left p-2">Price</th>
            <th class="text-left p-2">Description</th>
            <th class="text-left p-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(product, index) in products"
            :key="index"
            class="border-t hover:bg-gray-50"
          >
            <td class="p-2">{{ index + 1 }}</td>
            <td class="p-2">{{ product.name }}</td>
            <td class="p-2">${{ product.price }}</td>
            <td class="p-2">{{ product.description }}</td>
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
                  @click="showProduct(product)"
                  class="block w-full text-left px-4 py-2 text-gray-800 hover:bg-gray-100"
                >
                  Show
                </button>
                <button
                  @click="editProduct(product)"
                  class="block w-full text-left px-4 py-2 text-yellow-600 hover:bg-gray-100"
                >
                  Edit
                </button>
                <button
                  @click="deleteProduct(product.id)"
                  class="block w-full text-left px-4 py-2 text-red-600 hover:bg-gray-100"
                >
                  Delete
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <p v-if="loading" class="text-gray-600 mt-4">Loading products...</p>
      <p v-if="!loading && !products.length" class="text-gray-600 mt-4">
        No products found.
      </p>
    </div>

    <!-- Edit Product Modal -->
    <div
      v-if="isEditing"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center"
    >
      <div class="bg-white p-6 rounded shadow w-full max-w-md">
        <h3 class="text-xl font-semibold mb-4">Edit Product</h3>
        <form @submit.prevent="saveProduct" class="space-y-4">
          <input
            v-model="editedProduct.name"
            placeholder="Name"
            class="w-full p-2 border rounded"
            required
          />
          <input
            v-model="editedProduct.price"
            placeholder="Price"
            type="number"
            step="0.01"
            class="w-full p-2 border rounded"
            required
          />
          <input
            v-model="editedProduct.description"
            placeholder="Description"
            class="w-full p-2 border rounded"
            required
          />
          <input
            type="file"
            @change="handleImageEditUpload"
            accept="image/*"
            class="w-full p-2 border rounded"
          />
          <input
            v-model="editedProduct.category_id"
            placeholder="Category ID"
            type="number"
            class="w-full p-2 border rounded"
            required
          />
          <div class="flex justify-end space-x-2">
            <button
              type="button"
              @click="cancelEdit"
              class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
              :disabled="loading"
            >
              Save
            </button>
          </div>
        </form>
        <p v-if="error" class="text-red-600 mt-2">{{ error }}</p>
      </div>
    </div>

    <!-- Show Product Modal -->
    <div
      v-if="isShowing"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center"
    >
      <div class="bg-white p-6 rounded shadow w-full max-w-md">
        <h3 class="text-xl font-semibold mb-4">Product Details</h3>
        <div class="space-y-2">
          <p><strong>ID:</strong> {{ selectedProduct.id }}</p>
          <p><strong>Name:</strong> {{ selectedProduct.name }}</p>
          <p><strong>Price:</strong> ${{ selectedProduct.price }}</p>
          <p><strong>Description:</strong> {{ selectedProduct.description }}</p>
          <p><strong>Category ID:</strong> {{ selectedProduct.category_id }}</p>
          <img
            :src="selectedProduct.image_url"
            alt="Product Image"
            class="w-32 h-32 object-cover rounded border mx-auto"
          />
        </div>
        <div class="flex justify-end mt-4">
          <button
            @click="isShowing = false"
            class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

// Reactive state
const products = ref([]);
const newProduct = ref({
  name: '',
  price: '',
  description: '',
  image: null,
  category_id: '',
});
const editedProduct = ref({
  id: null,
  name: '',
  price: '',
  description: '',
  image: null,
  category_id: '',
});
const selectedProduct = ref({});
const isEditing = ref(false);
const isShowing = ref(false);
const showAddForm = ref(false);
const activeMenuIndex = ref(null);
const loading = ref(false);
const error = ref(null);

const BASE_URL = 'http://127.0.0.1:8000/api/products';

// Fetch products on mount
onMounted(() => {
  fetchProducts();
});

const fetchProducts = async () => {
  try {
    loading.value = true;
    const response = await fetch(BASE_URL);
    if (!response.ok) throw new Error('Failed to fetch products');
    const data = await response.json();
    products.value = Array.isArray(data) ? data : [data];
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const handleImageUpload = (event) => {
  newProduct.value.image = event.target.files[0];
};

const handleImageEditUpload = (event) => {
  editedProduct.value.image = event.target.files[0];
};

const addProduct = async () => {
  try {
    loading.value = true;
    const formData = new FormData();
    formData.append('name', newProduct.value.name);
    formData.append('price', newProduct.value.price);
    formData.append('description', newProduct.value.description);
    formData.append('image', newProduct.value.image);
    formData.append('category_id', newProduct.value.category_id);

    const response = await fetch(BASE_URL, {
      method: 'POST',
      body: formData,
    });
    if (!response.ok) throw new Error('Failed to add product');
    const data = await response.json();
    products.value.push(data);
    showAddForm.value = false;
    newProduct.value = {
      name: '',
      price: '',
      description: '',
      image: null,
      category_id: '',
    };
    error.value = null;
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const cancelAdd = () => {
  showAddForm.value = false;
  newProduct.value = {
    name: '',
    price: '',
    description: '',
    image: null,
    category_id: '',
  };
  error.value = null;
};

const editProduct = (product) => {
  isEditing.value = true;
  editedProduct.value = { ...product, image: null };
  activeMenuIndex.value = null;
};

const saveProduct = async () => {
  try {
    loading.value = true;
    const formData = new FormData();
    formData.append('name', editedProduct.value.name);
    formData.append('price', editedProduct.value.price);
    formData.append('description', editedProduct.value.description);
    if (editedProduct.value.image) formData.append('image', editedProduct.value.image);
    formData.append('category_id', editedProduct.value.category_id);

    const response = await fetch(`${BASE_URL}/${editedProduct.value.id}`, {
      method: 'PUT',
      body: formData,
    });
    if (!response.ok) throw new Error('Failed to update product');
    const data = await response.json();
    const index = products.value.findIndex((p) => p.id === data.id);
    if (index !== -1) products.value[index] = data;
    isEditing.value = false;
    error.value = null;
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
  }
};

const cancelEdit = () => {
  isEditing.value = false;
  editedProduct.value = {
    id: null,
    name: '',
    price: '',
    description: '',
    image: null,
    category_id: '',
  };
};

const deleteProduct = async (id) => {
  if (confirm('Are you sure you want to delete this product?')) {
    try {
      loading.value = true;
      const response = await fetch(`${BASE_URL}/${id}`, {
        method: 'DELETE',
      });
      if (!response.ok) throw new Error('Failed to delete product');
      products.value = products.value.filter((p) => p.id !== id);
      error.value = null;
    } catch (err) {
      error.value = err.message;
    } finally {
      loading.value = false;
      activeMenuIndex.value = null;
    }
  }
};

const toggleMenu = (index) => {
  activeMenuIndex.value = activeMenuIndex.value === index ? null : index;
};

const showProduct = (product) => {
  selectedProduct.value = { ...product };
  isShowing.value = true;
  activeMenuIndex.value = null;
};
</script>

<style scoped>
/* No custom CSS needed with Tailwind */
</style>