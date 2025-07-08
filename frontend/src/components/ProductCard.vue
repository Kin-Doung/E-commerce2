<template>
  <div
    class="bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow overflow-hidden group"
  >
    <div class="relative">
      <router-link :to="`/product/${product.id}`">
        <img
          :src="fullImageUrl"
          :alt="product.name"
          class="w-full h-64 object-cover group-hover:scale-105 transition-transform duration-300"
        />
      </router-link>
      <div
        v-if="product.originalPrice"
        class="absolute top-3 left-3 bg-red-500 text-white px-2 py-1 rounded text-xs"
      >
        Save ${{
          (
            parseFloat(product.originalPrice) - parseFloat(product.price)
          ).toFixed(2)
        }}
      </div>
    </div>
    <div class="p-6">
      <div class="flex items-center justify-between mb-2">
        <span class="text-sm text-blue-600 font-medium">{{
          product.brand || "Unknown Brand"
        }}</span>
        <span class="text-sm text-gray-500">{{
          product.category || "Uncategorized"
        }}</span>
      </div>
      <router-link :to="`/product/${product.id}`">
        <h3
          class="text-lg font-semibold text-gray-900 mb-2 hover:text-blue-600 transition-colors"
        >
          {{ product.name }}
        </h3>
      </router-link>
      <div class="flex items-center mb-3">
        <div class="flex items-center">
          <StarIcon
            v-for="i in 5"
            :key="i"
            :class="`h-4 w-4 ${
              i <= Math.floor(product.rating || 0)
                ? 'text-yellow-400 fill-current'
                : 'text-gray-300'
            }`"
          />
        </div>
        <span class="text-sm text-gray-600 ml-2">
          {{ (product.rating || 0).toFixed(1) }} ({{
            product.reviews || 0
          }}
          reviews)
        </span>
      </div>
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-2">
          <span class="text-2xl font-bold text-blue-900"
            >${{ parseFloat(product.price).toFixed(2) }}</span
          >
          <span
            v-if="product.originalPrice"
            class="text-lg text-gray-500 line-through"
          >
            ${{ parseFloat(product.originalPrice).toFixed(2) }}
          </span>
        </div>
        <button
          @click="addToCart"
          class="flex items-center px-3 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-medium rounded-md transition-colors"
        >
          <ShoppingCartIcon class="h-4 w-4 mr-1" />
          Add
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from "vue";
import { StarIcon, ShoppingCartIcon } from 'lucide-vue-next'
import { useCartStore } from "../stores/cart";

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
})

const cartStore = useCartStore();

const fullImageUrl = computed(() => {
  if (props.product.image_url.startsWith("http")) {
    return props.product.image_url;
  }
  return `http://localhost:8000${props.product.image_url}`;
});

const addToCart = () => {
  cartStore.addItem({
    id: props.product.id,
    name: props.product.name,
    price: parseFloat(props.product.price),
    image: fullImageUrl.value,
    quantity: 1,
  });
};
</script>
