<template>
  <div class="card shadow-sm border-0">
    <div class="card-header d-flex flex-wrap align-items-center justify-content-between gap-3">
      <h3 class="card-title m-0">Riwayat Log Aktivitas Sistem</h3>

      <!-- Filter & Search Toolbar -->
      <div class="d-flex flex-wrap align-items-center gap-2 ms-auto">
        <!-- Filter Modul -->
        <select
          v-model="selectedModule"
          class="form-select form-select-sm w-auto"
          @change="onFilterChange"
        >
          <option value="">Semua Modul</option>
          <option value="auth">Auth & Sesi</option>
          <option value="user">Kelola User</option>
          <option value="role">Kelola Role</option>
          <option value="employee">Data Pegawai</option>
          <option value="attendance">Presensi</option>
          <option value="transport_allowance">Tunjangan Transport</option>
          <option value="transport_setting">Setting Tunjangan</option>
          <option value="profile">My Profile</option>
          <option value="dashboard">Dashboard</option>
          <option value="activity_log">Log Aktivitas</option>
        </select>

        <!-- Filter Aksi -->
        <select
          v-model="selectedAction"
          class="form-select form-select-sm w-auto"
          @change="onFilterChange"
        >
          <option value="">Semua Aksi</option>
          <option value="login">Login</option>
          <option value="logout">Logout</option>
          <option value="create">Create</option>
          <option value="read">Read</option>
          <option value="update">Update</option>
          <option value="delete">Delete</option>
        </select>

        <!-- Input Search -->
        <div class="input-group input-group-sm" style="max-width: 250px;">
          <input
            v-model="searchQuery"
            type="text"
            class="form-control"
            placeholder="Cari user / deskripsi / IP..."
            @keyup.enter="onFilterChange"
          />
          <button class="btn btn-primary" type="button" @click="onFilterChange">
            <IconSearch :size="16" />
          </button>
        </div>
      </div>
    </div>

    <!-- Table Content -->
    <div class="table-responsive card-body p-0">
      <div v-if="isLoading" class="text-center py-5 text-muted">
        <div class="spinner-border spinner-border-sm text-primary me-2" role="status"></div>
        <span>Memuat data log aktivitas dari database...</span>
      </div>

      <div v-else-if="logs.length === 0" class="text-center py-5 text-muted">
        <p class="mb-0">Tidak ada log aktivitas yang sesuai dengan filter.</p>
      </div>

      <table v-else class="table table-vcenter table-striped card-table">
        <thead>
          <tr>
            <th class="w-1 text-center">No</th>
            <th>Pengguna / Akun</th>
            <th>Modul</th>
            <th>Aksi</th>
            <th>Deskripsi Aktivitas</th>
            <th>IP Address</th>
            <th>Waktu (Timestamp)</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in logs" :key="item.id">
            <td class="text-center text-muted">
              {{ (pagination.page - 1) * pagination.limit + index + 1 }}
            </td>
            <td>
              <div class="d-flex align-items-center gap-2">
                <span class="avatar avatar-xs rounded-circle bg-primary-lt text-primary fw-bold">
                  {{ (item.user_name || item.username || "S")[0].toUpperCase() }}
                </span>
                <div>
                  <div class="fw-bold">{{ item.user_name || item.username || "Sistem" }}</div>
                  <small class="text-muted" style="font-size: 0.75rem;">
                    {{ item.role_name ? `@${item.username} (${item.role_name})` : item.username || "-" }}
                  </small>
                </div>
              </div>
            </td>
            <td>
              <span class="badge bg-secondary-lt font-monospace text-uppercase">
                {{ item.module_code }}
              </span>
            </td>
            <td>
              <span :class="getActionBadgeClass(item.action)">
                {{ item.action.toUpperCase() }}
              </span>
            </td>
            <td class="text-secondary small" style="max-width: 320px;">
              {{ item.description || "-" }}
            </td>
            <td class="text-muted font-monospace small">
              {{ item.ip_address || "-" }}
            </td>
            <td class="text-nowrap small text-muted">
              {{ formatDateTimeID(item.created_at) }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination Footer -->
    <div
      v-if="pagination.totalPages > 1"
      class="card-footer d-flex align-items-center justify-content-between flex-wrap gap-2"
    >
      <div class="text-muted small">
        Menampilkan <strong>{{ (pagination.page - 1) * pagination.limit + 1 }}</strong> sampai
        <strong>{{ Math.min(pagination.page * pagination.limit, pagination.total) }}</strong> dari
        <strong>{{ pagination.total }}</strong> log aktivitas
      </div>

      <ul class="pagination pagination-sm m-0 ms-auto">
        <li class="page-item" :class="{ disabled: pagination.page <= 1 }">
          <button class="page-link" @click="changePage(pagination.page - 1)">
            Sebelumnya
          </button>
        </li>

        <li
          v-for="p in visiblePages"
          :key="p"
          class="page-item"
          :class="{ active: p === pagination.page }"
        >
          <button class="page-link" @click="changePage(p)">
            {{ p }}
          </button>
        </li>

        <li class="page-item" :class="{ disabled: pagination.page >= pagination.totalPages }">
          <button class="page-link" @click="changePage(pagination.page + 1)">
            Berikutnya
          </button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
definePageMeta({
  title: "Log Aktifitas",
});

useSeoMeta({
  title: "Log Aktifitas",
});

import { IconSearch } from "@tabler/icons-vue";
import { formatDateTimeID } from "~/utils/formatDate.js";

const logs = ref([]);
const isLoading = ref(false);
const searchQuery = ref("");
const selectedModule = ref("");
const selectedAction = ref("");

const pagination = reactive({
  page: 1,
  limit: 10,
  total: 0,
  totalPages: 1,
});

// Helper style badge aksi
const getActionBadgeClass = (action) => {
  switch (action) {
    case "login":
      return "badge bg-green text-white";
    case "logout":
      return "badge bg-danger text-white";
    case "create":
      return "badge bg-blue text-white";
    case "update":
      return "badge bg-warning text-white";
    case "delete":
      return "badge bg-red text-white";
    case "read":
      return "badge bg-azure text-white";
    default:
      return "badge bg-secondary text-white";
  }
};

// Hitung rentang halaman yang terlihat
const visiblePages = computed(() => {
  const pages = [];
  const start = Math.max(1, pagination.page - 2);
  const end = Math.min(pagination.totalPages, pagination.page + 2);
  for (let i = start; i <= end; i++) {
    pages.push(i);
  }
  return pages;
});

// Fetch log dari REST API
const fetchLogs = async () => {
  isLoading.value = true;
  try {
    const res = await $fetch("/api/logs", {
      params: {
        page: pagination.page,
        limit: pagination.limit,
        search: searchQuery.value.trim(),
        module: selectedModule.value,
        action: selectedAction.value,
      },
    });

    if (res?.success && res?.data) {
      logs.value = res.data.items || [];
      pagination.total = res.data.pagination.total;
      pagination.totalPages = res.data.pagination.totalPages;
      pagination.page = res.data.pagination.page;
    }
  } catch (err) {
    console.error("Gagal memuat activity logs:", err);
    logs.value = [];
  } finally {
    isLoading.value = false;
  }
};

const onFilterChange = () => {
  pagination.page = 1;
  fetchLogs();
};

const changePage = (newPage) => {
  if (newPage >= 1 && newPage <= pagination.totalPages && newPage !== pagination.page) {
    pagination.page = newPage;
    fetchLogs();
  }
};

onMounted(() => {
  fetchLogs();
});
</script>
