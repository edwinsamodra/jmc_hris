import { sendRedirect, createError, getRequestURL } from "h3";

export default defineEventHandler(async (event) => {
  const clientId = (process.env.CLIENT_ID || "").replace(/^"|"$/g, "").trim();

  if (!clientId) {
    throw createError({
      statusCode: 500,
      statusMessage: "Internal Server Error",
      message: "CLIENT_ID Google OAuth belum dikonfigurasi di file .env.",
    });
  }

  const reqUrl = getRequestURL(event);
  const redirectUri = `${reqUrl.origin}/api/auth/callback/google`;

  const scope = encodeURIComponent("openid email profile");
  const state = Buffer.from(JSON.stringify({ timestamp: Date.now() })).toString("base64url");

  const googleAuthUrl =
    `https://accounts.google.com/o/oauth2/v2/auth?` +
    `client_id=${encodeURIComponent(clientId)}&` +
    `redirect_uri=${encodeURIComponent(redirectUri)}&` +
    `response_type=code&` +
    `scope=${scope}&` +
    `state=${state}&` +
    `access_type=offline&` +
    `prompt=consent`;

  return sendRedirect(event, googleAuthUrl);
});
