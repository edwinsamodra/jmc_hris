/**
 * Vue Directive: v-can
 * Usage:
 *   v-can="'employee:create'"
 *   v-can="'employee:delete'"
 *   v-can="'transport_setting:update'"
 *
 * If user lacks the permission, the element is removed from DOM.
 */
export default defineNuxtPlugin((nuxtApp) => {
  nuxtApp.vueApp.directive("can", {
    mounted(el, binding) {
      checkPermission(el, binding);
    },
    updated(el, binding) {
      checkPermission(el, binding);
    },
  });
});

function checkPermission(el, binding) {
  const { value } = binding;
  if (!value) return;

  const [moduleCode, action] = String(value).split(":");
  if (!moduleCode || !action) return;

  const { can } = useAuth();
  const hasPerm = can(action, moduleCode);

  if (!hasPerm) {
    if (el.parentNode) {
      el.parentNode.removeChild(el);
    } else {
      el.style.display = "none";
    }
  }
}
