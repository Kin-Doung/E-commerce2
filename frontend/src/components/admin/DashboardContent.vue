<template>
  <div class="max-w-7xl mx-auto p-8">
    <!-- Heading -->
    <div class="mb-8">
      <h2 class="text-3xl font-bold text-gray-800">Admin Dashboard</h2>
      <p class="mt-2 text-gray-600">
        Welcome to the AquaPure Admin Dashboard. Here you can overview key metrics and manage your admin tasks.
      </p>
    </div>

    <!-- Metrics Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
      <!-- Total Orders Card -->
      <div class="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-700">Total Orders</h3>
            <p class="mt-1 text-3xl font-bold text-gray-900">150</p>
          </div>
          <div class="text-green-500">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M3 3h18M9 3v18M15 3v18M3 9h18M3 15h18" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Active Customers Card -->
      <div class="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-700">Active Customers</h3>
            <p class="mt-1 text-3xl font-bold text-gray-900">200</p>
          </div>
          <div class="text-blue-500">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M17 20h5v-2a3 3 0 00-3-3h-4.28a2 2 0 01-1.42-.59l-2.58-2.59A2 2 0 0010 11H7a5 5 0 00-5 5v4h5" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Pending Tasks Card -->
      <div class="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-700">Pending Tasks</h3>
            <p class="mt-1 text-3xl font-bold text-gray-900">5</p>
          </div>
          <div class="text-yellow-500">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// no logic yet — static dashboard metrics
</script>
