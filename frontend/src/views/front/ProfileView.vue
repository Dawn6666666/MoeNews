<script setup>
import { reactive } from 'vue'
import { useMessage } from 'naive-ui'
import { authApi } from '../../api'
import { useAuthStore } from '../../stores/auth'

const auth = useAuthStore()
const message = useMessage()
const form = reactive({ ...auth.user })

const submit = async () => {
  try {
    const user = await authApi.updateMe(form)
    auth.user = user
    localStorage.setItem('user', JSON.stringify(user))
    message.success('资料已更新')
  } catch (error) {
    message.error(error.message)
  }
}
</script>

<template>
  <section class="page">
    <n-card title="个人信息" style="max-width: 620px">
      <n-form :model="form" label-placement="left" label-width="90">
        <n-form-item label="用户名"><n-input v-model:value="form.username" disabled /></n-form-item>
        <n-form-item label="昵称"><n-input v-model:value="form.nickname" /></n-form-item>
        <n-form-item label="邮箱"><n-input v-model:value="form.email" /></n-form-item>
        <n-form-item label="手机号"><n-input v-model:value="form.phone" /></n-form-item>
        <n-button type="primary" @click="submit">保存</n-button>
      </n-form>
    </n-card>
  </section>
</template>
