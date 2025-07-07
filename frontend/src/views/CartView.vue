<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold text-blue-900">Shopping Cart</h1>
        <p class="text-gray-600 mt-2">
          {{ cartStore.items.length }} item{{
            cartStore.items.length !== 1 ? "s" : ""
          }}
          in your cart
        </p>
      </div>
      <router-link to="/shop">
        <button
          class="flex items-center px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50"
        >
          <ArrowLeftIcon class="h-4 w-4 mr-2" />
          Continue Shopping
        </button>
      </router-link>
    </div>

    <!-- Empty Cart -->
    <div v-if="cartStore.items.length === 0" class="text-center py-16">
      <ShoppingBagIcon class="h-24 w-24 text-gray-300 mx-auto mb-6" />
      <h1 class="text-3xl font-bold text-gray-900 mb-4">Your cart is empty</h1>
      <p class="text-gray-600 mb-8 max-w-md mx-auto">
        Looks like you haven't added any items to your cart yet. Start shopping
        to fill it up!
      </p>
      <router-link to="/shop">
        <button
          class="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md"
        >
          Continue Shopping
        </button>
      </router-link>
    </div>

    <!-- Cart Items -->
    <div v-else class="grid lg:grid-cols-3 gap-8">
      <div class="lg:col-span-2 space-y-4">
        <div
          v-for="item in cartStore.items"
          :key="item.id"
          class="bg-white p-6 rounded-lg shadow-md"
        >
          <div class="flex items-center space-x-4">
            <div class="relative w-20 h-20 flex-shrink-0">
              <img
                :src="item.image"
                :alt="item.name"
                class="w-full h-full object-cover rounded-lg"
              />
            </div>

            <div class="flex-1 min-w-0">
              <h3 class="text-lg font-semibold text-gray-900 truncate">
                {{ item.name }}
              </h3>
              <p class="text-blue-600 font-medium">
                ${{ item.price.toFixed(2) }} each
              </p>
            </div>

            <div class="flex items-center space-x-3">
              <div class="flex items-center border rounded-lg">
                <button
                  @click="cartStore.updateQuantity(item.id, item.quantity - 1)"
                  class="p-2 hover:bg-gray-50"
                >
                  <MinusIcon class="h-4 w-4" />
                </button>
                <input
                  type="number"
                  :value="item.quantity"
                  @input="
                    cartStore.updateQuantity(
                      item.id,
                      parseInt($event.target.value) || 1
                    )
                  "
                  class="w-16 text-center border-0 focus:ring-0"
                  min="1"
                />
                <button
                  @click="cartStore.updateQuantity(item.id, item.quantity + 1)"
                  class="p-2 hover:bg-gray-50"
                >
                  <PlusIcon class="h-4 w-4" />
                </button>
              </div>

              <div class="text-right min-w-0">
                <p class="text-lg font-semibold text-gray-900">
                  ${{ (item.price * item.quantity).toFixed(2) }}
                </p>
              </div>

              <button
                @click="cartStore.removeItem(item.id)"
                class="text-red-500 hover:text-red-700 p-2"
              >
                <Trash2Icon class="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>

        <!-- Clear Cart Button -->
        <div class="flex justify-end">
          <button
            @click="cartStore.clearCart"
            class="flex items-center px-4 py-2 text-red-600 border border-red-200 rounded-md hover:bg-red-50"
          >
            <Trash2Icon class="h-4 w-4 mr-2" />
            Clear Cart
          </button>
        </div>
      </div>

      <!-- Order Summary -->
      <div class="lg:col-span-1">
        <div class="bg-white p-6 rounded-lg shadow-md sticky top-4">
          <h2 class="text-xl font-semibold text-blue-900 mb-4">
            Order Summary
          </h2>

          <!-- Promo Code -->
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Promo Code</label
            >
            <div v-if="!promoApplied" class="flex space-x-2">
              <input
                type="text"
                placeholder="Enter code"
                v-model="promoCode"
                class="flex-1 px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                @click="applyPromoCode"
                :disabled="!promoCode"
                class="px-4 py-2 border border-gray-300 rounded-md hover:bg-gray-50 disabled:opacity-50"
              >
                Apply
              </button>
            </div>
            <div
              v-else
              class="flex items-center justify-between p-3 bg-green-50 border border-green-200 rounded-lg"
            >
              <div class="flex items-center space-x-2">
                <span
                  class="px-2 py-1 bg-green-100 text-green-800 text-xs rounded"
                  >{{ promoCode.toUpperCase() }}</span
                >
                <span class="text-sm text-green-700">Applied!</span>
              </div>
              <button
                @click="removePromoCode"
                class="text-green-700 hover:text-green-800"
              >
                <Trash2Icon class="h-3 w-3" />
              </button>
            </div>
            <div class="text-xs text-gray-500 mt-1">
              Try: SAVE10 or WELCOME20
            </div>
          </div>

          <hr class="my-4" />

          <!-- Price Breakdown -->
          <div class="space-y-3 mb-4">
            <div class="flex justify-between text-sm">
              <span class="text-gray-600">Subtotal</span>
              <span class="font-medium">${{ cartStore.total.toFixed(2) }}</span>
            </div>

            <div v-if="discount > 0" class="flex justify-between text-sm">
              <span class="text-green-600">Discount</span>
              <span class="font-medium text-green-600"
                >-${{ discount.toFixed(2) }}</span
              >
            </div>

            <div class="flex justify-between text-sm">
              <span class="text-gray-600">Shipping</span>
              <span class="font-medium">
                <span v-if="shipping === 0" class="text-green-600">Free</span>
                <span v-else>${{ shipping.toFixed(2) }}</span>
              </span>
            </div>

            <div class="flex justify-between text-sm">
              <span class="text-gray-600">Tax</span>
              <span class="font-medium">${{ tax.toFixed(2) }}</span>
            </div>
          </div>

          <hr class="my-4" />

          <div class="flex justify-between text-lg font-bold mb-4">
            <span class="text-blue-900">Total</span>
            <span class="text-blue-900">${{ finalTotal.toFixed(2) }}</span>
          </div>

          <!-- Free Shipping Notice -->
          <div
            v-if="shipping > 0"
            class="p-3 bg-blue-50 border border-blue-200 rounded-lg mb-4"
          >
            <p class="text-sm text-blue-700">
              Add ${{ (50 - cartStore.total).toFixed(2) }} more for free
              shipping!
            </p>
          </div>

          <!-- Checkout Button -->
          <button
            v-if="!showQRCode && !showReceipt"
            @click="showQRCode = true"
            class="w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md mb-4"
          >
            Proceed to Checkout
          </button>

          <!-- QR Code Display -->
          <div
            v-if="showQRCode"
            class="mt-4 p-4 border border-gray-200 rounded-lg text-center"
          >
            <h3 class="text-lg font-semibold mb-4 text-blue-900">
              Scan QR Code to Pay
            </h3>

            <img
              :src="`https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=Payment%20for%20Order%20Total%20${finalTotal.toFixed(
                2
              )}`"
              alt="QR Code"
              class="mx-auto mb-4"
            />

            <button
              @click="handleConfirmPayment"
              class="w-full py-3 bg-green-600 hover:bg-green-700 text-white font-medium rounded-md"
            >
              I Have Paid ${{ finalTotal.toFixed(2) }}
            </button>
          </div>

          <!-- ✅ RECEIPT -->
          <div
            v-if="showReceipt"
            class="mt-4 p-4 border border-gray-200 rounded-lg"
          >
            <h3 class="text-lg font-semibold mb-4 text-blue-900">
              Payment Receipt
            </h3>

            <div class="space-y-2 mb-4">
              <div
                v-for="item in paidItems"
                :key="item.id"
                class="flex justify-between text-sm"
              >
                <span>{{ item.name }} x{{ item.quantity }}</span>
                <span>${{ (item.price * item.quantity).toFixed(2) }}</span>
              </div>
            </div>

            <div class="flex justify-between text-base font-bold mb-4">
              <span>Total Paid</span>
              <span>${{ finalTotal.toFixed(2) }}</span>
            </div>

            <div class="flex space-x-2">
              <button
                @click="printReceipt"
                class="flex-1 py-2 bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium rounded-md"
              >
                Print Receipt
              </button>
              <button
                @click="exportReceipt"
                class="flex-1 py-2 bg-blue-600 hover:bg-blue-700 text-white font-medium rounded-md"
              >
                Export Receipt
              </button>
            </div>
          </div>

          <!-- Security Features -->
          <div class="grid grid-cols-3 gap-2 text-center pt-4 border-t">
            <div class="flex flex-col items-center">
              <TruckIcon class="h-5 w-5 text-blue-600 mb-1" />
              <span class="text-xs text-gray-600">Free Shipping $50+</span>
            </div>
            <div class="flex flex-col items-center">
              <ShieldIcon class="h-5 w-5 text-blue-600 mb-1" />
              <span class="text-xs text-gray-600">Secure Checkout</span>
            </div>
            <div class="flex flex-col items-center">
              <RotateCcwIcon class="h-5 w-5 text-blue-600 mb-1" />
              <span class="text-xs text-gray-600">30-Day Returns</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<script setup>
import { ref, computed } from "vue";
import {
  ArrowLeftIcon,
  ShoppingBagIcon,
  MinusIcon,
  PlusIcon,
  Trash2Icon,
  TruckIcon,
  ShieldIcon,
  RotateCcwIcon,
} from "lucide-vue-next";
import { useCartStore } from "../stores/cart";


// ✅ Pinia cart store
const cartStore = useCartStore();

// ✅ Promo code logic
const promoCode = ref("");
const promoApplied = ref(false);
const discount = ref(0);

const shipping = computed(() => (cartStore.total > 50 ? 0 : 7.99));
const tax = computed(() => cartStore.total * 0.08);
const finalTotal = computed(
  () => cartStore.total + shipping.value + tax.value - discount.value
);

const applyPromoCode = () => {
  if (promoCode.value.toLowerCase() === "save10") {
    discount.value = cartStore.total * 0.1;
    promoApplied.value = true;
  } else if (promoCode.value.toLowerCase() === "welcome20") {
    discount.value = cartStore.total * 0.2;
    promoApplied.value = true;
  } else {
    alert("Invalid promo code");
  }
};

const removePromoCode = () => {
  promoCode.value = "";
  promoApplied.value = false;
  discount.value = 0;
};

// ✅ QR code + Receipt
const showQRCode = ref(false);
const showReceipt = ref(false);
const paidItems = ref([]);

const handleConfirmPayment = () => {
  alert(
    `✅ Payment of $${finalTotal.value.toFixed(
      2
    )} confirmed via QR code!\nThank you for your order.`
  );

  // Store a copy for receipt
  paidItems.value = [...cartStore.items];

  // Clear the cart
  cartStore.clearCart();

  // Show receipt
  showQRCode.value = false;
  showReceipt.value = true;
};

// ✅ Simple print & export
const printReceipt = () => {
  window.print();
};

const exportReceipt = () => {
  // Very simple: create text blob
  let text = `RECEIPT\n\nItems:\n`;
  paidItems.value.forEach((item) => {
    text += `• ${item.name} x${item.quantity} - $${(
      item.price * item.quantity
    ).toFixed(2)}\n`;
  });
  text += `\nTotal Paid: $${finalTotal.value.toFixed(2)}`;

  const blob = new Blob([text], { type: "text/plain" });
  const link = document.createElement("a");
  link.href = URL.createObjectURL(blob);
  link.download = "receipt.txt";
  link.click();
};
</script>
