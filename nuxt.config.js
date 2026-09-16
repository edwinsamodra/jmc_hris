// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  future: {
    compatibilityVersion: 4,
  },

  compatibilityDate: "2024-11-01",

  devtools: { enabled: true },

  runtimeConfig: {
    database: {
      host: process.env.DB_HOST || "127.0.0.1",
      port: Number(process.env.DB_PORT || 3306),
      name: process.env.DB_NAME || "pj1",
      user: process.env.DB_USER || "admin",
      password: process.env.DB_PASSWORD || "",
    },
    recaptchaSecretKey:
      process.env.RECAPTCHA_SECRET_KEY || "",
    public: {
      appName: process.env.APP_NAME || "HRIS",
      appClient: process.env.APP_CLIENT || "HRIS",
      recaptchaSiteKey:
        process.env.RECAPTCHA_SITE_KEY ||
        process.env.NUXT_PUBLIC_RECAPTCHA_SITE_KEY ||
        "",
    },
  },

  css: [
    "@tabler/core/dist/css/tabler.min.css",
    // '@tabler/core/dist/css/tabler-icons.min.css',
    // "~/assets/css/main.css",
    "~/assets/css/backend.css",
  ],

  app: {
    head: {
      htmlAttrs: {
        "data-bs-navbar-position": "vertical",
      },
      charset: "utf-8",
      viewport: "width=device-width, initial-scale=1",
      link: [{ rel: "icon", type: "image/x-icon", href: "/favicon.png" }],
      script: [
        {
          src: `https://www.google.com/recaptcha/enterprise.js?render=${process.env.RECAPTCHA_SITE_KEY || "6LeFkr4tAAAAAN4NFL38ng_QdKuimjUwa6JXZct6"}`,
          async: true,
          defer: true,
        },
      ],
    },
  },

  plugins: [
    "~/plugins/jquery.client.js",
    "~/plugins/tabler.client.js",
    "~/plugins/apexcharts.client.js",
  ],

  vite: {
    optimizeDeps: {
      include: ["apexcharts"],
    },
  },
});
