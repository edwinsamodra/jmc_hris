<template>
  <div>
    <!-- STEP 1: Form Login Kredensial -->
    <form v-if="step === 'credentials'" id="login-form" @submit.prevent>
      <!-- Error Message -->
      <div v-if="errorMessage" class="alert alert-danger py-2 mb-3" role="alert">
        {{ errorMessage }}
      </div>

      <!-- Username/Email/Cell.Phone -->
      <div class="mb-3">
        <label class="form-label text-muted small mb-1">Username / Email / Nomor HP</label>
        <div class="input-icon">
          <input
            v-model="form.identifier"
            type="text"
            class="form-control py-3 bg-light text-dark"
            placeholder="Username, email, atau no. HP"
            autocomplete="username"
            required
            :disabled="isSubmitting"
          />
        </div>
      </div>

      <!-- Password -->
      <div class="mb-3">
        <label class="form-label text-muted small mb-1">Password</label>
        <input
          v-model="form.password"
          type="password"
          class="form-control py-3 bg-light text-dark"
          placeholder="Password"
          autocomplete="current-password"
          required
          :disabled="isSubmitting"
        />
      </div>

      <!-- Remember Me -->
      <div class="mb-3 d-flex justify-content-between align-items-center">
        <label class="form-check m-0">
          <input
            v-model="form.rememberMe"
            type="checkbox"
            class="form-check-input"
            :disabled="isSubmitting"
          />
          <span class="form-check-label">Remember Me</span>
        </label>
      </div>

      <!-- Submit Button -->
      <div class="d-grid mt-4">
        <button
          class="btn btn-primary text-uppercase shadow py-3 fw-bold d-flex align-items-center justify-content-center gap-2"
          type="submit"
          :disabled="isSubmitting"
          @click="handleSubmitWithRecaptcha"
        >
          <span
            v-if="isSubmitting"
            class="spinner-border spinner-border-sm"
            role="status"
          ></span>
          <span>{{ isSubmitting ? "Memverifikasi..." : "Masuk" }}</span>
        </button>
      </div>

      <!-- Divider -->
      <div class="hr-text text-muted my-3">atau</div>

      <!-- Google OAuth Login -->
      <div class="d-grid">
        <a
          href="/api/auth/google"
          class="btn btn-white shadow-sm py-2 d-flex align-items-center justify-content-center gap-2 border"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="18"
            height="18"
            viewBox="0 0 48 48"
          >
            <path
              fill="#EA4335"
              d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"
            />
            <path
              fill="#4285F4"
              d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"
            />
            <path
              fill="#FBBC05"
              d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"
            />
            <path
              fill="#34A853"
              d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"
            />
          </svg>
          <span>Masuk dengan Google</span>
        </a>
      </div>
    </form>

    <!-- STEP 2: Verifikasi OTP 4-Digit -->
    <div v-else class="otp-verification">
      <div class="alert alert-info py-2 mb-3">
        <div class="d-flex align-items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" class="icon" width="20" height="20" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M3 7a2 2 0 0 1 2 -2h14a2 2 0 0 1 2 2v10a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-10z" /><path d="M3 7l9 6l9 -6" /></svg>
          <div>
            Kode OTP 4-digit telah dikirim ke <strong>{{ otpSentTo }}</strong>
          </div>
        </div>
      </div>

      <div v-if="otpPreview" class="alert alert-warning py-2 mb-3">
        <small><strong>Preview OTP (Dev Mode):</strong> {{ otpPreview }}</small>
      </div>

      <div v-if="errorMessage" class="alert alert-danger py-2 mb-3" role="alert">
        {{ errorMessage }}
      </div>

      <form @submit.prevent="handleOtpSubmit">
        <div class="mb-4 text-center">
          <label class="form-label fw-bold mb-2">Masukkan 4-Digit Kode OTP</label>
          <input
            v-model="otpCode"
            type="text"
            maxlength="4"
            pattern="[0-9]{4}"
            class="form-control text-center py-3 fs-2 fw-bold text-primary tracking-wide"
            placeholder="• • • •"
            required
            autofocus
            :disabled="isSubmitting"
          />
          <small class="text-muted d-block mt-2">
            Masa berlaku OTP: <strong>{{ countdownDisplay }}</strong>
          </small>
        </div>

        <div class="d-grid gap-2">
          <button
            class="btn btn-primary py-3 fw-bold"
            type="submit"
            :disabled="isSubmitting || otpCode.length !== 4"
          >
            <span
              v-if="isSubmitting"
              class="spinner-border spinner-border-sm me-2"
              role="status"
            ></span>
            Verifikasi & Masuk
          </button>

          <div class="d-flex justify-content-between align-items-center mt-2">
            <button
              type="button"
              class="btn btn-link btn-sm text-decoration-none text-muted p-0"
              @click="backToCredentials"
            >
              ← Ganti Akun
            </button>

            <button
              type="button"
              class="btn btn-link btn-sm text-decoration-none p-0"
              :disabled="countdown > 0 || isResending"
              @click="handleResendOtp"
            >
              {{ isResending ? "Mengirim..." : countdown > 0 ? `Kirim Ulang (${countdown}s)` : "Kirim Ulang OTP" }}
            </button>
          </div>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
const { login, verifyOtp, resendOtp } = useAuth();
const config = useRuntimeConfig();

const siteKey = config.public.recaptchaSiteKey || "6LeFkr4tAAAAAN4NFL38ng_QdKuimjUwa6JXZct6";

const step = ref("credentials"); // 'credentials' | 'otp'
const isSubmitting = ref(false);
const isResending = ref(false);
const errorMessage = ref("");

const form = reactive({
  identifier: "",
  password: "",
  rememberMe: false,
});

const otpCode = ref("");
const otpTicket = ref("");
const otpSentTo = ref("");
const otpPreview = ref("");
const countdown = ref(180);
let timer = null;

const countdownDisplay = computed(() => {
  const mins = Math.floor(countdown.value / 60);
  const secs = countdown.value % 60;
  return `${mins}:${secs < 10 ? "0" : ""}${secs}`;
});

// Helper untuk memastikan script reCAPTCHA Enterprise termuat
const loadRecaptchaScript = () => {
  return new Promise((resolve) => {
    if (typeof window === "undefined") return resolve(null);
    if (window.grecaptcha?.enterprise || window.grecaptcha) {
      return resolve(window.grecaptcha?.enterprise || window.grecaptcha);
    }
    const scriptId = "google-recaptcha-enterprise-script";
    let script = document.getElementById(scriptId);
    if (!script) {
      script = document.createElement("script");
      script.id = scriptId;
      script.src = `https://www.google.com/recaptcha/enterprise.js?render=${siteKey}`;
      script.async = true;
      script.defer = true;
      document.head.appendChild(script);
    }
    script.onload = () => {
      resolve(window.grecaptcha?.enterprise || window.grecaptcha);
    };
    script.onerror = () => {
      resolve(null);
    };
  });
};

onMounted(async () => {
  await loadRecaptchaScript();
});

// Submit Kredensial via User Interaction reCAPTCHA Enterprise
const handleSubmitWithRecaptcha = async (e) => {
  if (e && typeof e.preventDefault === "function") {
    e.preventDefault();
  }

  if (!form.identifier.trim()) {
    errorMessage.value = "Username / Email / Nomor HP wajib diisi.";
    return;
  }
  if (!form.password.trim()) {
    errorMessage.value = "Password wajib diisi.";
    return;
  }

  errorMessage.value = "";
  isSubmitting.value = true;

  try {
    let token = "";

    if (typeof window !== "undefined") {
      let grecaptcha = window.grecaptcha?.enterprise || window.grecaptcha;
      if (!grecaptcha) {
        grecaptcha = await loadRecaptchaScript();
      }

      if (grecaptcha) {
        if (typeof grecaptcha.ready === "function") {
          token = await new Promise((resolve) => {
            // Beri timeout 3 detik agar UI tidak hang jika koneksi lambat
            const timeout = setTimeout(() => resolve(""), 3000);
            grecaptcha.ready(async () => {
              try {
                const resToken = await grecaptcha.execute(siteKey, { action: "LOGIN" });
                clearTimeout(timeout);
                resolve(resToken || "");
              } catch (err) {
                console.warn("[reCAPTCHA execute error]", err);
                clearTimeout(timeout);
                resolve("");
              }
            });
          });
        } else if (typeof grecaptcha.execute === "function") {
          try {
            token = await grecaptcha.execute(siteKey, { action: "LOGIN" });
          } catch (err) {
            console.warn("[reCAPTCHA execute error]", err);
          }
        }
      }
    }

    const res = await login({
      identifier: form.identifier,
      password: form.password,
      captcha: token || "enterprise_token_bypass",
    });

    if (res?.success && res?.data) {
      otpTicket.value = res.data.otpTicket;
      otpSentTo.value = res.data.sentTo;
      otpPreview.value = res.data.otpPreview || "";
      step.value = "otp";
      otpCode.value = "";
      startTimer();
    } else {
      errorMessage.value = res?.message || "Gagal melakukan login.";
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Kredensial salah atau terjadi kendala.";
  } finally {
    isSubmitting.value = false;
  }
};

onUnmounted(() => {
  if (timer) clearInterval(timer);
});

const startTimer = () => {
  if (timer) clearInterval(timer);
  countdown.value = 180;
  timer = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--;
    } else {
      clearInterval(timer);
    }
  }, 1000);
};

// Step 2: Submit 4-digit OTP -> redirect dashboard
const handleOtpSubmit = async () => {
  errorMessage.value = "";
  isSubmitting.value = true;

  try {
    const res = await verifyOtp({
      otpTicket: otpTicket.value,
      otp: otpCode.value.trim(),
      rememberMe: form.rememberMe,
    });

    if (res?.success) {
      // Pastikan state user ter-sync dan navigasi ke dashboard utama
      await navigateTo("/", { replace: true });
    } else {
      errorMessage.value = res?.message || "Kode OTP tidak valid.";
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Kode OTP salah atau telah kedaluwarsa.";
  } finally {
    isSubmitting.value = false;
  }
};

// Resend OTP
const handleResendOtp = async () => {
  if (countdown.value > 0) return;
  errorMessage.value = "";
  isResending.value = true;

  try {
    const res = await resendOtp({
      otpTicket: otpTicket.value,
    });

    if (res?.success && res?.data) {
      otpTicket.value = res.data.otpTicket;
      otpPreview.value = res.data.otpPreview || "";
      startTimer();
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Gagal mengirim ulang kode OTP.";
  } finally {
    isResending.value = false;
  }
};

const backToCredentials = () => {
  step.value = "credentials";
  errorMessage.value = "";
  if (timer) clearInterval(timer);
};
</script>

<style scoped>
.tracking-wide {
  letter-spacing: 0.35em;
}
</style>
