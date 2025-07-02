<script setup>
import { MapPin, Phone, Mail, Clock } from "lucide-vue-next"

import Button from "@/components/ui/button.vue"
import Input from "@/components/ui/input.vue"
import Textarea from "@/components/ui/textarea.vue"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card.vue"
</script>

<template>
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
      <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-blue-900 mb-4">Contact Us</h1>
        <p class="text-xl text-gray-600">We'd love to hear from you. Get in touch with our team.</p>
      </div>

      <div class="grid lg:grid-cols-2 gap-12">
        <div>
          <Card>
            <CardHeader>
              <CardTitle class="text-2xl text-blue-900">Send us a message</CardTitle>
            </CardHeader>
            <CardContent>
              <form class="space-y-6">
                <div class="grid md:grid-cols-2 gap-4">
                  <div>
                    <label htmlFor="firstName" class="block text-sm font-medium text-gray-700 mb-2">
                      First Name
                    </label>
                    <Input id="firstName" type="text" required />
                  </div>
                  <div>
                    <label htmlFor="lastName" class="block text-sm font-medium text-gray-700 mb-2">
                      Last Name
                    </label>
                    <Input id="lastName" type="text" required />
                  </div>
                </div>
                <div>
                  <label htmlFor="email" class="block text-sm font-medium text-gray-700 mb-2">
                    Email
                  </label>
                  <Input id="email" type="email" required />
                </div>
                <div>
                  <label htmlFor="phone" class="block text-sm font-medium text-gray-700 mb-2">
                    Phone Number
                  </label>
                  <Input id="phone" type="tel" />
                </div>
                <div>
                  <label htmlFor="subject" class="block text-sm font-medium text-gray-700 mb-2">
                    Subject
                  </label>
                  <Input id="subject" type="text" required />
                </div>
                <div>
                  <label htmlFor="message" class="block text-sm font-medium text-gray-700 mb-2">
                    Message
                  </label>
                  <Textarea id="message" rows={5} required />
                </div>
                <Button type="submit" class="w-full whitespace-nowrap bg-blue-600 hover:bg-blue-700">
                  Send Message
                </Button>
              </form>
            </CardContent>
          </Card>
        </div>

        <div class="space-y-8">
          <Card>
            <CardHeader>
              <CardTitle class="text-2xl text-blue-900">Get in touch</CardTitle>
            </CardHeader>
            <CardContent class="space-y-6">
              <div class="flex items-start space-x-4">
                <MapPin class="h-6 w-6 text-blue-600 mt-1" />
                <div>
                  <h3 class="font-semibold text-gray-900">Address</h3>
                  <p class="text-gray-600">
                    123 Water Street
                    <br />
                    Clean City, CC 12345
                    <br />
                    United States
                  </p>
                </div>
              </div>
              <div class="flex items-start space-x-4">
                <Phone class="h-6 w-6 text-blue-600 mt-1" />
                <div>
                  <h3 class="font-semibold text-gray-900">Phone</h3>
                  <p class="text-gray-600">+1 (555) 123-4567</p>
                </div>
              </div>
              <div class="flex items-start space-x-4">
                <Mail class="h-6 w-6 text-blue-600 mt-1" />
                <div>
                  <h3 class="font-semibold text-gray-900">Email</h3>
                  <p class="text-gray-600">info@aquapure.com</p>
                </div>
              </div>
              <div class="flex items-start space-x-4">
                <Clock class="h-6 w-6 text-blue-600 mt-1" />
                <div>
                  <h3 class="font-semibold text-gray-900">Business Hours</h3>
                  <p class="text-gray-600">
                    Monday - Friday: 9:00 AM - 6:00 PM
                    <br />
                    Saturday: 10:00 AM - 4:00 PM
                    <br />
                    Sunday: Closed
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle class="text-xl text-blue-900">Customer Support</CardTitle>
            </CardHeader>
            <CardContent>
              <p class="text-gray-600 mb-4">
                Need help with your order or have questions about our products? Our customer support team is here to
                help.
              </p>
              <div class="space-y-2">
                <p class="text-sm text-gray-600">
                  <strong>Support Email:</strong> support@aquapure.com
                </p>
                <p class="text-sm text-gray-600">
                  <strong>Support Phone:</strong> +1 (555) 123-4568
                </p>
                <p class="text-sm text-gray-600">
                  <strong>Response Time:</strong> Within 24 hours
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
</template>
