<template>
  <div class="card">
    <div class="card-header">
      <h3 class="card-title">Pengaturan Besaran Tarif & Aturan Jarak Tunjangan Transport</h3>
    </div>
    <div class="card-body">
      <div v-if="alertMessage" :class="`alert alert-${alertType} alert-dismissible mb-3`" role="alert">
        <div class="d-flex">
          <div>{{ alertMessage }}</div>
        </div>
        <a class="btn-close" @click="alertMessage = ''" aria-label="close"></a>
      </div>

      <div v-if="isLoading" class="text-center py-4">
        <div class="spinner-border text-primary" role="status"></div>
        <div class="mt-2 text-muted">Memuat data pengaturan...</div>
      </div>

      <form v-else @submit.prevent="handleSubmit">
        <div class="row g-3">
          <!-- Tarif Base Fare -->
          <div class="col-md-6">
            <label class="form-label required">Tarif per Kilometer (Base Fare)</label>
            <div class="input-group">
              <span class="input-group-text">Rp</span>
              <input
                type="text"
                v-model="displayBaseFare"
                @input="handleFareInput"
                class="form-control text-end"
                placeholder="5.000"
                required
              />
              <span class="input-group-text">/ km</span>
            </div>
            <small class="form-hint">Ketik angka saja, otomatis terformat Rupiah.</small>
          </div>

          <!-- Berlaku Mulai -->
          <div class="col-md-6">
            <label class="form-label required">Berlaku Mulai</label>
            <input
              type="date"
              v-model="form.effective_start"
              class="form-control"
              required
            />
            <small class="form-hint">Tanggal mulai berlakunya pengaturan tarif ini.</small>
          </div>

          <!-- Minimum Kilometer -->
          <div class="col-md-6">
            <label class="form-label required">Minimum Kilometer</label>
            <div class="input-group">
              <input
                type="number"
                v-model.number="form.min_km"
                min="0"
                step="0.1"
                class="form-control"
                placeholder="5"
                required
              />
              <span class="input-group-text">km</span>
            </div>
            <small class="form-hint">Jarak &le; batas ini tidak mendapatkan tunjangan transport.</small>
          </div>

          <!-- Maksimum Kilometer -->
          <div class="col-md-6">
            <label class="form-label required">Maksimum Kilometer</label>
            <div class="input-group">
              <input
                type="number"
                v-model.number="form.max_km"
                min="0"
                step="0.1"
                class="form-control"
                placeholder="25"
                required
              />
              <span class="input-group-text">km</span>
            </div>
            <small class="form-hint">Batas maksimal jarak yang diperhitungkan (kelebihan jarak dicap).</small>
          </div>

          <!-- Minimum Hari Kerja -->
          <div class="col-md-6">
            <label class="form-label required">Syarat Minimal Hari Masuk Kerja</label>
            <div class="input-group">
              <input
                type="number"
                v-model.number="form.min_work_days"
                min="1"
                class="form-control"
                placeholder="19"
                required
              />
              <span class="input-group-text">hari</span>
            </div>
            <small class="form-hint">Minimal hari kerja hadir pegawai per bulan (default 19 hari).</small>
          </div>
        </div>

        <div class="mt-4 pt-3 border-top d-flex gap-2">
          <button type="submit" class="btn btn-primary" :disabled="isSaving">
            <span v-if="isSaving" class="spinner-border spinner-border-sm me-2" role="status"></span>
            Simpan Pengaturan
          </button>
          <NuxtLink to="/tunjangan/transport" class="btn btn-outline-secondary">
            Kembali ke Daftar Periode
          </NuxtLink>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";

const isLoading = ref(true);
const isSaving = ref(false);
const alertMessage = ref("");
const alertType = ref("success");

const form = ref({
  base_fare: 5000,
  effective_start: new Date().toISOString().slice(0, 10),
  min_km: 5,
  max_km: 25,
  min_work_days: 19,
});

// Format input rupiah
const displayBaseFare = ref("5.000");

function formatNumber(val) {
  if (val == null || isNaN(val)) return "0";
  return new Intl.NumberFormat("id-ID").format(val);
}

function handleFareInput(e) {
  const cleanVal = e.target.value.replace(/\D/g, "");
  const num = cleanVal ? parseInt(cleanVal, 10) : 0;
  form.value.base_fare = num;
  displayBaseFare.value = formatNumber(num);
}

// Load data setting aktif saat form diakses
async function loadSetting() {
  try {
    isLoading.value = true;
    const res = await $fetch("/api/transport/settings");
    if (res?.success && res.data) {
      form.value.base_fare = Number(res.data.base_fare) || 5000;
      form.value.effective_start = res.data.effective_start
        ? String(res.data.effective_start).slice(0, 10)
        : new Date().toISOString().slice(0, 10);
      form.value.min_km = Number(res.data.min_km) ?? 5;
      form.value.max_km = Number(res.data.max_km) ?? 25;
      form.value.min_work_days = Number(res.data.min_work_days) ?? 19;
      displayBaseFare.value = formatNumber(form.value.base_fare);
    }
  } catch (err) {
    alertType.value = "danger";
    alertMessage.value = err?.data?.message || "Gagal memuat pengaturan tunjangan transport.";
  } finally {
    isLoading.value = false;
  }
}

// Submit form simpan setting baru
async function handleSubmit() {
  if (form.value.max_km < form.value.min_km) {
    alertType.value = "danger";
    alertMessage.value = "Maksimum kilometer tidak boleh lebih kecil dari minimum kilometer.";
    return;
  }

  try {
    isSaving.value = true;
    alertMessage.value = "";
    const res = await $fetch("/api/transport/settings", {
      method: "POST",
      body: {
        base_fare: Number(form.value.base_fare),
        effective_start: form.value.effective_start,
        min_km: Number(form.value.min_km),
        max_km: Number(form.value.max_km),
        min_work_days: Number(form.value.min_work_days),
      },
    });

    if (res?.success) {
      alertType.value = "success";
      alertMessage.value = "Pengaturan tunjangan transport berhasil disimpan!";
    }
  } catch (err) {
    alertType.value = "danger";
    alertMessage.value = err?.data?.message || "Gagal menyimpan pengaturan.";
  } finally {
    isSaving.value = false;
  }
}

onMounted(() => {
  loadSetting();
});
</script>
