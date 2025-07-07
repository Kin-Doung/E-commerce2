import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      name: "home",
      component: HomeView
    },
    {
      path: "/shop",
      name: "shop",
      component: () => import("../views/ShopView.vue")
    },
    {
      path: "/about",
      name: "about",
      component: () => import("../views/AboutView.vue")
    },
    {
      path: "/contact",
      name: "contact",
      component: () => import("../views/ContactView.vue")
    },
    {
      path: "/cart",
      name: "cart",
      component: () => import("../views/CartView.vue")
    },
    {
      path: "/faq",
      name: "faq",
      component: () => import("../views/FAQView.vue")
    },
    {
      path: "/login",
      name: "admin-login",
      component: () => import("../views/AdminLoginView.vue")
    },
    {
      path: "/register",
      name: "register",
      component: () => import("../views/RegisterView.vue")
    },
    {
      path: "/admin/dashboard",
      name: "AdminDashboard",
      component: () => import("../views/AdminDashboardView.vue")
    },
    {
      path: "/category",
      name: "category",
      component: () => import("../views/Category.vue")
    }
  ]
});

export default router;
