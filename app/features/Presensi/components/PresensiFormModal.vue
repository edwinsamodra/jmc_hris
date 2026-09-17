<template>
  <div
    v-if="show"
    class="modal modal-blur fade show d-block"
    tabindex="-1"
    style="background-color: rgba(0, 0, 0, 0.5); z-index: 1055"
  >
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content shadow-lg border-0">
        <!-- Modal Header -->
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title d-flex align-items-center gap-2 text-white">
            <IconCalendarEvent :size="20" />
            {{ isEdit ? "Edit Presensi Harian" : "Tambah Presensi Harian" }}
          </h5>
          <button
            type="button"
            class="btn-close btn-close-white"
            :disabled="isSubmitting"
            @click="closeModal"
            aria-label="Close"
          ></button>
        </div>

        <!-- Form Body -->
        <form @submit.prevent="handleSubmit">
          <div class="modal-body p-4">
            <!-- Info Pegawai -->
            <div class="mb-3 p-2 bg-light rounded border">
              <div class="text-muted small">Pegawai:</div>
              <div class="fw-bold text-dark">{{ employeeName || "-" }}</div>
            </div>

            <!-- Error message alert -->
            <div v-if="errorMessage" class="alert alert-danger py-2 small mb-3">
              {{ errorMessage }}
            </div>

            <!-- Tanggal Presensi -->
            <div class="mb-3">
              <div class="d-flex justify-content-between align-items-center mb-1">
                <label class="form-label required m-0">Tanggal Presensi</label>
                <span v-if="minDate && maxDate" class="text-muted small">
                  Periode: {{ minDate }} s/d {{ maxDate }}
                </span>
              </div>
              <input
                type="date"
                v-model="form.attendance_date"
                :min="minDate"
                :max="maxDate"
                class="form-control"
                required
              />
              <div class="form-text text-muted small">
                Hanya dapat memilih tanggal pada bulan periode terpilih (maksimal hari ini).
              </div>
            </div>

            <!-- Jenis Kehadiran -->
            <div class="mb-3">
              <label class="form-label required">Jenis Kehadiran</label>
              <select v-model="form.attendance_type" class="form-select" required>
                <option value="hadir">Hadir</option>
                <option value="cuti">Cuti</option>
                <option value="izin">Izin</option>
                <option value="unpaid_leave">Unpaid Leave</option>
              </select>
            </div>

            <!-- Bagian Khusus Hadir -->
            <template v-if="form.attendance_type === 'hadir'">
              <div class="row g-2 mb-3">
                <div class="col-6">
                  <label class="form-label required">Jam Masuk (Checkin)</label>
                  <input
                    type="time"
                    step="1"
                    v-model="form.checkin_time"
                    class="form-control"
                    required
                  />
                  <div class="form-text text-muted small">Normal s.d 08:15</div>
                </div>
                <div class="col-6">
                  <label class="form-label required">Jam Pulang (Checkout)</label>
                  <input
                    type="time"
                    step="1"
                    v-model="form.checkout_time"
                    class="form-control"
                    required
                  />
                  <div class="form-text text-muted small">Normal mulai 17:00</div>
                </div>
              </div>

              <div class="row g-2 mb-3">
                <div class="col-6">
                  <label class="form-label required">Lokasi Masuk</label>
                  <select v-model="form.checkin_location" class="form-select" required>
                    <option value="Gedung Utama">Gedung Utama</option>
                    <option value="Gedung A">Gedung A</option>
                    <option value="Gedung B">Gedung B</option>
                  </select>
                </div>
                <div class="col-6">
                  <label class="form-label required">Lokasi Pulang</label>
                  <select v-model="form.checkout_location" class="form-select" required>
                    <option value="Gedung Utama">Gedung Utama</option>
                    <option value="Gedung A">Gedung A</option>
                    <option value="Gedung B">Gedung B</option>
                  </select>
                </div>
              </div>

              <!-- Peringatan Aturan Lokasi -->
              <div
                v-if="form.checkin_location && form.checkout_location && form.checkin_location !== form.checkout_location"
                class="alert alert-warning py-1 px-2 small mb-3"
              >
                Lokasi checkin dan checkout berbeda. Presensi akan dihitung <strong>Tidak terpenuhi</strong> (durasi 0 jam).
              </div>
            </template>

            <!-- Status Verifikasi & Verifikator -->
            <div class="row g-2 mb-3">
              <div class="col-6">
                <label class="form-label required">Status Verifikasi</label>
                <select v-model="form.verification_status" class="form-select" required>
                  <option value="Disetujui">Disetujui</option>
                  <option value="Ditolak">Ditolak</option>
                </select>
              </div>
              <div class="col-6">
                <label class="form-label required">Verifikator</label>
                <select v-model="form.verified_by_role" class="form-select" required>
                  <option value="HRD">HRD</option>
                  <option value="Manager">Manager</option>
                  <option value="Lead">Lead</option>
                </select>
              </div>
            </div>

            <!-- Keterangan -->
            <div class="mb-0">
              <label class="form-label">Keterangan / Alasan</label>
              <textarea
                v-model="form.remarks"
                class="form-control"
                rows="2"
                placeholder="Catatan tambahan (opsional)"
              ></textarea>
            </div>
          </div>

          <!-- Modal Footer -->
          <div class="modal-footer bg-light">
            <button
              type="button"
              class="btn btn-secondary"
              :disabled="isSubmitting"
              @click="closeModal"
            >
              Batal
            </button>
            <button
              type="submit"
              class="btn btn-primary d-inline-flex align-items-center gap-1"
              :disabled="isSubmitting"
            >
              <IconDeviceFloppy :size="16" />
              {{ isSubmitting ? "Menyimpan..." : "Simpan Presensi" }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { IconCalendarEvent, IconDeviceFloppy } from "@tabler/icons-vue";

const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
  isEdit: {
    type: Boolean,
    default: false,
  },
  employeeId: {
    type: Number,
    required: true,
  },
  employeeName: {
    type: String,
    default: "",
  },
  periodYear: {
    type: Number,
    default: null,
  },
  periodMonth: {
    type: Number,
    default: null,
  },
  initialData: {
    type: Object,
    default: () => ({}),
  },
});

const emit = defineEmits(["update:show", "saved"]);

const isSubmitting = ref(false);
const errorMessage = ref("");

// Batas minimum dan maksimum tanggal dinamis sesuai bulan periode & maksimal hari ini
const todayStr = computed(() => new Date().toLocaleDateString("en-CA"));

const minDate = computed(() => {
  if (props.periodYear && props.periodMonth) {
    const y = props.periodYear;
    const m = String(props.periodMonth).padStart(2, "0");
    return `${y}-${m}-01`;
  }
  return undefined;
});

const maxDate = computed(() => {
  const today = todayStr.value;
  if (props.periodYear && props.periodMonth) {
    const y = props.periodYear;
    const m = props.periodMonth;
    // Dapatkan hari terakhir dari bulan periode
    const lastDayOfMonth = new Date(y, m, 0).getDate();
    const endOfMonthStr = `${y}-${String(m).padStart(2, "0")}-${String(lastDayOfMonth).padStart(2, "0")}`;
    
    // Maksimal adalah batas akhir bulan atau hari ini (mana yang lebih kecil)
    return endOfMonthStr < today ? endOfMonthStr : today;
  }
  return today;
});

const form = reactive({
  id: null,
  attendance_date: new Date().toISOString().slice(0, 10),
  attendance_type: "hadir",
  checkin_time: "08:00:00",
  checkout_time: "17:00:00",
  checkin_location: "Gedung Utama",
  checkout_location: "Gedung Utama",
  verification_status: "Disetujui",
  verified_by_role: "HRD",
  remarks: "",
});

watch(
  () => props.show,
  (val) => {
    if (val) {
      errorMessage.value = "";
      if (props.isEdit && props.initialData) {
        form.id = props.initialData.id;
        form.attendance_date = props.initialData.tgl || new Date().toISOString().slice(0, 10);
        form.attendance_type = props.initialData.attendanceType || "hadir";
        form.checkin_time = props.initialData.checkinAt || "08:00:00";
        form.checkout_time = props.initialData.checkoutAt || "17:00:00";
        form.checkin_location = props.initialData.lokasiCheckin && props.initialData.lokasiCheckin !== "-"
          ? props.initialData.lokasiCheckin
          : "Gedung Utama";
        form.checkout_location = props.initialData.lokasiCheckout && props.initialData.lokasiCheckout !== "-"
          ? props.initialData.lokasiCheckout
          : form.checkin_location;
        form.verification_status = props.initialData.verifikasi || "Disetujui";
        form.verified_by_role = props.initialData.verifikator || "HRD";
        form.remarks = props.initialData.keterangan && props.initialData.keterangan !== "-"
          ? props.initialData.keterangan
          : "";
      } else {
        form.id = null;
        
        // Default tanggal: sesuaikan dengan periode yang dibuka
        let initialDate = todayStr.value;
        if (props.periodYear && props.periodMonth) {
          const y = props.periodYear;
          const m = String(props.periodMonth).padStart(2, "0");
          const firstDayOfPeriod = `${y}-${m}-01`;
          const lastDayOfMonth = new Date(y, props.periodMonth, 0).getDate();
          const lastDayOfPeriod = `${y}-${m}-${String(lastDayOfMonth).padStart(2, "0")}`;
          
          if (todayStr.value >= firstDayOfPeriod && todayStr.value <= lastDayOfPeriod) {
            initialDate = todayStr.value;
          } else if (todayStr.value < firstDayOfPeriod) {
            initialDate = todayStr.value;
          } else {
            // Jika periode di masa lalu, default ke awal bulan atau akhir bulan
            initialDate = firstDayOfPeriod;
          }
        }

        form.attendance_date = initialDate;
        form.attendance_type = "hadir";
        form.checkin_time = "08:00:00";
        form.checkout_time = "17:00:00";
        form.checkin_location = "Gedung Utama";
        form.checkout_location = "Gedung Utama";
        form.verification_status = "Disetujui";
        form.verified_by_role = "HRD";
        form.remarks = "";
      }
    }
  },
);

const handleSubmit = async () => {
  isSubmitting.value = true;
  errorMessage.value = "";

  // Validasi frontend: tidak boleh tanggal di masa depan
  const today = todayStr.value;
  if (form.attendance_date > today) {
    errorMessage.value = `Tanggal presensi tidak boleh di masa depan (${form.attendance_date}). Maksimal tanggal presensi adalah hari ini (${today}).`;
    isSubmitting.value = false;
    return;
  }

  // Validasi frontend: harus berada di dalam rentang periode jika periode didefinisikan
  if (minDate.value && form.attendance_date < minDate.value) {
    errorMessage.value = `Tanggal presensi tidak boleh lebih kecil dari awal periode (${minDate.value}).`;
    isSubmitting.value = false;
    return;
  }
  if (maxDate.value && form.attendance_date > maxDate.value) {
    errorMessage.value = `Tanggal presensi tidak boleh melebihi batas periode (${maxDate.value}).`;
    isSubmitting.value = false;
    return;
  }

  try {
    const payload = {
      employee_id: props.employeeId,
      attendance_date: form.attendance_date,
      attendance_type: form.attendance_type,
      verification_status: form.verification_status,
      verified_by_role: form.verified_by_role,
      remarks: form.remarks,
    };

    if (form.attendance_type === "hadir") {
      payload.checkin_location = form.checkin_location;
      payload.checkout_location = form.checkout_location;
      payload.checkin_time = form.checkin_time;
      payload.checkout_time = form.checkout_time;
    }

    let response;
    if (props.isEdit && form.id) {
      response = await $fetch(`/api/attendances/${form.id}`, {
        method: "PUT",
        body: payload,
      });
    } else {
      response = await $fetch("/api/attendances", {
        method: "POST",
        body: payload,
      });
    }

    if (response && response.success) {
      isSubmitting.value = false;
      emit("update:show", false);
      emit("saved");
      return;
    } else {
      errorMessage.value = response?.message || "Gagal menyimpan data presensi.";
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Terjadi kesalahan saat menyimpan presensi.";
  } finally {
    isSubmitting.value = false;
  }
};

const closeModal = () => {
  if (isSubmitting.value) return;
  emit("update:show", false);
};
</script>
