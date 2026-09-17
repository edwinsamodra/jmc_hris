<script setup>
definePageMeta({
  middleware: [
    function () {
      return navigateTo('/user/manage', { replace: true })
    }
  ]
})
</script>

<template>
  <div></div>
</template>
