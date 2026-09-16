import { query } from "#server/utils/database";

export default defineEventHandler(async () => {
  await query("SELECT 1 AS connected");
  return { status: "ok", service: "hris-api", database: "connected" };
});
