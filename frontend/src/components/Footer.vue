<template>
  <footer class="bg-blue-900 text-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="grid md:grid-cols-4 gap-8">
        <div>
          <router-link to="/" class="flex items-center space-x-2 mb-4">
            <DropletIcon class="h-8 w-8 text-blue-400" />
            <span class="text-2xl font-bold">AquaPure</span>
          </router-link>
          <p class="text-blue-200 mb-4">Your trusted partner for clean, healthy hydration solutions.</p>
          <div class="flex space-x-4">
            <FacebookIcon class="h-5 w-5 text-blue-400 hover:text-white cursor-pointer" />
            <TwitterIcon class="h-5 w-5 text-blue-400 hover:text-white cursor-pointer" />
            <InstagramIcon class="h-5 w-5 text-blue-400 hover:text-white cursor-pointer" />
            <YoutubeIcon class="h-5 w-5 text-blue-400 hover:text-white cursor-pointer" />
          </div>
        </div>

        <div>
          <h3 class="text-lg font-semibold mb-4">Quick Links</h3>
          <ul class="space-y-2">
            <li><router-link to="/shop" class="text-blue-200 hover:text-white">Shop</router-link></li>
            <li><router-link to="/about" class="text-blue-200 hover:text-white">About Us</router-link></li>
            <li><router-link to="/blog" class="text-blue-200 hover:text-white">Blog</router-link></li>
            <li><router-link to="/contact" class="text-blue-200 hover:text-white">Contact</router-link></li>
          </ul>
        </div>

        <div>
          <h3 class="text-lg font-semibold mb-4">Categories</h3>
          <ul class="space-y-2">
            <li><router-link to="/shop?category=filters" class="text-blue-200 hover:text-white">Water Filters</router-link></li>
            <li><router-link to="/shop?category=purifiers" class="text-blue-200 hover:text-white">Purifiers</router-link></li>
            <li><router-link to="/shop?category=dispensers" class="text-blue-200 hover:text-white">Dispensers</router-link></li>
            <li><router-link to="/shop?category=accessories" class="text-blue-200 hover:text-white">Accessories</router-link></li>
          </ul>
        </div>

        <div>
          <h3 class="text-lg font-semibold mb-4">Support</h3>
          <ul class="space-y-2">
            <li><router-link to="/faq" class="text-blue-200 hover:text-white">FAQ</router-link></li>
            <li><router-link to="/shipping" class="text-blue-200 hover:text-white">Shipping Info</router-link></li>
            <li><router-link to="/returns" class="text-blue-200 hover:text-white">Returns</router-link></li>
            <li><router-link to="/warranty" class="text-blue-200 hover:text-white">Warranty</router-link></li>
          </ul>
        </div>
      </div>

      <div class="border-t border-blue-800 mt-8 pt-8 text-center">
        <p class="text-blue-200">© 2024 AquaPure. All rights reserved. | Privacy Policy | Terms of Service</p>
      </div>
    </div>
  </footer>
</template>

<script setup>
import { DropletIcon, FacebookIcon, TwitterIcon, InstagramIcon, YoutubeIcon } from 'lucide-vue-next'
</script>
