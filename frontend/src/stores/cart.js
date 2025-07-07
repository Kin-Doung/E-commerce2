import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: []
  }),

  getters: {
    itemCount: (state) => {
      return state.items.reduce((sum, item) => sum + item.quantity, 0)
    },
    
    total: (state) => {
      return state.items.reduce((sum, item) => sum + (item.price * item.quantity), 0)
    }
  },

  actions: {
    addItem(newItem) {
      const existingItem = this.items.find(item => item.id === newItem.id)
      
      if (existingItem) {
        existingItem.quantity += newItem.quantity
      } else {
        this.items.push({ ...newItem })
      }
      
      this.saveCart()
    },

    removeItem(id) {
      this.items = this.items.filter(item => item.id !== id)
      this.saveCart()
    },

    updateQuantity(id, quantity) {
      if (quantity <= 0) {
        this.removeItem(id)
        return
      }
      
      const item = this.items.find(item => item.id === id)
      if (item) {
        item.quantity = quantity
        this.saveCart()
      }
    },

    clearCart() {
      this.items = []
      this.saveCart()
    },

    saveCart() {
      localStorage.setItem('cart', JSON.stringify(this.items))
    },

    loadCart() {
      const savedCart = localStorage.getItem('cart')
      if (savedCart) {
        this.items = JSON.parse(savedCart)
      }
    }
  }
})