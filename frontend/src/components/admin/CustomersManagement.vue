<template>
  <div class="p-4 bg-white rounded shadow">
    <h2 class="text-2xl font-bold text-gray-900">Customers</h2>
    <p class="mt-2 text-gray-600">Manage your customer base.</p>

    <!-- Add Customer Form -->
    <div class="mt-4">
      <h3 class="text-lg font-semibold">Add New Customer</h3>
      <form @submit.prevent="addCustomer" class="mt-2 space-y-4">
        <input v-model="newCustomer.name" placeholder="Name" class="w-full p-2 border rounded" />
        <input v-model="newCustomer.email" placeholder="Email" class="w-full p-2 border rounded" />
        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Add Customer</button>
      </form>
    </div>

    <!-- Customer List -->
    <div class="mt-6">
      <h3 class="text-lg font-semibold">Customer List</h3>
      <ul class="mt-2 space-y-2">
        <li v-for="customer in customers" :key="customer.id" class="flex items-center justify-between p-2 bg-gray-50 rounded">
          <span>{{ customer.name }} - {{ customer.email }}</span>
          <div>
            <button @click="editCustomer(customer)" class="mr-2 px-2 py-1 bg-yellow-500 text-white rounded hover:bg-yellow-600">Edit</button>
            <button @click="deleteCustomer(customer.id)" class="px-2 py-1 bg-red-500 text-white rounded hover:bg-red-600">Delete</button>
          </div>
        </li>
      </ul>
    </div>

    <!-- Edit Modal -->
    <div v-if="isEditing" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center">
      <div class="bg-white p-4 rounded shadow-lg w-1/3">
        <h3 class="text-lg font-semibold">Edit Customer</h3>
        <form @submit.prevent="saveCustomer" class="mt-2 space-y-4">
          <input v-model="editedCustomer.name" placeholder="Name" class="w-full p-2 border rounded" />
          <input v-model="editedCustomer.email" placeholder="Email" class="w-full p-2 border rounded" />
          <div class="flex justify-end space-x-2">
            <button @click="cancelEdit" class="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600">Cancel</button>
            <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">Save</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// Reactive state
const customers = ref([
  { id: 1, name: 'John Doe', email: 'john@example.com' },
  { id: 2, name: 'Jane Smith', email: 'jane@example.com' },
  { id: 3, name: 'Mike Johnson', email: 'mike@example.com' },
])
const newCustomer = ref({ name: '', email: '' })
const isEditing = ref(false)
const editedCustomer = ref({ id: null, name: '', email: '' })

// CRUD Functions
const addCustomer = () => {
  if (newCustomer.value.name && newCustomer.value.email) {
    const id = customers.value.length ? Math.max(...customers.value.map(c => c.id)) + 1 : 1
    customers.value.push({ id, ...newCustomer.value })
    newCustomer.value = { name: '', email: '' } // Reset form
    // TODO: Replace with API call (e.g., fetch('/api/customers', { method: 'POST', body: JSON.stringify(newCustomer.value) }))
  }
}

const editCustomer = (customer) => {
  isEditing.value = true
  editedCustomer.value = { ...customer }
}

const saveCustomer = () => {
  const index = customers.value.findIndex(c => c.id === editedCustomer.value.id)
  if (index !== -1) {
    customers.value[index] = { ...editedCustomer.value }
    isEditing.value = false
    // TODO: Replace with API call (e.g., fetch(`/api/customers/${editedCustomer.value.id}`, { method: 'PUT', body: JSON.stringify(editedCustomer.value) }))
  }
}

const cancelEdit = () => {
  isEditing.value = false
  editedCustomer.value = { id: null, name: '', email: '' }
}

const deleteCustomer = (id) => {
  customers.value = customers.value.filter(c => c.id !== id)
  // TODO: Replace with API call (e.g., fetch(`/api/customers/${id}`, { method: 'DELETE' }))
}
</script>