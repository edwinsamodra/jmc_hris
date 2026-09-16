<script setup>
import {
  IconUser,
  IconMail,
  IconPhone,
  IconShieldLock,
  IconBriefcase,
  IconBuilding,
  IconCalendar,
  IconMapPin,
  IconRefresh,
  IconKey,
  IconId,
  IconCheck,
  IconAlertCircle,
  IconClock,
} from "@tabler/icons-vue";

definePageMeta({
  title: "My Profile",
});

useSeoMeta({
  title: "My Profile - HRIS",
});

const profileData = ref(null);
const isLoading = ref(true);
const errorMessage = ref("");

const fetchProfile = async () => {
  try {
    isLoading.value = true;
    errorMessage.value = "";
    const headers = useRequestHeaders(["cookie"]);
    const res = await $fetch("/api/profile", { headers });
    if (res?.success && res?.data) {
      profileData.value = res.data;
    } else {
      errorMessage.value = "Gagal memuat informasi profil.";
    }
  } catch (err) {
    console.error("Error fetching profile:", err);
    errorMessage.value =
      err?.data?.message || err?.message || "Terjadi kesalahan saat memuat profil.";
  } finally {
    isLoading.value = false;
  }
};

onMounted(() => {
  fetchProfile();
});

const user = computed(() => profileData.value?.user || null);
const role = computed(() => profileData.value?.role || null);
const employee = computed(() => profileData.value?.employee || null);

const userInitials = computed(() => {
  if (!user.value?.name) return "U";
  const parts = user.value.name.trim().split(" ");
  if (parts.length >= 2) {
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
  return parts[0].substring(0, 2).toUpperCase();
});

const formatDate = (dateStr) => {
  if (!dateStr) return "-";
  try {
    const d = new Date(dateStr);
    return d.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "long",
      year: "numeric",
    });
  } catch {
    return dateStr;
  }
};

const formatDateTime = (dateStr) => {
  if (!dateStr) return "-";
  try {
    const d = new Date(dateStr);
    return d.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "short",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  } catch {
    return dateStr;
  }
};
</script>

<template>
  <div>
    <!-- Error Alert -->
    <div v-if="errorMessage" class="alert alert-danger d-flex align-items-center mb-3" role="alert">
      <IconAlertCircle class="me-2" :size="20" />
      <div class="flex-grow-1">{{ errorMessage }}</div>
      <button class="btn btn-outline-danger btn-sm ms-2" @click="fetchProfile">
        <IconRefresh :size="16" class="me-1" /> Coba Lagi
      </button>
    </div>

    <!-- Loading Skeleton -->
    <div v-if="isLoading" class="row g-3">
      <div class="col-lg-4">
        <div class="card placeholder-glow">
          <div class="card-body text-center p-4">
            <div class="avatar avatar-xl rounded-circle placeholder mb-3" style="width: 80px; height: 80px;"></div>
            <div class="placeholder col-8 mb-2"></div>
            <div class="placeholder col-5"></div>
          </div>
        </div>
      </div>
      <div class="col-lg-8">
        <div class="card placeholder-glow">
          <div class="card-body p-4">
            <div class="placeholder col-12 mb-3" style="height: 30px;"></div>
            <div class="placeholder col-12 mb-2"></div>
            <div class="placeholder col-10 mb-2"></div>
            <div class="placeholder col-8"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Profile Content -->
    <div v-else-if="user" class="row g-3">
      <!-- Left Column: User Summary Card -->
      <div class="col-lg-4">
        <div class="card shadow-sm border-0 mb-3">
          <div class="card-body text-center p-4">
            <div class="mb-3 position-relative d-inline-block">
              <span
                class="avatar avatar-xl rounded-circle bg-primary text-white shadow-sm fw-bold fs-1"
                style="width: 88px; height: 88px;"
              >
                {{ userInitials }}
              </span>
              <span
                class="badge position-absolute bottom-0 end-0 rounded-pill p-1"
                :class="user.status === 'active' ? 'bg-success' : 'bg-danger'"
                :title="user.status === 'active' ? 'Status: Aktif' : 'Status: Nonaktif'"
              >
                <IconCheck v-if="user.status === 'active'" :size="14" />
                <IconAlertCircle v-else :size="14" />
              </span>
            </div>

            <h3 class="card-title fw-bold mb-1 fs-2 text-dark">{{ user.name }}</h3>
            <p class="text-secondary small mb-2">@{{ user.username }}</p>

            <div class="d-flex justify-content-center gap-2 mb-3">
              <span class="badge bg-blue-lt px-3 py-1 text-uppercase fw-semibold">
                {{ role?.name || "Pengguna" }}
              </span>
              <span
                class="badge"
                :class="user.status === 'active' ? 'bg-green-lt' : 'bg-red-lt'"
              >
                {{ user.status === 'active' ? 'Aktif' : 'Nonaktif' }}
              </span>
            </div>

            <p class="text-muted small mb-0 px-2" v-if="role?.description">
              {{ role.description }}
            </p>
          </div>

          <div class="card-footer bg-transparent border-top p-3 d-flex flex-column gap-2">
            <NuxtLink to="/change-password" class="btn btn-primary w-100 d-flex align-items-center justify-content-center gap-2">
              <IconKey :size="18" />
              <span>Ganti Password</span>
            </NuxtLink>
            <button @click="fetchProfile" type="button" class="btn btn-outline-secondary w-100 d-flex align-items-center justify-content-center gap-2">
              <IconRefresh :size="18" />
              <span>Refresh Profil</span>
            </button>
          </div>
        </div>

        <!-- Quick Meta Info -->
        <div class="card shadow-sm border-0">
          <div class="card-header py-3 bg-transparent">
            <h4 class="card-title fw-bold mb-0 text-dark d-flex align-items-center gap-2">
              <IconClock :size="18" class="text-primary" /> Informasi Akun
            </h4>
          </div>
          <div class="list-group list-group-flush small">
            <div class="list-group-item d-flex justify-content-between align-items-center px-3 py-2">
              <span class="text-secondary">Akun Dibuat</span>
              <span class="fw-semibold text-dark">{{ formatDate(user.createdAt) }}</span>
            </div>
            <div class="list-group-item d-flex justify-content-between align-items-center px-3 py-2">
              <span class="text-secondary">Terakhir Diperbarui</span>
              <span class="fw-semibold text-dark">{{ formatDateTime(user.updatedAt) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Right Column: Detail Information Sections -->
      <div class="col-lg-8">
        <!-- Section 1: Data Akun User -->
        <div class="card shadow-sm border-0 mb-3">
          <div class="card-header py-3 bg-transparent">
            <h3 class="card-title fw-bold mb-0 text-dark d-flex align-items-center gap-2">
              <IconShieldLock :size="20" class="text-primary" />
              Data Akun Pengguna
            </h3>
          </div>
          <div class="card-body p-4">
            <div class="row g-3">
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Nama Lengkap</label>
                <div class="fw-bold text-dark fs-3">{{ user.name }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Username</label>
                <div class="fw-bold text-dark fs-3">@{{ user.username }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconMail :size="14" /> Email Pengguna
                </label>
                <div class="fw-semibold text-dark">{{ user.email || "-" }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconPhone :size="14" /> Nomor HP / WhatsApp
                </label>
                <div class="fw-semibold text-dark">{{ user.cellphone || "-" }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Role / Hak Akses</label>
                <div>
                  <span class="badge bg-primary text-white fs-4 px-2 py-1">{{ role?.name }}</span>
                </div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Status Akun</label>
                <div>
                  <span class="badge" :class="user.status === 'active' ? 'bg-success text-white' : 'bg-danger text-white'">
                    {{ user.status === 'active' ? 'Aktif' : 'Nonaktif' }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Section 2: Data Pegawai (Jika terasosiasi) -->
        <div class="card shadow-sm border-0" v-if="employee">
          <div class="card-header py-3 bg-transparent d-flex justify-content-between align-items-center">
            <h3 class="card-title fw-bold mb-0 text-dark d-flex align-items-center gap-2">
              <IconBriefcase :size="20" class="text-primary" />
              Biodata & Kepegawaian
            </h3>
            <span
              class="badge text-uppercase"
              :class="{
                'bg-blue-lt': employee.employmentType === 'pkwt',
                'bg-green-lt': employee.employmentType === 'pkwtt',
                'bg-orange-lt': employee.employmentType === 'magang',
              }"
            >
              {{ employee.employmentType }}
            </span>
          </div>
          <div class="card-body p-4">
            <div class="row g-3">
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconId :size="14" /> Nomor Induk Pegawai (NIP)
                </label>
                <div class="fw-bold text-dark fs-3 font-monospace">{{ employee.nip }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconBuilding :size="14" /> Departemen
                </label>
                <div class="fw-bold text-dark fs-3">{{ employee.department?.name || "-" }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconBriefcase :size="14" /> Jabatan
                </label>
                <div class="fw-bold text-dark">{{ employee.position?.name || "-" }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconCalendar :size="14" /> Tanggal Bergabung
                </label>
                <div class="fw-semibold text-dark">{{ formatDate(employee.joinedAt) }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Tempat & Tanggal Lahir</label>
                <div class="fw-semibold text-dark">
                  {{ employee.birthPlace || "-" }}, {{ formatDate(employee.birthDate) }}
                </div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Jenis Kelamin</label>
                <div class="fw-semibold text-dark">{{ employee.gender || "-" }}</div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Status Pernikahan</label>
                <div class="fw-semibold text-dark">
                  {{ employee.maritalStatus || "-" }}
                  <span v-if="employee.childrenCount !== null" class="text-muted small">
                    ({{ employee.childrenCount }} Anak)
                  </span>
                </div>
              </div>
              <div class="col-sm-6">
                <label class="form-label text-secondary small mb-1">Jarak Rumah - Kantor</label>
                <div class="fw-semibold text-dark">
                  {{ employee.distanceKm !== null ? `${employee.distanceKm} km` : "-" }}
                </div>
              </div>
              <div class="col-12">
                <label class="form-label text-secondary small mb-1 d-flex align-items-center gap-1">
                  <IconMapPin :size="14" /> Alamat Lengkap Domisili
                </label>
                <div class="p-3 bg-light rounded text-dark">
                  <div>{{ employee.fullAddress || "-" }}</div>
                  <div class="text-secondary small mt-1" v-if="employee.location?.district">
                    Kec. {{ employee.location.district }}, {{ employee.location.regency }}, {{ employee.location.province }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Info Card if User has no Employee Link (e.g. Pure Superadmin) -->
        <div class="card shadow-sm border-0 bg-light" v-else>
          <div class="card-body p-4 text-center">
            <IconUser class="text-secondary mb-2" :size="32" />
            <h4 class="text-dark fw-bold mb-1">Akun Administrator Sistem</h4>
            <p class="text-secondary small mb-0">
              Akun ini beroperasi sebagai Superadmin sistem dan tidak terikat pada rekaman data pegawai operasional.
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.avatar-xl {
  font-size: 2rem;
}
</style>
