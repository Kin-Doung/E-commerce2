<template>
  <div class="min-h-screen bg-gray-50 p-6 flex flex-col items-center">
    <h1 class="text-3xl font-extrabold text-gray-800 mb-8">
      ✨ Dynamic Product Showcase
    </h1>

    <div class="w-full max-w-2xl flex flex-col sm:flex-row gap-4 mb-8">
      <div class="relative flex-grow">
        <input type="text" v-model="searchQuery" placeholder="Search products..."
          class="w-full bg-white border border-gray-300 rounded-xl px-4 py-2 pl-10 shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500" />
        <svg class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" fill="none"
          stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        </svg>
      </div>

      <div class="relative w-full sm:w-64" ref="dropdownRef">
        <button @click="toggleDropdown"
          class="w-full bg-white border border-gray-300 rounded-xl px-4 py-2 text-left shadow-sm flex justify-between items-center focus:outline-none focus:ring-2 focus:ring-indigo-500">
          <span>{{ selectedCategory || 'Select a category' }}</span>
          <svg class="w-5 h-5 transform transition-transform duration-200" :class="{ 'rotate-180': isOpen }" fill="none"
            stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
          </svg>
        </button>

        <transition name="fade">
          <ul v-if="isOpen"
            class="absolute z-10 mt-2 w-full bg-white border border-gray-200 rounded-xl shadow-lg max-h-60 overflow-auto">
            <li v-for="(category, index) in categories" :key="index" @click="selectCategory(category)"
              class="px-4 py-2 hover:bg-gray-100 cursor-pointer text-sm">
              {{ category }}
            </li>
          </ul>
        </transition>
      </div>

      <button v-if="selectedCategory !== 'All Categories' || searchQuery" @click="clearFilters"
        class="px-4 py-2 bg-red-500 text-white rounded-xl shadow-sm hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-red-500 transition-colors duration-200">
        Clear Filters
      </button>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-full max-w-4xl">
      <div v-for="product in filteredProducts" :key="product.id"
        class="bg-white border border-gray-200 rounded-xl shadow-md p-5 flex flex-col justify-between transform transition-transform hover:scale-105 duration-200">
        <div>
          <img :src="product.image" :alt="product.name" class="w-full h-48 object-cover rounded-lg mb-4" />
          <h2 class="text-xl font-bold text-gray-900 mb-2">
            {{ product.name }}
          </h2>
          <p class="text-sm text-indigo-600 font-medium mb-3">
            {{ product.category }}
          </p>
          <div class="flex items-center mb-4">
            <span class="text-yellow-500 text-lg mr-1">
              <span v-for="n in 5" :key="n">
                <template v-if="product.rating >= n">★</template>
                <template v-else-if="product.rating > n - 1">&#9734;</template>
                <template v-else>&#9734;</template>
              </span>
            </span>
            <span class="text-gray-600 text-sm">({{ product.rating.toFixed(1) }})</span>
          </div>
          </div>
        <div class="flex justify-between items-center">
          <span class="text-xl font-semibold text-gray-800">${{ product.price.toFixed(2) }}</span>
          <button @click="showDetail(product)"
            class="bg-indigo-500 text-white px-4 py-2 rounded-lg hover:bg-indigo-600 transition-colors duration-200">
            View Detail
          </button>
        </div>
      </div>

      <div v-if="filteredProducts.length === 0" class="col-span-full text-center py-10 text-gray-600 text-lg">
        No products found matching your criteria. Try adjusting your filters!
      </div>
    </div>

    <transition name="fade">
      <div v-if="selectedProduct"
        class="fixed inset-0 bg-gray-600 bg-opacity-75 flex items-center justify-center p-4 z-50">
        <div class="bg-white rounded-xl shadow-xl max-w-md w-full p-6 relative flex flex-col">
          <button @click="closeDetail"
            class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 text-2xl font-bold leading-none">
            &times;
          </button>
          <img :src="selectedProduct.image" :alt="selectedProduct.name"
            class="w-full h-64 object-cover rounded-lg mb-4" />
          <h2 class="text-2xl font-bold text-gray-900 mb-2">{{ selectedProduct.name }}</h2>
          <p class="text-md text-indigo-600 font-medium mb-3">{{ selectedProduct.category }}</p>
          <div class="flex items-center mb-4">
            <span class="text-yellow-500 text-xl mr-2">
              <span v-for="n in 5" :key="'detail-star-' + n">
                <template v-if="selectedProduct.rating >= n">★</template>
                <template v-else-if="selectedProduct.rating > n - 1">&#9734;</template>
                <template v-else>&#9734;</template>
              </span>
            </span>
            <span class="text-gray-600 text-base">({{ selectedProduct.rating.toFixed(1) }} out of 5)</span>
          </div>
          <p class="text-gray-700 text-base mb-4">{{ selectedProduct.description }}</p>
          <div class="flex justify-between items-center mt-auto">
            <span class="text-2xl font-semibold text-gray-800">${{ selectedProduct.price.toFixed(2) }}</span>
            <button
              class="bg-indigo-500 text-white px-5 py-2 rounded-lg hover:bg-indigo-600 transition-colors duration-200">
              Add to Cart
            </button>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue';

const categories = [
  'All Categories',
  'Electronics',
  'Clothing',
  'Home & Kitchen',
  'Beauty & Personal Care',
  'Books',
];

const products = [
  {
    id: 1,
    name: 'Wireless Headphones',
    category: 'Electronics',
    price: 59.99,
    description: 'Immersive sound with comfortable earcups, featuring noise cancellation and long battery life.',
    image: 'https://picsum.photos/id/1015/400/300',
    rating: 4.5, // Added rating
  },
  {
    id: 2,
    name: 'T-shirt - Cotton Blend',
    category: 'Clothing',
    price: 19.99,
    description: 'Soft and breathable, perfect for everyday wear. Available in multiple colors and sizes.',
    image: 'https://picsum.photos/id/1018/400/300',
    rating: 3.8, // Added rating
  },
  {
    id: 3,
    name: 'High-Speed Blender',
    category: 'Home & Kitchen',
    price: 79.99,
    description: 'Powerful motor for smoothies, soups, and more. Easy to clean and durable.',
    image: 'https://picsum.photos/id/1060/400/300',
    rating: 4.9, // Added rating
  },
  {
    id: 4,
    name: 'Anti-Aging Skincare Set',
    category: 'Beauty & Personal Care',
    price: 120.00,
    description: 'Complete routine for youthful and radiant skin. Includes cleanser, serum, and moisturizer.',
    image: 'https://picsum.photos/id/400/400/300',
    rating: 4.2, // Added rating
  },
  {
    id: 5,
    name: 'Classic Novel Collection',
    category: 'Books',
    price: 35.50,
    description: 'A timeless collection of literary masterpieces, perfect for any book lover.',
    image: 'https://picsum.photos/id/237/400/300',
    rating: 4.7, // Added rating
  },
  {
    id: 6,
    name: 'USB-C Fast Charger',
    category: 'Electronics',
    price: 24.95,
    description: 'Rapid charging for all your compatible devices. Compact and travel-friendly.',
    image: 'https://picsum.photos/id/1070/400/300',
    rating: 4.0, // Added rating
  },
  {
    id: 7,
    name: 'Denim Jacket',
    category: 'Clothing',
    price: 49.99,
    description: 'A versatile and stylish addition to any wardrobe. Made from durable denim.',
    image: 'https://picsum.photos/id/10/400/300',
    rating: 3.5, // Added rating
  },
  {
    id: 8,
    name: 'Smart Coffee Maker',
    category: 'Home & Kitchen',
    price: 99.00,
    description: 'Brew your perfect coffee with smart home integration. Customizable brew strength.',
    image: 'https://picsum.photos/id/1069/400/300',
    rating: 4.6, // Added rating
  },
];

const selectedCategory = ref('All Categories');
const searchQuery = ref('');
const isOpen = ref(false);
const dropdownRef = ref(null);
const selectedProduct = ref(null);

function toggleDropdown() {
  isOpen.value = !isOpen.value;
}

function selectCategory(category) {
  selectedCategory.value = category;
  isOpen.value = false;
}

function clearFilters() {
  selectedCategory.value = 'All Categories';
  searchQuery.value = '';
}

function handleClickOutside(event) {
  if (dropdownRef.value && !dropdownRef.value.contains(event.target)) {
    isOpen.value = false;
  }
}

function showDetail(product) {
  selectedProduct.value = product;
}

function closeDetail() {
  selectedProduct.value = null;
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});

onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});

const filteredProducts = computed(() => {
  let productsToFilter = products;

  // Filter by category
  if (selectedCategory.value !== 'All Categories') {
    productsToFilter = productsToFilter.filter(
      (p) => p.category === selectedCategory.value
    );
  }

  // Filter by search query
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    productsToFilter = productsToFilter.filter(
      (p) =>
        p.name.toLowerCase().includes(query) ||
        p.description.toLowerCase().includes(query)
    );
  }

  return productsToFilter;
});
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>