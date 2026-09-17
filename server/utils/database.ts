import mariadb, { type PoolConnection, type UpsertResult } from "mariadb";

let pool: mariadb.Pool | undefined;

function getPool() {
  if (!pool) {
    let dbHost = process.env.DB_HOST || "127.0.0.1";
    let dbPort = Number(process.env.DB_PORT || 3306);
    let dbName = process.env.DB_NAME || "jmc_hris";
    let dbUser = process.env.DB_USER || "admin";
    let dbPassword = process.env.DB_PASSWORD || "jamurkembang";

    try {
      const config = useRuntimeConfig()?.database;
      if (config) {
        dbHost = config.host || dbHost;
        dbPort = Number(config.port || dbPort);
        dbName = config.name || dbName;
        dbUser = config.user || dbUser;
        dbPassword = config.password || dbPassword;
      }
    } catch {
      // useRuntimeConfig may not be available in some contexts, fall back to process.env
    }

    pool = mariadb.createPool({
      host: dbHost,
      port: dbPort,
      database: dbName,
      user: dbUser,
      password: dbPassword,
      connectionLimit: 5,
      insertIdAsNumber: true,
      bigIntAsNumber: true,
    });
  }

  return pool;
}

function sanitizeRow<T>(row: T): T {
  if (row === null || row === undefined) return row;
  if (typeof row === "bigint") return Number(row) as unknown as T;
  if (Array.isArray(row)) return row.map(sanitizeRow) as unknown as T;
  if (typeof row === "object" && !(row instanceof Date)) {
    const res: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(row as Record<string, unknown>)) {
      res[k] = sanitizeRow(v);
    }
    return res as unknown as T;
  }
  return row;
}

export async function query<T = Record<string, unknown>>(
  sql: string,
  params: unknown[] = [],
) {
  const rows = await getPool().query<T[]>(sql, params);
  return sanitizeRow(rows);
}

export async function execute(sql: string, params: unknown[] = []) {
  const res = await getPool().query<UpsertResult>(sql, params);
  return {
    ...res,
    insertId: Number(res.insertId),
    affectedRows: Number(res.affectedRows),
  };
}

export async function withConnection<T>(
  callback: (connection: PoolConnection) => Promise<T>,
) {
  const connection = await getPool().getConnection();

  try {
    return await callback(connection);
  } finally {
    connection.release();
  }
}
