<template>
  <NuxtLayout name="default">
    <template #actions>
      <button
        class="btn btn-primary d-inline-flex align-items-center gap-1"
        @click="openAddModal"
      >
        <IconPlus stroke="{3}" size="18" />
        <span>Tambah User</span>
      </button>
    </template>

    <!-- Alert Feedback -->
    <div
      v-if="alertMessage"
      class="alert alert-dismissible mb-3"
      :class="alertType === 'success' ? 'alert-success' : 'alert-danger'"
      role="alert"
    >
      <div class="d-flex">
        <div>{{ alertMessage }}</div>
      </div>
      <button
        type="button"
        class="btn-close"
        @click="alertMessage = ''"
        aria-label="Close"
      ></button>
    </div>

    <div class="card">
      <div class="card-header">
        <div class="d-flex flex-wrap gap-2 ms-auto align-items-center">
          <!-- Filter Role -->
          <select
            v-model="selectedRoleFilter"
            class="form-select"
            style="width: 180px"
          >
            <option value="">Semua Role</option>
            <option
              v-for="r in rolesList"
              :key="r.id"
              :value="r.id"
            >
              {{ r.name }}
            </option>
          </select>

          <!-- Filter Status -->
          <select
            v-model="selectedStatusFilter"
            class="form-select"
            style="width: 150px"
          >
            <option value="">Semua Status</option>
            <option value="active">Aktif</option>
            <option value="inactive">Nonaktif</option>
          </select>

          <!-- Search -->
          <div class="input-group" style="width: 250px">
            <input
              v-model="searchQuery"
              type="text"
              class="form-control"
              placeholder="Cari user / nama / NIP..."
            />
            <button
              v-if="searchQuery"
              class="btn"
              type="button"
              @click="searchQuery = ''"
            >
              &times;
            </button>
            <button v-else class="btn" type="button">
              <IconSearch stroke="{2}" size="18" />
            </button>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="pendingUsers" class="card-body text-center py-5">
        <div class="spinner-border text-primary" role="status"></div>
        <div class="mt-2 text-muted">Memuat data user...</div>
      </div>

      <!-- Error State -->
      <div
        v-else-if="errorUsers"
        class="card-body text-center py-5 text-danger"
      >
        <p>Gagal memuat data user: {{ errorUsers.message }}</p>
        <button class="btn btn-sm btn-outline-primary" @click="refreshUsers()">
          Coba Lagi
        </button>
      </div>

      <!-- Table View User -->
      <div v-else class="table-responsive card-body p-0">
        <table class="table table-vcenter table-hover mb-0">
          <thead>
            <tr>
              <th style="width: 50px" class="text-center">No</th>
              <th
                style="cursor: pointer"
                @click="sortBy('name')"
              >
                <div class="d-flex align-items-center gap-1">
                  <span>Nama</span>
                  <IconArrowsSort size="14" class="text-muted" />
                </div>
              </th>
              <th
                style="cursor: pointer"
                @click="sortBy('username')"
              >
                <div class="d-flex align-items-center gap-1">
                  <span>Username</span>
                  <IconArrowsSort size="14" class="text-muted" />
                </div>
              </th>
              <th>Jabatan</th>
              <th>Departemen</th>
              <th>Role</th>
              <th
                class="text-center"
                style="width: 100px; cursor: pointer"
                @click="sortBy('status')"
              >
                <div class="d-flex align-items-center justify-content-center gap-1">
                  <span>Status</span>
                  <IconArrowsSort size="14" class="text-muted" />
                </div>
              </th>
              <th class="text-center" style="width: 120px">Aksi</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in processedUsers" :key="item.id">
              <td class="text-center text-muted">{{ index + 1 }}</td>
              <td>
                <div class="fw-semibold text-dark">{{ item.name }}</div>
                <div v-if="item.employee_nip" class="small text-muted">
                  NIP: {{ item.employee_nip }}
                </div>
              </td>
              <td>
                <span class="font-monospace text-primary fw-medium">{{ item.username }}</span>
                <span
                  v-if="isSelfUser(item.id)"
                  class="badge bg-purple-lt ms-1"
                  title="Akun Anda saat ini"
                >
                  Akun Anda
                </span>
              </td>
              <td>{{ item.position_name || '-' }}</td>
              <td>{{ item.department_name || '-' }}</td>
              <td>
                <span class="badge bg-azure-lt">{{ item.role_name }}</span>
              </td>
              <td class="text-center">
                <span
                  v-if="item.status === 'active'"
                  class="text-green d-inline-flex align-items-center gap-1"
                  title="Aktif"
                >
                  <IconCircleCheckFilled size="20" />
                </span>
                <span
                  v-else
                  class="text-danger d-inline-flex align-items-center gap-1"
                  title="Nonaktif"
                >
                  <IconXboxXFilled size="20" />
                </span>
              </td>
              <td class="text-center text-nowrap">
                <div class="d-inline-flex gap-1">
                  <!-- Aksi Edit -->
                  <button
                    class="btn btn-icon btn-sm btn-outline-primary"
                    title="Edit User"
                    @click="openEditModal(item)"
                  >
                    <IconPencil size="16" />
                  </button>

                  <!-- Aksi Hapus (Disable jika akun diri sendiri) -->
                  <button
                    v-if="!isSelfUser(item.id)"
                    class="btn btn-icon btn-sm btn-outline-danger"
                    title="Hapus User"
                    @click="openDeleteModal(item)"
                  >
                    <IconTrash size="16" />
                  </button>
                  <button
                    v-else
                    class="btn btn-icon btn-sm btn-outline-secondary disabled"
                    title="Tidak dapat menghapus akun sendiri"
                    disabled
                  >
                    <IconTrash size="16" />
                  </button>
                </div>
              </td>
            </tr>
            <tr v-if="processedUsers.length === 0">
              <td colspan="8" class="text-center py-4 text-muted">
                Tidak ada data user yang sesuai.
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="card-footer d-flex align-items-center">
        <span class="text-muted small">
          Menampilkan {{ processedUsers.length }} dari {{ rawUsers.length }} user terdaftar
        </span>
      </div>
    </div>

    <!-- MODAL FORM TAMBAH / EDIT USER -->
    <div
      v-if="showFormModal"
      class="modal modal-blur fade show d-block"
      tabindex="-1"
      style="background: rgba(0, 0, 0, 0.5)"
    >
      <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              {{ isEditMode ? 'Perbarui Data User' : 'Tambah User Baru' }}
            </h5>
            <button
              type="button"
              class="btn-close"
              @click="closeFormModal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="submitForm">
              <!-- ERROR FORM ALERT -->
              <div v-if="formError" class="alert alert-danger mb-3" role="alert">
                {{ formError }}
              </div>

              <!-- NAMA PENGGUNA (Autosuggestion & Autocomplete dari Data Pegawai) -->
              <div class="mb-3 position-relative">
                <label class="form-label required">
                  Nama Pengguna (Data Pegawai)
                </label>
                <div class="input-group">
                  <input
                    v-model="employeeSearchInput"
                    type="text"
                    class="form-control"
                    :class="{ 'is-invalid': formErrors.name }"
                    placeholder="Ketik minimal 2 karakter nama pegawai..."
                    @input="onEmployeeSearchInput"
                    @focus="showEmployeeSuggestions = employeeSuggestions.length > 0"
                  />
                  <button
                    v-if="formData.employee_id"
                    class="btn btn-outline-secondary"
                    type="button"
                    title="Lepaskan tautan pegawai"
                    @click="clearSelectedEmployee"
                  >
                    Reset
                  </button>
                </div>
                <div v-if="formErrors.name" class="invalid-feedback d-block">
                  {{ formErrors.name }}
                </div>
                <div v-if="formData.employee_nip" class="form-text text-success">
                  Terpaut dengan Pegawai: <strong>{{ formData.name }}</strong> (NIP: {{ formData.employee_nip }})
                </div>

                <!-- Dropdown Autosuggestion List -->
                <div
                  v-if="showEmployeeSuggestions && employeeSuggestions.length > 0"
                  class="dropdown-menu show w-100 shadow-sm mt-1"
                  style="max-height: 220px; overflow-y: auto;"
                >
                  <a
                    v-for="emp in employeeSuggestions"
                    :key="emp.id"
                    href="#"
                    class="dropdown-item py-2"
                    @click.prevent="selectEmployee(emp)"
                  >
                    <div>
                      <div class="fw-semibold">{{ emp.name }}</div>
                      <div class="small text-muted">
                        NIP: {{ emp.nip || emp.employeeNumber }} • Jabatan: {{ emp.positionName || '-' }} • Dept: {{ emp.departmentName || '-' }}
                      </div>
                    </div>
                  </a>
                </div>
              </div>

              <!-- USERNAME -->
              <div class="mb-3">
                <label class="form-label required">Username</label>
                <div class="input-group">
                  <input
                    v-model="formData.username"
                    type="text"
                    class="form-control"
                    :class="{
                      'is-invalid': formErrors.username || usernameCheckStatus === 'unavailable',
                      'is-valid': usernameCheckStatus === 'available' && !formErrors.username
                    }"
                    placeholder="Contoh: ahmadhermawan (min 6 char, huruf kecil & angka)"
                    @input="onUsernameInput"
                  />
                  <span v-if="isCheckingUsername" class="input-group-text">
                    <span class="spinner-border spinner-border-sm" role="status"></span>
                  </span>
                </div>
                <div v-if="formErrors.username" class="invalid-feedback d-block">
                  {{ formErrors.username }}
                </div>
                <div v-else-if="usernameCheckMessage" class="form-text" :class="usernameCheckStatus === 'available' ? 'text-success' : 'text-danger'">
                  {{ usernameCheckMessage }}
                </div>
                <div v-else class="form-text text-muted">
                  Minimal 6 karakter, hanya huruf kecil dan angka, tanpa spasi.
                </div>
              </div>

              <!-- JABATAN & DEPARTEMEN -->
              <div class="row g-3 mb-3">
                <div class="col-md-6">
                  <label class="form-label required">Jabatan</label>
                  <select
                    v-model="formData.position_id"
                    class="form-select"
                    :class="{ 'is-invalid': formErrors.position_id }"
                  >
                    <option :value="null" disabled>Pilih Jabatan</option>
                    <option
                      v-for="pos in positionsList"
                      :key="pos.id"
                      :value="pos.id"
                    >
                      {{ pos.name }}
                    </option>
                  </select>
                  <div v-if="formErrors.position_id" class="invalid-feedback">
                    {{ formErrors.position_id }}
                  </div>
                </div>

                <div class="col-md-6">
                  <label class="form-label required">Departemen</label>
                  <select
                    v-model="formData.department_id"
                    class="form-select"
                    :class="{ 'is-invalid': formErrors.department_id }"
                  >
                    <option :value="null" disabled>Pilih Departemen</option>
                    <option
                      v-for="dept in departmentsList"
                      :key="dept.id"
                      :value="dept.id"
                    >
                      {{ dept.name }}
                    </option>
                  </select>
                  <div v-if="formErrors.department_id" class="invalid-feedback">
                    {{ formErrors.department_id }}
                  </div>
                </div>
              </div>

              <!-- ROLE -->
              <div class="mb-3">
                <label class="form-label required">Role</label>
                <select
                  v-model="formData.role_id"
                  class="form-select"
                  :class="{ 'is-invalid': formErrors.role_id }"
                >
                  <option :value="null" disabled>Pilih Role</option>
                  <option
                    v-for="r in rolesList"
                    :key="r.id"
                    :value="r.id"
                  >
                    {{ r.name }} ({{ r.description }})
                  </option>
                </select>
                <div v-if="formErrors.role_id" class="invalid-feedback">
                  {{ formErrors.role_id }}
                </div>
              </div>

              <!-- PASSWORD -->
              <div class="mb-3">
                <div class="d-flex justify-content-between align-items-center">
                  <label
                    class="form-label"
                    :class="{ required: !isEditMode }"
                  >
                    Password {{ isEditMode ? '(Kosongkan jika tidak ingin mengubah)' : '' }}
                  </label>
                  <button
                    type="button"
                    class="btn btn-sm btn-outline-primary mb-1 d-inline-flex align-items-center gap-1"
                    @click="generateRandomPassword"
                  >
                    <IconKey size="14" />
                    <span>Generate Password</span>
                  </button>
                </div>
                <div class="input-group">
                  <input
                    v-model="formData.password"
                    :type="showPasswordText ? 'text' : 'password'"
                    class="form-control"
                    :class="{ 'is-invalid': formErrors.password }"
                    placeholder="Minimal 8 karakter (Huruf besar, kecil, angka, simbol)"
                    @input="validatePasswordOnKeyUp"
                  />
                  <button
                    class="btn btn-outline-secondary"
                    type="button"
                    @click="showPasswordText = !showPasswordText"
                  >
                    <IconEye v-if="!showPasswordText" size="18" />
                    <IconEyeOff v-else size="18" />
                  </button>
                </div>
                <div v-if="formErrors.password" class="invalid-feedback d-block">
                  {{ formErrors.password }}
                </div>
                <!-- Indikator Syarat Password -->
                <div class="mt-2 small text-muted">
                  <div class="d-flex flex-wrap gap-2">
                    <span :class="pwdCriteria.length ? 'text-success' : 'text-muted'">
                      • Min. 8 karakter
                    </span>
                    <span :class="pwdCriteria.noSpace ? 'text-success' : 'text-muted'">
                      • Tanpa spasi
                    </span>
                    <span :class="pwdCriteria.upper ? 'text-success' : 'text-muted'">
                      • Min. 1 Huruf Besar
                    </span>
                    <span :class="pwdCriteria.lower ? 'text-success' : 'text-muted'">
                      • Min. 1 Huruf Kecil
                    </span>
                    <span :class="pwdCriteria.symbol ? 'text-success' : 'text-muted'">
                      • Min. 1 Karakter Khusus / Simbol
                    </span>
                  </div>
                </div>
              </div>

              <!-- STATUS -->
              <div class="mb-3">
                <label class="form-label">Status Pengguna</label>
                <label class="form-check form-switch">
                  <input
                    v-model="formData.isActive"
                    class="form-check-input"
                    type="checkbox"
                  />
                  <span class="form-check-label fw-medium">
                    {{ formData.isActive ? 'Aktif (Dapat Login)' : 'Nonaktif (Tidak Dapat Login)' }}
                  </span>
                </label>
                <div class="form-text text-muted">
                  Catatan: Mengubah status user menjadi nonaktif akan secara otomatis me-logout sesi user tersebut dari aplikasi.
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <div class="d-flex gap-2 ms-auto">
              <button
                type="button"
                class="btn btn-secondary"
                @click="closeFormModal"
              >
                Batal
              </button>
              <button
                type="button"
                class="btn btn-primary d-inline-flex align-items-center gap-1"
                :disabled="isSubmitting"
                @click="submitForm"
              >
                <span
                  v-if="isSubmitting"
                  class="spinner-border spinner-border-sm"
                  role="status"
                ></span>
                <IconCheck v-else size="18" />
                <span>{{ isEditMode ? 'Simpan Perubahan' : 'Tambah User' }}</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- MODAL KONFIRMASI HAPUS USER -->
    <div
      v-if="showDeleteModal"
      class="modal modal-blur fade show d-block"
      tabindex="-1"
      style="background: rgba(0, 0, 0, 0.5)"
    >
      <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
          <button
            type="button"
            class="btn-close"
            @click="showDeleteModal = false"
            aria-label="Close"
          ></button>
          <div class="modal-status bg-danger"></div>
          <div class="modal-body text-center py-4">
            <IconAlertTriangle class="text-danger mb-2" size="48" />
            <h3 class="mb-1">Hapus User</h3>
            <div class="text-secondary">
              Apakah Anda yakin ingin menghapus akun user
              <strong>{{ userToDelete?.username }}</strong> ({{ userToDelete?.name }})?
            </div>
            <div v-if="deleteError" class="alert alert-danger mt-3 small">
              {{ deleteError }}
            </div>
          </div>
          <div class="modal-footer">
            <div class="w-100">
              <div class="row">
                <div class="col">
                  <button
                    class="btn w-100"
                    @click="showDeleteModal = false"
                  >
                    Batal
                  </button>
                </div>
                <div class="col">
                  <button
                    class="btn btn-danger w-100 d-inline-flex align-items-center justify-content-center gap-1"
                    :disabled="isDeleting"
                    @click="confirmDeleteUser"
                  >
                    <span
                      v-if="isDeleting"
                      class="spinner-border spinner-border-sm"
                      role="status"
                    ></span>
                    <span>Hapus</span>
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

<script setup>
import {
  IconPencil,
  IconPlus,
  IconSearch,
  IconTrash,
  IconCheck,
  IconKey,
  IconEye,
  IconEyeOff,
  IconAlertTriangle,
  IconCircleCheckFilled,
  IconXboxXFilled,
  IconArrowsSort,
} from "@tabler/icons-vue";

definePageMeta({
  title: "Kelola User",
  layout: false,
});

useSeoMeta({
  title: "Kelola User",
});

const { user: currentUser } = useAuth();

// Feedback alert
const alertMessage = ref("");
const alertType = ref("success");

const showAlert = (msg, type = "success") => {
  alertMessage.value = msg;
  alertType.value = type;
  setTimeout(() => {
    if (alertMessage.value === msg) {
      alertMessage.value = "";
    }
  }, 5000);
};

// 1. Fetch Users List
const {
  data: usersResponse,
  pending: pendingUsers,
  error: errorUsers,
  refresh: refreshUsers,
} = await useFetch("/api/users", { lazy: true });

const rawUsers = computed(() => usersResponse.value?.data || []);

// 2. Fetch Supporting Data: Roles, Positions, Departments, Employees
const { data: rolesResponse } = await useFetch("/api/roles", { lazy: true });
const rolesList = computed(() => rolesResponse.value?.data || []);

const { data: positionsResponse } = await useFetch("/api/positions", { lazy: true });
const positionsList = computed(() => positionsResponse.value || []);

const { data: departmentsResponse } = await useFetch("/api/departments", { lazy: true });
const departmentsList = computed(() => departmentsResponse.value || []);

const { data: employeesResponse } = await useFetch("/api/employees", { lazy: true });
const allEmployees = computed(() => employeesResponse.value || []);

// Filtering & Sorting
const searchQuery = ref("");
const selectedRoleFilter = ref("");
const selectedStatusFilter = ref("");
const sortKey = ref("id");
const sortOrder = ref("desc");

const isSelfUser = (userId) => {
  return Number(currentUser.value?.id) === Number(userId);
};

const sortBy = (key) => {
  if (sortKey.value === key) {
    sortOrder.value = sortOrder.value === "asc" ? "desc" : "asc";
  } else {
    sortKey.value = key;
    sortOrder.value = "asc";
  }
};

const processedUsers = computed(() => {
  let list = [...rawUsers.value];

  // Role filter
  if (selectedRoleFilter.value) {
    list = list.filter((u) => String(u.role_id) === String(selectedRoleFilter.value));
  }

  // Status filter
  if (selectedStatusFilter.value) {
    list = list.filter((u) => u.status === selectedStatusFilter.value);
  }

  // Search filter
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase().trim();
    list = list.filter(
      (u) =>
        (u.name && u.name.toLowerCase().includes(q)) ||
        (u.username && u.username.toLowerCase().includes(q)) ||
        (u.employee_nip && u.employee_nip.toLowerCase().includes(q)) ||
        (u.role_name && u.role_name.toLowerCase().includes(q)) ||
        (u.position_name && u.position_name.toLowerCase().includes(q)),
    );
  }

  // Sorting
  list.sort((a, b) => {
    let valA = a[sortKey.value] || "";
    let valB = b[sortKey.value] || "";

    if (typeof valA === "string") {
      valA = valA.toLowerCase();
      valB = (valB || "").toLowerCase();
      return sortOrder.value === "asc"
        ? valA.localeCompare(valB)
        : valB.localeCompare(valA);
    }

    return sortOrder.value === "asc" ? (valA > valB ? 1 : -1) : (valA < valB ? 1 : -1);
  });

  return list;
});

// Modal State & Form Handling
const showFormModal = ref(false);
const isEditMode = ref(false);
const editUserId = ref(null);
const isSubmitting = ref(false);
const formError = ref("");
const formErrors = ref({});
const showPasswordText = ref(false);

const formData = ref({
  name: "",
  username: "",
  password: "",
  role_id: null,
  employee_id: null,
  employee_nip: "",
  position_id: null,
  department_id: null,
  isActive: true,
});

// Autosuggestion State
const employeeSearchInput = ref("");
const showEmployeeSuggestions = ref(false);

const employeeSuggestions = computed(() => {
  const query = employeeSearchInput.value.trim().toLowerCase();
  if (query.length < 2) return [];

  return allEmployees.value.filter((emp) => {
    const name = (emp.name || "").toLowerCase();
    const nip = (emp.nip || emp.employeeNumber || "").toLowerCase();
    return name.includes(query) || nip.includes(query);
  });
});

const onEmployeeSearchInput = () => {
  showEmployeeSuggestions.value = true;
  formData.value.name = employeeSearchInput.value;
  formData.value.employee_id = null;
  formData.value.employee_nip = "";
};

const selectEmployee = (emp) => {
  formData.value.name = emp.name;
  formData.value.employee_id = emp.id;
  formData.value.employee_nip = emp.nip || emp.employeeNumber || "";
  employeeSearchInput.value = emp.name;
  showEmployeeSuggestions.value = false;

  // Auto-fill Jabatan & Departemen jika ada
  if (emp.positionId) {
    formData.value.position_id = emp.positionId;
  }
  if (emp.departmentId) {
    formData.value.department_id = emp.departmentId;
  }
};

const clearSelectedEmployee = () => {
  formData.value.employee_id = null;
  formData.value.employee_nip = "";
  employeeSearchInput.value = "";
  formData.value.name = "";
};

// Username Validation & Realtime Check
const isCheckingUsername = ref(false);
const usernameCheckStatus = ref(""); // 'available' | 'unavailable' | ''
const usernameCheckMessage = ref("");
let usernameDebounceTimer = null;

const onUsernameInput = () => {
  // Paksa huruf kecil dan tanpa spasi
  formData.value.username = formData.value.username.toLowerCase().replace(/\s+/g, "");

  formErrors.value.username = "";
  usernameCheckStatus.value = "";
  usernameCheckMessage.value = "";

  const val = formData.value.username;
  const usernameRegex = /^[a-z0-9]{6,}$/;
  if (!usernameRegex.test(val)) {
    if (val.length < 6) {
      formErrors.value.username = "Username minimal 6 karakter.";
    } else {
      formErrors.value.username = "Username hanya boleh huruf kecil dan angka, tanpa spasi.";
    }
    return;
  }

  clearTimeout(usernameDebounceTimer);
  usernameDebounceTimer = setTimeout(async () => {
    try {
      isCheckingUsername.value = true;
      const res = await $fetch("/api/users/check-username", {
        params: {
          username: val,
          excludeUserId: isEditMode.value ? editUserId.value : undefined,
        },
      });
      if (res.available) {
        usernameCheckStatus.value = "available";
        usernameCheckMessage.value = "Username tersedia";
      } else {
        usernameCheckStatus.value = "unavailable";
        usernameCheckMessage.value = "Username sudah digunakan";
      }
    } catch {
      // ignore
    } finally {
      isCheckingUsername.value = false;
    }
  }, 400);
};

// Password Validation & Generator
const pwdCriteria = computed(() => {
  const p = formData.value.password || "";
  return {
    length: p.length >= 8,
    noSpace: p.length > 0 && !/\s/.test(p),
    upper: /[A-Z]/.test(p),
    lower: /[a-z]/.test(p),
    symbol: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(p),
  };
});

const validatePasswordOnKeyUp = () => {
  formErrors.value.password = "";
  const p = formData.value.password;
  if (!p && isEditMode.value) return;

  if (p.length < 8) {
    formErrors.value.password = "Password minimal 8 karakter.";
  } else if (/\s/.test(p)) {
    formErrors.value.password = "Password tidak boleh mengandung spasi.";
  } else if (!/[A-Z]/.test(p)) {
    formErrors.value.password = "Password harus mengandung minimal 1 huruf besar.";
  } else if (!/[a-z]/.test(p)) {
    formErrors.value.password = "Password harus mengandung minimal 1 huruf kecil.";
  } else if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(p)) {
    formErrors.value.password = "Password harus mengandung minimal 1 simbol/karakter khusus.";
  }
};

const generateRandomPassword = () => {
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

  // Shuffle
  formData.value.password = pwd
    .split("")
    .sort(() => 0.5 - Math.random())
    .join("");

  showPasswordText.value = true;
  formErrors.value.password = "";
};

// Open Modals
const openAddModal = () => {
  isEditMode.value = false;
  editUserId.value = null;
  formError.value = "";
  formErrors.value = {};
  employeeSearchInput.value = "";
  showEmployeeSuggestions.value = false;
  usernameCheckStatus.value = "";
  usernameCheckMessage.value = "";

  formData.value = {
    name: "",
    username: "",
    password: "",
    role_id: rolesList.value[0]?.id || null,
    employee_id: null,
    employee_nip: "",
    position_id: positionsList.value[0]?.id || null,
    department_id: departmentsList.value[0]?.id || null,
    isActive: true,
  };

  generateRandomPassword();
  showFormModal.value = true;
};

const openEditModal = (userItem) => {
  isEditMode.value = true;
  editUserId.value = userItem.id;
  formError.value = "";
  formErrors.value = {};
  employeeSearchInput.value = userItem.name;
  showEmployeeSuggestions.value = false;
  usernameCheckStatus.value = "";
  usernameCheckMessage.value = "";

  formData.value = {
    name: userItem.name,
    username: userItem.username,
    password: "",
    role_id: userItem.role_id,
    employee_id: userItem.employee_id,
    employee_nip: userItem.employee_nip || "",
    position_id: userItem.position_id || positionsList.value[0]?.id || null,
    department_id: userItem.department_id || departmentsList.value[0]?.id || null,
    isActive: userItem.status === "active",
  };

  showFormModal.value = true;
};

const closeFormModal = () => {
  showFormModal.value = false;
};

// Submit Form (Create / Update)
const submitForm = async () => {
  formError.value = "";
  formErrors.value = {};

  if (!formData.value.name.trim()) {
    formErrors.value.name = "Nama pengguna wajib diisi.";
  }

  if (!formData.value.username.trim()) {
    formErrors.value.username = "Username wajib diisi.";
  } else {
    const usernameRegex = /^[a-z0-9]{6,}$/;
    if (!usernameRegex.test(formData.value.username)) {
      formErrors.value.username = "Username minimal 6 karakter alfanumerik huruf kecil tanpa spasi.";
    }
  }

  if (!isEditMode.value && !formData.value.password) {
    formErrors.value.password = "Password wajib diisi atau gunakan tombol Generate Password.";
  } else if (formData.value.password) {
    validatePasswordOnKeyUp();
  }

  if (!formData.value.role_id) {
    formErrors.value.role_id = "Role wajib dipilih.";
  }

  if (Object.keys(formErrors.value).length > 0) {
    return;
  }

  try {
    isSubmitting.value = true;
    const payload = {
      name: formData.value.name.trim(),
      username: formData.value.username.trim(),
      roleId: formData.value.role_id,
      employeeId: formData.value.employee_id,
      status: formData.value.isActive ? "active" : "inactive",
    };

    if (formData.value.password) {
      payload.password = formData.value.password;
    }

    if (isEditMode.value) {
      const res = await $fetch(`/api/users/${editUserId.value}`, {
        method: "PUT",
        body: payload,
      });
      showAlert(res.message || "User berhasil diperbarui.", "success");
    } else {
      const res = await $fetch("/api/users", {
        method: "POST",
        body: payload,
      });
      showAlert(res.message || "User baru berhasil ditambahkan.", "success");
    }

    closeFormModal();
    await refreshUsers();
  } catch (err) {
    formError.value = err?.data?.message || err?.message || "Terjadi kesalahan saat menyimpan data user.";
  } finally {
    isSubmitting.value = false;
  }
};

// Delete Modal & Confirmation
const showDeleteModal = ref(false);
const userToDelete = ref(null);
const isDeleting = ref(false);
const deleteError = ref("");

const openDeleteModal = (userItem) => {
  userToDelete.value = userItem;
  deleteError.value = "";
  showDeleteModal.value = true;
};

const confirmDeleteUser = async () => {
  if (!userToDelete.value) return;

  try {
    isDeleting.value = true;
    deleteError.value = "";
    const res = await $fetch(`/api/users/${userToDelete.value.id}`, {
      method: "DELETE",
    });
    showAlert(res.message || "User berhasil dihapus.", "success");
    showDeleteModal.value = false;
    await refreshUsers();
  } catch (err) {
    deleteError.value = err?.data?.message || err?.message || "Gagal menghapus user.";
  } finally {
    isDeleting.value = false;
  }
};
</script>
