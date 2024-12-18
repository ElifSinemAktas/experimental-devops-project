<template>
  <v-app-bar app>
    <!-- Clickable MyApp title -->
    <v-toolbar-title @click="goToLanding" style="cursor: pointer;">
      MyApp
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <template v-if="showAuthButtons">
      <!-- Show Login/Sign-Up buttons only for unauthenticated users -->
      <v-btn text color="primary" @click="goToLogin">Login</v-btn>
      <v-btn outlined color="primary" @click="goToSignUp">Sign Up</v-btn>
    </template>
    <template v-if="isAuthenticated">
      <!-- Logout button for authenticated users -->
      <v-btn text color="primary" @click="logout">Logout</v-btn>
    </template>
  </v-app-bar>
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useStore } from 'vuex';

// Router and Store utilities
const router = useRouter();
const store = useStore();

// Computed property for showing login/signup buttons
const isAuthenticated = computed(() => store.getters.isAuthenticated);
const showAuthButtons = computed(() => !isAuthenticated.value);

// Navigate to the Landing Page
function goToLanding() {
  router.push('/'); // Redirect to the Landing Page
}

// Navigate to the Login Page
function goToLogin() {
  router.push('/login');
}

// Navigate to the Sign-Up Page
function goToSignUp() {
  router.push('/signup');
}

// Logout function
function logout() {
  store.dispatch('logout');
  router.push('/');
}
</script>

<style>
.v-toolbar-title {
  cursor: pointer;
  font-weight: bold;
}
</style>