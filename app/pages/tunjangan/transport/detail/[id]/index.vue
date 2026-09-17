<template>
  <div>
    <!-- Header Page -->
    <div class="d-flex align-items-center justify-content-between mb-3">
      <div>
        <h2 class="page-title mb-1">{{ periodData.period_label || 'Detail Tunjangan Transport' }}</h2>
        <div class="text-muted small">
          Status: 
          <span
            class="badge"
            :class="{
              'bg-success-lt': periodData.status === 'calculated',
              'bg-warning-lt': periodData.status === 'draft',
              'bg-secondary-lt': periodData.status === 'locked'
            }"
          >
            {{ periodData.status === 'calculated' ? 'Sudah Dihitung' : periodData.status }}
          </span>
          <span v-if="periodData.calculated_at" class="ms-2">
            Terakhir dihitung: {{ new Date(periodData.calculated_at).toLocaleString('id-ID') }}
          </span>
        </div>
      </div>
      <div>
        <NuxtLink to="/tunjangan/transport" class="btn btn-outline-secondary">
          <IconArrowLeft size="18" class="me-1" />
          <span>Kembali</span>
        </NuxtLink>
      </div>
    </div>

    <!-- Alert / Pesan -->
    <div v-if="alertMessage" :class="`alert alert-${alertType} alert-dismissible mb-3`" role="alert">
      <div>{{ alertMessage }}</div>
      <a class="btn-close" @click="alertMessage = ''" aria-label="close"></a>
    </div>

    <!-- Main Card -->
    <div class="card">
      <div class="card-header">
        <div class="d-flex flex-wrap align-items-center gap-2 w-100">
          <!-- Tombol Hitung Tunjangan (Hanya muncul/bisa diklik oleh Admin HRD) -->
          <button
            v-if="canCalculate"
            class="btn btn-primary"
            :disabled="isCalculating"
            @click="handleCalculate"
          >
            <span v-if="isCalculating" class="spinner-border spinner-border-sm me-2" role="status"></span>
            <IconCalculator v-else class="icon me-1" />
            Hitung Tunjangan
          </button>

          <!-- Ringkasan Agregat -->
          <div class="ms-3 d-none d-md-flex gap-3 align-items-center">
            <div>
              <span class="text-muted small">Penerima:</span>
              <strong class="ms-1">{{ periodData.total_recipients || 0 }} Orang</strong>
            </div>
            <div>
              <span class="text-muted small">Total:</span>
              <strong class="ms-1 text-primary">{{ formatRupiah(periodData.total_amount || 0) }}</strong>
            </div>
          </div>

          <!-- Search Box -->
          <div class="ms-auto input-group input-group-sm" style="width: 250px">
            <input
              type="text"
              v-model="searchQuery"
              @keyup.enter="handleSearch"
              class="form-control"
              placeholder="Cari nama pegawai / NIP..."
            />
            <button class="btn btn-outline-secondary" type="button" @click="handleSearch">
              <IconSearch :size="16" />
            </button>
          </div>
        </div>
      </div>

      <div class="table-responsive card-body p-0">
        <div v-if="isLoading" class="text-center py-5">
          <div class="spinner-border text-primary" role="status"></div>
          <div class="mt-2 text-muted">Memuat data penerima tunjangan...</div>
        </div>

        <!-- Tabel Hasil Perhitungan -->
        <table v-else class="table table-vcenter table-hover m-0">
          <thead>
            <tr>
              <th class="text-center" style="width: 60px">No. Urut</th>
              <th
                class="cursor-pointer user-select-none"
                @click="toggleSort('name')"
              >
                <div class="d-flex align-items-center justify-content-between">
                  <span>Nama Penerima</span>
                  <span class="text-muted small ms-1">{{ getSortIcon('name') }}</span>
                </div>
              </th>
              <th
                class="text-center cursor-pointer user-select-none"
                style="width: 140px"
                @click="toggleSort('km')"
              >
                <div class="d-flex align-items-center justify-content-center">
                  <span>Km</span>
                  <span class="text-muted small ms-1">{{ getSortIcon('km') }}</span>
                </div>
              </th>
              <th
                class="text-center cursor-pointer user-select-none"
                style="width: 140px"
                @click="toggleSort('hari')"
              >
                <div class="d-flex align-items-center justify-content-center">
                  <span>Hari</span>
                  <span class="text-muted small ms-1">{{ getSortIcon('hari') }}</span>
                </div>
              </th>
              <th
                class="text-end cursor-pointer user-select-none"
                style="width: 180px"
                @click="toggleSort('nominal')"
              >
                <div class="d-flex align-items-center justify-content-end">
                  <span>Nominal</span>
                  <span class="text-muted small ms-1">{{ getSortIcon('nominal') }}</span>
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="recipients.length === 0">
              <td colspan="5" class="text-center py-5 text-muted">
                <div class="mb-2">Belum ada data hasil perhitungan pada periode ini.</div>
                <div class="small">Klik tombol <strong>"Hitung Tunjangan"</strong> di atas untuk menjalankan kalkulasi.</div>
              </td>
            </tr>
            <tr v-for="(item, index) in recipients" :key="item.id">
              <td class="text-center">{{ (meta.page - 1) * meta.limit + index + 1 }}</td>
              <td>
                <div class="fw-bold">{{ item.name }}</div>
                <div class="text-muted small">NIP: {{ item.nip }} &bull; {{ item.employment_type?.toUpperCase() }}</div>
              </td>
              <td class="text-center">
                <span class="badge bg-blue-lt">{{ item.km }} km</span>
                <span v-if="item.original_km && item.original_km !== item.km" class="text-muted small ms-1" title="Jarak asli">
                  ({{ item.original_km }} km)
                </span>
              </td>
              <td class="text-center">
                <span class="badge bg-green-lt">{{ item.hari }} Hari</span>
              </td>
              <td class="text-end fw-bold text-primary">
                {{ formatRupiah(item.nominal) }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination Footer -->
      <div v-if="meta.total_pages > 1" class="card-footer d-flex align-items-center">
        <div class="text-muted small">
          Menampilkan {{ (meta.page - 1) * meta.limit + 1 }} - {{ Math.min(meta.page * meta.limit, meta.total) }} dari {{ meta.total }} penerima
        </div>
        <ul class="pagination ms-auto m-0">
          <li class="page-item" :class="{ disabled: meta.page <= 1 }">
            <button class="page-link" @click="changePage(meta.page - 1)">Previous</button>
          </li>
          <li
            v-for="p in meta.total_pages"
            :key="p"
            class="page-item"
            :class="{ active: meta.page === p }"
          >
            <button class="page-link" @click="changePage(p)">{{ p }}</button>
          </li>
          <li class="page-item" :class="{ disabled: meta.page >= meta.total_pages }">
            <button class="page-link" @click="changePage(meta.page + 1)">Next</button>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { IconSearch, IconCalculator, IconArrowLeft } from "@tabler/icons-vue";
import { formatRupiah } from "~/utils/formatRupiah.js";
import { useAuth } from "~/composables/useAuth.js";

definePageMeta({
  title: "Detail Tunjangan Transport",
});

useSeoMeta({
  title: "Detail Tunjangan Transport",
});

const auth = useAuth();
// Manager HRD hanya Read-Only (RO) pada modul tunjangan, Admin HRD memiliki izin update/kalkulasi
const canCalculate = computed(() => {
  return auth.userRole.value === "admin_hrd" || auth.can("transport_allowance", "update") || auth.can("transport_allowance", "create");
});

const route = useRoute();
const periodId = route.params.id;

const isLoading = ref(true);
const isCalculating = ref(false);
const alertMessage = ref("");
const alertType = ref("success");

const periodData = ref({});
const recipients = ref([]);
const searchQuery = ref("");
const sortBy = ref("name");
const sortDir = ref("asc");

const meta = ref({
  page: 1,
  limit: 20,
  total: 0,
  total_pages: 1,
});

function getSortIcon(col) {
  if (sortBy.value !== col) return "↕";
  return sortDir.value === "asc" ? "↑" : "↓";
}

function toggleSort(col) {
  if (sortBy.value === col) {
    sortDir.value = sortDir.value === "asc" ? "desc" : "asc";
  } else {
    sortBy.value = col;
    sortDir.value = "asc";
  }
  meta.value.page = 1;
  fetchDetail();
}

async function fetchDetail() {
  try {
    isLoading.value = true;
    alertMessage.value = "";

    const params = {
      page: meta.value.page,
      limit: meta.value.limit,
      sort_by: sortBy.value,
      sort_dir: sortDir.value,
    };

    if (searchQuery.value) {
      params.search = searchQuery.value;
    }

    const res = await $fetch(`/api/transport/periods/${periodId}`, { params });

    if (res?.success && res.data) {
      periodData.value = res.data.period || {};
      recipients.value = res.data.recipients || [];
      if (res.meta) {
        meta.value = {
          page: res.meta.page,
          limit: res.meta.limit,
          total: res.meta.total,
          total_pages: res.meta.total_pages,
        };
      }
    }
  } catch (err) {
    alertType.value = "danger";
    alertMessage.value = err?.data?.message || "Gagal memuat detail tunjangan transport.";
  } finally {
    isLoading.value = false;
  }
}

async function handleCalculate() {
  try {
    isCalculating.value = true;
    alertMessage.value = "";

    const res = await $fetch(`/api/transport/periods/${periodId}/calculate`, {
      method: "POST",
    });

    if (res?.success) {
      alertType.value = "success";
      alertMessage.value = res.message || "Perhitungan tunjangan transport berhasil diselesaikan!";
      // Muat ulang data hasil hitung
      await fetchDetail();
    }
  } catch (err) {
    alertType.value = "danger";
    alertMessage.value = err?.data?.message || "Gagal melakukan perhitungan tunjangan transport.";
  } finally {
    isCalculating.value = false;
  }
}

function handleSearch() {
  meta.value.page = 1;
  fetchDetail();
}

function changePage(p) {
  if (p < 1 || p > meta.value.total_pages) return;
  meta.value.page = p;
  fetchDetail();
}

onMounted(() => {
  fetchDetail();
});
</script>

<style scoped>
.cursor-pointer {
  cursor: pointer;
}
</style>
