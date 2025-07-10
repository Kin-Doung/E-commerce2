import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "../stores/auth";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: () => import("../views/HomeView.vue"),
    },
    {
      path: "/shop",
      name: "shop",
      component: () => import("../views/ShopView.vue"),
    },
    {
      path: "/about",
      name: "about",
      component: () => import("../views/AboutView.vue"),
    },
    {
      path: "/contact",
      name: "contact",
      component: () => import("../views/ContactView.vue"),
    },
    {
      path: "/faq",
      name: "faq",
      component: () => import("../views/FAQView.vue"),
    },
    {
      path: "/cart",
      name: "cart",
      component: () => import("../views/CartView.vue"),
    },
    // ... other public routes ...
    {
      path: "/login",
      name: "admin-login",
      component: () => import("../views/AdminLoginView.vue"),
    },
    {
      path: "/register",
      name: "register",
      component: () => import("../views/RegisterView.vue"),
    },
    {
      path: "/admin",
      name: "admin",
      component: () => import("../views/AdminDashboardView.vue"),
      children: [
        {
          path: "dashboard",
          name: "AdminDashboard",
          component: () => import("../components/admin/DashboardContent.vue"),
        },
        {
          path: "orders",
          name: "Orders",
          component: () =>
            import("../components/admin/OrdersManagement.vue"),
        },
        {
          path: "inventory",
          name: "inventory",
          component: () =>
            import("../components/admin/InventoryManagement.vue"),
        },
        {
          path: "analytics",
          name: "Analytics",
          component: () => import("../components/admin/AnalyticsDashboard.vue"),
        },
        {
          path: "customers",
          name: "Customers",
          component: () =>
            import("../components/admin/CustomersManagement.vue"),
        },
        {
          path: "categories",
          name: "Categories",
          component: () =>
            import("../components/admin/CategoriesManagement.vue"), // New component
        },
        {
          path: "products",
          name: "Products",
          component: () => import("../components/admin/ProductsManagement.vue"),
        },
        {
          path: "settings",
          name: "Settings",
          component: () => import("../components/admin/SettingsPanel.vue"),
        },
      ],
    },
    {
      path: "/admin/dashboard",
      name: "AdminDashboard",
      component: () => import("../views/AdminDashboardView.vue")
    }
  ]
});

// Navigation guard to protect admin routes
router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();

  if (to.path.startsWith('/admin')) {
    if (!authStore.isAuthenticated) {
      // Not logged in, redirect to login
      next({ name: 'admin-login' });
    } else if (!authStore.isAdmin) {
      // Logged in but not admin, redirect to home or public page
      next({ name: 'home' });
    } else {
      // Admin authenticated, allow access
      next();
    }
  } else {
    // Public routes, allow access
    next();
  }
});

export default router;
