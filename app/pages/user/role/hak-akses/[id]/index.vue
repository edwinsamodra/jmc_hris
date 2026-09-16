<template>
  <div>
    <!-- Tombol Kembali / Header Navigasi -->
    <div class="mb-3 d-flex align-items-center justify-content-between">
      <NuxtLink to="/user/role" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1">
        <IconArrowLeft size="16" />
        <span>Kembali ke Daftar Role</span>
      </NuxtLink>
    </div>

    <!-- Loading State -->
    <div v-if="pending" class="card card-body text-center py-5">
      <div class="spinner-border text-primary" role="status"></div>
      <div class="mt-2 text-muted">Memuat data hak akses role...</div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="card card-body text-center py-5 text-danger">
      <p>Gagal memuat data hak akses: {{ error.message || 'Data role tidak ditemukan' }}</p>
      <NuxtLink to="/user/role" class="btn btn-sm btn-primary">Kembali ke Daftar Role</NuxtLink>
    </div>

    <div v-else>
      <!-- Form Metadata Role (Read-only / Disabled) -->
      <div class="card mb-3">
        <div class="card-header bg-light-lt">
          <h3 class="card-title">Informasi Role</h3>
        </div>
        <div class="card-body">
          <div class="row g-3">
            <div class="col-md-4">
              <label class="form-label required">Nama Role</label>
              <input
                type="text"
                class="form-control"
                :value="roleDetail?.name || ''"
                readonly
                disabled
              />
            </div>
            <div class="col-md-8">
              <label class="form-label required">Deskripsi</label>
              <textarea
                class="form-control"
                rows="2"
                :value="roleDetail?.description || ''"
                readonly
                disabled
              ></textarea>
            </div>
          </div>
        </div>
      </div>

      <!-- Table Matriks Detail Hak Akses Role -->
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h3 class="card-title">Daftar Hak Akses Modul</h3>
          <span class="badge bg-blue-lt">View Only</span>
        </div>
        <div class="table-responsive card-body p-0">
          <table class="table table-vcenter table-hover mb-0">
            <thead>
              <tr>
                <th style="width: 50px" class="text-center">No</th>
                <th style="cursor: pointer;" @click="toggleSort">
                  <div class="d-flex align-items-center gap-1">
                    <span>Modul/Fitur</span>
                    <IconArrowsSort size="14" class="text-muted" />
                  </div>
                </th>
                <th class="text-center" style="width: 100px">Akses</th>
                <th class="text-center" style="width: 100px">Create</th>
                <th style="width: 120px">Read</th>
                <th style="width: 120px">Update</th>
                <th style="width: 120px">Delete</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, index) in sortedPermissions" :key="item.module_id">
                <td class="text-center text-muted">{{ index + 1 }}</td>
                <td>
                  <div class="fw-semibold text-dark">{{ item.module_name }}</div>
                  <div class="small text-muted">{{ item.module_description }}</div>
                </td>
                <td class="text-center">
                  <IconCircleCheckFilled
                    v-if="Boolean(item.can_access)"
                    class="text-green"
                    size="20"
                  />
                  <IconXboxXFilled v-else class="text-muted" size="20" />
                </td>
                <td class="text-center">
                  <IconCircleCheckFilled
                    v-if="Boolean(item.can_create)"
                    class="text-green"
                    size="20"
                  />
                  <IconXboxXFilled v-else class="text-muted" size="20" />
                </td>
                <td>
                  <span
                    class="badge"
                    :class="getScopeBadgeClass(item.read_scope)"
                  >
                    {{ formatScopeText(item.read_scope) }}
                  </span>
                </td>
                <td>
                  <span
                    class="badge"
                    :class="getScopeBadgeClass(item.update_scope)"
                  >
                    {{ formatScopeText(item.update_scope) }}
                  </span>
                </td>
                <td>
                  <span
                    class="badge"
                    :class="getScopeBadgeClass(item.delete_scope)"
                  >
                    {{ formatScopeText(item.delete_scope) }}
                  </span>
                </td>
              </tr>
              <tr v-if="sortedPermissions.length === 0">
                <td colspan="7" class="text-center py-4 text-muted">
                  Tidak ada data modul perizinan.
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  IconCircleCheckFilled,
  IconXboxXFilled,
  IconArrowLeft,
  IconArrowsSort,
} from "@tabler/icons-vue";

definePageMeta({
  title: "Detail Hak Akses Role",
});

const route = useRoute();
const roleId = computed(() => route.params.id);

// Fetch real data role detail dan permissions dari backend API
const { data: responseData, pending, error } = await useFetch(
  () => `/api/roles/${roleId.value}`,
  {
    lazy: true,
    watch: [roleId],
  },
);

const roleDetail = computed(() => responseData.value?.data?.role || null);
const permissions = computed(() => responseData.value?.data?.permissions || []);

useSeoMeta({
  title: computed(() =>
    roleDetail.value ? `Hak Akses - ${roleDetail.value.name}` : "Hak Akses Role",
  ),
});

// Sorting state untuk kolom Modul/Fitur
const sortAsc = ref(true);
const isSortedByName = ref(false);

const toggleSort = () => {
  if (!isSortedByName.value) {
    isSortedByName.value = true;
    sortAsc.value = true;
  } else {
    sortAsc.value = !sortAsc.value;
  }
};

const sortedPermissions = computed(() => {
  const list = [...permissions.value];
  if (!isSortedByName.value) {
    // Default sort berdasarkan sort_order dari backend
    return list;
  }
  return list.sort((a, b) => {
    const nameA = a.module_name || "";
    const nameB = b.module_name || "";
    return sortAsc.value
      ? nameA.localeCompare(nameB)
      : nameB.localeCompare(nameA);
  });
});

const formatScopeText = (scope) => {
  switch (scope) {
    case "all":
      return "All";
    case "own":
      return "Own";
    case "no":
    default:
      return "No";
  }
};

const getScopeBadgeClass = (scope) => {
  switch (scope) {
    case "all":
      return "bg-green-lt text-green";
    case "own":
      return "bg-blue-lt text-blue";
    case "no":
    default:
      return "bg-secondary-lt text-muted";
  }
};
</script>
