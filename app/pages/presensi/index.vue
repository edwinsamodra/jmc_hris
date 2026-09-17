<template>
  <NuxtLayout name="default">
    <template #actions>
      <div class="d-flex gap-2">
        <button
          v-if="can('attendance', 'create')"
          type="button"
          class="btn btn-outline-primary"
          @click="downloadTemplate"
        >
          <IconFileDownload size="18" class="me-1" />
          <span>Download Template CSV</span>
        </button>

        <!-- Tombol Import CSV khusus Admin HRD (CRUD access) -->
        <button
          v-if="can('attendance', 'create')"
          type="button"
          class="btn btn-primary"
          @click="isImportModalOpen = true"
        >
          <IconUpload size="18" class="me-1" />
          <span>Import CSV</span>
        </button>
      </div>
    </template>

    <!-- Card Filter & Search -->
    <div class="card mb-3 shadow-sm border-0">
      <div class="card-body">
        <div class="row g-3 align-items-end">
          <!-- Filter Periode Bulan -->
          <div class="col-12 col-md-3">
            <label class="form-label small fw-bold text-muted">Bulan Periode</label>
            <select
              v-model="selectedMonth"
              class="form-select"
              @change="handleFilterChange"
            >
              <option v-for="m in months" :key="m.value" :value="m.value">
                {{ m.label }}
              </option>
            </select>
          </div>

          <!-- Filter Periode Tahun -->
          <div class="col-12 col-md-2">
            <label class="form-label small fw-bold text-muted">Tahun</label>
            <select
              v-model="selectedYear"
              class="form-select"
              @change="handleFilterChange"
            >
              <option v-for="y in availableYears" :key="y" :value="y">
                {{ y }}
              </option>
            </select>
          </div>

          <!-- Input Search Nama / NIP -->
          <div class="col-12 col-md-5">
            <label class="form-label small fw-bold text-muted">Pencarian Pegawai</label>
            <div class="input-icon">
              <input
                type="text"
                v-model="searchQuery"
                class="form-control"
                placeholder="Cari berdasarkan nama atau NIP..."
                @keyup.enter="handleSearch"
              />
              <span class="input-icon-addon">
                <IconSearch :size="18" class="text-muted" />
              </span>
            </div>
          </div>

          <!-- Tombol Aksi Filter -->
          <div class="col-12 col-md-2 d-flex gap-2">
            <button
              type="button"
              class="btn btn-primary flex-fill d-inline-flex align-items-center justify-content-center gap-1"
              @click="handleSearch"
            >
              <IconSearch :size="16" />
              <span>Cari</span>
            </button>
            <button
              type="button"
              class="btn btn-outline-secondary"
              title="Reset Filter"
              @click="handleReset"
            >
              <IconRefresh :size="16" />
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Error Alert -->
    <div v-if="errorMessage" class="alert alert-danger d-flex align-items-center gap-2 mb-3">
      <IconAlertCircle :size="20" />
      <div>{{ errorMessage }}</div>
    </div>

    <!-- Tabel Rekap Presensi -->
    <div class="card shadow-sm border-0">
      <div class="card-header bg-body d-flex justify-content-between align-items-center py-3">
        <h3 class="card-title fw-bold m-0 text-primary">
          Data Rekapitulasi Presensi Pegawai
        </h3>
        <span class="badge bg-blue-lt px-3 py-2 fs-6">
          Periode: {{ months.find((m) => m.value === selectedMonth)?.label }} {{ selectedYear }}
        </span>
      </div>

      <div class="table-responsive">
        <table class="table table-vcenter table-hover table-striped mb-0">
          <thead class="table-light">
            <tr>
              <th style="width: 60px" class="text-center">No.</th>
              <th>Nama Pegawai</th>
              <th>Jabatan</th>
              <th class="text-center" style="width: 90px">Hadir</th>
              <th class="text-center" style="width: 140px">Status Hadir</th>
              <th class="text-center" style="width: 80px">Cuti</th>
              <th class="text-center" style="width: 100px">Kuota Cuti</th>
              <th class="text-center" style="width: 80px">Izin</th>
              <th class="text-center" style="width: 100px">Kuota Izin</th>
              <th class="text-center" style="width: 110px">Unpaid Leave</th>
              <th class="text-center" style="width: 130px">Kuota Unpaid Leave</th>
              <th style="width: 100px" class="text-center">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <!-- Loading row -->
            <tr v-if="isLoading">
              <td colspan="12" class="text-center py-5 text-muted">
                <div class="spinner-border spinner-border-sm text-primary me-2"></div>
                Memuat data rekap presensi...
              </td>
            </tr>

            <!-- Empty row -->
            <tr v-else-if="items.length === 0">
              <td colspan="12" class="text-center py-5 text-muted">
                <IconFilter :size="32" class="mb-2 text-secondary opacity-50" />
                <div>Tidak ada data rekap presensi untuk periode atau pencarian ini.</div>
              </td>
            </tr>

            <!-- Data rows -->
            <tr v-else v-for="item in items" :key="item.employeeId">
              <td class="text-center text-muted fw-bold">{{ item.no }}</td>
              <td>
                <div class="fw-bold text-dark">{{ item.nama }}</div>
                <div class="text-muted small">NIP: {{ item.nip }}</div>
              </td>
              <td>
                <div>{{ item.jabatan }}</div>
                <div class="text-muted small">{{ item.departemen }}</div>
              </td>
              <td class="text-center fw-bold">
                {{ Number(item.hadir).toFixed(1) }}
              </td>
              <td class="text-center">
                <span
                  class="badge px-2 py-1"
                  :class="item.statusHadir === 'Terpenuhi' ? 'bg-success text-white' : 'bg-danger text-white'"
                >
                  {{ item.statusHadir }}
                </span>
              </td>
              <td class="text-center">{{ Number(item.cuti).toFixed(1) }}</td>
              <td class="text-center text-muted">{{ Number(item.kuotaCuti).toFixed(1) }}</td>
              <td class="text-center">{{ Number(item.izin).toFixed(1) }}</td>
              <td class="text-center text-muted">{{ Number(item.kuotaIzin).toFixed(1) }}</td>
              <td class="text-center">{{ Number(item.unpaidLeave).toFixed(1) }}</td>
              <td class="text-center text-muted">{{ Number(item.kuotaUnpaidLeave).toFixed(1) }}</td>
              <td class="text-center">
                <button
                  type="button"
                  class="btn btn-sm btn-outline-primary d-inline-flex align-items-center gap-1 shadow-sm"
                  title="Lihat Detail Presensi"
                  @click="goToDetail(item.employeeId)"
                >
                  <IconEye :size="16" />
                  <span>Detail</span>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination bar -->
      <div
        v-if="totalPages > 1"
        class="card-footer d-flex align-items-center justify-content-between py-2"
      >
        <div class="text-muted small">
          Menampilkan baris {{ (page - 1) * perPage + 1 }} -
          {{ Math.min(page * perPage, total) }} dari {{ total }} pegawai
        </div>
        <ul class="pagination pagination-sm m-0">
          <li class="page-item" :class="{ disabled: page <= 1 }">
            <button
              class="page-link"
              type="button"
              :disabled="page <= 1"
              @click="page--; fetchSummary()"
            >
              Sebelumnya
            </button>
          </li>
          <li
            v-for="p in totalPages"
            :key="p"
            class="page-item"
            :class="{ active: page === p }"
          >
            <button class="page-link" type="button" @click="page = p; fetchSummary()">
              {{ p }}
            </button>
          </li>
          <li class="page-item" :class="{ disabled: page >= totalPages }">
            <button
              class="page-link"
              type="button"
              :disabled="page >= totalPages"
              @click="page++; fetchSummary()"
            >
              Berikutnya
            </button>
          </li>
        </ul>
      </div>
    </div>

    <!-- Modal Import CSV -->
    <ImportModal
      v-model:show="isImportModalOpen"
      @imported="onImportSuccess"
    />
  </NuxtLayout>
</template>

<script setup>
import ImportModal from "@/features/Presensi/components/ImportModal.vue";
import {
  IconAlertCircle,
  IconEye,
  IconFileDownload,
  IconFilter,
  IconRefresh,
  IconSearch,
  IconUpload,
} from "@tabler/icons-vue";

definePageMeta({
  title: "Rekap Presensi",
  layout: false,
});

useSeoMeta({
  title: "Rekap Presensi - HRIS",
});

const { can } = useAuth();
const router = useRouter();

// State periode: default N-1 bulan berjalan
const now = new Date();
let initialYear = now.getFullYear();
let initialMonth = now.getMonth(); // 0-indexed: jika Sept (8), maka N-1 adalah Agustus (7), jadi initialMonth = 8
if (initialMonth === 0) {
  initialMonth = 12;
  initialYear -= 1;
}

const selectedYear = ref(initialYear);
const selectedMonth = ref(initialMonth);
const searchQuery = ref("");
const page = ref(1);
const perPage = ref(10);
const total = ref(0);
const totalPages = ref(1);

const items = ref([]);
const isLoading = ref(false);
const errorMessage = ref("");
const isImportModalOpen = ref(false);

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

// Fetch summary data
const fetchSummary = async () => {
  isLoading.value = true;
  errorMessage.value = "";

  try {
    const params = {
      year: selectedYear.value,
      month: selectedMonth.value,
      page: page.value,
      limit: perPage.value,
    };

    if (searchQuery.value.trim()) {
      params.search = searchQuery.value.trim();
    }

    const response = await $fetch("/api/attendances/summary", { params });

    if (response && response.success) {
      items.value = response.data.items || [];
      total.value = response.data.pagination.total || 0;
      totalPages.value = response.data.pagination.totalPages || 1;
    } else {
      errorMessage.value = response?.message || "Gagal memuat data rekap presensi.";
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Terjadi kesalahan saat memuat rekap presensi.";
  } finally {
    isLoading.value = false;
  }
};

const handleSearch = () => {
  page.value = 1;
  fetchSummary();
};

const handleFilterChange = () => {
  page.value = 1;
  fetchSummary();
};

const handleReset = () => {
  searchQuery.value = "";
  selectedYear.value = initialYear;
  selectedMonth.value = initialMonth;
  page.value = 1;
  fetchSummary();
};

const downloadTemplate = () => {
  window.open("/api/attendances/template", "_blank");
};

const goToDetail = (employeeId) => {
  router.push(`/presensi/${employeeId}?year=${selectedYear.value}&month=${selectedMonth.value}`);
};

const onImportSuccess = () => {
  fetchSummary();
};

onMounted(() => {
  fetchSummary();
});
</script>
