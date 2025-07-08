<template>
  <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center bg-gray-900 bg-opacity-50">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
      <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
        <h3 class="text-lg font-medium text-gray-900">Quick Add</h3>
        <button @click="$emit('close')" class="text-gray-400 hover:text-gray-600">
          <XIcon class="h-5 w-5" />
        </button>
      </div>
      <div class="p-6">
        <div class="space-y-4">
          <!-- Add Order Form -->
          <div>
            <h4 class="text-sm font-medium text-gray-700">Add New Order</h4>
            <div class="mt-2 space-y-3">
              <div>
                <label for="order-customer" class="block text-sm font-medium text-gray-700">Customer</label>
                <select id="order-customer" v-model="orderForm.customer_id" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
                  <option value="">Select Customer</option>
                  <option v-for="customer in customers" :key="customer.id" :value="customer.id">{{ customer.name }}</option>
                </select>
              </div>
              <div>
                <label for="order-total" class="block text-sm font-medium text-gray-700">Total</label>
                <input id="order-total" type="number" v-model="orderForm.total" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" placeholder="0.00" />
              </div>
              <button @click="addOrder" class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                <ShoppingCartIcon class="h-4 w-4 mr-2" />
                Add Order
              </button>
            </div>
          </div>
          <!-- Add Product Form -->
          <div>
            <h4 class="text-sm font-medium text-gray-700">Add New Product</h4>
            <div class="mt-2 space-y-3">
              <div>
                <label for="product-name" class="block text-sm font-medium text-gray-700">Name</label>
                <input id="product-name" type="text" v-model="productForm.name" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" placeholder="Product Name" />
              </div>
              <div>
                <label for="product-price" class="block text-sm font-medium text-gray-700">Price</label>
                <input id="product-price" type="number" v-model="productForm.price" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" placeholder="0.00" />
              </div>
              <div>
                <label for="product-stock" class="block text-sm font-medium text-gray-700">Stock</label>
                <input id="product-stock" type="number" v-model="productForm.stock" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" placeholder="0" />
              </div>
              <button @click="addProduct" class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                <PackageIcon class="h-4 w-4 mr-2" />
                Add Product
              </button>
            </div>
          </div>
          <!-- Add Customer Form -->
          <div>
            <h4 class="text-sm font-medium text-gray-700">Add New Customer</h4>
            <div class="mt-2 space-y-3">
              <div>
                <label for="customer-name" class="block text-sm font-medium text-gray-700">Name</label>
                <input id="customer-name" type="text" v-model="customerForm.name" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" placeholder="Customer Name" />
              </div>
              <div>
                <label for="customer-email" class="block text-sm font-medium text-gray-700">Email</label>
                <input id="customer-email" type="email" v-model="customerForm.email" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" placeholder="customer@example.com" />
              </div>
              <button @click="addCustomer" class="w-full flex items-center justify-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700">
                <UsersIcon class="h-4 w-4 mr-2" />
                Add Customer
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { XIcon, ShoppingCartIcon, PackageIcon, UsersIcon } from 'lucide-vue-next'

defineProps({
  show: Boolean,
  customers: Array
})

defineEmits(['close', 'add-order', 'add-product', 'add-customer'])

const orderForm = ref({
  customer_id: '',
  total: 0,
})

const productForm = ref({
  name: '',
  price: 0,
  stock: 0,
})

const customerForm = ref({
  name: '',
  email: '',
})

const addOrder = () => {
  if (orderForm.value.customer_id && orderForm.value.total > 0) {
    emit('add-order', { ...orderForm.value })
    resetOrderForm()
  }
}

const addProduct = () => {
  if (productForm.value.name && productForm.value.price > 0 && productForm.value.stock >= 0) {
    emit('add-product', { ...productForm.value })
    resetProductForm()
  }
}

const addCustomer = () => {
  if (customerForm.value.name && customerForm.value.email) {
    emit('add-customer', { ...customerForm.value })
    resetCustomerForm()
  }
}

const resetOrderForm = () => {
  orderForm.value = { customer_id: '', total: 0 }
}

const resetProductForm = () => {
  productForm.value = { name: '', price: 0, stock: 0 }
}

const resetCustomerForm = () => {
  customerForm.value = { name: '', email: '' }
}
</script>