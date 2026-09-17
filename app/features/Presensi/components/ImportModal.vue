<template>
  <div
    v-if="show"
    class="modal modal-blur fade show d-block"
    tabindex="-1"
    style="background-color: rgba(0, 0, 0, 0.5); z-index: 1055"
  >
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
      <div class="modal-content shadow-lg border-0">
        <!-- Modal Header -->
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title d-flex align-items-center gap-2 text-white">
            <IconUpload :size="20" />
            Import Data Presensi (CSV)
          </h5>
          <button
            type="button"
            class="btn-close btn-close-white"
            :disabled="isUploading"
            @click="closeModal"
            aria-label="Close"
          ></button>
        </div>

        <!-- Modal Body -->
        <div class="modal-body p-4">


          <!-- Drag and drop zone -->
          <div
            class="dropzone-area p-4 border border-2 border-dashed rounded text-center mb-3"
            :class="{ 'border-primary bg-light': isDragging, 'bg-body': !isDragging }"
            @dragover.prevent="isDragging = true"
            @dragleave.prevent="isDragging = false"
            @drop.prevent="handleDrop"
            @click="triggerFileInput"
            style="cursor: pointer"
          >
            <input
              ref="fileInputRef"
              type="file"
              accept=".csv"
              class="d-none"
              @change="handleFileChange"
            />
            <div v-if="!selectedFile" class="py-3">
              <IconCloudUpload :size="48" class="text-primary mb-2" />
              <div class="fw-bold fs-3">Pilih File CSV atau Tarik ke Sini</div>
              <p class="text-muted small mb-0">Hanya format file .csv yang didukung (Maksimal 10MB)</p>
            </div>
            <div v-else class="py-2">
              <IconFileSpreadsheet :size="40" class="text-success mb-2" />
              <div class="fw-bold text-dark">{{ selectedFile.name }}</div>
              <div class="text-muted small">{{ formatFileSize(selectedFile.size) }}</div>
              <button
                type="button"
                class="btn btn-sm btn-outline-danger mt-2"
                :disabled="isUploading"
                @click.stop="removeFile"
              >
                <IconTrash :size="14" class="me-1" /> Ganti File
              </button>
            </div>
          </div>

          <!-- Upload Progress / Processing state -->
          <div v-if="isUploading" class="mb-3">
            <div class="d-flex justify-content-between align-items-center mb-1 small fw-bold">
              <span>Memproses kalkulasi absensi di latar belakang...</span>
              <span>Mohon tunggu</span>
            </div>
            <div class="progress progress-sm">
              <div class="progress-bar progress-bar-indeterminate bg-primary"></div>
            </div>
          </div>

          <!-- Error / Success Alert -->
          <div v-if="errorMessage" class="alert alert-danger d-flex align-items-start gap-2 mb-3">
            <IconAlertCircle :size="20" class="flex-shrink-0 mt-1" />
            <div>
              <div class="fw-bold">Gagal Mengimpor File</div>
              <div class="small">{{ errorMessage }}</div>
            </div>
          </div>

          <!-- Import Results summary -->
          <div v-if="importResult" class="card card-body bg-light border mb-0">
            <div class="d-flex align-items-center gap-2 mb-2">
              <IconCheck :size="20" class="text-success" />
              <span class="fw-bold text-success">{{ importResult.message }}</span>
            </div>
            <div class="row g-2 mb-2 small text-center">
              <div class="col-4">
                <div class="p-2 border rounded bg-white">
                  <div class="text-muted">Total Baris</div>
                  <div class="fs-4 fw-bold">{{ importResult.data?.totalRows || 0 }}</div>
                </div>
              </div>
              <div class="col-4">
                <div class="p-2 border rounded bg-white text-success">
                  <div class="text-muted">Berhasil</div>
                  <div class="fs-4 fw-bold text-success">{{ importResult.data?.successRows || 0 }}</div>
                </div>
              </div>
              <div class="col-4">
                <div class="p-2 border rounded bg-white text-danger">
                  <div class="text-muted">Gagal / Lewat</div>
                  <div class="fs-4 fw-bold text-danger">{{ importResult.data?.failedRows || 0 }}</div>
                </div>
              </div>
            </div>

            <!-- List Error Validasi jika ada -->
            <div v-if="importResult.data?.errors && importResult.data.errors.length > 0" class="mt-2">
              <div class="fw-bold text-danger small mb-1">Daftar Baris yang Perlu Diperhatikan:</div>
              <div class="border rounded bg-white p-2" style="max-height: 140px; overflow-y: auto">
                <ul class="mb-0 ps-3 small text-danger">
                  <li v-for="(err, eIdx) in importResult.data.errors" :key="eIdx">
                    Baris {{ err.row }}: {{ err.message }}
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        <!-- Modal Footer -->
        <div class="modal-footer bg-light">
          <button
            type="button"
            class="btn btn-secondary"
            :disabled="isUploading"
            @click="closeModal"
          >
            {{ importResult ? "Tutup" : "Batal" }}
          </button>
          <button
            v-if="!importResult"
            type="button"
            class="btn btn-primary d-inline-flex align-items-center gap-1"
            :disabled="!selectedFile || isUploading"
            @click="submitImport"
          >
            <IconUpload :size="16" />
            {{ isUploading ? "Sedang Mengimpor..." : "Mulai Import" }}
          </button>
          <button
            v-else
            type="button"
            class="btn btn-success d-inline-flex align-items-center gap-1"
            @click="finishImport"
          >
            <IconRefresh :size="16" />
            Selesai & Muat Ulang Data
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  IconUpload,
  IconInfoCircle,
  IconFileDownload,
  IconCloudUpload,
  IconFileSpreadsheet,
  IconTrash,
  IconAlertCircle,
  IconCheck,
  IconRefresh,
} from "@tabler/icons-vue";

const props = defineProps({
  show: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(["update:show", "imported"]);

const fileInputRef = ref(null);
const selectedFile = ref(null);
const isDragging = ref(false);
const isUploading = ref(false);
const errorMessage = ref("");
const importResult = ref(null);

const triggerFileInput = () => {
  if (isUploading.value) return;
  fileInputRef.value?.click();
};

const handleFileChange = (e) => {
  const files = e.target.files;
  if (files && files.length > 0) {
    validateAndSetFile(files[0]);
  }
};

const handleDrop = (e) => {
  isDragging.value = false;
  if (isUploading.value) return;
  const files = e.dataTransfer.files;
  if (files && files.length > 0) {
    validateAndSetFile(files[0]);
  }
};

const validateAndSetFile = (file) => {
  errorMessage.value = "";
  importResult.value = null;

  if (!file.name.toLowerCase().endsWith(".csv")) {
    errorMessage.value = "Format file tidak valid. Harap pilih file dengan ekstensi .csv.";
    return;
  }

  if (file.size > 10 * 1024 * 1024) {
    errorMessage.value = "Ukuran file terlalu besar. Maksimal 10MB.";
    return;
  }

  selectedFile.value = file;
};

const removeFile = () => {
  selectedFile.value = null;
  errorMessage.value = "";
  importResult.value = null;
  if (fileInputRef.value) {
    fileInputRef.value.value = "";
  }
};

const formatFileSize = (bytes) => {
  if (!bytes) return "0 B";
  const k = 1024;
  const sizes = ["B", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + " " + sizes[i];
};

const downloadTemplate = () => {
  window.open("/api/attendances/template", "_blank");
};

const submitImport = async () => {
  if (!selectedFile.value || isUploading.value) return;

  isUploading.value = true;
  errorMessage.value = "";
  importResult.value = null;

  try {
    const formData = new FormData();
    formData.append("file", selectedFile.value);

    const response = await $fetch("/api/attendances/import", {
      method: "POST",
      body: formData,
    });

    if (response && response.success) {
      importResult.value = response;
    } else {
      errorMessage.value = response?.message || "Gagal mengimpor file presensi.";
    }
  } catch (err) {
    errorMessage.value =
      err?.data?.message || err?.message || "Terjadi kesalahan saat memproses import presensi.";
  } finally {
    isUploading.value = false;
  }
};

const finishImport = () => {
  emit("imported");
  closeModal();
};

const closeModal = () => {
  if (isUploading.value) return;
  selectedFile.value = null;
  errorMessage.value = "";
  importResult.value = null;
  emit("update:show", false);
};
</script>

<style scoped>
.dropzone-area {
  transition: all 0.2s ease-in-out;
}
.dropzone-area:hover {
  border-color: #206bc4 !important;
  background-color: #f8fafc;
}
</style>
