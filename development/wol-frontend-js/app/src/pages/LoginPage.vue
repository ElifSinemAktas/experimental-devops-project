<template>
    <v-container>
      <v-row justify="center">
        <v-col  cols="12" md="6" lg="4">
          <v-card>
            <v-card-title>Login</v-card-title>
            <v-card-text>
              <v-form>
                <v-text-field
                  v-model="email"
                  label="Email"
                  type="email"
                  outlined
                  required
                ></v-text-field>
                <v-text-field
                  v-model="password"
                  label="Password"
                  type="password"
                  outlined
                  required
                ></v-text-field>
                <v-btn block color="primary" @click="login">Login</v-btn>
              </v-form>
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </template>
  
  <script>
import { ref } from "vue";
import { useRouter } from "vue-router"; // Import Vue Router
import { useStore } from "vuex"; // Import Vuex store
import apiClient from "../plugins/axios"; // Import the Axios instance

export default {
  setup() {
    const email = ref("");
    const password = ref("");
    const router = useRouter(); // Initialize router
    const store = useStore(); // Initialize store

    async function login() {
      try {
        const response = await apiClient.post("/users/login", {
          email: email.value,
          password: password.value,
        });

        // Dispatch the login action to the Vuex store
        store.dispatch('login', {
          token: response.data.access_token,
          user: response.data.user,
        });

        alert("Login successful!");
        router.push("/me"); // Redirect to /me page
      } catch (error) {
        alert("Error during login: " + error.response.data.detail);
        console.error(error);
      }
    }

    return {
      email,
      password,
      login,
    };
  },
};
</script>