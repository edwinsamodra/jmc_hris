import { setHeader } from "h3";
import { requirePermission } from "#server/utils/rbac";

export default defineEventHandler(async (event) => {
  // RBAC: read permission on 'attendance'
  await requirePermission(event, "attendance", "read");

  const csvHeaders = [
    "nip",
    "nama",
    "tanggal",
    "jam_masuk",
    "lokasi_masuk",
    "jam_pulang",
    "lokasi_pulang",
    "jenis_presensi",
    "status_verifikasi",
    "verifikator",
    "keterangan",
  ];

  const sampleRows = [
    [
      "EMP-001",
      "Ahmad Hermawan",
      "2026-08-03",
      "08:00:00",
      "Gedung Utama",
      "17:00:00",
      "Gedung Utama",
      "hadir",
      "Disetujui",
      "HRD",
      "Hadir tepat waktu",
    ],
    [
      "EMP-002",
      "Dhea Angela",
      "2026-08-03",
      "08:12:00",
      "Gedung A",
      "17:15:00",
      "Gedung A",
      "hadir",
      "Disetujui",
      "Manager",
      "Masuk toleransi 15 menit",
    ],
    [
      "EMP-003",
      "Budi Santoso",
      "2026-08-03",
      "08:30:00",
      "Gedung B",
      "17:30:00",
      "Gedung B",
      "hadir",
      "Disetujui",
      "Lead",
      "Terlambat tapi durasi 8 jam",
    ],
    [
      "EMP-004",
      "Siti Nurhaliza",
      "2026-08-04",
      "",
      "",
      "",
      "",
      "cuti",
      "Disetujui",
      "Manager",
      "Cuti tahunan",
    ],
    [
      "EMP-005",
      "Rudi Hartono",
      "2026-08-04",
      "",
      "",
      "",
      "",
      "izin",
      "Disetujui",
      "HRD",
      "Izin keperluan keluarga",
    ],
    [
      "EMP-006",
      "Dewi Lestari",
      "2026-08-04",
      "",
      "",
      "",
      "",
      "unpaid_leave",
      "Disetujui",
      "HRD",
      "Izin cuti di luar tanggungan",
    ],
  ];

  const formattedRows = sampleRows.map((row) =>
    row
      .map((cell) => {
        const str = String(cell ?? "").replace(/"/g, '""');
        return str.includes(",") || str.includes('"') || str.includes("\n")
          ? `"${str}"`
          : str;
      })
      .join(","),
  );

  const csvContent = "\uFEFF" + [csvHeaders.join(","), ...formattedRows].join("\r\n");

  setHeader(event, "Content-Type", "text/csv; charset=utf-8");
  setHeader(
    event,
    "Content-Disposition",
    'attachment; filename="template_import_presensi.csv"',
  );

  return csvContent;
});
