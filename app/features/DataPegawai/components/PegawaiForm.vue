<template>
  <div>
    <!-- Success & Error Alerts -->
    <div v-if="successMessage" class="alert alert-success alert-dismissible mb-4 shadow-sm" role="alert">
      <div class="d-flex align-items-center">
        <IconCheck class="me-2 text-success" size="22" />
        <div>
          <h4 class="alert-title mb-1">Berhasil!</h4>
          <div class="text-secondary">{{ successMessage }}</div>
        </div>
      </div>
      <button type="button" class="btn-close" @click="successMessage = ''"></button>
    </div>

    <div v-if="errorMessage" class="alert alert-danger alert-dismissible mb-4 shadow-sm" role="alert">
      <div class="d-flex align-items-center">
        <IconAlertCircle class="me-2 text-danger" size="22" />
        <div>
          <h4 class="alert-title mb-1">Gagal Menyimpan Data</h4>
          <div class="text-secondary">{{ errorMessage }}</div>
        </div>
      </div>
      <button type="button" class="btn-close" @click="errorMessage = ''"></button>
    </div>

    <form @submit.prevent="handleSubmit">
      <div class="row g-3">
        <!-- Kolom Kiri: Data Diri -->
        <div class="col-lg-6">
          <div class="card shadow-sm border-0 h-100">
            <div class="card-header bg-white py-3">
              <h3 class="card-title fw-bold text-primary mb-0">1. Data Diri Pegawai</h3>
            </div>
            <div class="card-body">
              <div class="row g-3">
                <!-- Foto, NIP, Nama Lengkap -->
                <div class="col-12">
                  <div class="row align-items-center g-3">
                    <!-- Foto Profil -->
                    <div class="col-auto text-center">
                      <div class="avatar-preview-container mb-2">
                        <img
                          :src="photoPreview || form.photo_path || '/images/default-avatar.svg'"
                          alt="Foto Pegawai"
                          class="foto-profil shadow-sm"
                        />
                      </div>
                      <label
                        for="unggah-foto"
                        class="btn btn-sm btn-outline-primary cursor-pointer w-100"
                      >
                        <IconCamera size="16" class="me-1" />
                        {{ form.photo_path || photoPreview ? 'Ganti Foto' : 'Unggah Foto' }}
                      </label>
                      <input
                        id="unggah-foto"
                        type="file"
                        accept="image/png, image/jpeg, image/jpg"
                        hidden
                        @change="handlePhotoChange"
                      />
                      <div class="text-muted small mt-1" style="font-size: 11px;">
                        PNG/JPG (Maks 2MB)
                      </div>
                    </div>

                    <div class="col">
                      <!-- NIP -->
                      <div class="mb-3">
                        <label class="form-label required">NIP (Nomor Induk Pegawai)</label>
                        <input
                          v-model="form.nip"
                          type="text"
                          class="form-control"
                          :class="{ 'is-invalid': validationErrors.nip }"
                          placeholder="Contoh: 19930412001"
                          @input="validateField('nip')"
                        />
                        <div v-if="validationErrors.nip" class="invalid-feedback">
                          {{ validationErrors.nip }}
                        </div>
                        <small class="form-hint">Minimal 8 karakter angka, tanpa spasi.</small>
                      </div>

                      <!-- Nama Lengkap -->
                      <div>
                        <label class="form-label required">Nama Lengkap</label>
                        <input
                          v-model="form.name"
                          type="text"
                          class="form-control"
                          :class="{ 'is-invalid': validationErrors.name }"
                          placeholder="Nama lengkap pegawai"
                          @input="validateField('name')"
                        />
                        <div v-if="validationErrors.name" class="invalid-feedback">
                          {{ validationErrors.name }}
                        </div>
                        <small class="form-hint">Huruf, angka, tanda petik atas ('), dan spasi.</small>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Email -->
                <div class="col-md-6">
                  <label class="form-label required">Email</label>
                  <input
                    v-model="form.email"
                    type="email"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.email }"
                    placeholder="pegawai@example.com"
                    @input="validateField('email')"
                  />
                  <div v-if="validationErrors.email" class="invalid-feedback">
                    {{ validationErrors.email }}
                  </div>
                </div>

                <!-- Nomor HP -->
                <div class="col-md-6">
                  <label class="form-label required">Nomor HP</label>
                  <input
                    v-model="form.phone"
                    type="text"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.phone }"
                    placeholder="+6282218458888"
                    @input="validateField('phone')"
                  />
                  <div v-if="validationErrors.phone" class="invalid-feedback">
                    {{ validationErrors.phone }}
                  </div>
                  <small class="form-hint">Format internasional (+62...)</small>
                </div>

                <!-- Tempat Lahir -->
                <div class="col-md-5">
                  <label class="form-label required">Tempat Lahir</label>
                  <input
                    v-model="form.birth_place"
                    type="text"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.birth_place }"
                    placeholder="Kota kelahiran"
                  />
                </div>

                <!-- Tanggal Lahir -->
                <div class="col-md-4">
                  <label class="form-label required">Tanggal Lahir</label>
                  <input
                    v-model="form.birth_date"
                    type="date"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.birth_date }"
                    @change="calculateAge"
                  />
                </div>

                <!-- Usia (Disabled) -->
                <div class="col-md-3">
                  <label class="form-label">Usia</label>
                  <div class="input-group">
                    <input
                      :value="calculatedAge"
                      type="text"
                      class="form-control bg-light text-center fw-bold"
                      readonly
                      placeholder="0"
                    />
                    <span class="input-group-text bg-light">Thn</span>
                  </div>
                </div>

                <!-- Status Pernikahan -->
                <div class="col-md-6">
                  <label class="form-label required">Status Pernikahan</label>
                  <div class="d-flex gap-3 mt-2">
                    <label class="form-check cursor-pointer">
                      <input
                        v-model="form.marital_status"
                        class="form-check-input"
                        type="radio"
                        value="Belum Menikah"
                      />
                      <span class="form-check-label">Belum Menikah</span>
                    </label>
                    <label class="form-check cursor-pointer">
                      <input
                        v-model="form.marital_status"
                        class="form-check-input"
                        type="radio"
                        value="Menikah"
                      />
                      <span class="form-check-label">Menikah</span>
                    </label>
                  </div>
                </div>

                <!-- Jumlah Anak -->
                <div class="col-md-6">
                  <label class="form-label required">Jumlah Anak</label>
                  <input
                    v-model.number="form.children_count"
                    type="number"
                    min="0"
                    max="99"
                    class="form-control"
                    placeholder="0"
                  />
                  <small class="form-hint">Maksimal 2 digit (0 - 99).</small>
                </div>

                <!-- Kecamatan (Autocomplete) -->
                <div class="col-md-12 position-relative">
                  <label class="form-label required">
                    Kecamatan (Ketik minimal 3 huruf untuk cari)
                  </label>
                  <div class="input-icon">
                    <span class="input-icon-addon">
                      <IconSearch size="16" class="text-muted" />
                    </span>
                    <input
                      v-model="districtSearch"
                      type="text"
                      class="form-control"
                      :class="{ 'is-invalid': validationErrors.district_id }"
                      placeholder="Ketik nama kecamatan..."
                      autocomplete="off"
                      @input="onDistrictSearchInput"
                      @focus="showDistrictDropdown = true"
                    />
                  </div>
                  <div v-if="validationErrors.district_id" class="invalid-feedback d-block">
                    {{ validationErrors.district_id }}
                  </div>

                  <!-- Dropdown Hasil Autocomplete Wilayah -->
                  <div
                    v-if="showDistrictDropdown && districtResults.length > 0"
                    class="dropdown-menu show w-100 shadow p-1 mt-1 position-absolute"
                    style="max-height: 200px; overflow-y: auto; z-index: 1050;"
                  >
                    <button
                      v-for="item in districtResults"
                      :key="item.id"
                      type="button"
                      class="dropdown-item py-2"
                      @click="selectDistrict(item)"
                    >
                      <div class="fw-bold">{{ item.district_name }}</div>
                      <div class="text-muted small">{{ item.regency_name }}, {{ item.province_name }}</div>
                    </button>
                  </div>
                </div>

                <!-- Kabupaten & Provinsi (Otomatis Terisi & Disabled) -->
                <div class="col-md-6">
                  <label class="form-label">Kabupaten / Kota</label>
                  <input
                    :value="form.regency_name"
                    type="text"
                    class="form-control bg-light"
                    readonly
                    placeholder="Otomatis dari kecamatan"
                  />
                </div>

                <div class="col-md-6">
                  <label class="form-label">Provinsi</label>
                  <input
                    :value="form.province_name"
                    type="text"
                    class="form-control bg-light"
                    readonly
                    placeholder="Otomatis dari kecamatan"
                  />
                </div>

                <!-- Alamat Lengkap -->
                <div class="col-12">
                  <label class="form-label required">Alamat Lengkap</label>
                  <textarea
                    v-model="form.full_address"
                    class="form-control"
                    rows="3"
                    :class="{ 'is-invalid': validationErrors.full_address }"
                    placeholder="Jl. Nama Jalan, No. Rumah, RT/RW, dsb."
                  ></textarea>
                </div>

                <!-- Jarak Rumah - Kantor -->
                <div class="col-md-6">
                  <label class="form-label required">Jarak Rumah - Kantor</label>
                  <div class="input-group">
                    <input
                      v-model.number="form.distance_km"
                      type="number"
                      min="0"
                      max="99"
                      step="0.1"
                      class="form-control"
                      placeholder="0"
                    />
                    <span class="input-group-text">km</span>
                  </div>
                  <small class="form-hint">Maksimal 2 digit.</small>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Kolom Kanan: Kepegawaian & Pendidikan -->
        <div class="col-lg-6">
          <div class="row g-3">
            <!-- Data Kepegawaian -->
            <div class="col-12">
              <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                  <h3 class="card-title fw-bold text-primary mb-0">2. Data Kepegawaian</h3>
                </div>
                <div class="card-body">
                  <div class="row g-3">
                    <!-- Tanggal Masuk -->
                    <div class="col-md-6">
                      <label class="form-label required">Tanggal Masuk</label>
                      <input
                        v-model="form.joined_at"
                        type="date"
                        class="form-control"
                        :class="{ 'is-invalid': validationErrors.joined_at }"
                      />
                    </div>

                    <!-- Status Kontrak -->
                    <div class="col-md-6">
                      <label class="form-label required">Status Kontrak</label>
                      <select v-model="form.employment_type" class="form-select">
                        <option value="pkwtt">PKWTT (Tetap)</option>
                        <option value="pkwt">PKWT (Kontrak)</option>
                        <option value="magang">Magang</option>
                      </select>
                    </div>

                    <!-- Jabatan -->
                    <div class="col-md-6">
                      <label class="form-label required">Jabatan</label>
                      <select
                        v-model.number="form.position_id"
                        class="form-select"
                        :class="{ 'is-invalid': validationErrors.position_id }"
                      >
                        <option :value="0" disabled>Pilih Jabatan</option>
                        <option
                          v-for="pos in positions"
                          :key="pos.id"
                          :value="pos.id"
                        >
                          {{ pos.name }}
                        </option>
                      </select>
                    </div>

                    <!-- Departemen -->
                    <div class="col-md-6">
                      <label class="form-label required">Departemen</label>
                      <select
                        v-model.number="form.department_id"
                        class="form-select"
                        :class="{ 'is-invalid': validationErrors.department_id }"
                      >
                        <option :value="0" disabled>Pilih Departemen</option>
                        <option
                          v-for="dept in departments"
                          :key="dept.id"
                          :value="dept.id"
                        >
                          {{ dept.name }}
                        </option>
                      </select>
                    </div>

                    <!-- Status Kepegawaian (Switch) -->
                    <div class="col-md-6">
                      <label class="form-label">Status Kepegawaian</label>
                      <label class="form-check form-switch mt-2 cursor-pointer">
                        <input
                          v-model="form.isActive"
                          class="form-check-input"
                          type="checkbox"
                        />
                        <span class="form-check-label fw-bold" :class="form.isActive ? 'text-success' : 'text-danger'">
                          {{ form.isActive ? 'Aktif' : 'Nonaktif' }}
                        </span>
                      </label>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Riwayat Pendidikan Dinamis -->
            <div class="col-12">
              <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 d-flex align-items-center justify-content-between">
                  <div>
                    <h3 class="card-title fw-bold text-primary mb-0">3. Riwayat Pendidikan</h3>
                    <div class="text-muted small">Semua kolom pada baris yang ditambahkan wajib diisi lengkap.</div>
                  </div>
                  <button
                    type="button"
                    class="btn btn-sm btn-outline-primary"
                    @click="addEducationRow"
                  >
                    <IconPlus size="16" class="me-1" />
                    Tambah Jenjang
                  </button>
                </div>
                <div class="card-body p-0">
                  <div class="table-responsive">
                    <table class="table table-vcenter table-borderless m-0">
                      <thead class="bg-light">
                        <tr>
                          <th style="width: 22%;">Jenjang <span class="text-danger">*</span></th>
                          <th>Nama Sekolah / Universitas <span class="text-danger">*</span></th>
                          <th style="width: 25%;">Tahun Lulus <span class="text-danger">*</span></th>
                          <th style="width: 5%;"></th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-if="form.educations.length === 0">
                          <td colspan="4" class="text-center py-4 text-muted small">
                            Belum ada data pendidikan. Klik "Tambah Jenjang" di atas untuk menambahkan.
                          </td>
                        </tr>
                        <tr
                          v-for="(edu, idx) in form.educations"
                          :key="idx"
                          class="border-bottom align-top"
                        >
                          <td class="py-2">
                            <select
                              v-model="edu.education_level"
                              class="form-select form-select-sm"
                              @change="validateEducationRow(idx)"
                            >
                              <option value="SD">SD</option>
                              <option value="SMP">SMP</option>
                              <option value="SMA">SMA</option>
                              <option value="SMK">SMK</option>
                              <option value="D3">D3</option>
                              <option value="S1">S1</option>
                              <option value="S2">S2</option>
                              <option value="S3">S3</option>
                            </select>
                          </td>
                          <td class="py-2">
                            <input
                              v-model="edu.school_name"
                              type="text"
                              class="form-control form-control-sm"
                              :class="{ 'is-invalid': educationErrors[idx]?.school_name }"
                              placeholder="Nama sekolah / universitas..."
                              @input="validateEducationRow(idx)"
                            />
                            <div
                              v-if="educationErrors[idx]?.school_name"
                              class="invalid-feedback d-block"
                              style="font-size: 11px;"
                            >
                              {{ educationErrors[idx].school_name }}
                            </div>
                          </td>
                          <td class="py-2">
                            <input
                              v-model.number="edu.graduation_year"
                              type="number"
                              min="1950"
                              max="2099"
                              class="form-control form-control-sm"
                              :class="{ 'is-invalid': educationErrors[idx]?.graduation_year }"
                              placeholder="Contoh: 2020"
                              @input="validateEducationRow(idx)"
                            />
                            <div
                              v-if="educationErrors[idx]?.graduation_year"
                              class="invalid-feedback d-block"
                              style="font-size: 11px;"
                            >
                              {{ educationErrors[idx].graduation_year }}
                            </div>
                          </td>
                          <td class="py-2 text-center">
                            <button
                              type="button"
                              class="btn btn-icon btn-sm btn-ghost-danger"
                              title="Hapus baris"
                              @click="removeEducationRow(idx)"
                            >
                              <IconTrash size="16" />
                            </button>
                          </td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
                <div class="card-footer bg-white border-top py-3">
                  <div class="d-flex justify-content-end gap-2">
                    <button
                      type="button"
                      class="btn btn-outline-secondary px-4"
                      :disabled="isSubmitting"
                      @click="goBack()"
                    >
                      Batal
                    </button>
                    <button
                      type="submit"
                      class="btn btn-primary px-4 shadow-sm"
                      :disabled="isSubmitting"
                    >
                      <span v-if="isSubmitting" class="spinner-border spinner-border-sm me-2"></span>
                      <span>{{ isEditMode ? 'Simpan Perubahan' : 'Simpan Pegawai' }}</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script setup>
import {
  IconCamera,
  IconCheck,
  IconAlertCircle,
  IconSearch,
  IconPlus,
  IconTrash,
} from "@tabler/icons-vue";

const route = useRoute();
const { goBack } = useGoBack();

// Detect Edit Mode
const employeeId = computed(() => route.params.id);
const isEditMode = computed(() => Boolean(employeeId.value));

// Master data
const positions = ref([]);
const departments = ref([]);

// Form State
const form = reactive({
  nip: "",
  name: "",
  email: "",
  phone: "",
  photo_path: "",
  photo_base64: "",
  birth_place: "",
  birth_date: "",
  marital_status: "Belum Menikah",
  children_count: 0,
  district_id: 0,
  district_name: "",
  regency_name: "",
  province_name: "",
  full_address: "",
  distance_km: 0,
  joined_at: "",
  position_id: 0,
  department_id: 0,
  employment_type: "pkwtt",
  isActive: true,
  educations: [
    { education_level: "S1", school_name: "", graduation_year: "" },
  ],
});

const calculatedAge = ref(0);
const photoPreview = ref("");
const validationErrors = reactive({});
const educationErrors = ref([]);
const isSubmitting = ref(false);
const errorMessage = ref("");
const successMessage = ref("");

// Autocomplete Kecamatan State
const districtSearch = ref("");
const districtResults = ref([]);
const showDistrictDropdown = ref(false);
let districtTimer = null;

// Calculate Age
const calculateAge = () => {
  if (!form.birth_date) {
    calculatedAge.value = 0;
    return;
  }
  const bDate = new Date(form.birth_date);
  if (isNaN(bDate.getTime())) {
    calculatedAge.value = 0;
    return;
  }
  const today = new Date();
  let age = today.getFullYear() - bDate.getFullYear();
  if (
    today.getMonth() < bDate.getMonth() ||
    (today.getMonth() === bDate.getMonth() && today.getDate() < bDate.getDate())
  ) {
    age--;
  }
  calculatedAge.value = Math.max(0, age);
};

// Autocomplete Kecamatan Search
const onDistrictSearchInput = () => {
  clearTimeout(districtTimer);
  showDistrictDropdown.value = true;
  if (districtSearch.value.trim().length < 3) {
    districtResults.value = [];
    return;
  }

  districtTimer = setTimeout(async () => {
    try {
      const res = await $fetch(`/api/wilayah/districts?q=${encodeURIComponent(districtSearch.value.trim())}`);
      districtResults.value = res?.data || [];
    } catch (err) {
      console.error("Gagal mencari kecamatan:", err);
    }
  }, 300);
};

const selectDistrict = (item) => {
  form.district_id = item.id;
  form.district_name = item.district_name;
  form.regency_name = item.regency_name;
  form.province_name = item.province_name;
  districtSearch.value = item.district_name;
  showDistrictDropdown.value = false;
  validationErrors.district_id = "";
};

// Educations Add/Remove & Validation
const addEducationRow = () => {
  form.educations.push({
    education_level: "SMA",
    school_name: "",
    graduation_year: "",
  });
  educationErrors.value.push({});
};

const removeEducationRow = (index) => {
  form.educations.splice(index, 1);
  educationErrors.value.splice(index, 1);
};

const validateEducationRow = (index) => {
  const edu = form.educations[index];
  if (!edu) return;

  if (!educationErrors.value[index]) {
    educationErrors.value[index] = {};
  }

  if (!edu.school_name || !String(edu.school_name).trim()) {
    educationErrors.value[index].school_name = "Nama sekolah/universitas wajib diisi.";
  } else {
    delete educationErrors.value[index].school_name;
  }

  const gradYear = Number(edu.graduation_year);
  if (!edu.graduation_year || isNaN(gradYear) || gradYear < 1950 || gradYear > 2099) {
    educationErrors.value[index].graduation_year = "Tahun lulus wajib 4 digit (1950 - 2099).";
  } else {
    delete educationErrors.value[index].graduation_year;
  }
};

const validateEducations = () => {
  let isValid = true;
  educationErrors.value = [];

  for (let i = 0; i < form.educations.length; i++) {
    const edu = form.educations[i];
    const rowErr = {};

    if (!edu.school_name || !String(edu.school_name).trim()) {
      rowErr.school_name = "Nama sekolah/universitas wajib diisi.";
      isValid = false;
    }

    const gradYear = Number(edu.graduation_year);
    if (!edu.graduation_year || isNaN(gradYear) || gradYear < 1950 || gradYear > 2099) {
      rowErr.graduation_year = "Tahun lulus wajib 4 digit (1950 - 2099).";
      isValid = false;
    }

    educationErrors.value[i] = rowErr;
  }

  return isValid;
};

// Photo Upload Handler
const handlePhotoChange = (e) => {
  const file = e.target.files?.[0];
  if (!file) return;

  // Validate format
  if (!["image/png", "image/jpeg", "image/jpg"].includes(file.type)) {
    alert("Hanya format gambar PNG, JPG, atau JPEG yang diperbolehkan.");
    return;
  }

  // Validate size <= 2MB
  if (file.size > 2 * 1024 * 1024) {
    alert("Ukuran foto maksimal 2MB.");
    return;
  }

  const reader = new FileReader();
  reader.onload = (event) => {
    photoPreview.value = event.target?.result;
    form.photo_base64 = event.target?.result;
  };
  reader.readAsDataURL(file);
};

// Field Validation
const validateField = (field) => {
  switch (field) {
    case "nip":
      if (!form.nip) {
        validationErrors.nip = "NIP wajib diisi.";
      } else if (!/^\d{8,}$/.test(form.nip)) {
        validationErrors.nip = "NIP harus berupa angka minimal 8 digit tanpa spasi.";
      } else {
        delete validationErrors.nip;
      }
      break;
    case "name":
      if (!form.name) {
        validationErrors.name = "Nama lengkap wajib diisi.";
      } else if (!/^[a-zA-Z0-9\s'’`]+$/.test(form.name)) {
        validationErrors.name = "Nama hanya boleh mengandung huruf, angka, tanda petik atas ('), dan spasi.";
      } else {
        delete validationErrors.name;
      }
      break;
    case "email":
      if (!form.email) {
        validationErrors.email = "Email wajib diisi.";
      } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
        validationErrors.email = "Format email tidak valid.";
      } else {
        delete validationErrors.email;
      }
      break;
    case "phone":
      if (!form.phone) {
        validationErrors.phone = "Nomor HP wajib diisi.";
      } else if (!/^\+[0-9]{8,15}$/.test(form.phone)) {
        validationErrors.phone = "Nomor HP harus format internasional, misal +6282218458888.";
      } else {
        delete validationErrors.phone;
      }
      break;
  }
};

// Full Form Validation
const validateForm = () => {
  validateField("nip");
  validateField("name");
  validateField("email");
  validateField("phone");

  if (!form.birth_place) validationErrors.birth_place = "Tempat lahir wajib diisi.";
  else delete validationErrors.birth_place;

  if (!form.birth_date) validationErrors.birth_date = "Tanggal lahir wajib diisi.";
  else delete validationErrors.birth_date;

  if (!form.district_id) validationErrors.district_id = "Kecamatan wajib dipilih dari daftar pencarian.";
  else delete validationErrors.district_id;

  if (!form.full_address) validationErrors.full_address = "Alamat lengkap wajib diisi.";
  else delete validationErrors.full_address;

  if (!form.joined_at) validationErrors.joined_at = "Tanggal masuk wajib diisi.";
  else delete validationErrors.joined_at;

  if (!form.position_id) validationErrors.position_id = "Jabatan wajib dipilih.";
  else delete validationErrors.position_id;

  if (!form.department_id) validationErrors.department_id = "Departemen wajib dipilih.";
  else delete validationErrors.department_id;

  const isEduValid = validateEducations();
  if (!isEduValid) {
    validationErrors.educations = "Semua baris riwayat pendidikan wajib diisi lengkap.";
  } else {
    delete validationErrors.educations;
  }

  return Object.keys(validationErrors).length === 0 && isEduValid;
};

// Fetch initial master data & employee detail if edit mode
const initData = async () => {
  try {
    const [posRes, deptRes] = await Promise.all([
      $fetch("/api/positions"),
      $fetch("/api/departments"),
    ]);

    positions.value = Array.isArray(posRes) ? posRes : (posRes?.data || []);
    departments.value = Array.isArray(deptRes) ? deptRes : (deptRes?.data || []);

    if (isEditMode.value) {
      const empRes = await $fetch(`/api/employees/${employeeId.value}`);
      if (empRes?.success && empRes?.data) {
        const d = empRes.data;
        form.nip = d.nip || "";
        form.name = d.name || "";
        form.email = d.email || "";
        form.phone = d.phone || "";
        form.photo_path = d.photo_path || "";
        form.birth_place = d.birth_place || "";
        form.birth_date = d.birth_date ? d.birth_date.slice(0, 10) : "";
        form.marital_status = d.marital_status || "Belum Menikah";
        form.children_count = d.children_count || 0;
        form.district_id = d.district_id || 0;
        form.district_name = d.district_name || "";
        form.regency_name = d.regency_name || "";
        form.province_name = d.province_name || "";
        districtSearch.value = d.district_name || "";
        form.full_address = d.full_address || "";
        form.distance_km = d.distance_km || 0;
        form.joined_at = d.joined_at ? d.joined_at.slice(0, 10) : "";
        form.position_id = d.position_id || 0;
        form.department_id = d.department_id || 0;
        form.employment_type = d.employment_type || "pkwtt";
        form.isActive = d.status === "active";
        form.educations = d.educations && d.educations.length > 0 ? d.educations : [
          { education_level: "S1", school_name: "", graduation_year: "" },
        ];
        calculateAge();
      }
    }
  } catch (err) {
    errorMessage.value = "Gagal memuat data formulir: " + (err?.data?.message || err?.message);
  }
};

// Submit Form
const handleSubmit = async () => {
  if (!validateForm()) {
    errorMessage.value = "Silakan periksa kembali isian formulir yang ditandai merah.";
    window.scrollTo({ top: 0, behavior: "smooth" });
    return;
  }

  isSubmitting.value = true;
  errorMessage.value = "";
  successMessage.value = "";

  const payload = {
    nip: form.nip,
    name: form.name,
    email: form.email,
    phone: form.phone,
    photo: form.photo_base64 || form.photo_path,
    birth_place: form.birth_place,
    birth_date: form.birth_date,
    marital_status: form.marital_status,
    children_count: form.children_count,
    district_id: form.district_id,
    full_address: form.full_address,
    distance_km: form.distance_km,
    joined_at: form.joined_at,
    position_id: form.position_id,
    department_id: form.department_id,
    employment_type: form.employment_type,
    status: form.isActive ? "active" : "inactive",
    educations: form.educations.filter((e) => e.school_name || e.education_level),
  };

  try {
    let res;
    if (isEditMode.value) {
      res = await $fetch(`/api/employees/${employeeId.value}`, {
        method: "PUT",
        body: payload,
      });
    } else {
      res = await $fetch("/api/employees", {
        method: "POST",
        body: payload,
      });
    }

    successMessage.value = res?.message || "Data pegawai berhasil disimpan.";
    window.scrollTo({ top: 0, behavior: "smooth" });
    setTimeout(() => {
      navigateTo("/pegawai");
    }, 1200);
  } catch (err) {
    errorMessage.value = err?.data?.message || err?.message || "Terjadi kesalahan saat menyimpan data pegawai.";
    window.scrollTo({ top: 0, behavior: "smooth" });
  } finally {
    isSubmitting.value = false;
  }
};

onMounted(() => {
  initData();
});
</script>

<style scoped>
.foto-profil {
  width: 110px;
  height: 110px;
  border-radius: 50%;
  object-fit: cover;
  border: 3px solid #f1f5f9;
}
.cursor-pointer {
  cursor: pointer;
}
</style>
