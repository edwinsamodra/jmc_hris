// Map path prefixes to system module codes
const ROUTE_MODULE_MAP = [
  { prefix: "/pegawai", module: "employee" },
  { prefix: "/presensi", module: "attendance" },
  { prefix: "/tunjangan/setting", module: "transport_setting" },
  { prefix: "/tunjangan/transport", module: "transport_allowance" },
  { prefix: "/tunjangan", module: "transport_allowance" },
  { prefix: "/user/role", module: "role" },
  { prefix: "/user/manage", module: "user" },
  { prefix: "/user", module: "user" },
  { prefix: "/log", module: "activity_log" },
  { prefix: "/profile", module: "profile" },
];

export default defineNuxtRouteMiddleware(async (to) => {
  const path = to.path.toLowerCase();
  const isAuthPage = path.startsWith("/login") || path.startsWith("/(auth)");

  const { user, fetchUser, hasModuleAccess } = useAuth();
  const sessionCookie = useCookie("hris_session_token");

  // If user state is empty but session cookie exists, fetch user session
  if (!user.value && sessionCookie.value) {
    await fetchUser();
  }

  // authenticated -> redirect to /
  if (user.value && isAuthPage) {
    return navigateTo("/");
  }

  // unauthenticated -> redirect to /login
  if (!user.value && !isAuthPage) {
    return navigateTo("/login");
  }

  // RBAC Route Permission Check (jika sudah login dan bukan auth page)
  if (user.value && !isAuthPage && path !== "/") {
    const routeRule = ROUTE_MODULE_MAP.find((item) =>
      path === item.prefix || path.startsWith(item.prefix + "/")
    );

    if (routeRule && !hasModuleAccess(routeRule.module)) {
      // User tidak memiliki akses ke modul ini -> alihkan ke /
      return navigateTo("/");
    }
  }
});
