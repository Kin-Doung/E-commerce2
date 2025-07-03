import { defineStore } from 'pinia'

export const useProductStore = defineStore('products', {
  state: () => ({
    products: [],
    loading: false,
    error: null
  }),

  actions: {
    async fetchProducts() {
      this.loading = true
      this.error = null
      
      try {
        // Mock API call - in real app, this would be an HTTP request to Laravel API
        await new Promise(resolve => setTimeout(resolve, 1000))

        this.products = [
          {
            id: '1',
            name: 'AquaPure Premium Filter',
            price: 89.99,
            originalPrice: 109.99,
            image: 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=300&h=300&fit=crop',
            rating: 4.8,
            reviews: 124,
            category: 'Filters',
            brand: 'AquaPure',
            description: 'Advanced multi-stage filtration system that removes 99.9% of contaminants while preserving essential minerals.',
            inStock: true,
            stockCount: 15
          },
          {
            id: '2',
            name: 'Crystal Clear Water Dispenser',
            price: 299.99,
            image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop',
            rating: 4.9,
            reviews: 89,
            category: 'Dispensers',
            brand: 'AquaPure',
            description: 'Premium water dispenser with hot and cold water options.',
            inStock: true,
            stockCount: 8
          },
          {
            id: '3',
            name: 'Eco-Friendly Water Bottle Set',
            price: 24.99,
            originalPrice: 34.99,
            image: 'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=300&h=300&fit=crop',
            rating: 4.7,
            reviews: 256,
            category: 'Accessories',
            brand: 'EcoFlow',
            description: 'Set of 4 BPA-free water bottles made from recycled materials.',
            inStock: true,
            stockCount: 25
          },
          {
            id: '4',
            name: 'Professional Water Purifier',
            price: 449.99,
            image: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=300&h=300&fit=crop',
            rating: 4.9,
            reviews: 67,
            category: 'Purifiers',
            brand: 'PureTech',
            description: 'Industrial-grade water purification system for home use.',
            inStock: true,
            stockCount: 5
          },
          {
            id: '5',
            name: 'Portable Water Filter Bottle',
            price: 39.99,
            image: 'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=300&h=300&fit=crop',
            rating: 4.6,
            reviews: 189,
            category: 'Bottles',
            brand: 'FilterFlow',
            description: 'Portable bottle with built-in filtration system.',
            inStock: true,
            stockCount: 30
          },
          {
            id: '6',
            name: 'Smart Water Quality Monitor',
            price: 129.99,
            image: 'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=300&h=300&fit=crop',
            rating: 4.5,
            reviews: 78,
            category: 'Accessories',
            brand: 'SmartH2O',
            description: 'WiFi-enabled water quality monitoring device.',
            inStock: true,
            stockCount: 12
          }
        ]
      } catch (error) {
        this.error = 'Failed to fetch products'
        console.error('Error fetching products:', error)
      } finally {
        this.loading = false
      }
    },

    getProductById(id) {
      return this.products.find(product => product.id === id)
    }
  }
})
