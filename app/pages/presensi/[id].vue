<template>
  <NuxtLayout name="default">
    <template #actions>
      <div class="d-flex gap-2">
        <NuxtLink
          to="/presensi"
          class="btn btn-outline-secondary"
        >
          <IconArrowLeft size="18" class="me-1" />
          <span>Kembali</span>
        </NuxtLink>

        <!-- Tombol Tambah Presensi khusus Admin HRD (CRUD access) -->
        <button
          v-if="can('attendance', 'create')"
          type="button"
          class="btn btn-primary"
          @click="openAddModal"
        >
          <IconPlus size="18" class="me-1" />
          <span>Tambah Presensi</span>
        </button>
      </div>
    </template>

    <!-- Error Alert -->
    <div v-if="errorMessage" class="alert alert-danger d-flex align-items-center gap-2 mb-3">
      <IconAlertCircle :size="20" />
      <div>{{ errorMessage }}</div>
    </div>

    <!-- Header Profil Pegawai & Selector Periode -->
    <div class="card mb-3 shadow-sm border-0">
      <div class="card-body">
        <div class="row g-3 align-items-center">
          <div class="col-12 col-md-7">
            <div class="d-flex align-items-center gap-3">
              <div class="avatar avatar-lg rounded bg-primary-lt text-primary fw-bold fs-2">
                {{ employee?.name ? employee.name.charAt(0) : "P" }}
              </div>
              <div>
                <h2 class="card-title fw-bold text-dark m-0 fs-3">
                  {{ employee?.name || "Memuat..." }}
                </h2>
                <div class="text-muted small mt-1">
                  NIP: <strong>{{ employee?.nip || "-" }}</strong> &bull;
                  Jabatan: <strong>{{ employee?.position || "-" }}</strong> &bull;
                  Departemen: <strong>{{ employee?.department || "-" }}</strong>
                </div>
                <div class="mt-1">
                  <span class="badge bg-blue-lt me-1 text-uppercase">
                    {{ employee?.employmentType || "PKWTT" }}
                  </span>
                  <span
                    class="badge"
                    :class="employee?.status === 'active' ? 'bg-success-lt text-success' : 'bg-danger-lt text-danger'"
                  >
                    {{ employee?.status === "active" ? "Aktif" : "Nonaktif" }}
                  </span>
                </div>
              </div>
            </div>
          </div>

          <!-- Filter Periode Bulan / Tahun -->
          <div class="col-12 col-md-5">
            <div class="row g-2 align-items-end justify-content-md-end">
              <div class="col-6 col-sm-6">
                <label class="form-label small fw-bold text-muted">Bulan Periode</label>
                <select
                  v-model="selectedMonth"
                  class="form-select form-select-sm"
                  @change="handlePeriodChange"
                >
                  <option v-for="m in months" :key="m.value" :value="m.value">
                    {{ m.label }}
                  </option>
                </select>
              </div>
              <div class="col-6 col-sm-4">
                <label class="form-label small fw-bold text-muted">Tahun</label>
                <select
                  v-model="selectedYear"
                  class="form-select form-select-sm"
                  @change="handlePeriodChange"
                >
                  <option v-for="y in availableYears" :key="y" :value="y">
                    {{ y }}
                  </option>
                </select>
              </div>
              <div class="col-auto">
                <button
                  type="button"
                  class="btn btn-sm btn-outline-secondary"
                  title="Muat Ulang"
                  @click="fetchDetails"
                >
                  <IconRefresh :size="16" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Ringkasan Statistik Periode Terpilih -->
    <div class="row g-3 mb-3">
      <!-- Hadir -->
      <div class="col-6 col-md-3">
        <div class="card card-sm shadow-sm border-0 bg-body">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-auto">
                <span class="avatar bg-blue-lt rounded">
                  <IconCheck :size="22" />
                </span>
              </div>
              <div class="col">
                <div class="text-muted small">Total Hadir</div>
                <div class="fs-2 fw-bold text-primary">
                  {{ Number(summary.hadir).toFixed(1) }} <span class="fs-5 text-muted fw-normal">Hari</span>
                </div>
                <div class="mt-1">
                  <span
                    class="badge"
                    :class="summary.statusHadir === 'Terpenuhi' ? 'bg-success text-white' : 'bg-danger text-white'"
                  >
                    {{ summary.statusHadir }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Cuti -->
      <div class="col-6 col-md-3">
        <div class="card card-sm shadow-sm border-0 bg-body">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-auto">
                <span class="avatar bg-yellow-lt rounded">
                  <IconCalendar :size="22" />
                </span>
              </div>
              <div class="col">
                <div class="text-muted small">Cuti Terpakai</div>
                <div class="fs-2 fw-bold text-warning">
                  {{ Number(summary.cuti).toFixed(1) }} <span class="fs-5 text-muted fw-normal">Hari</span>
                </div>
                <div class="text-muted small mt-1">
                  Kuota: <strong>{{ Number(summary.kuotaCuti).toFixed(1) }}</strong> Hari
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Izin -->
      <div class="col-6 col-md-3">
        <div class="card card-sm shadow-sm border-0 bg-body">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-auto">
                <span class="avatar bg-purple-lt rounded">
                  <IconClock :size="22" />
                </span>
              </div>
              <div class="col">
                <div class="text-muted small">Izin</div>
                <div class="fs-2 fw-bold text-purple">
                  {{ Number(summary.izin).toFixed(1) }} <span class="fs-5 text-muted fw-normal">Hari</span>
                </div>
                <div class="text-muted small mt-1">
                  Kuota: <strong>{{ Number(summary.kuotaIzin).toFixed(1) }}</strong> Hari
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Unpaid Leave -->
      <div class="col-6 col-md-3">
        <div class="card card-sm shadow-sm border-0 bg-body">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-auto">
                <span class="avatar bg-red-lt rounded">
                  <IconX :size="22" />
                </span>
              </div>
              <div class="col">
                <div class="text-muted small">Unpaid Leave</div>
                <div class="fs-2 fw-bold text-danger">
                  {{ Number(summary.unpaidLeave).toFixed(1) }} <span class="fs-5 text-muted fw-normal">Hari</span>
                </div>
                <div class="text-muted small mt-1">
                  Kuota: <strong>{{ Number(summary.kuotaUnpaidLeave).toFixed(1) }}</strong> Hari
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Tabel Detail Presensi Harian -->
    <div class="card shadow-sm border-0">
      <div class="card-header bg-body d-flex justify-content-between align-items-center py-3">
        <h3 class="card-title fw-bold m-0 text-primary">
          Riwayat Presensi Harian
        </h3>
        <span class="text-muted small">
          Total: <strong>{{ items.length }}</strong> Catatan Presensi
        </span>
      </div>

      <div class="table-responsive">
        <table class="table table-vcenter table-hover table-striped mb-0">
          <thead class="table-light">
            <tr>
              <th style="width: 130px">Tgl</th>
              <th>Lokasi Checkin</th>
              <th style="width: 120px">Kehadiran</th>
              <th class="text-center" style="width: 130px">Durasi (Hadir)</th>
              <th class="text-center" style="width: 140px">Status</th>
              <th class="text-center" style="width: 120px">Verifikasi</th>
              <th style="width: 120px">Verifikator</th>
              <th>Keterangan</th>
              <!-- Kolom Aksi hanya untuk Admin HRD -->
              <th v-if="can('attendance', 'update') || can('attendance', 'delete')" style="width: 100px" class="text-center">
                Aksi
              </th>
            </tr>
          </thead>
          <tbody>
            <!-- Loading -->
            <tr v-if="isLoading">
              <td :colspan="can('attendance', 'update') ? 9 : 8" class="text-center py-5 text-muted">
                <div class="spinner-border spinner-border-sm text-primary me-2"></div>
                Memuat riwayat harian presensi...
              </td>
            </tr>

            <!-- Empty -->
            <tr v-else-if="items.length === 0">
              <td :colspan="can('attendance', 'update') ? 9 : 8" class="text-center py-5 text-muted">
                <IconCalendar :size="32" class="mb-2 text-secondary opacity-50" />
                <div>Belum ada riwayat presensi harian pada periode ini.</div>
              </td>
            </tr>

            <!-- Data rows -->
            <tr v-else v-for="row in items" :key="row.id">
              <td>
                <div class="fw-bold text-dark">{{ formatDateIndo(row.tgl) }}</div>
                <div class="text-muted small">{{ row.tgl }}</div>
              </td>
              <td>
                <div class="d-flex align-items-center gap-1">
                  <IconBuilding :size="16" class="text-muted" />
                  <span class="fw-semibold">{{ row.lokasiCheckin }}</span>
                </div>
                <div v-if="row.checkinAt && row.checkoutAt" class="text-muted small">
                  {{ row.checkinAt }} - {{ row.checkoutAt }}
                </div>
              </td>
              <td>
                <span
                  class="badge px-2 py-1"
                  :class="{
                    'bg-blue-lt text-primary': row.attendanceType === 'hadir',
                    'bg-yellow-lt text-warning': row.attendanceType === 'cuti',
                    'bg-purple-lt text-purple': row.attendanceType === 'izin',
                    'bg-red-lt text-danger': row.attendanceType === 'unpaid_leave',
                  }"
                >
                  {{ row.kehadiran }}
                </span>
              </td>
              <td class="text-center fw-bold">
                <span v-if="row.attendanceType === 'hadir'">
                  {{ Number(row.durasi).toFixed(1) }} jam
                </span>
                <span v-else class="text-muted">-</span>
              </td>
              <td class="text-center">
                <span
                  class="badge px-2 py-1"
                  :class="row.status === 'Terpenuhi' ? 'bg-success text-white' : 'bg-danger text-white'"
                >
                  {{ row.status }}
                </span>
              </td>
              <td class="text-center">
                <span
                  class="badge px-2 py-1"
                  :class="row.verifikasi === 'Disetujui' ? 'bg-success-lt text-success' : 'bg-danger-lt text-danger'"
                >
                  {{ row.verifikasi }}
                </span>
              </td>
              <td>
                <span class="badge bg-secondary-lt text-secondary">
                  {{ row.verifikator }}
                </span>
              </td>
              <td class="text-muted small">
                {{ row.keterangan || "-" }}
              </td>
              <!-- Tombol Aksi (CRUD) khusus Admin HRD -->
              <td v-if="can('attendance', 'update') || can('attendance', 'delete')" class="text-center">
                <div class="btn-group btn-group-sm">
                  <button
                    v-if="can('attendance', 'update')"
                    type="button"
                    class="btn btn-outline-primary"
                    title="Edit Presensi"
                    @click="openEditModal(row)"
                  >
                    <IconPencil :size="14" />
                  </button>
                  <button
                    v-if="can('attendance', 'delete')"
                    type="button"
                    class="btn btn-outline-danger"
                    title="Hapus Presensi"
                    @click="openDeleteModal(row)"
                  >
                    <IconTrash :size="14" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal Form Tambah / Edit Presensi -->
    <PresensiFormModal
      v-model:show="isFormModalOpen"
      :is-edit="isEditMode"
      :employee-id="Number(employeeId)"
      :employee-name="employee?.name || ''"
      :period-year="Number(selectedYear)"
      :period-month="Number(selectedMonth)"
      :initial-data="selectedRowData"
      @saved="onFormSaved"
    />

    <!-- Modal Konfirmasi Hapus Presensi -->
    <div
      v-if="isDeleteModalOpen"
      class="modal modal-blur fade show d-block"
      tabindex="-1"
      style="background-color: rgba(0, 0, 0, 0.5); z-index: 1055"
    >
      <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content shadow-lg border-0">
          <div class="modal-body text-center py-4">
            <IconAlertCircle :size="48" class="text-danger mb-2" />
            <h4 class="fw-bold text-danger">Hapus Presensi Harian?</h4>
            <p class="text-muted small mb-0">
              Apakah Anda yakin ingin menghapus data presensi tanggal
              <strong>{{ itemToDelete?.tgl }}</strong>?
            </p>
          </div>
          <div class="modal-footer bg-light justify-content-center">
            <button
              type="button"
              class="btn btn-secondary"
              :disabled="isDeleting"
              @click="closeDeleteModal"
            >
              Batal
            </button>
            <button
              type="button"
              class="btn btn-danger"
              :disabled="isDeleting"
              @click="confirmDelete"
            >
              {{ isDeleting ? "Menghapus..." : "Ya, Hapus" }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </NuxtLayout>
</template>

<script setup>
import PresensiFormModal from "@/features/Presensi/components/PresensiFormModal.vue";
import {
  IconAlertCircle,
  IconArrowLeft,
  IconBuilding,
  IconCalendar,
  IconCheck,
  IconClock,
  IconPencil,
  IconPlus,
  IconRefresh,
  IconTrash,
  IconX
} from "@tabler/icons-vue";

definePageMeta({
  title: "Detail Presensi Pegawai",
  layout: false,
});

useSeoMeta({
  title: "Detail Presensi Pegawai - HRIS",
});

const route = useRoute();
const router = useRouter();
const { can } = useAuth();

const employeeId = computed(() => route.params.id);

// Default period from query params or N-1
const now = new Date();
let defaultYear = now.getFullYear();
let defaultMonth = now.getMonth();
if (defaultMonth === 0) {
  defaultMonth = 12;
  defaultYear -= 1;
}

const selectedYear = ref(parseInt(route.query.year || defaultYear, 10));
const selectedMonth = ref(parseInt(route.query.month || defaultMonth, 10));

const employee = ref(null);
const summary = ref({
  hadir: 0,
  statusHadir: "Tidak terpenuhi",
  cuti: 0,
  kuotaCuti: 12,
  izin: 0,
  kuotaIzin: 3,
  unpaidLeave: 0,
  kuotaUnpaidLeave: 5,
});
const items = ref([]);
const isLoading = ref(false);
const errorMessage = ref("");

// Modal states
const isFormModalOpen = ref(false);
const isEditMode = ref(false);
const selectedRowData = ref(null);

// Delete state
const isDeleteModalOpen = ref(false);
const itemToDelete = ref(null);
const isDeleting = ref(false);

const months = [
  { value: 1, label: "Januari" },
  { value: 2, label: "Februari" },
  { value: 3, label: "Maret" },
  { value: 4, label: "April" },
  { value: 5, label: "Mei" },
  { value: 6, label: "Juni" },
  { value: 7, label: "Juli" },
  { value: 8, label: "Agustus" },
  { value: 9, label: "September" },
  { value: 10, label: "Oktober" },
  { value: 11, label: "November" },
  { value: 12, label: "Desember" },
];

const availableYears = computed(() => {
  const current = new Date().getFullYear();
  return [current - 2, current - 1, current, current + 1];
});

const fetchDetails = async () => {
  if (!employeeId.value) return;

  isLoading.value = true;
  errorMessage.value = "";

  try {
    const response = await $fetch(`/api/attendances/${employeeId.value}`, {
      params: {
        year: selectedYear.value,
        month: selectedMonth.value,
      },
    });

    if (response && response.success) {
      employee.value = response.data.employee;
      summary.value = response.data.summary;
      items.value = response.data.items || [];
    } else {
      errorMessage.value = response?.message || "Gagal memuat detail presensi.";
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Terjadi kesalahan saat memuat data presensi.";
  } finally {
    isLoading.value = false;
  }
};

const handlePeriodChange = () => {
  router.replace({
    query: {
      ...route.query,
      year: selectedYear.value,
      month: selectedMonth.value,
    },
  });
  fetchDetails();
};

const openAddModal = () => {
  isEditMode.value = false;
  selectedRowData.value = null;
  isFormModalOpen.value = true;
};

const openEditModal = (item) => {
  isEditMode.value = true;
  selectedRowData.value = { ...item };
  isFormModalOpen.value = true;
};

const openDeleteModal = (item) => {
  itemToDelete.value = item;
  isDeleteModalOpen.value = true;
};

const closeDeleteModal = () => {
  if (isDeleting.value) return;
  isDeleteModalOpen.value = false;
  itemToDelete.value = null;
};

const confirmDelete = async () => {
  if (!itemToDelete.value) return;

  const targetId = itemToDelete.value.id;
  isDeleting.value = true;
  try {
    const response = await $fetch(`/api/attendances/${targetId}`, {
      method: "DELETE",
    });

    if (response && response.success) {
      isDeleteModalOpen.value = false;
      itemToDelete.value = null;
      isDeleting.value = false;
      fetchDetails();
    } else {
      alert(response?.message || "Gagal menghapus presensi.");
    }
  } catch (err) {
    alert(err?.data?.message || "Terjadi kesalahan saat menghapus presensi.");
  } finally {
    isDeleting.value = false;
  }
};

const onFormSaved = () => {
  isFormModalOpen.value = false;
  fetchDetails();
};

const formatDateIndo = (dateStr) => {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return dateStr;
  return d.toLocaleDateString("id-ID", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
};

onMounted(() => {
  fetchDetails();
});
</script>
