<template>
  <div class="max-w-2xl mx-auto p-6 border border-gray-200 rounded-lg shadow-sm">
    <h2 class="text-2xl font-bold text-gray-800 text-center mb-6">Admin Settings</h2>
    <form @submit.prevent="saveSettings" class="space-y-6">
      <div class="flex flex-col">
        <label for="siteName" class="mb-2 font-semibold text-gray-700">Site Name</label>
        <input
          id="siteName"
          v-model="settings.siteName"
          type="text"
          placeholder="Enter site name"
          class="p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-green-500"
        />
      </div>
      <div class="flex items-center">
        <input
          id="maintenanceMode"
          v-model="settings.maintenanceMode"
          type="checkbox"
          class="h-5 w-5 text-green-600 border-gray-300 rounded focus:ring-green-500"
        />
        <label for="maintenanceMode" class="ml-2 font-semibold text-gray-700">Maintenance Mode</label>
      </div>
      <button
        type="submit"
        :disabled="isSaving"
        class="w-full bg-green-600 text-white py-2 px-4 rounded-md hover:bg-green-700 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
      >
        Save Settings
      </button>
    </form>
    <p v-if="message" class="mt-4 text-center text-green-600">{{ message }}</p>
  </div>
</template>

<script>
import { reactive, ref } from 'vue';

export default {
  name: 'AdminSetting',
  setup() {
    const settings = reactive({
      siteName: '',
      maintenanceMode: false,
    });

    const message = ref('');
    const isSaving = ref(false);

    const saveSettings = () => {
      isSaving.value = true;
      setTimeout(() => {
        console.log('Settings saved:', settings);
        message.value = 'Settings saved successfully!';
        isSaving.value = false;
      }, 1000);
    };

    return {
      settings,
      message,
      isSaving,
      saveSettings,
    };
  },
};
</script>

<style scoped>
/* No custom CSS needed with Tailwind */
</style>