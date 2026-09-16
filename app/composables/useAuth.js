export const useAuth = () => {
  const user = useState("auth_user", () => null);
  const permissions = useState("auth_permissions", () => []);
  const session = useState("auth_session", () => null);
  const isLoading = useState("auth_loading", () => false);

  const isLoggedIn = computed(() => Boolean(user.value));
  const userRole = computed(() => user.value?.role_code || user.value?.role?.code || "");
  const userName = computed(() => user.value?.name || "");

  /**
   * Fetch current logged in user & permissions from /api/auth/me
   */
  const fetchUser = async () => {
    try {
      isLoading.value = true;
      const headers = useRequestHeaders(["cookie"]);
      const res = await $fetch("/api/auth/me", {
        headers,
      });
      if (res?.success && res?.data) {
        user.value = res.data.user;
        permissions.value = res.data.permissions || [];
        session.value = res.data.session || null;
        return { success: true, data: res.data };
      }
      user.value = null;
      permissions.value = [];
      session.value = null;
      return { success: false };
    } catch (err) {
      user.value = null;
      permissions.value = [];
      session.value = null;
      return { success: false, error: err };
    } finally {
      isLoading.value = false;
    }
  };

  /**
   * Step 1: Login with credentials (triggers 4-digit OTP email)
   */
  const login = async ({ identifier, password, captcha }) => {
    const res = await $fetch("/api/auth/login", {
      method: "POST",
      body: { identifier, password, captcha },
    });
    return res;
  };

  /**
   * Step 2: Verify OTP 4-digit
   */
  const verifyOtp = async ({ otpTicket, otp, rememberMe }) => {
    const res = await $fetch("/api/auth/verify-otp", {
      method: "POST",
      body: { otpTicket, otp, rememberMe },
    });
    if (res?.success && res?.data) {
      user.value = res.data.user;
      permissions.value = res.data.permissions || [];
      session.value = {
        rememberMe: res.data.rememberMe,
        expiresAt: res.data.expiresAt,
      };
    }
    return res;
  };

  /**
   * Resend OTP
   */
  const resendOtp = async ({ otpTicket }) => {
    const res = await $fetch("/api/auth/resend-otp", {
      method: "POST",
      body: { otpTicket },
    });
    return res;
  };

  /**
   * Logout user
   */
  const logout = async () => {
    try {
      await $fetch("/api/auth/logout", {
        method: "POST",
      });
    } catch {
      // Ignore network error on logout
    } finally {
      user.value = null;
      permissions.value = [];
      session.value = null;
      navigateTo("/login");
    }
  };

  /**
   * Check if user has permission to access a specific module
   */
  const hasModuleAccess = (moduleCode) => {
    if (!permissions.value || permissions.value.length === 0) return false;
    const perm = permissions.value.find((p) => p.module_code === moduleCode);
    return perm ? Boolean(perm.can_access) : false;
  };

  /**
   * Check if user has action permission ('create' | 'read' | 'update' | 'delete') on a module
   */
  const can = (action, moduleCode) => {
    if (!permissions.value || permissions.value.length === 0) return false;
    const perm = permissions.value.find((p) => p.module_code === moduleCode);
    if (!perm || !perm.can_access) return false;

    switch (action) {
      case "create":
        return Boolean(perm.can_create);
      case "read":
        return perm.read_scope !== "no";
      case "update":
        return perm.update_scope !== "no";
      case "delete":
        return perm.delete_scope !== "no";
      default:
        return false;
    }
  };

  /**
   * Get data scope ('all' | 'own' | 'no') for a specific action on a module
   */
  const getScope = (action, moduleCode) => {
    if (!permissions.value || permissions.value.length === 0) return "no";
    const perm = permissions.value.find((p) => p.module_code === moduleCode);
    if (!perm || !perm.can_access) return "no";

    switch (action) {
      case "create":
        return perm.can_create ? "all" : "no";
      case "read":
        return perm.read_scope || "no";
      case "update":
        return perm.update_scope || "no";
      case "delete":
        return perm.delete_scope || "no";
      default:
        return "no";
    }
  };

  /**
   * Check if active user has a specific role code
   */
  const isRole = (roleCode) => {
    return userRole.value === roleCode;
  };

  return {
    user,
    permissions,
    session,
    isLoading,
    isLoggedIn,
    userRole,
    userName,
    fetchUser,
    login,
    verifyOtp,
    resendOtp,
    logout,
    hasModuleAccess,
    can,
    getScope,
    isRole,
  };
};
