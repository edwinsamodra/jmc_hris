import crypto from "node:crypto";

/**
 * Hash password using crypto.scryptSync with random salt.
 * Format output: salt:derivedKeyHex
 */
export function hashPassword(password: string): string {
  const salt = crypto.randomBytes(16).toString("hex");
  const derivedKey = crypto.scryptSync(password, salt, 64);
  return `${salt}:${derivedKey.toString("hex")}`;
}

/**
 * Verify password against stored hash.
 * Also supports plain SHA-256 fallback if any legacy hash exists.
 */
export function verifyPassword(password: string, storedHash: string): boolean {
  if (!storedHash) return false;

  try {
    if (storedHash.includes(":")) {
      const [salt, key] = storedHash.split(":");
      if (!salt || !key) return false;
      const keyBuffer = Buffer.from(key, "hex");
      const derivedKey = crypto.scryptSync(password, salt, 64);
      return crypto.timingSafeEqual(keyBuffer, derivedKey);
    }

    // Fallback direct sha256
    const hash = crypto.createHash("sha256").update(password).digest("hex");
    return hash === storedHash;
  } catch {
    return false;
  }
}

/**
 * Generate secure random session token
 */
export function generateSessionToken(): string {
  return crypto.randomBytes(32).toString("hex");
}

/**
 * Generate 4-digit OTP code string (e.g. '4829')
 */
export function generateOtpCode(): string {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

/**
 * Hash OTP code for secure storage in database
 */
export function hashOtp(otp: string): string {
  return crypto.createHash("sha256").update(otp).digest("hex");
}

/**
 * Verify OTP against hash in constant-time comparison
 */
export function verifyOtpHash(otp: string, storedHash: string): boolean {
  try {
    const incomingHash = hashOtp(otp);
    return crypto.timingSafeEqual(
      Buffer.from(incomingHash, "hex"),
      Buffer.from(storedHash, "hex"),
    );
  } catch {
    return false;
  }
}
