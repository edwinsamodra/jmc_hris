<script setup>
definePageMeta({
  layout: "auth",
  title: "Login",
});

import LoginForm from "~/features/auth/Login/components/LoginForm.vue";
import logoJmcBlack from "~/assets/images/logo/logo_jmc_black.png";

const { initTheme } = useTheme();
const config = useRuntimeConfig();
const route = useRoute();

onMounted(() => {
  initTheme();
});
</script>

<template>
  <div class="box col-md-8 p-4">
    <!-- Logo -->
    <div class="d-flex gap-3 mb-4 align-items-center">
      <div class="logo">
        <img
          :src="logoJmcBlack"
          alt="Logo"
          height="30"
        />
      </div>

      <div class="logo-text">
        <h1 class="mb-0 text-primary">{{ config.public.appName }}</h1>

        <div>{{ config.public.appClient }}</div>
      </div>
    </div>

    <p>Selamat Datang, silahkan masukkan username dan password anda!</p>

    <!-- Error Alert jika login google/auth gagal -->
    <div v-if="route.query.error" class="alert alert-danger alert-dismissible mb-3" role="alert">
      <div class="d-flex">
        <div>
          <svg xmlns="http://www.w3.org/2000/svg" class="icon alert-icon" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><circle cx="12" cy="12" r="9" /><line x1="12" y1="8" x2="12" y2="12" /><line x1="12" y1="16" x2="12.01" y2="16" /></svg>
        </div>
        <div>
          {{ route.query.error }}
        </div>
      </div>
    </div>

    <!-- Login Form -->
    <LoginForm />
  </div>
</template>
