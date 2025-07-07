<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-blue-900 mb-4">Shop Water Products</h1>
      <p class="text-gray-600">Discover our complete range of premium water solutions</p>
    </div>

    <div class="flex flex-col lg:flex-row gap-8">
      <!-- Filters Sidebar -->
      <div :class="`lg:w-64 ${showFilters ? 'block' : 'hidden lg:block'}`">
        <div class="bg-white p-6 rounded-lg shadow-md">
          <h3 class="text-lg font-semibold text-blue-900 mb-4">Filters</h3>

          <!-- Categories -->
          <div class="mb-6">
            <h4 class="font-medium text-gray-900 mb-3">Categories</h4>
            <div class="space-y-2">
              <div v-for="category in categories" :key="category" class="flex items-center space-x-2">
                <input
                  type="checkbox"
                  :id="`category-${category}`"
                  :value="category"
                  v-model="selectedCategories"
                  class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                  :aria-label="`Filter by category ${category}`"
                />
                <label :for="`category-${category}`" class="text-sm">{{ category }}</label>
              </div>
            </div>
          </div>

          <!-- Brands -->
          <div class="mb-6">
            <h4 class="font-medium text-gray-900 mb-3">Brands</h4>
            <div class="space-y-2">
              <div v-for="brand in brands" :key="brand" class="flex items-center space-x-2">
                <input
                  type="checkbox"
                  :id="`brand-${brand}`"
                  :value="brand"
                  v-model="selectedBrands"
                  class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                  :aria-label="`Filter by brand ${brand}`"
                />
                <label :for="`brand-${brand}`" class="text-sm">{{ brand }}</label>
              </div>
            </div>
          </div>

          <!-- Price Range -->
          <div class="mb-6">
            <h4 class="font-medium text-gray-900 mb-3">Price Range</h4>
            <div class="px-2">
              <input
                type="range"
                min="0"
                max="500"
                v-model.number="priceRange[0]"
                class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
              />
              <input
                type="range"
                min="0"
                max="500"
                v-model.number="priceRange[1]"
                class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
              />
              <div class="flex justify-between text-sm text-gray-600 mt-2">
                <span>${{ priceRange[0] }}</span>
                <span>${{ priceRange[1] }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Products -->
      <div class="flex-1">
        <!-- Toolbar -->
        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-6 gap-4">
          <div class="flex items-center gap-4">
            <button
              @click="showFilters = !showFilters"
              class="lg:hidden px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50 flex items-center"
              aria-label="Toggle filters"
            >
              <FilterIcon class="h-4 w-4 mr-2" />
              Filters
            </button>
            <span class="text-gray-600">{{ filteredProducts.length }} products found</span>
          </div>

          <div class="flex items-center gap-4">
            <select
              v-model="sortBy"
              class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="featured">Featured</option>
              <option value="price-low">Price: Low to High</option>
              <option value="price-high">Price: High to Low</option>
              <option value="rating">Highest Rated</option>
              <option value="name">Name A-Z</option>
            </select>

            <div class="flex border rounded-md">
              <button
                @click="viewMode = 'grid'"
                :class="`px-3 py-2 ${viewMode === 'grid' ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'}`"
                aria-label="Grid view"
              >
                <GridIcon class="h-4 w-4" />
              </button>
              <button
                @click="viewMode = 'list'"
                :class="`px-3 py-2 ${viewMode === 'list' ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'}`"
                aria-label="List view"
              >
                <ListIcon class="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>

        <!-- Products Grid -->
        <div v-if="loading" class="text-center py-12">
          <p class="text-gray-500 text-lg">Loading products...</p>
        </div>
        <div v-else-if="error" class="text-center py-12">
          <p class="text-red-500 text-lg">Error: {{ error }}</p>
          <button
            @click="fetchData"
            class="mt-4 px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50"
          >
            Retry
          </button>
        </div>
        <div v-else-if="sortedProducts.length === 0" class="text-center py-12">
          <p class="text-gray-500 text-lg">No products found matching your criteria.</p>
          <button
            @click="clearFilters"
            class="mt-4 px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50"
          >
            Clear Filters
          </button>
        </div>
        <div v-else :class="`grid gap-6 ${viewMode === 'grid' ? 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-3' : 'grid-cols-1'}`">
          <ProductCard v-for="product in sortedProducts" :key="product.id" :product="product" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onMounted } from 'vue';
import ProductCard from '@/components/ProductCard.vue';
import { FilterIcon, GridIcon, ListIcon } from 'lucide-vue-next';

const products = ref([]);
const loading = ref(true);
const error = ref(null);

const fetchData = async () => {
  try {
    const response = await fetch('http://localhost:8000/api/products');
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    const data = await response.json();
    console.log('API response:', data);
    products.value = data;
  } catch (err) {
    error.value = err.message;
    console.error('Fetch error:', err);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  fetchData();
});

// Filter states
const selectedCategories = ref([]);
const selectedBrands = ref([]);
const priceRange = ref([0, 500]);
const sortBy = ref('featured');
const viewMode = ref('grid');
const showFilters = ref(false);

// Derive unique categories and brands
const categories = computed(() => {
  const set = new Set(products.value.map((p) => p.category).filter(Boolean));
  return Array.from(set);
});

const brands = computed(() => {
  const set = new Set(products.value.map((p) => p.brand).filter(Boolean));
  return Array.from(set);
});

// Filter products
const filteredProducts = computed(() => {
  return products.value.filter((product) => {
    const inCategory = selectedCategories.value.length === 0 || selectedCategories.value.includes(product.category);
    const inBrand = selectedBrands.value.length === 0 || selectedBrands.value.includes(product.brand);
    const price = parseFloat(product.price);
    const inPrice = price >= priceRange.value[0] && price <= priceRange.value[1];
    return inCategory && inBrand && inPrice;
  });
});

// Sort products
const sortedProducts = computed(() => {
  let sorted = [...filteredProducts.value];
  switch (sortBy.value) {
    case 'price-low':
      sorted.sort((a, b) => parseFloat(a.price) - parseFloat(b.price));
      break;
    case 'price-high':
      sorted.sort((a, b) => parseFloat(b.price) - parseFloat(a.price));
      break;
    case 'rating':
      sorted.sort((a, b) => (b.rating || 0) - (a.rating || 0));
      break;
    case 'name':
      sorted.sort((a, b) => a.name.localeCompare(b.name));
      break;
  }
  return sorted;
});

function clearFilters() {
  selectedCategories.value = [];
  selectedBrands.value = [];
  priceRange.value = [0, 500];
  sortBy.value = 'featured';
  viewMode.value = 'grid';
}

watch(priceRange, ([min, max]) => {
  if (min > max) {
    priceRange.value = [max, min];
  }
});

watch(sortedProducts, (newProducts) => {
  console.log('Sorted products:', newProducts);
});
</script>