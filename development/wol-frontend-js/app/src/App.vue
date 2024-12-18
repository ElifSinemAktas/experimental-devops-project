<template>
  <v-app>
    <!-- Global Header -->
    <Header />

    <!-- Dynamic Page Content -->
    <v-main>
      <router-view />
    </v-main>

    <!-- Global Footer -->
    <v-footer app>
      <span>&copy; 2024 MyApp</span>
    </v-footer>
  </v-app>
</template>

<script>
import Header from './components/Header.vue';

export default {
  name: 'App',
  components: {
    Header,
  },
};
</script>

<style>
/* Add your global styles here */
</style>
