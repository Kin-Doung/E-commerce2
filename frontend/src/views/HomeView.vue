<template>
  <div>
    <!-- Hero Section -->
    <section class="relative bg-gradient-to-br from-blue-50 to-white py-20 lg:py-32">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h1 class="text-4xl lg:text-6xl font-bold text-blue-900 mb-6">
              Pure Water,
              <span class="text-blue-600"> Pure Life</span>
            </h1>
            <p class="text-xl text-gray-600 mb-8">
              Discover our premium collection of water solutions designed for clean, healthy hydration. From advanced
              filtration systems to eco-friendly accessories.
            </p>
            <div class="flex flex-col sm:flex-row gap-4 mb-12">
              <router-link to="/shop">
                <button class="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md transition-colors">
                  Shop Now
                </button>
              </router-link>
              <router-link to="/about">
                <button class="px-6 py-3 border border-gray-300 text-gray-700 hover:bg-gray-50 font-medium rounded-md transition-colors">
                  Learn More
                </button>
              </router-link>
            </div>
            <div class="flex items-center space-x-8">
              <div class="flex items-center space-x-2">
                <DropletIcon class="h-6 w-6 text-blue-600" />
                <span class="text-sm text-gray-600">Premium Quality</span>
              </div>
              <div class="flex items-center space-x-2">
                <LeafIcon class="h-6 w-6 text-green-600" />
                <span class="text-sm text-gray-600">Eco-Friendly</span>
              </div>
              <div class="flex items-center space-x-2">
                <ShieldIcon class="h-6 w-6 text-blue-600" />
                <span class="text-sm text-gray-600">Certified Safe</span>
              </div>
            </div>
          </div>
          <div class="relative">
            <img
              src="https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=500&h=600&fit=crop"
              alt="Premium water products"
              class="w-full h-auto rounded-lg shadow-2xl"
            />
            <div class="absolute -bottom-6 -left-6 bg-white p-6 rounded-lg shadow-lg">
              <div class="text-2xl font-bold text-blue-900">99.9%</div>
              <div class="text-sm text-gray-600">Purity Guaranteed</div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="py-20 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl lg:text-4xl font-bold text-blue-900 mb-4">Why Choose AquaPure?</h2>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto">
            We're committed to providing the highest quality water solutions with exceptional service and environmental
            responsibility.
          </p>
        </div>
        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          <div v-for="(feature, index) in features" :key="index" class="text-center p-6 rounded-lg hover:shadow-lg transition-shadow">
            <div class="inline-flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full mb-6">
              <component :is="feature.icon" class="h-8 w-8 text-blue-600" />
            </div>
            <h3 class="text-xl font-semibold text-blue-900 mb-4">{{ feature.title }}</h3>
            <p class="text-gray-600">{{ feature.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Featured Products -->
    <section class="py-20 bg-gray-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center mb-16">
          <h2 class="text-3xl lg:text-4xl font-bold text-blue-900 mb-4">Featured Products</h2>
          <p class="text-xl text-gray-600 max-w-3xl mx-auto">
            Discover our most popular water solutions, carefully selected for quality, performance, and customer
            satisfaction.
          </p>
        </div>
        <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8 mb-12">
          <ProductCard v-for="product in featuredProducts" :key="product.id" :product="product" />
        </div>
        <div class="text-center">
          <router-link to="/shop">
            <button class="px-6 py-3 border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white font-medium rounded-md transition-colors">
              View All Products
            </button>
          </router-link>
        </div>
      </div>
    </section>

    <!-- Newsletter -->
    <section class="bg-blue-600 py-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h2 class="text-3xl font-bold text-white mb-4">Stay Hydrated with Our Newsletter</h2>
        <p class="text-blue-100 text-lg mb-8 max-w-2xl mx-auto">
          Get the latest updates on new products, health tips, and exclusive offers delivered to your inbox.
        </p>
        <div class="flex flex-col sm:flex-row max-w-md mx-auto gap-4">
          <input 
            type="email" 
            placeholder="Enter your email" 
            class="flex-1 px-4 py-3 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-300"
            v-model="email"
          />
          <button 
            @click="subscribeNewsletter"
            class="px-6 py-3 bg-white text-blue-600 hover:bg-gray-100 font-medium rounded-md transition-colors"
          >
            Subscribe
          </button>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { DropletIcon, LeafIcon, ShieldIcon, FilterIcon, RecycleIcon, AwardIcon, TruckIcon } from 'lucide-vue-next'
import ProductCard from '../components/ProductCard.vue'
import { useProductStore } from '../stores/products'

const productStore = useProductStore()
const email = ref('')

const features = [
  {
    icon: FilterIcon,
    title: "Advanced Filtration",
    description: "State-of-the-art filtration technology removes 99.9% of contaminants while preserving essential minerals.",
  },
  {
    icon: RecycleIcon,
    title: "Eco-Friendly",
    description: "Sustainable packaging and products designed to reduce environmental impact and promote green living.",
  },
  {
    icon: AwardIcon,
    title: "Certified Quality",
    description: "All products meet international quality standards and are certified by leading health organizations.",
  },
  {
    icon: TruckIcon,
    title: "Free Delivery",
    description: "Fast, reliable delivery service with free shipping on orders over $50 to your doorstep.",
  },
]

const featuredProducts = ref([])

const subscribeNewsletter = () => {
  if (email.value) {
    alert('Thank you for subscribing!')
    email.value = ''
  }
}

onMounted(async () => {
  await productStore.fetchProducts()
  featuredProducts.value = productStore.products.slice(0, 4)
})
</script>
