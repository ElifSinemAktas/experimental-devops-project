
# Starting a New Vuetify Project with Vite

This guide will walk you through the steps to set up a new Vuetify project using Vite.

## Prerequisites

1. **Install Node.js**: Download and install Node.js from their [official website](https://nodejs.org/en).
2. **Check npm version**: Ensure you have npm installed by running the following command in your terminal:
    ```bash
    npm -v
    ```

## Creating a New Vuetify Project

1. **Create a new Vuetify project**: Use the following command to create a new Vuetify project with Vite. 
    ```bash
    npm create vuetify@latest
    ```
    ```
    √ Project name: ... app
    √ Which preset would you like to install? » Default (Adds routing, ESLint & SASS variables)
    √ Use TypeScript? ... No / Yes (SELECT NO)
    √ Would you like to install dependencies with yarn, npm, pnpm, or bun? » npm
    √ Install Dependencies? ... No / Yes (SELECT YES)
    ```

2. **Install Vuex and Axios**: After creating the Vuetify project, install Vuex and Axios using the following command (run it in your app directory):
    ```bash
    npm install vuex
    ```
    ```bash
    npm install axios
    ```

2. **Check Packages**: In your app directory, run the following command (use -g flag to see globally installed packages).

    ```bash
       npm list --depth=0
    ```
## Notes

1. **Vue.js**: The core framework where you write the logic for your application.
2. **Vite**: The toolchain you use to build, run, and optimize your Vue.js application.
3. **Vuetify**: An add-on to Vue.js that provides pre-styled components, making it easier to design the UI.
4. **Vuex**: A state management pattern + library for Vue.js applications. It serves as a centralized store for all the components in an application, with rules ensuring that the state can only be mutated in a predictable fashion.