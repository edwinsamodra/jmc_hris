import { query } from "#server/utils/database";

export interface DistrictSearchResult {
  id: number;
  district_code: string;
  district_name: string;
  regency_id: number;
  regency_code: string;
  regency_name: string;
  province_id: number;
  province_code: string;
  province_name: string;
  full_location: string;
}

export default defineEventHandler(async (event) => {
  const queryParams = getQuery(event);
  const q = String(queryParams.q || "").trim();

  if (!q || q.length < 3) {
    return {
      success: true,
      data: [],
      message: "Masukkan minimal 3 karakter untuk pencarian kecamatan.",
    };
  }

  const searchKeyword = `%${q}%`;

  const results = await query<DistrictSearchResult>(
    `SELECT
       d.id,
       d.code AS district_code,
       d.name AS district_name,
       r.id AS regency_id,
       r.code AS regency_code,
       r.name AS regency_name,
       p.id AS province_id,
       p.code AS province_code,
       p.name AS province_name,
       CONCAT(d.name, ', ', r.name, ', ', p.name) AS full_location
     FROM districts d
     JOIN regencies r ON r.id = d.regency_id
     JOIN provinces p ON p.id = r.province_id
     WHERE d.name LIKE ? OR r.name LIKE ?
     ORDER BY d.name ASC
     LIMIT 25`,
    [searchKeyword, searchKeyword],
  );

  return {
    success: true,
    data: results,
  };
});
