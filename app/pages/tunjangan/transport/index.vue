<template>
  <div class="card">
    <div class="card-header">
      <div class="d-flex flex-wrap gap-2 align-items-center w-100">
        <div class="card-title m-0">Daftar Bulan Berjalan</div>
        <div class="d-flex gap-2 ms-auto align-items-center">
          <!-- Filter Tahun -->
          <div class="d-flex align-items-center gap-1">
            <label class="form-label m-0 text-muted small">Tahun:</label>
            <select
              v-model="selectedYear"
              @change="handleFilterChange"
              class="form-select form-select-sm"
              style="width: 140px"
            >
              <option value="">Semua Tahun</option>
              <option v-for="y in availableYears" :key="y" :value="y">
                {{ y }}
              </option>
            </select>
          </div>

          <!-- Search -->
          <div class="input-group input-group-sm" style="width: 220px">
            <input
              type="text"
              v-model="searchQuery"
              @keyup.enter="handleSearch"
              class="form-control"
              placeholder="Cari bulan/status..."
            />
            <button class="btn btn-outline-secondary" type="button" @click="handleSearch">
              <IconSearch :size="16" />
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Alert / Pesan -->
    <div v-if="errorMessage" class="alert alert-danger m-3" role="alert">
      {{ errorMessage }}
    </div>

    <div class="table-responsive card-body p-0">
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status"></div>
        <div class="mt-2 text-muted">Memuat data periode tunjangan...</div>
      </div>

      <table v-else class="table table-vcenter table-hover m-0">
        <thead>
          <tr>
            <th class="text-center" style="width: 60px">No. Urut</th>
            <th>Nama Bulan</th>
            <th class="text-center">Total Penerima</th>
            <th class="text-end">Total Tunjangan Transport</th>
            <th class="text-center" style="width: 120px">Status</th>
            <th class="text-center" style="width: 100px">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="periods.length === 0">
            <td colspan="6" class="text-center py-4 text-muted">
              Tidak ada data periode tunjangan transport yang ditemukan.
            </td>
          </tr>
          <tr v-for="(item, index) in periods" :key="item.id">
            <td class="text-center">{{ (meta.page - 1) * meta.limit + index + 1 }}</td>
            <td class="fw-bold">{{ item.period_label }}</td>
            <td class="text-center">
              <span class="badge bg-blue-lt">{{ item.total_recipients }} Pegawai</span>
            </td>
            <td class="text-end fw-bold text-primary">
              {{ formatRupiah(item.total_amount) }}
            </td>
            <td class="text-center">
              <span
                class="badge"
                :class="{
                  'bg-success-lt': item.status === 'calculated',
                  'bg-warning-lt': item.status === 'draft',
                  'bg-secondary-lt': item.status === 'locked'
                }"
              >
                {{ item.status === 'calculated' ? 'Dihitung' : item.status }}
              </span>
            </td>
            <td class="text-center">
              <NuxtLink
                :to="`/tunjangan/transport/detail/${item.id}`"
                class="btn btn-primary btn-sm"
              >
                Detail
              </NuxtLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination Footer -->
    <div v-if="meta.total_pages > 1" class="card-footer d-flex align-items-center">
      <div class="text-muted small">
        Menampilkan {{ (meta.page - 1) * meta.limit + 1 }} - {{ Math.min(meta.page * meta.limit, meta.total) }} dari {{ meta.total }} periode
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
</template>

<script setup>
import { ref, onMounted } from "vue";
import { IconSearch } from "@tabler/icons-vue";
import { formatRupiah } from "~/utils/formatRupiah.js";

definePageMeta({
  title: "Tunjangan Transport",
});

useSeoMeta({
  title: "Tunjangan Transport",
});

const isLoading = ref(true);
const errorMessage = ref("");
const periods = ref([]);
const availableYears = ref([2026, 2025, 2024]);
const selectedYear = ref("");
const searchQuery = ref("");

const meta = ref({
  page: 1,
  limit: 12,
  total: 0,
  total_pages: 1,
});

async function fetchPeriods() {
  try {
    isLoading.value = true;
    errorMessage.value = "";

    const params = {
      page: meta.value.page,
      limit: meta.value.limit,
    };

    if (selectedYear.value) {
      params.year = selectedYear.value;
    }
    if (searchQuery.value) {
      params.search = searchQuery.value;
    }

    const res = await $fetch("/api/transport/periods", { params });

    if (res?.success) {
      periods.value = res.data || [];
      if (res.meta) {
        meta.value = {
          page: res.meta.page,
          limit: res.meta.limit,
          total: res.meta.total,
          total_pages: res.meta.total_pages,
        };
        if (res.meta.available_years && res.meta.available_years.length > 0) {
          availableYears.value = res.meta.available_years;
        }
      }
    }
  } catch (err) {
    errorMessage.value = err?.data?.message || "Gagal memuat data periode tunjangan transport.";
  } finally {
    isLoading.value = false;
  }
}

function handleFilterChange() {
  meta.value.page = 1;
  fetchPeriods();
}

function handleSearch() {
  meta.value.page = 1;
  fetchPeriods();
}

function changePage(page) {
  if (page < 1 || page > meta.value.total_pages) return;
  meta.value.page = page;
  fetchPeriods();
}

onMounted(() => {
  fetchPeriods();
});
</script>
