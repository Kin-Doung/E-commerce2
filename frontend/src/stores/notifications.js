import { defineStore } from 'pinia'

export const useNotificationStore = defineStore('notifications', {
  state: () => ({
    notifications: [],
    unreadCount: 0,
    loading: false,
    error: null,
    token: null // Make sure to set this somewhere in your app
  }),

  getters: {
    unreadNotifications: (state) => {
      return state.notifications.filter(notification => !notification.is_read)
    },

    recentNotifications: (state) => {
      return state.notifications.slice(0, 5)
    }
  },

  actions: {
    async fetchNotifications() {
      this.loading = true

      try {
        const response = await fetch('/api/notifications', {
          headers: {
            'Authorization': `Bearer ${this.token}`
          }
        })
        
        if (!response.ok) throw new Error('Failed to fetch notifications')
        
        const data = await response.json()
        this.notifications = data.notifications
        this.unreadCount = data.unread_count

        return { success: true }
      } catch (error) {
        this.error = error.message
        // Mock data for development
        this.notifications = [
          {
            id: 1,
            user_id: 1,
            message: 'Your order #12345 has been shipped!',
            sent_date: '2024-01-15T10:30:00Z',
            is_read: false
          },
          {
            id: 2,
            user_id: 1,
            message: 'New products available in Water Filters category',
            sent_date: '2024-01-14T15:20:00Z',
            is_read: true
          }
        ]
        this.unreadCount = this.notifications.filter(n => !n.is_read).length
        return { success: false, error: error.message }
      } finally {
        this.loading = false
      }
    },

    async markAsRead(notificationId) {
      try {
        const response = await fetch(`/api/notifications/${notificationId}/read`, {
          method: 'PUT',
          headers: {
            'Authorization': `Bearer ${this.token}`
          }
        })
        
        if (!response.ok) throw new Error('Failed to mark notification as read')
        
        const notification = this.notifications.find(n => n.id === notificationId)
        if (notification && !notification.is_read) {
          notification.is_read = true
          this.unreadCount--
        }

        return { success: true }
      } catch (error) {
        return { success: false, error: error.message }
      }
    },

    async markAllAsRead() {
      try {
        const response = await fetch('/api/notifications/mark-all-read', {
          method: 'PUT',
          headers: {
            'Authorization': `Bearer ${this.token}`
          }
        })
        
        if (!response.ok) throw new Error('Failed to mark all notifications as read')
        
        this.notifications.forEach(notification => {
          notification.is_read = true
        })
        this.unreadCount = 0

        return { success: true }
      } catch (error) {
        return { success: false, error: error.message }
      }
    },

    addNotification(notification) {
      this.notifications.unshift(notification)
      if (!notification.is_read) {
        this.unreadCount++
      }
    }
  }
})
