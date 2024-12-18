import { createRouter, createWebHistory } from "vue-router";
import store from '@/store'; // Import the Vuex store

import LandingPage from '@/pages/LandingPage.vue';
import LoginPage from '@/pages/LoginPage.vue';
import SignUpPage from '@/pages/SignUpPage.vue';
import UserPage from '@/pages/UserPage.vue';

const routes = [
  {
    path: '/', // Root URL
    name: 'LandingPage',
    component: LandingPage,
  },
  {
    path: '/login', // Custom path for login
    name: 'LoginPage',
    component: LoginPage,
  },
  {
    path: '/signup', // Custom path for sign-up
    name: 'SignUpPage',
    component: SignUpPage,
  },
  {
    path: '/me', // Custom path for user page
    name: 'UserPage',
    component: UserPage,
    meta: { requiresAuth: true }, // Add meta field to require authentication
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Add navigation guard
router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // Check if the user is authenticated
    if (!store.getters.isAuthenticated) {
      // If not authenticated, redirect to login page
      next({ path: '/login' });
    } else {
      // If authenticated, proceed to the route
      next();
    }
  } else {
    // If the route does not require authentication, proceed
    next();
  }
});

export default router;