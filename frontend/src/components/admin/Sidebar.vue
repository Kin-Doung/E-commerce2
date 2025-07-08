<template>
  <aside class="w-64 bg-white shadow-md h-screen">
    <div class="p-6">
      <h1 class="text-xl font-semibold text-gray-900">AquaPure Admin</h1>
    </div>
    <nav class="mt-4">
      <ul class="space-y-1">
        <li
          v-for="item in items"
          :key="item.id"
          class="cursor-pointer flex items-center px-6 py-3 text-sm font-medium"
          :class="{
            'bg-blue-50 text-blue-600': $route.name === item.id,
            'text-gray-600 hover:bg-gray-50 hover:text-gray-900':
              $route.name !== item.id,
          }"
        >
          <router-link :to="item.path" class="flex items-center w-full">
            <component :is="iconComponent(item.icon)" class="h-5 w-5 mr-3" />
            <span>{{ item.name }}</span>
          </router-link>
        </li>
      </ul>
    </nav>
  </aside>
</template>

<script setup>
import {
  HomeIcon,
  BarChart2Icon,
  UsersIcon,
  PackageIcon,
  SettingsIcon,
  ListIcon,
  ShoppingCartIcon,
  TruckIcon,
  CreditCardIcon,
  BellIcon,
  UserIcon,
  ShieldIcon,
  HelpCircleIcon,
} from "lucide-vue-next";

defineProps({
  items: Array,
});

const iconComponent = (iconName) => {
  const icons = {
    HomeIcon,
    BarChart2Icon,
    UsersIcon,
    PackageIcon,
    SettingsIcon,
    ListIcon,
    ShoppingCartIcon,
    TruckIcon,
    CreditCardIcon,
    BellIcon,
    UserIcon,
    ShieldIcon,
    HelpCircleIcon,
  };
  return icons[iconName] || HomeIcon;
};
</script>
