import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { addToast } from '../utils/toast'
import axios from 'axios'

export const useOrdersStore = defineStore('orders', () => {
  // State
  const orders = ref([])
  const selectedOrder = ref(null)
  const filters = ref({
    search: '',
    status: 'all',
    page: 1,
    perPage: 25, // Matches your pagination requirement
  })

  // Computed
  const filteredOrders = computed(() => {
    let result = orders.value
    if (filters.value.search) {
      result = result.filter(order =>
        order.customer_name.toLowerCase().includes(filters.value.search.toLowerCase()) ||
        order.id.toString().includes(filters.value.search)
      )
    }
    if (filters.value.status !== 'all') {
      result = result.filter(order => order.status === filters.value.status)
    }
    return result
  })

  const paginatedOrders = computed(() => {
    const start = (filters.value.page - 1) * filters.value.perPage
    return filteredOrders.value.slice(start, start + filters.value.perPage)
  })

  const totalPages = computed(() => Math.ceil(filteredOrders.value.length / filters.value.perPage))

  // Actions
  async function fetchOrders() {
    try {
      const response = await axios.get('http://127.0.0.1:8000/api/orders', {
        params: {
          page: filters.value.page,
          per_page: filters.value.perPage,
          search: filters.value.search,
          status: filters.value.status !== 'all' ? filters.value.status : undefined,
        },
      })
      orders.value = response.data.data
      addToast('success', 'Orders Fetched', 'Orders loaded successfully')
    } catch (error) {
      console.error('Failed to fetch orders:', error)
      addToast('error', 'Fetch Error', 'Failed to load orders')
    }
  }

  function updateFilters(newFilters) {
    filters.value = { ...filters.value, ...newFilters }
    fetchOrders()
  }

  function viewOrder(order) {
    selectedOrder.value = order
    addToast('info', 'View Order', `Viewing order #${order.id}`)
  }

  function editOrder(order) {
    selectedOrder.value = { ...order }
    addToast('info', 'Edit Order', `Editing order #${order.id}`)
  }

  async function saveOrder(order) {
    try {
      if (order.id) {
        const response = await axios.put(`http://127.0.0.1:8000/api/orders/${order.id}`, order)
        const index = orders.value.findIndex(o => o.id === order.id)
        orders.value[index] = response.data
        addToast('success', 'Order Updated', `Order #${order.id} updated`)
      } else {
        const response = await axios.post('http://127.0.0.1:8000/api/orders', order)
        orders.value.push(response.data)
        addToast('success', 'Order Created', `Order #${response.data.id} created`)
      }
      selectedOrder.value = null
    } catch (error) {
      console.error('Failed to save order:', error)
      addToast('error', 'Save Error', 'Failed to save order')
    }
  }

  function clearSelectedOrder() {
    selectedOrder.value = null
  }

  function addOrder() {
    selectedOrder.value = { id: '', customer_name: '', total: 0, status: 'pending', created_at: new Date().toISOString() }
  }

  return { orders, selectedOrder, filters, paginatedOrders, totalPages, fetchOrders, updateFilters, viewOrder, editOrder, saveOrder, clearSelectedOrder, addOrder }
})