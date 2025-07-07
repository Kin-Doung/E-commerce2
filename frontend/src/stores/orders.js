import { defineStore } from 'pinia'

export const useOrderStore = defineStore('orders', {
  state: () => ({
    orders: [],
    currentOrder: null,
    orderItems: [],
    loading: false,
    error: null,
    token: null // Make sure token is initialized or set from outside
  }),

  getters: {
    orderHistory: (state) => {
      return state.orders.slice().sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
    },

    totalSpent: (state) => {
      return state.orders.reduce((total, order) => total + parseFloat(order.total), 0)
    }
  },

  actions: {
    async fetchOrders() {
      this.loading = true

      try {
        const response = await fetch('/api/orders', {
          headers: {
            'Authorization': `Bearer ${this.token}`
          }
        })
        
        if (!response.ok) throw new Error('Failed to fetch orders')
        
        const data = await response.json()
        this.orders = data.orders

        return { success: true }
      } catch (error) {
        this.error = error.message
        // Mock data for development
        this.orders = [
          {
            id: 1,
            user_id: 1,
            address_id: 1,
            total: 389.97,
            status: 'completed',
            created_at: '2024-01-15T10:30:00Z',
            items: [
              {
                id: 1,
                order_id: 1,
                product_id: 1,
                quantity: 2,
                price: 89.99,
                product: { productName: 'AquaPure Premium Filter', image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=100&h=100&fit=crop' }
              },
              {
                id: 2,
                order_id: 1,
                product_id: 2,
                quantity: 1,
                price: 299.99,
                product: { productName: 'Crystal Clear Water Dispenser', image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop' }
              }
            ]
          }
        ]
        return { success: false, error: error.message }
      } finally {
        this.loading = false
      }
    },

    async fetchOrder(orderId) {
      this.loading = true

      try {
        const response = await fetch(`/api/orders/${orderId}`, {
          headers: {
            'Authorization': `Bearer ${this.token}`
          }
        })
        
        if (!response.ok) throw new Error('Order not found')
        
        const data = await response.json()
        this.currentOrder = data.order
        this.orderItems = data.order.items

        return { success: true }
      } catch (error) {
        this.error = error.message
        return { success: false, error: error.message }
      } finally {
        this.loading = false
      }
    },

    async createOrder(orderData) {
      this.loading = true

      try {
        const response = await fetch('/api/orders', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.token}`
          },
          body: JSON.stringify(orderData)
        })
        
        if (!response.ok) throw new Error('Failed to create order')
        
        const data = await response.json()
        this.orders.unshift(data.order)
        
        return { success: true, order: data.order }
      } catch (error) {
        this.error = error.message
        return { success: false, error: error.message }
      } finally {
        this.loading = false
      }
    },

    async updateOrderStatus(orderId, newStatus) {
      try {
        const response = await fetch(`/api/orders/${orderId}/status`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${this.token}`
          },
          body: JSON.stringify({ status: newStatus })
        })
        
        if (!response.ok) throw new Error('Failed to update order status')
        
        const orderIndex = this.orders.findIndex(order => order.id === orderId)
        if (orderIndex !== -1) {
          this.orders[orderIndex].status = newStatus
        }
        
        return { success: true }
      } catch (error) {
        return { success: false, error: error.message }
      }
    }
  }
})
