import { query } from "#server/utils/database";

export default defineEventHandler(async () => {
  return query(`
    SELECT id, code, name, position_type AS positionType
    FROM positions
    ORDER BY name ASC
  `);
});
