<script setup>
definePageMeta({
  title: "Data Pegawai",
  layout: false,
});

useSeoMeta({
  title: "Data Pegawai - HRIS",
});

import {
  IconPencil,
  IconPlus,
  IconSearch,
  IconTrash,
  IconFileDescription,
  IconFileSpreadsheet,
  IconFileTypePdf,
  IconChevronUp,
  IconChevronDown,
  IconArrowsSort,
  IconCheck,
  IconX,
  IconFilter,
  IconRefresh,
} from "@tabler/icons-vue";

const { can, userRole } = useAuth();

// State
const employees = ref([]);
const positions = ref([]);
const isLoading = ref(false);
const errorMessage = ref("");
const successMessage = ref("");

// Pagination state
const page = ref(1);
const perPage = ref(10);
const total = ref(0);
const totalPages = ref(1);

// Search & Filter state
const searchQuery = ref("");
const selectedPositions = ref([]);
const isPositionDropdownOpen = ref(false);
const minTenure = ref("");
const maxTenure = ref("");
const selectedContract = ref("");
const selectedStatus = ref("");

// Sorting state
const sortBy = ref("id");
const sortOrder = ref("desc");

// Bulk selection state
const selectedIds = ref([]);

// Single Delete Modal state
const itemToDelete = ref(null);
const isDeleting = ref(false);

// Format date ID
const formatDate = (dateStr) => {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return String(dateStr);
  return d.toLocaleDateString("id-ID", {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
};

// Fetch Positions for multi-select filter
const fetchPositions = async () => {
  try {
    const res = await $fetch("/api/positions");
    positions.value = Array.isArray(res) ? res : (res?.data || []);
  } catch (err) {
    console.error("Gagal memuat master jabatan:", err);
  }
};

// Fetch Employees data from backend
const fetchEmployees = async () => {
  isLoading.value = true;
  errorMessage.value = "";
  try {
    const params = {
      page: page.value,
      perPage: perPage.value,
      sortBy: sortBy.value,
      sortOrder: sortOrder.value,
    };

    if (searchQuery.value.trim()) {
      params.search = searchQuery.value.trim();
    }
    if (selectedPositions.value.length > 0) {
      params.positions = selectedPositions.value.join(",");
    }
    if (minTenure.value !== "" && !isNaN(minTenure.value)) {
      params.minTenure = minTenure.value;
    }
    if (maxTenure.value !== "" && !isNaN(maxTenure.value)) {
      params.maxTenure = maxTenure.value;
    }
    if (selectedContract.value) {
      params.employmentType = selectedContract.value;
    }
    if (selectedStatus.value) {
      params.status = selectedStatus.value;
    }

    const res = await $fetch("/api/employees", { params });
    if (res?.success && res?.data) {
      employees.value = res.data.items || [];
      total.value = res.data.pagination?.total || 0;
      totalPages.value = res.data.pagination?.totalPages || 1;
      // Clear selections if outside scope
      selectedIds.value = selectedIds.value.filter((id) =>
        employees.value.some((e) => e.id === id)
      );
    }
  } catch (err) {
    errorMessage.value = err?.data?.message || err?.message || "Gagal memuat data pegawai.";
    employees.value = [];
  } finally {
    isLoading.value = false;
  }
};

// Debounced search
let searchTimer = null;
const onSearchInput = () => {
  clearTimeout(searchTimer);
  searchTimer = setTimeout(() => {
    page.value = 1;
    fetchEmployees();
  }, 400);
};

// Handle column sorting
const handleSort = (column) => {
  if (sortBy.value === column) {
    sortOrder.value = sortOrder.value === "asc" ? "desc" : "asc";
  } else {
    sortBy.value = column;
    sortOrder.value = "asc";
  }
  page.value = 1;
  fetchEmployees();
};

// Reset all filters
const resetFilters = () => {
  searchQuery.value = "";
  selectedPositions.value = [];
  minTenure.value = "";
  maxTenure.value = "";
  selectedContract.value = "";
  selectedStatus.value = "";
  page.value = 1;
  fetchEmployees();
};

// Toggle position in multi-select
const togglePosition = (posId) => {
  const index = selectedPositions.value.indexOf(posId);
  if (index > -1) {
    selectedPositions.value.splice(index, 1);
  } else {
    selectedPositions.value.push(posId);
  }
  page.value = 1;
  fetchEmployees();
};

// Bulk selection helpers
const isAllSelected = computed(() => {
  return employees.value.length > 0 && employees.value.every((e) => selectedIds.value.includes(e.id));
});

const toggleSelectAll = () => {
  if (isAllSelected.value) {
    selectedIds.value = [];
  } else {
    selectedIds.value = employees.value.map((e) => e.id);
  }
};

const toggleSelectRow = (id) => {
  const index = selectedIds.value.indexOf(id);
  if (index > -1) {
    selectedIds.value.splice(index, 1);
  } else {
    selectedIds.value.push(id);
  }
};

// Bulk Status Action
const handleBulkStatus = async (status) => {
  if (selectedIds.value.length === 0) return;
  try {
    errorMessage.value = "";
    const res = await $fetch("/api/employees/bulk-status", {
      method: "POST",
      body: { ids: selectedIds.value, status },
    });
    successMessage.value = res?.message || "Status pegawai berhasil diubah.";
    selectedIds.value = [];
    fetchEmployees();
    setTimeout(() => { successMessage.value = ""; }, 4000);
  } catch (err) {
    errorMessage.value = err?.data?.message || err?.message || "Gagal mengubah status pegawai.";
  }
};

// Bulk Delete Action
const handleBulkDelete = async () => {
  if (selectedIds.value.length === 0) return;
  if (!confirm(`Apakah Anda yakin ingin menghapus ${selectedIds.value.length} data pegawai yang dipilih?`)) {
    return;
  }
  try {
    errorMessage.value = "";
    const res = await $fetch("/api/employees/bulk-delete", {
      method: "POST",
      body: { ids: selectedIds.value },
    });
    successMessage.value = res?.message || "Data pegawai berhasil dihapus.";
    selectedIds.value = [];
    fetchEmployees();
    setTimeout(() => { successMessage.value = ""; }, 4000);
  } catch (err) {
    errorMessage.value = err?.data?.message || err?.message || "Gagal menghapus data pegawai massal.";
  }
};

// Single Delete
const openDeleteModal = (item) => {
  itemToDelete.value = item;
};

const confirmDeleteSingle = async () => {
  if (!itemToDelete.value) return;
  isDeleting.value = true;
  errorMessage.value = "";
  try {
    const res = await $fetch(`/api/employees/${itemToDelete.value.id}`, {
      method: "DELETE",
    });
    successMessage.value = res?.message || `Pegawai '${itemToDelete.value.name}' berhasil dihapus.`;
    itemToDelete.value = null;
    fetchEmployees();
    setTimeout(() => { successMessage.value = ""; }, 4000);
  } catch (err) {
    errorMessage.value = err?.data?.message || err?.message || "Gagal menghapus pegawai.";
  } finally {
    isDeleting.value = false;
  }
};

// Export Handlers
const exportExcel = () => {
  window.open("/api/employees/export?format=excel", "_blank");
};

const exportPdf = () => {
  window.open("/api/employees/export?format=pdf", "_blank");
};

const downloadSinglePdf = (item) => {
  window.open(`/api/employees/export?format=pdf&id=${item.id}`, "_blank");
};

// Watchers
watch([perPage, selectedContract, selectedStatus], () => {
  page.value = 1;
  fetchEmployees();
});

onMounted(() => {
  fetchPositions();
  fetchEmployees();
});
</script>

<template>
  <NuxtLayout name="default">
    <template #actions>
      <div class="d-flex gap-2">
        <!-- Download Buttons -->
        <button class="btn btn-outline-secondary" title="Download Excel" @click="exportExcel">
          <IconFileSpreadsheet size="18" class="me-1 text-success" />
          <span>Excel</span>
        </button>
        <button class="btn btn-outline-secondary" title="Download PDF" @click="exportPdf">
          <IconFileTypePdf size="18" class="me-1 text-danger" />
          <span>PDF</span>
        </button>

        <!-- Tambah Data (Hanya Admin HRD) -->
        <NuxtLink
          v-if="can('create', 'employee')"
          to="/pegawai/form"
          class="btn btn-primary"
        >
          <IconPlus size="18" class="me-1" />
          <span>Data Baru</span>
        </NuxtLink>
      </div>
    </template>

    <!-- Alerts -->
    <div v-if="successMessage" class="alert alert-success alert-dismissible mb-3" role="alert">
      <div class="d-flex align-items-center">
        <IconCheck class="me-2" size="20" />
        <div>{{ successMessage }}</div>
      </div>
      <button type="button" class="btn-close" @click="successMessage = ''"></button>
    </div>

    <div v-if="errorMessage" class="alert alert-danger alert-dismissible mb-3" role="alert">
      <div class="d-flex align-items-center">
        <IconX class="me-2" size="20" />
        <div>{{ errorMessage }}</div>
      </div>
      <button type="button" class="btn-close" @click="errorMessage = ''"></button>
    </div>

    <!-- Readonly Info Banner for Manager HRD -->
    <div v-if="!can('create', 'employee') && can('read', 'employee')" class="alert alert-info py-2 px-3 mb-3 d-flex align-items-center">
      <span class="badge bg-blue text-blue-fg me-2">Mode Readonly</span>
      <span class="text-secondary small">
        Anda masuk sebagai <strong>Manager HRD</strong>. Anda memiliki hak akses melihat, mencari, memfilter, dan mengunduh laporan data pegawai.
      </span>
    </div>

    <div class="card shadow-sm border-0">
      <!-- Card Header: Filters & Search -->
      <div class="card-header bg-white py-3">
        <div class="row g-2 align-items-center w-100">
          <!-- Search Box -->
          <div class="col-lg-3 col-md-4">
            <div class="input-icon">
              <span class="input-icon-addon">
                <IconSearch size="16" class="text-secondary" />
              </span>
              <input
                v-model="searchQuery"
                type="text"
                class="form-control"
                placeholder="Cari nama / NIP / jabatan..."
                @input="onSearchInput"
              />
            </div>
          </div>

          <!-- Filter Masa Kerja -->
          <div class="col-lg-3 col-md-4">
            <div class="d-flex align-items-center gap-1">
              <span class="text-muted small text-nowrap">Masa Kerja:</span>
              <input
                v-model="minTenure"
                type="number"
                min="0"
                class="form-control form-control-sm text-center"
                style="width: 55px"
                placeholder="Min"
                @input="onSearchInput"
              />
              <span class="text-muted">-</span>
              <input
                v-model="maxTenure"
                type="number"
                min="0"
                class="form-control form-control-sm text-center"
                style="width: 55px"
                placeholder="Max"
                @input="onSearchInput"
              />
              <span class="text-muted small">Thn</span>
            </div>
          </div>

          <!-- Filter Jabatan (Multi-Select Dropdown) -->
          <div class="col-lg-2 col-md-4">
            <div class="dropdown">
              <button
                class="btn btn-outline-secondary dropdown-toggle w-100 text-truncate text-start"
                type="button"
                @click="isPositionDropdownOpen = !isPositionDropdownOpen"
              >
                <span v-if="selectedPositions.length === 0">Semua Jabatan</span>
                <span v-else-if="selectedPositions.length === 1">1 Jabatan Terpilih</span>
                <span v-else>{{ selectedPositions.length }} Jabatan Terpilih</span>
              </button>
              <div
                class="dropdown-menu p-2 shadow"
                :class="{ show: isPositionDropdownOpen }"
                style="min-width: 220px; max-height: 250px; overflow-y: auto;"
              >
                <div class="fw-bold px-2 py-1 small text-muted">PILIH JABATAN</div>
                <label
                  v-for="pos in positions"
                  :key="pos.id"
                  class="dropdown-item d-flex align-items-center gap-2 cursor-pointer py-1"
                >
                  <input
                    type="checkbox"
                    class="form-check-input m-0"
                    :checked="selectedPositions.includes(pos.id)"
                    @change="togglePosition(pos.id)"
                  />
                  <span class="small">{{ pos.name }}</span>
                </label>
                <div v-if="positions.length === 0" class="p-2 text-muted small text-center">
                  Tidak ada jabatan.
                </div>
              </div>
            </div>
          </div>

          <!-- Filter Status Kontrak -->
          <div class="col-lg-2 col-md-4">
            <select v-model="selectedContract" class="form-select">
              <option value="">Semua Kontrak</option>
              <option value="pkwtt">PKWTT (Tetap)</option>
              <option value="pkwt">PKWT (Kontrak)</option>
              <option value="magang">Magang</option>
            </select>
          </div>

          <!-- Reset Filter -->
          <div class="col-lg-2 col-md-4 d-flex gap-1 justify-content-end">
            <select v-model="selectedStatus" class="form-select form-select-sm" style="max-width: 110px;">
              <option value="">Status</option>
              <option value="active">Aktif</option>
              <option value="inactive">Nonaktif</option>
            </select>
            <button
              class="btn btn-icon btn-outline-secondary"
              title="Reset Filter"
              @click="resetFilters"
            >
              <IconRefresh size="16" />
            </button>
          </div>
        </div>
      </div>

      <!-- Bulk Actions Bar (Muncul ketika baris dicentang) -->
      <div
        v-if="selectedIds.length > 0 && can('update', 'employee')"
        class="bg-blue-lt px-3 py-2 border-bottom d-flex align-items-center justify-content-between flex-wrap gap-2"
      >
        <div class="d-flex align-items-center gap-2">
          <span class="badge bg-primary text-white">{{ selectedIds.length }}</span>
          <span class="small fw-semibold text-primary">Pegawai Terpilih</span>
        </div>
        <div class="d-flex gap-2">
          <div class="dropdown">
            <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button" data-bs-toggle="dropdown">
              Ubah Status
            </button>
            <ul class="dropdown-menu">
              <li>
                <a class="dropdown-item text-success" href="#" @click.prevent="handleBulkStatus('active')">
                  Set Aktif
                </a>
              </li>
              <li>
                <a class="dropdown-item text-secondary" href="#" @click.prevent="handleBulkStatus('inactive')">
                  Set Nonaktif
                </a>
              </li>
            </ul>
          </div>
          <button
            v-if="can('delete', 'employee')"
            class="btn btn-sm btn-outline-danger"
            @click="handleBulkDelete"
          >
            <IconTrash size="15" class="me-1" />
            Hapus Terpilih
          </button>
        </div>
      </div>

      <!-- Table Body -->
      <div class="table-responsive">
        <table class="table table-vcenter table-hover card-table">
          <thead>
            <tr>
              <!-- Bulk Checkbox (Admin HRD only) -->
              <th v-if="can('update', 'employee')" class="w-1 text-center">
                <input
                  type="checkbox"
                  class="form-check-input"
                  :checked="isAllSelected"
                  @change="toggleSelectAll"
                />
              </th>
              <th class="w-1 text-center">No</th>
              <!-- Sortable NIP -->
              <th class="cursor-pointer user-select-none" @click="handleSort('nip')">
                <div class="d-flex align-items-center gap-1">
                  <span>NIP</span>
                  <IconChevronUp v-if="sortBy === 'nip' && sortOrder === 'asc'" size="14" class="text-primary" />
                  <IconChevronDown v-else-if="sortBy === 'nip' && sortOrder === 'desc'" size="14" class="text-primary" />
                  <IconArrowsSort v-else size="13" class="text-muted opacity-50" />
                </div>
              </th>
              <!-- Sortable Nama -->
              <th class="cursor-pointer user-select-none" @click="handleSort('name')">
                <div class="d-flex align-items-center gap-1">
                  <span>Nama</span>
                  <IconChevronUp v-if="sortBy === 'name' && sortOrder === 'asc'" size="14" class="text-primary" />
                  <IconChevronDown v-else-if="sortBy === 'name' && sortOrder === 'desc'" size="14" class="text-primary" />
                  <IconArrowsSort v-else size="13" class="text-muted opacity-50" />
                </div>
              </th>
              <!-- Sortable Jabatan -->
              <th class="cursor-pointer user-select-none" @click="handleSort('position')">
                <div class="d-flex align-items-center gap-1">
                  <span>Jabatan</span>
                  <IconChevronUp v-if="sortBy === 'position' && sortOrder === 'asc'" size="14" class="text-primary" />
                  <IconChevronDown v-else-if="sortBy === 'position' && sortOrder === 'desc'" size="14" class="text-primary" />
                  <IconArrowsSort v-else size="13" class="text-muted opacity-50" />
                </div>
              </th>
              <!-- Sortable Tanggal Masuk -->
              <th class="cursor-pointer user-select-none" @click="handleSort('joined_at')">
                <div class="d-flex align-items-center gap-1">
                  <span>Tanggal Masuk</span>
                  <IconChevronUp v-if="sortBy === 'joined_at' && sortOrder === 'asc'" size="14" class="text-primary" />
                  <IconChevronDown v-else-if="sortBy === 'joined_at' && sortOrder === 'desc'" size="14" class="text-primary" />
                  <IconArrowsSort v-else size="13" class="text-muted opacity-50" />
                </div>
              </th>
              <!-- Sortable Masa Kerja -->
              <th class="cursor-pointer user-select-none" @click="handleSort('experience')">
                <div class="d-flex align-items-center gap-1">
                  <span>Masa Kerja</span>
                  <IconChevronUp v-if="sortBy === 'experience' && sortOrder === 'asc'" size="14" class="text-primary" />
                  <IconChevronDown v-else-if="sortBy === 'experience' && sortOrder === 'desc'" size="14" class="text-primary" />
                  <IconArrowsSort v-else size="13" class="text-muted opacity-50" />
                </div>
              </th>
              <th>Status</th>
              <th class="text-center" style="min-width: 140px;">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="isLoading">
              <td :colspan="can('update', 'employee') ? 9 : 8" class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <div class="text-muted mt-2 small">Memuat data pegawai...</div>
              </td>
            </tr>
            <tr v-else-if="employees.length === 0">
              <td :colspan="can('update', 'employee') ? 9 : 8" class="text-center py-5 text-muted">
                Tidak ada data pegawai yang sesuai dengan filter pencarian.
              </td>
            </tr>
            <tr
              v-for="(item, index) in employees"
              :key="item.id"
              :class="{ 'table-active': selectedIds.includes(item.id) }"
            >
              <!-- Checkbox -->
              <td v-if="can('update', 'employee')" class="text-center">
                <input
                  type="checkbox"
                  class="form-check-input"
                  :checked="selectedIds.includes(item.id)"
                  @change="toggleSelectRow(item.id)"
                />
              </td>
              <!-- No Urut -->
              <td class="text-center text-muted">
                {{ (page - 1) * perPage + index + 1 }}
              </td>
              <!-- NIP -->
              <td>
                <span class="badge bg-azure-lt font-monospace">{{ item.nip }}</span>
              </td>
              <!-- Nama -->
              <td>
                <div class="d-flex align-items-center gap-2">
                  <div class="avatar avatar-xs rounded-circle bg-blue-lt">
                    {{ item.name.charAt(0) }}
                  </div>
                  <div>
                    <div class="font-weight-medium">{{ item.name }}</div>
                    <div class="text-muted small">{{ item.email }}</div>
                  </div>
                </div>
              </td>
              <!-- Jabatan & Departemen -->
              <td>
                <div>{{ item.position_name }}</div>
                <div class="text-muted small">{{ item.department_name }}</div>
              </td>
              <!-- Tanggal Masuk -->
              <td>{{ formatDate(item.joined_at) }}</td>
              <!-- Masa Kerja -->
              <td>
                <span class="badge bg-purple-lt">{{ item.tenure_text }}</span>
              </td>
              <!-- Status -->
              <td>
                <span
                  class="badge"
                  :class="item.status === 'active' ? 'bg-success-lt text-success' : 'bg-danger-lt text-danger'"
                >
                  {{ item.status === 'active' ? 'Aktif' : 'Nonaktif' }}
                </span>
                <div class="text-muted small text-uppercase">{{ item.employment_type }}</div>
              </td>
              <!-- Aksi -->
              <td class="text-nowrap text-center">
                <div class="d-flex justify-content-center gap-1">
                  <!-- Tombol Detail -->
                  <NuxtLink
                    :to="`/pegawai/${item.nip || item.id}`"
                    class="btn btn-icon btn-ghost-primary"
                    title="Detail Pegawai"
                  >
                    <IconFileDescription size="18" />
                  </NuxtLink>

                  <!-- Tombol Edit (Hanya Admin HRD) -->
                  <NuxtLink
                    v-if="can('update', 'employee')"
                    :to="`/pegawai/form/${item.id}`"
                    class="btn btn-icon btn-ghost-warning"
                    title="Ubah Data"
                  >
                    <IconPencil size="18" />
                  </NuxtLink>

                  <!-- Tombol Download PDF Profil -->
                  <button
                    class="btn btn-icon btn-ghost-secondary"
                    title="Download Lembar Profil (PDF)"
                    @click="downloadSinglePdf(item)"
                  >
                    <IconFileTypePdf size="18" class="text-danger" />
                  </button>

                  <!-- Tombol Hapus (Hanya Admin HRD) -->
                  <button
                    v-if="can('delete', 'employee')"
                    class="btn btn-icon btn-ghost-danger"
                    title="Hapus Pegawai"
                    @click="openDeleteModal(item)"
                  >
                    <IconTrash size="18" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Card Footer: Pagination -->
      <div class="card-footer d-flex align-items-center justify-content-between flex-wrap gap-2 py-2">
        <div class="d-flex align-items-center gap-2 text-muted small">
          <span>Tampilkan</span>
          <select v-model="perPage" class="form-select form-select-sm" style="width: 70px;">
            <option :value="10">10</option>
            <option :value="25">25</option>
            <option :value="50">50</option>
            <option :value="100">100</option>
          </select>
          <span>dari <strong>{{ total }}</strong> pegawai</span>
        </div>

        <ul v-if="totalPages > 1" class="pagination pagination-sm m-0">
          <li class="page-item" :class="{ disabled: page <= 1 }">
            <button class="page-link" @click="page--; fetchEmployees()">
              Sebelumnya
            </button>
          </li>
          <li
            v-for="p in totalPages"
            :key="p"
            class="page-item"
            :class="{ active: page === p }"
          >
            <button class="page-link" @click="page = p; fetchEmployees()">
              {{ p }}
            </button>
          </li>
          <li class="page-item" :class="{ disabled: page >= totalPages }">
            <button class="page-link" @click="page++; fetchEmployees()">
              Selanjutnya
            </button>
          </li>
        </ul>
      </div>
    </div>

    <!-- Modal Hapus Satuan -->
    <div
      v-if="itemToDelete"
      class="modal modal-blur fade show d-block"
      style="background: rgba(0,0,0,0.5);"
      tabindex="-1"
    >
      <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
          <button type="button" class="btn-close" @click="itemToDelete = null"></button>
          <div class="modal-status bg-danger"></div>
          <div class="modal-body text-center py-4">
            <IconTrash size="48" class="text-danger mb-2" />
            <h3 class="mb-1">Hapus Data Pegawai</h3>
            <div class="text-secondary">
              Apakah Anda yakin ingin menghapus data pegawai <strong>{{ itemToDelete.name }}</strong> (NIP: {{ itemToDelete.nip }})?
            </div>
          </div>
          <div class="modal-footer">
            <div class="w-100">
              <div class="row">
                <div class="col">
                  <button class="btn btn-outline-secondary w-100" @click="itemToDelete = null">
                    Batal
                  </button>
                </div>
                <div class="col">
                  <button
                    class="btn btn-danger w-100"
                    :disabled="isDeleting"
                    @click="confirmDeleteSingle"
                  >
                    <span v-if="isDeleting" class="spinner-border spinner-border-sm me-1"></span>
                    Hapus
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </NuxtLayout>
</template>

<style scoped>
.cursor-pointer {
  cursor: pointer;
}
.user-select-none {
  user-select: none;
}
</style>
