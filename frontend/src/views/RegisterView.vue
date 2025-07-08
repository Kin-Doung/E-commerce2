<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-blue-100 flex items-center justify-center p-4">
    <div class="w-full max-w-md">
      <!-- Header -->
      <div class="text-center mb-8">
        <div class="flex items-center justify-center space-x-2 mb-4">
          <DropletIcon class="h-10 w-10 text-blue-600" />
          <span class="text-3xl font-bold text-blue-900">AquaPure</span>
        </div>
        <h1 class="text-2xl font-bold text-blue-900">Create Account</h1>
        <p class="text-gray-600">Join us for clean, healthy hydration</p>
      </div>

      <!-- Register Form -->
      <div class="bg-white rounded-lg shadow-xl p-8">
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div v-if="error" class="p-3 bg-red-50 border border-red-200 rounded-md">
            <p class="text-red-600 text-sm">{{ error }}</p>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div>
              <label for="firstName" class="block text-sm font-medium text-gray-700 mb-2">First Name</label>
              <input
                id="firstName"
                type="text"
                v-model="formData.firstName"
                placeholder="First name"
                required
                class="w-full px-3 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label for="lastName" class="block text-sm font-medium text-gray-700 mb-2">Last Name</label>
              <input
                id="lastName"
                type="text"
                v-model="formData.lastName"
                placeholder="Last name"
                required
                class="w-full px-3 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
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
                placeholder="Create a password"
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

          <div>
            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Confirm Password</label>
            <input
              id="confirmPassword"
              type="password"
              v-model="formData.confirmPassword"
              placeholder="Confirm your password"
              required
              class="w-full px-3 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>

          <div class="flex items-center space-x-2">
            <input
              id="agreeTerms"
              type="checkbox"
              v-model="formData.agreeTerms"
              required
              class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
            />
            <label for="agreeTerms" class="text-sm text-gray-600">
              I agree to the <a href="#" class="text-blue-600 hover:text-blue-700">Terms of Service</a> and 
              <a href="#" class="text-blue-600 hover:text-blue-700">Privacy Policy</a>
            </label>
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md transition-colors disabled:opacity-50"
          >
            <div v-if="loading" class="flex items-center justify-center space-x-2">
              <div class="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
              <span>Creating account...</span>
            </div>
            <span v-else>Create Account</span>
          </button>
        </form>

        <!-- Login Link -->
        <div class="mt-6 text-center">
          <p class="text-sm text-gray-600">
            Already have an account?
            <router-link to="/login" class="text-blue-600 hover:text-blue-700 font-medium">
              Sign in here
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
import { useNotificationStore } from '../stores/notifications'

const router = useRouter()
const authStore = useAuthStore()
const notificationStore = useNotificationStore()

const formData = ref({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  confirmPassword: '',
  agreeTerms: false
})

const showPassword = ref(false)
const loading = ref(false)
const error = ref('')

const handleSubmit = async () => {
  if (formData.value.password !== formData.value.confirmPassword) {
    error.value = 'Passwords do not match'
    return
  }

  if (formData.value.password.length < 6) {
    error.value = 'Password must be at least 6 characters'
    return
  }

  loading.value = true
  error.value = ''

  try {
    // Mock registration - replace with actual API call
    try {
      const response = await authStore.register({
        name: `${formData.value.firstName} ${formData.value.lastName}`,
        email: formData.value.email,
        password: formData.value.password,
        password_confirmation: formData.value.confirmPassword,
        role: 'user'
      })

      if (!response.success) {
        throw new Error(response.error || 'Registration failed')
      }

      // Add success notification
      notificationStore.addNotification({
        id: Date.now(),
        message: `Welcome to AquaPure, ${authStore.user.name}!`,
        sent_date: new Date().toISOString(),
        is_read: false
      })

      router.push('/')
    } catch (err) {
      error.value = err.message
    }

  } catch (err) {
    error.value = 'Registration failed. Please try again.'
  } finally {
    loading.value = false
  }
}
</script>
