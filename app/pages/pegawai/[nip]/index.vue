<script setup>
definePageMeta({
  title: "Detail Pegawai",
  layout: false,
});

useSeoMeta({
  title: "Detail Pegawai - HRIS",
});

import {
  IconArrowLeft,
  IconPencil,
  IconFileTypePdf,
  IconAlertCircle,
  IconMapPin,
  IconBriefcase,
  IconUser,
  IconSchool,
} from "@tabler/icons-vue";

const route = useRoute();
const { goBack } = useGoBack();
const { can } = useAuth();

const nipParam = computed(() => route.params.nip);
const employee = ref(null);
const isLoading = ref(true);
const errorMessage = ref("");

// Format date Indo
const formatDateIndo = (dateStr) => {
  if (!dateStr) return "-";
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return String(dateStr);
  return d.toLocaleDateString("id-ID", {
    day: "numeric",
    month: "long",
    year: "numeric",
  });
};

// Fetch Employee Detail
const fetchEmployeeDetail = async () => {
  if (!nipParam.value) return;
  isLoading.value = true;
  errorMessage.value = "";
  try {
    const res = await $fetch(`/api/employees/${nipParam.value}`);
    if (res?.success && res?.data) {
      employee.value = res.data;
    } else {
      errorMessage.value = "Data pegawai tidak ditemukan.";
    }
  } catch (err) {
    errorMessage.value = err?.data?.message || err?.message || "Gagal memuat data detail pegawai.";
  } finally {
    isLoading.value = false;
  }
};

const downloadPdf = () => {
  if (!employee.value) return;
  window.open(`/api/employees/export?format=pdf&id=${employee.value.id}`, "_blank");
};

onMounted(() => {
  fetchEmployeeDetail();
});
</script>

<template>
  <NuxtLayout name="default">
    <template #actions>
      <div class="d-flex gap-2">
        <button class="btn btn-outline-secondary" @click="goBack()">
          <IconArrowLeft size="18" class="me-1" />
          <span>Kembali</span>
        </button>
        <button
          v-if="employee"
          class="btn btn-outline-danger"
          title="Download PDF"
          @click="downloadPdf"
        >
          <IconFileTypePdf size="18" class="me-1" />
          <span>Download PDF</span>
        </button>
        <NuxtLink
          v-if="employee && can('update', 'employee')"
          :to="`/pegawai/form/${employee.id}`"
          class="btn btn-primary"
        >
          <IconPencil size="18" class="me-1" />
          <span>Edit Data</span>
        </NuxtLink>
      </div>
    </template>

    <!-- Loading State -->
    <div v-if="isLoading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status"></div>
      <div class="text-muted mt-2">Memuat detail data pegawai...</div>
    </div>

    <!-- Error State -->
    <div v-else-if="errorMessage" class="alert alert-danger shadow-sm my-4" role="alert">
      <div class="d-flex align-items-center">
        <IconAlertCircle class="me-2 text-danger" size="24" />
        <div>
          <h4 class="alert-title mb-1">Gagal Memuat Data</h4>
          <div class="text-secondary">{{ errorMessage }}</div>
        </div>
      </div>
      <div class="mt-3">
        <button class="btn btn-outline-secondary btn-sm" @click="goBack()">
          Kembali ke Daftar Pegawai
        </button>
      </div>
    </div>

    <!-- Employee Detail Content -->
    <div v-else-if="employee" class="row g-3">
      <!-- Kolom Kiri: Data Diri & Kontak -->
      <div class="col-lg-6">
        <div class="card shadow-sm border-0 mb-3">
          <div class="card-header bg-white py-3">
            <h3 class="card-title fw-bold text-primary mb-0 d-flex align-items-center gap-2">
              <IconUser size="20" />
              <span>1. Data Diri Pegawai</span>
            </h3>
          </div>
          <div class="card-body">
            <!-- Profil Avatar Header -->
            <div class="d-flex align-items-center gap-3 pb-3 border-bottom mb-3">
              <img
                :src="employee.photo_url || employee.photo_path || '/images/default-avatar.svg'"
                alt="Foto Profil"
                class="foto-profil shadow-sm"
              />
              <div>
                <div class="h3 fw-bold mb-1">{{ employee.name }}</div>
                <div class="badge bg-azure-lt font-monospace me-2">NIP: {{ employee.nip }}</div>
                <span
                  class="badge"
                  :class="employee.status === 'active' ? 'bg-success-lt text-success' : 'bg-danger-lt text-danger'"
                >
                  {{ employee.status === 'active' ? 'Aktif' : 'Nonaktif' }}
                </span>
              </div>
            </div>

            <!-- Datagrid Informasi Pribadi -->
            <div class="datagrid">
              <div class="datagrid-item">
                <div class="datagrid-title">Email</div>
                <div class="datagrid-content">{{ employee.email }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Nomor HP</div>
                <div class="datagrid-content">{{ employee.phone || '-' }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Tempat, Tanggal Lahir</div>
                <div class="datagrid-content">
                  {{ employee.birth_place || '-' }}, {{ formatDateIndo(employee.birth_date) }}
                </div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Usia</div>
                <div class="datagrid-content fw-bold text-primary">
                  {{ employee.age !== null ? `${employee.age} Tahun` : '-' }}
                </div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Status Pernikahan</div>
                <div class="datagrid-content">{{ employee.marital_status || '-' }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Jumlah Anak</div>
                <div class="datagrid-content">{{ employee.children_count }}</div>
              </div>
            </div>
          </div>
        </div>

        <!-- Alamat & Domisili -->
        <div class="card shadow-sm border-0">
          <div class="card-header bg-white py-3">
            <h3 class="card-title fw-bold text-primary mb-0 d-flex align-items-center gap-2">
              <IconMapPin size="20" />
              <span>Domisili & Alamat</span>
            </h3>
          </div>
          <div class="card-body">
            <div class="datagrid">
              <div class="datagrid-item" style="grid-column: span 2;">
                <div class="datagrid-title">Alamat Lengkap</div>
                <div class="datagrid-content">{{ employee.full_address || '-' }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Kecamatan</div>
                <div class="datagrid-content">{{ employee.district_name || '-' }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Kabupaten / Kota</div>
                <div class="datagrid-content">{{ employee.regency_name || '-' }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Provinsi</div>
                <div class="datagrid-content">{{ employee.province_name || '-' }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Jarak Rumah - Kantor</div>
                <div class="datagrid-content fw-bold text-azure">
                  {{ employee.distance_km || 0 }} km
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Kolom Kanan: Kepegawaian & Riwayat Pendidikan -->
      <div class="col-lg-6">
        <!-- Informasi Kepegawaian -->
        <div class="card shadow-sm border-0 mb-3">
          <div class="card-header bg-white py-3">
            <h3 class="card-title fw-bold text-primary mb-0 d-flex align-items-center gap-2">
              <IconBriefcase size="20" />
              <span>2. Informasi Kepegawaian</span>
            </h3>
          </div>
          <div class="card-body">
            <div class="datagrid">
              <div class="datagrid-item">
                <div class="datagrid-title">Jabatan</div>
                <div class="datagrid-content fw-bold">{{ employee.position_name }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Departemen</div>
                <div class="datagrid-content">{{ employee.department_name }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Tanggal Masuk</div>
                <div class="datagrid-content">{{ formatDateIndo(employee.joined_at) }}</div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Masa Kerja</div>
                <div class="datagrid-content">
                  <span class="badge bg-purple-lt fs-6">{{ employee.tenure_text }}</span>
                </div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Status Kontrak</div>
                <div class="datagrid-content text-uppercase fw-semibold">
                  {{ employee.employment_type }}
                </div>
              </div>
              <div class="datagrid-item">
                <div class="datagrid-title">Status Kepegawaian</div>
                <div class="datagrid-content">
                  <span
                    class="badge"
                    :class="employee.status === 'active' ? 'bg-success text-white' : 'bg-danger text-white'"
                  >
                    {{ employee.status === 'active' ? 'Aktif' : 'Nonaktif' }}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Riwayat Pendidikan -->
        <div class="card shadow-sm border-0">
          <div class="card-header bg-white py-3">
            <h3 class="card-title fw-bold text-primary mb-0 d-flex align-items-center gap-2">
              <IconSchool size="20" />
              <span>3. Riwayat Pendidikan</span>
            </h3>
          </div>
          <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-vcenter table-hover m-0">
                <thead class="bg-light">
                  <tr>
                    <th style="width: 50px;" class="text-center">No</th>
                    <th style="width: 120px;">Jenjang</th>
                    <th>Nama Institusi / Sekolah</th>
                    <th style="width: 130px;" class="text-center">Tahun Lulus</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-if="!employee.educations || employee.educations.length === 0">
                    <td colspan="4" class="text-center py-4 text-muted small">
                      Tidak ada data riwayat pendidikan.
                    </td>
                  </tr>
                  <tr
                    v-for="(edu, idx) in employee.educations"
                    :key="edu.id || idx"
                  >
                    <td class="text-center text-muted">{{ idx + 1 }}</td>
                    <td>
                      <span class="badge bg-blue-lt">{{ edu.education_level }}</span>
                    </td>
                    <td class="fw-semibold">{{ edu.school_name }}</td>
                    <td class="text-center">{{ edu.graduation_year || '-' }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </NuxtLayout>
</template>

<style scoped>
.foto-profil {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #f1f5f9;
}
</style>
