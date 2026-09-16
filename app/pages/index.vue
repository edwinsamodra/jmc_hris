<script setup>
import {
  IconUsers,
  IconHourglassEmpty,
  IconFileDescription,
  IconBackpack,
} from "@tabler/icons-vue";

definePageMeta({
  title: "Dashboard",
});

useSeoMeta({
  title: "Dashboard - HRIS",
});

const { user, userRole } = useAuth();

const userRoleLabel = computed(() => {
  const roleCode = user.value?.role_code || user.value?.role?.code || userRole.value;
  if (roleCode === "superadmin") return "Superadmin";
  if (roleCode === "manager_hrd") return "Manager HRD";
  if (roleCode === "admin_hrd") return "Admin HRD";
  return user.value?.role_name || user.value?.role?.name || "Pengguna";
});

// Fetch Real Dashboard Data
const dashboardData = ref(null);
const isLoading = ref(true);

const fetchDashboardStats = async () => {
  try {
    isLoading.value = true;
    const headers = useRequestHeaders(["cookie"]);
    const res = await $fetch("/api/dashboard/stats", { headers });
    if (res?.success) {
      dashboardData.value = res.data;
    }
  } catch (err) {
    console.error("Failed to load dashboard data:", err);
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  fetchDashboardStats();
});

// Stats array for Admin HRD
const adminStats = computed(() => {
  const stats = dashboardData.value?.stats;
  return [
    {
      title: "Total Pegawai",
      value: stats?.totalPegawai ?? 0,
      icon: IconUsers,
      backgroundColor: "linear-gradient(180deg, #549CE3 0%, #4A7BB2 100%)",
    },
    {
      title: "Total Pegawai Kontrak",
      value: stats?.totalPkwt ?? 0,
      icon: IconHourglassEmpty,
      backgroundColor: "linear-gradient(180deg, #EACE5C 0%, #D4A94D 100%)",
    },
    {
      title: "Total Pegawai Tetap",
      value: stats?.totalPkwtt ?? 0,
      icon: IconFileDescription,
      backgroundColor: "linear-gradient(180deg, #20BF91 0%, #1DA17D 100%)",
    },
    {
      title: "Peserta Magang",
      value: stats?.totalMagang ?? 0,
      icon: IconBackpack,
      backgroundColor: "linear-gradient(180deg, #F48968 0%, #CD795D 100%)",
    },
  ];
});

// Donut Charts Data for Admin HRD
const statusPegawaiSeries = computed(() => {
  return dashboardData.value?.charts?.employmentType?.series || [0, 0, 0];
});

const statusPegawaiOptions = {
  chart: { type: "donut", height: 220 },
  labels: ["PKWT", "PKWTT", "Magang"],
  colors: ["rgba(84, 128, 199, 1)", "rgba(43, 80, 142, 1)", "rgba(254, 126, 0, 1)"],
  legend: { position: "bottom" },
  dataLabels: { enabled: true },
};

const genderPegawaiSeries = computed(() => {
  return dashboardData.value?.charts?.gender?.series || [0, 0];
});

const genderPegawaiOptions = {
  chart: { type: "donut", height: 220 },
  labels: ["Laki-laki", "Perempuan"],
  colors: ["rgba(43, 80, 142, 1)", "rgba(254, 126, 0, 1)"],
  legend: { position: "bottom" },
  dataLabels: { enabled: true },
};

// Recent Employees Table for Admin HRD
const recentEmployees = computed(() => {
  return dashboardData.value?.recentEmployees || [];
});
</script>

<template>
  <div class="row g-3">
    <!-- Card Greetings -->
    <div
      :class="{
        'col-md-4 col-xl-3': userRole === 'admin_hrd',
        'col-12': userRole !== 'admin_hrd',
      }"
    >
      <div class="card bg-dark text-white shadow-sm border-0" data-bs-theme="dark">
        <div class="card-body p-4 d-flex flex-column justify-content-between">
          <div>
            <div class="mb-3">
              <span class="badge bg-primary text-white px-3 py-1 fs-5 fw-semibold shadow-sm">
                {{ userRoleLabel }}
              </span>
            </div>
            <h2 class="h2 mb-3 text-white fw-bold">
              Selamat Datang {{ user?.name || "Pengguna" }} - {{ userRoleLabel }}
            </h2>
          </div>
          <p class="mb-0 text-white-50 small fst-italic border-top border-secondary pt-3 mt-3">
            "Fokuskan tujuan yang ingin didapat, jangan biarkan faktor lain menghalangi tujuan Anda."
          </p>
        </div>
      </div>
    </div>

    <!-- ========================================== -->
    <!-- 1. DASHBOARD KHUSUS: ADMIN HRD             -->
    <!-- Versi Lengkap: Widgets + Charts +          -->
    <!-- 5 Pegawai Masuk Paling Baru                -->
    <!-- ========================================== -->
    <template v-if="userRole === 'admin_hrd'">
      <div class="col-md-8 col-xl-9">
        <div class="row g-3">
          <!-- 4 Widgets Statistik Pegawai -->
          <div class="col-12">
            <div class="card shadow-sm">
              <div class="card-body">
                <div class="row g-3">
                  <div
                    class="col-md-6 col-lg-3"
                    v-for="(item, index) in adminStats"
                    :key="index"
                  >
                    <div class="row align-items-center">
                      <div class="col-auto">
                        <div
                          class="d-flex rounded-circle shadow-sm"
                          :style="{
                            width: '52px',
                            height: '52px',
                            background: item.backgroundColor,
                          }"
                        >
                          <component
                            :is="item.icon"
                            :stroke="2"
                            class="m-auto text-white"
                          />
                        </div>
                      </div>
                      <div class="col">
                        <h3 class="fs-2 mb-0 fw-bold">{{ item.value }}</h3>
                        <p class="text-secondary fw-light mb-0 small">
                          {{ item.title }}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- 2 Doughnut Charts -->
          <div class="col-md-6">
            <div class="card shadow-sm h-100">
              <div class="card-header">
                <h3 class="card-title fw-bold">Status Pegawai</h3>
              </div>
              <div class="card-body">
                <client-only>
                  <apexchart
                    type="donut"
                    :options="statusPegawaiOptions"
                    :series="statusPegawaiSeries"
                  />
                </client-only>
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <div class="card shadow-sm h-100">
              <div class="card-header">
                <h3 class="card-title fw-bold">Pegawai Berdasarkan Gender</h3>
              </div>
              <div class="card-body">
                <client-only>
                  <apexchart
                    type="donut"
                    :options="genderPegawaiOptions"
                    :series="genderPegawaiSeries"
                  />
                </client-only>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Tabel 5 Pegawai Masuk Paling Baru -->
      <div class="col-12">
        <div class="card shadow-sm">
          <div class="card-header d-flex justify-content-between align-items-center">
            <h3 class="card-title fw-bold">5 Pegawai dengan Tanggal Masuk Paling Baru</h3>
            <NuxtLink to="/pegawai" class="btn btn-outline-primary btn-sm">
              Lihat Semua Pegawai
            </NuxtLink>
          </div>
          <div class="table-responsive card-body p-0">
            <table class="table table-vcenter table-striped card-table">
              <thead>
                <tr>
                  <th class="w-1">No</th>
                  <th>NIP</th>
                  <th>Nama Lengkap</th>
                  <th>Jabatan & Dept</th>
                  <th>Tanggal Masuk</th>
                  <th>Status Kontrak</th>
                  <th>Aksi</th>
                </tr>
              </thead>
              <tbody>
                <tr v-if="recentEmployees.length === 0">
                  <td colspan="7" class="text-center py-4 text-secondary">
                    Belum ada data pegawai.
                  </td>
                </tr>
                <tr v-for="(emp, index) in recentEmployees" :key="emp.id">
                  <td class="text-center">{{ index + 1 }}</td>
                  <td class="fw-bold">{{ emp.nip }}</td>
                  <td>
                    <div class="d-flex align-items-center gap-2">
                      <span class="avatar avatar-sm rounded-circle bg-primary text-white fw-bold">
                        {{ emp.name.charAt(0) }}
                      </span>
                      <span class="fw-semibold">{{ emp.name }}</span>
                    </div>
                  </td>
                  <td>{{ emp.position }} ({{ emp.department }})</td>
                  <td>{{ emp.joinedAt }}</td>
                  <td>
                    <span
                      class="badge"
                      :class="{
                        'bg-blue-lt': emp.employmentType === 'PKWT',
                        'bg-green-lt': emp.employmentType === 'PKWTT',
                        'bg-orange-lt': emp.employmentType === 'MAGANG',
                      }"
                    >
                      {{ emp.employmentType }}
                    </span>
                  </td>
                  <td>
                    <NuxtLink
                      to="/pegawai"
                      class="btn btn-primary btn-sm"
                    >
                      Detail Pegawai
                    </NuxtLink>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>
