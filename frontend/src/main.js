import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { toast as originalToast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css' // Import CSS for toast styling

import App from './App.vue'
import router from './router'
import { useAuthStore } from './stores/auth'

const app = createApp(App)

// Wrap the toast function to filter out object messages
function safeToast(message, options) {
  let safeMessage = message
  if (typeof message !== 'string') {
    try {
      safeMessage = JSON.stringify(message)
    } catch {
      safeMessage = String(message)
    }
  }
  if (!safeMessage || safeMessage === '[object Object]') {
    return
  }
  return originalToast(safeMessage, options)
}

// Replace the toast export with the safe wrapper
app.config.globalProperties.$toast = safeToast

app.use(createPinia())
app.use(router)
// Use the original toast plugin but override global $toast
/* Toast plugin disabled to remove unwanted "[object Object]" alerts
app.use(originalToast, {
  autoClose: 3000,
  position: 'top-right',
  transition: 'bounce',
})
*/

// Restore auth state from localStorage on app startup
const authStore = useAuthStore()
authStore.checkAuth()

app.mount('#app')
