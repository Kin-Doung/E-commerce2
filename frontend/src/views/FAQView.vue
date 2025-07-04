<script setup>
import { ref } from 'vue'

const faqs = ref([
  {
    question: 'How often should I replace my water filter?',
    answer:
      'Most of our water filters should be replaced every 6 months or after filtering 300 gallons of water, whichever comes first. However, this can vary depending on your water quality and usage. We recommend checking the filter indicator if your system has one, or monitoring the taste and flow rate of your water.',
  },
  {
    question: 'Are your products certified?',
    answer:
      'Yes, all our water filtration products are certified by NSF International and meet or exceed NSF/ANSI standards 42 and 53. Our products are also tested and certified by independent third-party laboratories to ensure they meet the highest quality and safety standards.',
  },
  {
    question: 'Do you offer free shipping?',
    answer:
      'We offer free standard shipping on all orders over $50 within the continental United States. For orders under $50, standard shipping is $7.99. We also offer expedited shipping options at checkout for faster delivery.',
  },
  {
    question: 'What is your return policy?',
    answer:
      "We offer a 30-day money-back guarantee on all our products. If you're not completely satisfied with your purchase, you can return it within 30 days for a full refund. The product must be in its original condition and packaging. Return shipping costs are covered by us for defective products.",
  },
  {
    question: 'How do I install a water filter system?',
    answer:
      'Most of our water filter systems come with detailed installation instructions and all necessary hardware. Many can be installed without professional help in 30-60 minutes. We also provide video tutorials on our website and offer phone support if you need assistance during installation.',
  },
  {
    question: 'What contaminants do your filters remove?',
    answer:
      'Our filters are designed to remove a wide range of contaminants including chlorine, lead, mercury, pesticides, herbicides, industrial chemicals, and sediment. The specific contaminants removed depend on the filter model. Each product page lists the specific contaminants that filter removes.',
  },
  {
    question: 'Do your filters remove beneficial minerals?',
    answer:
      'Our advanced filtration systems are designed to remove harmful contaminants while preserving beneficial minerals like calcium and magnesium. This ensures you get clean, healthy water that still contains the minerals your body needs.',
  },
  {
    question: 'How can I track my order?',
    answer:
      "Once your order ships, you'll receive a tracking number via email. You can use this number to track your package on our website or the carrier's website. You can also log into your account on our website to view your order status and tracking information.",
  },
  {
    question: 'What warranty do you offer?',
    answer:
      "We offer a 1-year manufacturer's warranty on all our products, covering defects in materials and workmanship. Some premium products come with extended warranties up to 3 years. The warranty does not cover normal wear and tear or damage from misuse.",
  },
  {
    question: 'Can I cancel or modify my order?',
    answer:
      "You can cancel or modify your order within 2 hours of placing it by contacting our customer service team. After this time, if your order hasn't shipped yet, we may still be able to make changes, but we cannot guarantee it. Once an order has shipped, it cannot be modified.",
  },
])
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <div class="text-center mb-12">
      <h1 class="text-4xl font-bold text-blue-900 mb-4">Frequently Asked Questions</h1>
      <p class="text-xl text-gray-600">Find answers to common questions about our products and services</p>
    </div>

    <div class="space-y-4">
      <details
        v-for="(faq, index) in faqs"
        :key="index"
        class="border rounded-lg px-6 py-4 group transition"
      >
        <summary
          class="cursor-pointer font-semibold text-blue-900 hover:text-blue-700 marker:hidden flex justify-between items-center"
        >
          {{ faq.question }}
        </summary>
        <p class="text-gray-600 mt-2">{{ faq.answer }}</p>
      </details>
    </div>

    <div class="mt-12 text-center bg-blue-50 rounded-lg p-8">
      <h2 class="text-2xl font-bold text-blue-900 mb-4">Still have questions?</h2>
      <p class="text-gray-600 mb-6">
        Can't find the answer you're looking for? Our customer support team is here to help.
      </p>
      <div class="flex flex-col sm:flex-row gap-4 justify-center">
        <a
          href="/contact"
          class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-base font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700"
        >
          Contact Support
        </a>
        <a
          href="tel:+15551234567"
          class="inline-flex items-center justify-center px-6 py-3 border border-blue-600 text-base font-medium rounded-md text-blue-600 bg-white hover:bg-blue-50"
        >
          Call Us: (+855) 123-456-789
        </a>
      </div>
    </div>
  </div>
</template>
