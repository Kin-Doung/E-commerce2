<script setup>
import { Award, Users, Leaf, Target } from "lucide-vue-next";
import { ref } from "vue";

const values = ref([
  {
    icon: Award,
    title: "Quality First",
    description:
      "We never compromise on quality. Every product undergoes rigorous testing to ensure it meets our high standards.",
  },
  {
    icon: Users,
    title: "Customer Focused",
    description:
      "Our customers are at the heart of everything we do. We listen, learn, and continuously improve based on your feedback.",
  },
  {
    icon: Leaf,
    title: "Environmental Responsibility",
    description:
      "We are committed to sustainable practices and reducing our environmental footprint through eco-friendly products.",
  },
  {
    icon: Target,
    title: "Innovation",
    description:
      "We continuously invest in research and development to bring you the latest in water purification technology.",
  },
]);

const team = ref([
  {
    name: "Mr. Kin Doung",
    role: "CEO & Founder",
    image: "src/assets/images/profileKin.png",
  },
  {
    name: "Ms. Linna Rin",
    role: "CTO",
    image: "src/assets/images/profileLinna.png",
  },
  {
    name: "Mr. Kartrok Thy",
    role: "Head of Product",
    image: "src/assets/images/profileKartrok.jpg",
  },
]);
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
    <!-- Hero Section -->
    <div class="text-center mb-16">
      <h1 class="text-4xl font-bold text-blue-900 mb-6">About AquaPure</h1>
      <p class="text-xl text-gray-600 max-w-3xl mx-auto">
        For over a decade, we've been dedicated to providing clean, healthy
        water solutions that improve lives and protect our planet.
      </p>
    </div>

    <!-- Story Section -->
    <div class="grid lg:grid-cols-2 gap-12 items-center mb-20">
      <div>
        <h2 class="text-3xl font-bold text-blue-900 mb-6">Our Story</h2>
        <p class="text-gray-600 mb-4">
          Founded in 2014, AquaPure began with a simple mission: to make clean,
          healthy water accessible to everyone. What started as a small family
          business has grown into a trusted brand serving thousands of customers
          worldwide.
        </p>
        <p class="text-gray-600 mb-4">
          Our founders, passionate about environmental sustainability and public
          health, recognized the growing need for reliable water purification
          solutions. They set out to create products that not only deliver
          exceptional performance but also minimize environmental impact.
        </p>
        <p class="text-gray-600">
          Today, we continue to innovate and expand our product line, always
          staying true to our core values of quality, sustainability, and
          customer satisfaction.
        </p>
      </div>
      <div>
        <img
          src="https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=600&h=400&fit=crop"
          alt="AquaPure team"
          class="w-full h-auto rounded-lg shadow-lg"
        />
      </div>
    </div>

    <!-- Values Section -->
    <div class="mb-20">
      <div class="text-center mb-12">
        <h2 class="text-3xl font-bold text-blue-900 mb-4">Our Values</h2>
        <p class="text-xl text-gray-600">
          The principles that guide everything we do
        </p>
      </div>
      <div class="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
        <div v-for="(value, index) in values" :key="index" class="text-center">
          <div
            class="inline-flex items-center justify-center w-16 h-16 bg-blue-100 rounded-full mb-4"
          >
            <component :is="value.icon" class="h-8 w-8 text-blue-600" />
          </div>
          <h3 class="text-xl font-semibold text-blue-900 mb-3">
            {{ value.title }}
          </h3>
          <p class="text-gray-600">{{ value.description }}</p>
        </div>
      </div>
    </div>

    <!-- Stats Section -->
    <div class="bg-blue-50 rounded-lg p-8 mb-20">
      <div class="grid md:grid-cols-4 gap-8 text-center">
        <div>
          <div class="text-3xl font-bold text-blue-900 mb-2">50,000+</div>
          <div class="text-gray-600">Happy Customers</div>
        </div>
        <div>
          <div class="text-3xl font-bold text-blue-900 mb-2">100+</div>
          <div class="text-gray-600">Products</div>
        </div>
        <div>
          <div class="text-3xl font-bold text-blue-900 mb-2">10+</div>
          <div class="text-gray-600">Years Experience</div>
        </div>
        <div>
          <div class="text-3xl font-bold text-blue-900 mb-2">99.9%</div>
          <div class="text-gray-600">Purity Rate</div>
        </div>
      </div>
    </div>

    <!-- Team Section -->
    <div class="text-center">
      <h2 class="text-3xl font-bold text-blue-900 mb-4">Meet Our Team</h2>
      <p class="text-xl text-gray-600 mb-12">
        The passionate people behind AquaPure
      </p>
      <div class="grid md:grid-cols-3 gap-8">
        <div v-for="(member, index) in team" :key="index" class="text-center">
          <img
            :src="member.image"
            :alt="member.name"
            class="w-48 h-48 rounded-full mx-auto mb-4 object-cover"
          />
          <h3 class="text-xl font-semibold text-blue-900">{{ member.name }}</h3>
          <p class="text-gray-600">{{ member.role }}</p>
        </div>
      </div>
    </div>
  </div>
</template>
