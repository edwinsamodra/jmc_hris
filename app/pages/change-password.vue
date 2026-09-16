<script setup>
import {
  IconKey,
  IconEye,
  IconEyeOff,
  IconCheck,
  IconAlertCircle,
  IconLock,
  IconShieldLock,
  IconRefresh,
  IconArrowLeft,
} from "@tabler/icons-vue";

definePageMeta({
  title: "Ganti Password",
});

useSeoMeta({
  title: "Ganti Password - HRIS",
});

const { user } = useAuth();
const currentUsername = computed(() => user.value?.username || "");

const form = ref({
  currentPassword: "",
  newPassword: "",
  confirmPassword: "",
});

const showCurrentPassword = ref(false);
const showNewPassword = ref(false);
const showConfirmPassword = ref(false);

const isSubmitting = ref(false);
const alertMessage = ref("");
const alertType = ref("success"); // 'success' | 'danger'
const fieldErrors = ref({});

// Evaluasi aturan password baru secara reaktif
const passwordCriteria = computed(() => {
  const p = form.value.newPassword || "";
  return {
    length: p.length >= 8,
    noSpace: p.length > 0 && !/\s/.test(p),
    upper: /[A-Z]/.test(p),
    lower: /[a-z]/.test(p),
    symbol: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(p),
  };
});

// Validasi onkeyup untuk password baru
const validateNewPasswordOnKeyUp = () => {
  fieldErrors.value.newPassword = "";
  const p = form.value.newPassword;
  if (!p) return;

  if (p.length < 8) {
    fieldErrors.value.newPassword = "Password minimal 8 karakter.";
  } else if (/\s/.test(p)) {
    fieldErrors.value.newPassword = "Password tidak boleh mengandung spasi.";
  } else if (!/[A-Z]/.test(p)) {
    fieldErrors.value.newPassword = "Password harus mengandung minimal 1 huruf besar.";
  } else if (!/[a-z]/.test(p)) {
    fieldErrors.value.newPassword = "Password harus mengandung minimal 1 huruf kecil.";
  } else if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(p)) {
    fieldErrors.value.newPassword = "Password harus mengandung minimal 1 karakter khusus / simbol.";
  }

  // Cek juga konfirmasi jika sudah diisi
  if (form.value.confirmPassword) {
    validateConfirmPasswordOnKeyUp();
  }
};

// Validasi onkeyup untuk konfirmasi password
const validateConfirmPasswordOnKeyUp = () => {
  fieldErrors.value.confirmPassword = "";
  if (!form.value.confirmPassword) return;

  if (form.value.confirmPassword !== form.value.newPassword) {
    fieldErrors.value.confirmPassword = "Konfirmasi password tidak cocok dengan password baru.";
  }
};

// Generate Random Password
const generatePassword = () => {
  const upper = "ABCDEFGHJKLMNPQRSTUVWXYZ";
  const lower = "abcdefghijkmnopqrstuvwxyz";
  const numbers = "23456789";
  const symbols = "@#$%&*!_+-=";

  let pwd = "";
  pwd += upper[Math.floor(Math.random() * upper.length)];
  pwd += lower[Math.floor(Math.random() * lower.length)];
  pwd += numbers[Math.floor(Math.random() * numbers.length)];
  pwd += symbols[Math.floor(Math.random() * symbols.length)];

  const allChars = upper + lower + numbers + symbols;
  for (let i = 0; i < 8; i++) {
    pwd += allChars[Math.floor(Math.random() * allChars.length)];
  }

  // Acak karakter
  const generated = pwd
    .split("")
    .sort(() => 0.5 - Math.random())
    .join("");

  form.value.newPassword = generated;
  form.value.confirmPassword = generated;

  showNewPassword.value = true;
  showConfirmPassword.value = true;

  fieldErrors.value.newPassword = "";
  fieldErrors.value.confirmPassword = "";
};

// Reset Form
const resetForm = () => {
  form.value.currentPassword = "";
  form.value.newPassword = "";
  form.value.confirmPassword = "";
  fieldErrors.value = {};
};

// Submit Ganti Password
const handleSubmit = async () => {
  alertMessage.value = "";
  fieldErrors.value = {};

  if (!form.value.currentPassword) {
    fieldErrors.value.currentPassword = "Password saat ini wajib diisi.";
  }

  if (!form.value.newPassword) {
    fieldErrors.value.newPassword = "Password baru wajib diisi.";
  } else {
    validateNewPasswordOnKeyUp();
  }

  if (!form.value.confirmPassword) {
    fieldErrors.value.confirmPassword = "Konfirmasi password baru wajib diisi.";
  } else if (form.value.confirmPassword !== form.value.newPassword) {
    fieldErrors.value.confirmPassword = "Konfirmasi password tidak cocok.";
  }

  if (Object.keys(fieldErrors.value).some((k) => fieldErrors.value[k])) {
    return;
  }

  try {
    isSubmitting.value = true;
    const res = await $fetch("/api/profile/change-password", {
      method: "PUT",
      body: {
        currentPassword: form.value.currentPassword,
        newPassword: form.value.newPassword,
        confirmPassword: form.value.confirmPassword,
      },
    });

    if (res?.success) {
      alertType.value = "success";
      alertMessage.value = res.message || "Password Anda berhasil diperbarui!";
      resetForm();
    }
  } catch (err) {
    console.error("Change password error:", err);
    alertType.value = "danger";
    alertMessage.value =
      err?.data?.message || err?.message || "Terjadi kesalahan saat memperbarui password.";
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<template>
  <div class="row justify-content-center">
    <div class="col-md-8 col-lg-6">
      <!-- Back to Profile Link -->
      <div class="mb-3">
        <NuxtLink to="/profile" class="btn btn-link link-secondary px-0 text-decoration-none d-inline-flex align-items-center gap-1">
          <IconArrowLeft :size="18" />
          <span>Kembali ke My Profile</span>
        </NuxtLink>
      </div>

      <!-- Alert Notifikasi -->
      <div
        v-if="alertMessage"
        class="alert alert-dismissible d-flex align-items-center mb-3"
        :class="alertType === 'success' ? 'alert-success' : 'alert-danger'"
        role="alert"
      >
        <IconCheck v-if="alertType === 'success'" class="me-2" :size="20" />
        <IconAlertCircle v-else class="me-2" :size="20" />
        <div class="flex-grow-1">{{ alertMessage }}</div>
        <button
          type="button"
          class="btn-close"
          @click="alertMessage = ''"
          aria-label="Close"
        ></button>
      </div>

      <!-- Card Form Ganti Password -->
      <div class="card shadow-sm border-0">
        <div class="card-header bg-transparent py-3">
          <h3 class="card-title fw-bold text-dark d-flex align-items-center gap-2 mb-0">
            <IconShieldLock :size="22" class="text-primary" />
            Ganti Password Akun
          </h3>
        </div>

        <div class="card-body p-4">
          <form @submit.prevent="handleSubmit">
            <!-- Hidden username field for accessibility & password manager standards -->
            <input
              type="text"
              name="username"
              :value="currentUsername"
              autocomplete="username"
              tabindex="-1"
              aria-hidden="true"
              style="display: none;"
            />

            <!-- 1. CURRENT PASSWORD -->
            <div class="mb-3">
              <label class="form-label required">Password Saat Ini</label>
              <div class="input-group">
                <input
                  v-model="form.currentPassword"
                  :type="showCurrentPassword ? 'text' : 'password'"
                  class="form-control"
                  :class="{ 'is-invalid': fieldErrors.currentPassword }"
                  placeholder="Masukkan password saat ini..."
                  autocomplete="current-password"
                />
                <button
                  class="btn btn-outline-secondary"
                  type="button"
                  tabindex="-1"
                  @click="showCurrentPassword = !showCurrentPassword"
                >
                  <IconEye v-if="!showCurrentPassword" :size="18" />
                  <IconEyeOff v-else :size="18" />
                </button>
              </div>
              <div v-if="fieldErrors.currentPassword" class="invalid-feedback d-block">
                {{ fieldErrors.currentPassword }}
              </div>
            </div>

            <!-- 2. NEW PASSWORD -->
            <div class="mb-3">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label required mb-0">Password Baru</label>
                <button
                  type="button"
                  class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1"
                  @click="generatePassword"
                >
                  <IconKey :size="14" />
                  <span>Generate Password</span>
                </button>
              </div>
              <div class="input-group">
                <input
                  v-model="form.newPassword"
                  :type="showNewPassword ? 'text' : 'password'"
                  class="form-control"
                  :class="{ 'is-invalid': fieldErrors.newPassword }"
                  placeholder="Masukkan password baru..."
                  autocomplete="new-password"
                  @keyup="validateNewPasswordOnKeyUp"
                  @input="validateNewPasswordOnKeyUp"
                />
                <button
                  class="btn btn-outline-secondary"
                  type="button"
                  tabindex="-1"
                  @click="showNewPassword = !showNewPassword"
                >
                  <IconEye v-if="!showNewPassword" :size="18" />
                  <IconEyeOff v-else :size="18" />
                </button>
              </div>
              <div v-if="fieldErrors.newPassword" class="invalid-feedback d-block">
                {{ fieldErrors.newPassword }}
              </div>

              <!-- Indikator Kriteria Password OnKeyUp -->
              <div class="mt-2 p-3 bg-light rounded border border-light-subtle">
                <div class="fw-semibold text-secondary small mb-2">Syarat & Ketentuan Password:</div>
                <div class="row g-2 small">
                  <div class="col-6 d-flex align-items-center gap-1" :class="passwordCriteria.length ? 'text-success fw-medium' : 'text-muted'">
                    <IconCheck v-if="passwordCriteria.length" :size="15" />
                    <span v-else>•</span>
                    Minimal 8 karakter
                  </div>
                  <div class="col-6 d-flex align-items-center gap-1" :class="passwordCriteria.noSpace ? 'text-success fw-medium' : 'text-muted'">
                    <IconCheck v-if="passwordCriteria.noSpace" :size="15" />
                    <span v-else>•</span>
                    Tidak boleh ada spasi
                  </div>
                  <div class="col-6 d-flex align-items-center gap-1" :class="passwordCriteria.upper ? 'text-success fw-medium' : 'text-muted'">
                    <IconCheck v-if="passwordCriteria.upper" :size="15" />
                    <span v-else>•</span>
                    Min. 1 huruf besar (A-Z)
                  </div>
                  <div class="col-6 d-flex align-items-center gap-1" :class="passwordCriteria.lower ? 'text-success fw-medium' : 'text-muted'">
                    <IconCheck v-if="passwordCriteria.lower" :size="15" />
                    <span v-else>•</span>
                    Min. 1 huruf kecil (a-z)
                  </div>
                  <div class="col-12 d-flex align-items-center gap-1" :class="passwordCriteria.symbol ? 'text-success fw-medium' : 'text-muted'">
                    <IconCheck v-if="passwordCriteria.symbol" :size="15" />
                    <span v-else>•</span>
                    Min. 1 karakter khusus / simbol (@, #, $, %, dll)
                  </div>
                </div>
              </div>
            </div>

            <!-- 3. CONFIRM PASSWORD -->
            <div class="mb-4">
              <label class="form-label required">Konfirmasi Password Baru</label>
              <div class="input-group">
                <input
                  v-model="form.confirmPassword"
                  :type="showConfirmPassword ? 'text' : 'password'"
                  class="form-control"
                  :class="{ 'is-invalid': fieldErrors.confirmPassword }"
                  placeholder="Ketik ulang password baru..."
                  autocomplete="new-password"
                  @keyup="validateConfirmPasswordOnKeyUp"
                  @input="validateConfirmPasswordOnKeyUp"
                />
                <button
                  class="btn btn-outline-secondary"
                  type="button"
                  tabindex="-1"
                  @click="showConfirmPassword = !showConfirmPassword"
                >
                  <IconEye v-if="!showConfirmPassword" :size="18" />
                  <IconEyeOff v-else :size="18" />
                </button>
              </div>
              <div v-if="fieldErrors.confirmPassword" class="invalid-feedback d-block">
                {{ fieldErrors.confirmPassword }}
              </div>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="d-flex gap-2 justify-content-end border-top pt-3">
              <button
                type="button"
                class="btn btn-outline-secondary"
                :disabled="isSubmitting"
                @click="resetForm"
              >
                Reset
              </button>
              <button
                type="submit"
                class="btn btn-primary d-inline-flex align-items-center gap-2"
                :disabled="isSubmitting"
              >
                <span
                  v-if="isSubmitting"
                  class="spinner-border spinner-border-sm"
                  role="status"
                ></span>
                <IconLock v-else :size="18" />
                <span>Simpan Password Baru</span>
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>
