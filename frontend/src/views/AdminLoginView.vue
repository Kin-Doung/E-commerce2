<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-blue-100 flex items-center justify-center p-4">
    <div class="w-full max-w-md">
      <!-- Header -->
      <div class="text-center mb-8">
        <div class="flex items-center justify-center space-x-2 mb-4">
          <DropletIcon class="h-10 w-10 text-blue-600" />
          <span class="text-3xl font-bold text-blue-900">AquaPure</span>
        </div>
        <h1 class="text-2xl font-bold text-blue-900">Welcome Back</h1>
        <p class="text-gray-600">Sign in to your account</p>
      </div>

      <!-- Login Form -->
      <div class="bg-white rounded-lg shadow-xl p-8">
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div v-if="error" class="p-3 bg-red-50 border border-red-200 rounded-md">
            <p class="text-red-600 text-sm">{{ error }}</p>
          </div>

          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
            <input
              id="email"
              type="email"
              v-model="formData.email"
              placeholder="Enter your email"
              required
              class="w-full px-3 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
            <div class="relative">
              <input
                id="password"
                :type="showPassword ? 'text' : 'password'"
                v-model="formData.password"
                placeholder="Enter your password"
                required
                class="w-full px-3 py-3 pr-10 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
              >
                <EyeOffIcon v-if="showPassword" class="h-4 w-4" />
                <EyeIcon v-else class="h-4 w-4" />
              </button>
            </div>
          </div>

          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-2">
              <input
                id="rememberMe"
                type="checkbox"
                v-model="formData.rememberMe"
                class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
              />
              <label for="rememberMe" class="text-sm text-gray-600">Remember me</label>
            </div>
            <button type="button" class="text-sm text-blue-600 hover:text-blue-700 font-medium">
              Forgot password?
            </button>
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md transition-colors disabled:opacity-50"
          >
            <div v-if="loading" class="flex items-center justify-center space-x-2">
              <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              <span>Signing in...</span>
            </div>
            <span v-else>Sign In</span>
          </button>
        </form>

        <!-- Demo Credentials -->
        <div class="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
          <h3 class="text-sm font-medium text-blue-900 mb-2">Demo Credentials:</h3>
          <div class="space-y-2">
            <div class="text-xs text-blue-700">
              <p><strong>Regular User:</strong></p>
              <p>Email: user@aquapure.com</p>
              <p>Password: user123</p>
            </div>
            <div class="text-xs text-blue-700">
              <p><strong>Admin User:</strong></p>
              <p>Email: admin@aquapure.com</p>
              <p>Password: admin123</p>
            </div>
          </div>
          <div class="mt-3 flex space-x-2">
            <button
              @click="fillUserCredentials"
              class="px-3 py-1 bg-blue-100 text-blue-700 text-xs rounded hover:bg-blue-200"
            >
              Use User Demo
            </button>
            <button
              @click="fillAdminCredentials"
              class="px-3 py-1 bg-green-100 text-green-700 text-xs rounded hover:bg-green-200"
            >
              Use Admin Demo
            </button>
          </div>
        </div>

        <!-- Register Link -->
        <div class="mt-6 text-center">
          <p class="text-sm text-gray-600">
            Don't have an account?
            <router-link to="/register" class="text-blue-600 hover:text-blue-700 font-medium">
              Sign up here
            </router-link>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { DropletIcon, EyeIcon, EyeOffIcon } from 'lucide-vue-next'
import { useAuthStore } from '../stores/auth'
import { useNotificationStore } from '../stores/notifications.js'

const router = useRouter()
const authStore = useAuthStore()
const notificationStore = useNotificationStore()

const formData = ref({
  email: '',
  password: '',
  rememberMe: false
})

const showPassword = ref(false)
const loading = ref(false)
const error = ref('')

const handleSubmit = async () => {
  loading.value = true
  error.value = ''

  try {
    // Mock authentication - replace with actual API call
    await new Promise(resolve => setTimeout(resolve, 1000))

    // Mock user data based on email
    let userData = null
    if (formData.value.email === 'admin@aquapure.com' && formData.value.password === 'admin123') {
      userData = {
        id: 1,
        email: 'admin@aquapure.com',
        role: 'admin',
        name: 'Admin User'
      }
    } else if (formData.value.email === 'user@aquapure.com' && formData.value.password === 'user123') {
      userData = {
        id: 2,
        email: 'user@aquapure.com',
        role: 'user',
        name: 'Regular User'
      }
    } else {
      throw new Error('Invalid credentials')
    }

    // Set user data in auth store
    authStore.user = userData
    authStore.token = 'mock_token_' + Date.now()
    authStore.isAuthenticated = true

    // Store in localStorage
    localStorage.setItem('auth_token', authStore.token)
    localStorage.setItem('user', JSON.stringify(userData))

    // Add success notification
    notificationStore.addNotification({
      id: Date.now(),
      message: `Welcome back, ${userData.name}!`,
      sent_date: new Date().toISOString(),
      is_read: false
    })

    // Redirect based on role
    if (userData.role === 'admin') {
      router.push('/admin/dashboard')
    } else {
      router.push('/')
    }

  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const fillUserCredentials = () => {
  formData.value.email = 'user@aquapure.com'
  formData.value.password = 'user123'
}

const fillAdminCredentials = () => {
  formData.value.email = 'admin@aquapure.com'
  formData.value.password = 'admin123'
}
</script>
