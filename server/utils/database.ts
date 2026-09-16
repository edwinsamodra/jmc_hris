import mariadb, { type PoolConnection, type UpsertResult } from "mariadb";

let pool: mariadb.Pool | undefined;

function getPool() {
  if (!pool) {
    const config = useRuntimeConfig().database;

    pool = mariadb.createPool({
      host: config.host,
      port: config.port,
      database: config.name,
      user: config.user,
      password: config.password,
      connectionLimit: 5,
    });
  }

  return pool;
}

export async function query<T = Record<string, unknown>>(
  sql: string,
  params: unknown[] = [],
) {
  return getPool().query<T[]>(sql, params);
}

export async function execute(sql: string, params: unknown[] = []) {
  return getPool().query<UpsertResult>(sql, params);
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
