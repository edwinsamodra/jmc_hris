<template>
  <div class="card">
    <div class="card-header">
      <div class="d-flex flex-wrap gap-2 ms-auto align-items-center">
        <!-- Filter Role -->
        <select v-model="selectedRoleFilter" class="form-select" style="width: 200px">
          <option value="">Semua Role</option>
          <option
            v-for="roleItem in allRoles"
            :key="roleItem.id"
            :value="roleItem.id"
          >
            {{ roleItem.name }}
          </option>
        </select>

        <!-- Search -->
        <div class="input-group" style="width: 250px">
          <input
            v-model="searchQuery"
            type="text"
            class="form-control"
            placeholder="Cari Role / Deskripsi..."
          />
          <button class="btn" type="button" @click="searchQuery = ''" v-if="searchQuery">
            &times;
          </button>
          <button class="btn" type="button" v-else>
            <IconSearch stroke="{2}" />
          </button>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="pending" class="card-body text-center py-5">
      <div class="spinner-border text-primary" role="status"></div>
      <div class="mt-2 text-muted">Memuat data role...</div>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="card-body text-center py-5 text-danger">
      <p>Gagal memuat data role: {{ error.message || 'Terjadi kesalahan sistem' }}</p>
      <button class="btn btn-sm btn-outline-primary" @click="refresh()">Coba Lagi</button>
    </div>

    <!-- Table View -->
    <div v-else class="table-responsive card-body p-0">
      <table class="table table-vcenter table-hover mb-0">
        <thead>
          <tr>
            <th style="width: 60px" class="text-center">No</th>
            <th style="width: 200px">Role</th>
            <th>Deskripsi</th>
            <th class="text-center" style="width: 140px">Aksi</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, index) in filteredRoles" :key="item.id">
            <td class="text-center text-muted">{{ index + 1 }}</td>
            <td class="fw-semibold text-dark">
              {{ item.name }}
              <div class="small text-muted font-monospace">{{ item.code }}</div>
            </td>
            <td class="text-secondary">{{ item.description }}</td>
            <td class="text-center">
              <NuxtLink
                :to="`/user/role/hak-akses/${item.id}`"
                class="btn btn-sm btn-primary d-inline-flex align-items-center gap-1"
              >
                <IconShieldLock size="16" />
                <span>Hak Akses</span>
              </NuxtLink>
            </td>
          </tr>
          <tr v-if="filteredRoles.length === 0">
            <td colspan="4" class="text-center py-4 text-muted">
              Tidak ada data role yang sesuai dengan filter/pencarian.
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="card-footer d-flex align-items-center">
      <span class="text-muted small">
        Menampilkan {{ filteredRoles.length }} dari {{ allRoles.length }} role
      </span>
    </div>
  </div>
</template>

<script setup>
import { IconSearch, IconShieldLock } from "@tabler/icons-vue";

definePageMeta({
  title: "Manajemen Role",
});

useSeoMeta({
  title: "Manajemen Role",
});

const searchQuery = ref("");
const selectedRoleFilter = ref("");

// Fetch real data role dari endpoint /api/roles
const { data: responseData, pending, error, refresh } = await useFetch("/api/roles", {
  lazy: true,
});

const allRoles = computed(() => {
  return responseData.value?.data || [];
});

const filteredRoles = computed(() => {
  let list = allRoles.value;

  if (selectedRoleFilter.value) {
    list = list.filter((r) => String(r.id) === String(selectedRoleFilter.value));
  }

  if (searchQuery.value.trim()) {
    const q = searchQuery.value.toLowerCase().trim();
    list = list.filter(
      (r) =>
        (r.name && r.name.toLowerCase().includes(q)) ||
        (r.description && r.description.toLowerCase().includes(q)) ||
        (r.code && r.code.toLowerCase().includes(q)),
    );
  }

  return list;
});
</script>
