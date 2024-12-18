<template>
  <v-container>
    <v-row justify="center" align="center">
      <v-col cols="12" md="6" lg="4">
        <v-card class="elevation-12">
          <v-card-title class="headline">Sign Up</v-card-title>
          <v-card-text>
            <v-form @submit.prevent="signup">
              <v-text-field
                v-model="firstName"
                label="First Name"
                outlined
                required
                prepend-inner-icon="mdi-account"
              ></v-text-field>
              <v-text-field
                v-model="lastName"
                label="Last Name"
                outlined
                required
                prepend-inner-icon="mdi-account"
              ></v-text-field>
              <v-text-field
                v-model="email"
                label="Email"
                type="email"
                outlined
                required
                prepend-inner-icon="mdi-email"
              ></v-text-field>
              <v-text-field
                v-model="password"
                label="Password"
                type="password"
                outlined
                required
                prepend-inner-icon="mdi-lock"
              ></v-text-field>
              <v-btn block color="primary" type="submit">Sign Up</v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import apiClient from '../plugins/axios'; // Ensure this is the correct path to your axios instance

// Form fields
const firstName = ref('');
const lastName = ref('');
const email = ref('');
const password = ref('');

// Router instance
const router = useRouter();

// Signup function
async function signup() {
  try {
    // Make the API call to sign up the user
    const response = await apiClient.post('/users/signup', {
      first_name: firstName.value,
      last_name: lastName.value,
      email: email.value,
      password: password.value,
    });

    alert('Sign-up successful!');

    // Redirect to the Login Page
    router.push('/login');
  } catch (error) {
    alert('Error during sign-up: ' + error.response.data.detail);
    console.error(error);
  }
}
</script>