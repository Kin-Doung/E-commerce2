
<template>
  <div class="bg-white shadow rounded-lg p-6">
    <h2 class="text-lg font-medium text-gray-900">Order #{{ orderId }}</h2>
    <div v-if="order" class="mt-4">
      <p class="text-sm text-gray-500">Customer: {{ order.customer?.name }}</p>
      <p class="text-sm text-gray-500">Email: {{ order.customer?.email }}</p>
      <p class="text-sm text-gray-500">Total: ${{ order.total?.toFixed(2) }}</p>
      <p class="text-sm text-gray-500">Status: {{ order.status }}</p>
      <p class="text-sm text-gray-500">Date: {{ formatDate(order.created_at) }}</p>
    </div>
    <div v-else class="mt-4 text-sm text-gray-500">
      Loading order details...
    </div>
    <button
      @click="$router.push('/admin/orders')"
      class="mt-4 inline-flex items-center px-3 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
    >
      Back to Orders
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const orderId = route.params.id
const order = ref(null)

const formatDate = (date) => {
  return new Date(date).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
}

onMounted(async () => {
  try {
    const response = await fetch(`http://127.0.0.1:8000/api/orders/${orderId}`)
    if (!response.ok) throw new Error('Failed to fetch order')
    order.value = await response.json()
  } catch (error) {
    console.error('Failed to fetch order:', error)
  }
})
</script>
```