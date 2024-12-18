<template>
    <v-container>
      <v-row class="landing-page">
        <v-col cols="12" md="6">
          <h1 class="headline">Build like the best</h1>
          <p class="subheading">
            Increase developer velocity. Secure every step. Automate entire workflows. Redefine collaboration.
          </p>
          <v-btn large color="primary" @click="$router.push('/signup')">Get Started</v-btn>
        </v-col>
        <v-col cols="12" md="6">
          <v-img
            src="../assets/logo.png"
            alt="Placeholder Image"
            class="landing-image"
            contain
          ></v-img>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script>
  export default {
    name: "LandingPage",
  };
  </script>
  
  <style scoped>
  .landing-page {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 80vh;
  }
  .headline {
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 1rem;
  }
  .subheading {
    font-size: 1.25rem;
    margin-bottom: 2rem;
  }
  .landing-image {
    max-width: 100%;
    height: auto;
  }
  </style>
  