import { H3Event, getHeader, getCookie, setCookie, deleteCookie, createError } from "h3";
import { query, execute } from "#server/utils/database";

export interface AuthSessionUser {
  id: number;
  employee_id: number | null;
  role_id: number;
  role_code: string;
  role_name: string;
  name: string;
  username: string;
  email: string | null;
  cellphone: string | null;
  status: "active" | "inactive";
  employee?: {
    id: number;
    nip: string;
    name: string;
    email: string;
    phone: string;
    department_id: number;
    department_name: string;
    position_id: number;
    position_name: string;
    employment_type: string;
  } | null;
}

export interface AuthSessionContext {
  sessionToken: string;
  rememberMe: boolean;
  expiresAt: Date;
  user: AuthSessionUser;
}

export const SESSION_COOKIE_NAME = "hris_session_token";
export const INACTIVITY_TIMEOUT_MINUTES = 3;
export const REMEMBER_ME_DAYS = 30;

/**
 * Get Client IP Address from request headers
 */
export function getClientIp(event: H3Event): string {
  const forwarded = getHeader(event, "x-forwarded-for");
  if (forwarded) {
    return forwarded.split(",")[0].trim();
  }
  return event.node.req.socket?.remoteAddress || "127.0.0.1";
}

/**
 * Get User Agent
 */
export function getUserAgent(event: H3Event): string {
  return getHeader(event, "user-agent") || "unknown";
}

/**
 * Extract session token from Authorization Bearer header or HTTP Cookie
 */
export function extractSessionToken(event: H3Event): string | null {
  const authHeader = getHeader(event, "authorization");
  if (authHeader && authHeader.startsWith("Bearer ")) {
    const token = authHeader.substring(7).trim();
    if (token) return token;
  }

  const cookieToken = getCookie(event, SESSION_COOKIE_NAME);
  if (cookieToken) return cookieToken;

  return null;
}

/**
 * Set session cookie in response
 */
export function setSessionCookie(
  event: H3Event,
  token: string,
  rememberMe: boolean,
) {
  const maxAge = rememberMe
    ? REMEMBER_ME_DAYS * 24 * 60 * 60
    : INACTIVITY_TIMEOUT_MINUTES * 60;

  setCookie(event, SESSION_COOKIE_NAME, token, {
    httpOnly: true,
    sameSite: "lax",
    path: "/",
    maxAge,
    secure: process.env.NODE_ENV === "production",
  });
}

/**
 * Clear session cookie
 */
export function clearSessionCookie(event: H3Event) {
  deleteCookie(event, SESSION_COOKIE_NAME, {
    path: "/",
  });
}

/**
 * Validate and refresh an active user session.
 * Handles 3-minute inactivity sliding window for non-remember-me sessions.
 */
export async function getAuthenticatedSession(
  event: H3Event,
  options: { required?: boolean } = { required: true },
): Promise<AuthSessionContext | null> {
  const token = extractSessionToken(event);

  if (!token) {
    if (options.required) {
      throw createError({
        statusCode: 401,
        statusMessage: "Unauthorized",
        message: "Sesi tidak ditemukan atau belum login.",
      });
    }
    return null;
  }

  // Cari session aktif di database
  const sessions = await query<any>(
    `SELECT s.id AS session_id, s.session_token, s.remember_me, s.last_activity_at,
            s.expires_at, s.logged_out_at,
            u.id AS user_id, u.employee_id, u.role_id, u.name AS user_name,
            u.username, u.email, u.cellphone, u.status AS user_status,
            r.code AS role_code, r.name AS role_name,
            e.nip AS employee_nip, e.name AS employee_name, e.email AS employee_email,
            e.phone AS employee_phone, e.department_id, e.position_id, e.employment_type,
            d.name AS department_name, p.name AS position_name
     FROM user_sessions s
     JOIN users u ON u.id = s.user_id
     JOIN roles r ON r.id = u.role_id
     LEFT JOIN employees e ON e.id = u.employee_id
     LEFT JOIN departments d ON d.id = e.department_id
     LEFT JOIN positions p ON p.id = e.position_id
     WHERE s.session_token = ?
       AND s.logged_out_at IS NULL
       AND u.deleted_at IS NULL
     LIMIT 1`,
    [token],
  );

  if (!sessions || sessions.length === 0) {
    clearSessionCookie(event);
    if (options.required) {
      throw createError({
        statusCode: 401,
        statusMessage: "Unauthorized",
        message: "Sesi tidak valid atau telah berakhir.",
      });
    }
    return null;
  }

  const row = sessions[0];
  const now = new Date();
  const expiresAt = new Date(row.expires_at);

  // Periksa apakah user dinonaktifkan
  if (row.user_status !== "active") {
    // Otomatis logout session
    await execute(
      "UPDATE user_sessions SET logged_out_at = NOW() WHERE id = ?",
      [row.session_id],
    );
    clearSessionCookie(event);
    throw createError({
      statusCode: 403,
      statusMessage: "Forbidden",
      message: "Akun Anda saat ini dinonaktifkan.",
    });
  }

  // Periksa apakah sesi telah kedaluwarsa (berdasarkan timestamp epoch)
  if (now.getTime() > expiresAt.getTime()) {
    await execute(
      "UPDATE user_sessions SET logged_out_at = NOW() WHERE id = ?",
      [row.session_id],
    );
    clearSessionCookie(event);
    if (options.required) {
      throw createError({
        statusCode: 401,
        statusMessage: "Unauthorized",
        message: "Sesi Anda telah kedaluwarsa karena tidak ada aktivitas selama 3 menit.",
      });
    }
    return null;
  }

  // Perpanjang sesi jika bukan remember_me (sliding window 3 menit)
  const isRememberMe = Boolean(row.remember_me);
  if (!isRememberMe) {
    const newExpiresAt = new Date(now.getTime() + INACTIVITY_TIMEOUT_MINUTES * 60 * 1000);
    await execute(
      `UPDATE user_sessions 
       SET last_activity_at = NOW(), expires_at = ?
       WHERE id = ?`,
      [newExpiresAt, row.session_id],
    );
    // Refresh cookie expiry di client
    setSessionCookie(event, token, false);
  } else {
    // Tetap update last_activity_at
    await execute(
      `UPDATE user_sessions SET last_activity_at = NOW() WHERE id = ?`,
      [row.session_id],
    );
  }

  const sessionUser: AuthSessionUser = {
    id: row.user_id,
    employee_id: row.employee_id,
    role_id: row.role_id,
    role_code: row.role_code,
    role_name: row.role_name,
    name: row.user_name,
    username: row.username,
    email: row.email,
    cellphone: row.cellphone,
    status: row.user_status,
    employee: row.employee_id
      ? {
          id: row.employee_id,
          nip: row.employee_nip,
          name: row.employee_name,
          email: row.employee_email,
          phone: row.employee_phone,
          department_id: row.department_id,
          department_name: row.department_name,
          position_id: row.position_id,
          position_name: row.position_name,
          employment_type: row.employment_type,
        }
      : null,
  };

  return {
    sessionToken: token,
    rememberMe: isRememberMe,
    expiresAt,
    user: sessionUser,
  };
}

/**
 * Record activity log helper
 */
export async function logActivity(
  event: H3Event,
  params: {
    userId?: number | null;
    moduleCode?: string;
    module?: string;
    action: "login" | "logout" | "create" | "read" | "update" | "delete";
    description?: string;
    details?: string;
    subjectType?: string;
    subjectId?: number | null;
    oldValues?: Record<string, unknown> | null;
    newValues?: Record<string, unknown> | null;
  },
) {
  try {
    const ip = getClientIp(event);
    const ua = getUserAgent(event);
    const url = event.node.req.url || "";
    const method = event.node.req.method || "";

    // Dapatkan userId jika belum dipassing secara eksplisit
    let userId = params.userId;
    if (userId === undefined) {
      try {
        const session = await getAuthenticatedSession(event, { required: false });
        userId = session?.user?.id ?? null;
      } catch {
        userId = null;
      }
    }

    const moduleCode = params.moduleCode || params.module || "system";
    const description = params.description || params.details || "";

    await execute(
      `INSERT INTO activity_logs (
        user_id, module_code, action, description,
        subject_type, subject_id, ip_address, user_agent,
        old_values, new_values, url, method, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())`,
      [
        userId,
        moduleCode,
        params.action,
        description,
        params.subjectType || null,
        params.subjectId || null,
        ip,
        ua,
        params.oldValues ? JSON.stringify(params.oldValues) : null,
        params.newValues ? JSON.stringify(params.newValues) : null,
        url,
        method,
      ],
    );
  } catch (err) {
    console.error("Failed to write activity log:", err);
  }
}
