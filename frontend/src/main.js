import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css' // Import CSS for toast styling

import App from './App.vue'
import router from './router'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(toast, {
  autoClose: 3000,
  position: 'top-right',
  transition: 'bounce',
})

app.mount('#app')