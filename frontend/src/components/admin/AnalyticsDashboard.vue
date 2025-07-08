<template>
  <div class="max-w-7xl mx-auto p-8">
    <!-- Heading -->
    <div class="mb-8">
      <h2 class="text-3xl font-bold text-gray-800">Analytics</h2>
      <p class="mt-2 text-gray-600">
        View detailed analytics for AquaPure. Track sales, customer trends, and more.
      </p>
    </div>

    <!-- Analytics Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
      <!-- Sales This Month -->
      <div class="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-700">Sales This Month</h3>
            <p class="mt-1 text-3xl font-bold text-gray-900">$12,500</p>
          </div>
          <div class="text-green-500">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M3 17l6-6 4 4 8-8" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Customer Growth -->
      <div class="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-700">Customer Growth</h3>
            <p class="mt-1 text-3xl font-bold text-gray-900">+15%</p>
          </div>
          <div class="text-blue-500">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M5 12h14M12 5l7 7-7 7" />
            </svg>
          </div>
        </div>
      </div>

      <!-- Top Product -->
      <div class="p-6 bg-white rounded-lg shadow hover:shadow-md transition">
        <div class="flex items-center justify-between">
          <div>
            <h3 class="text-lg font-semibold text-gray-700">Top Product</h3>
            <p class="mt-1 text-2xl font-bold text-gray-900">AquaFilter Pro</p>
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
// Static demo — no JS needed yet
</script>
