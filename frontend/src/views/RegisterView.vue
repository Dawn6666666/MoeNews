<script setup>
import { reactive } from 'vue'
import { useMessage } from 'naive-ui'
import { useRouter } from 'vue-router'
import { authApi } from '../api'

const router = useRouter()
const message = useMessage()
const form = reactive({ username: '', password: '', confirmPassword: '', nickname: '' })

const submit = async () => {
  try {
    await authApi.register(form)
    message.success('注册成功，请登录')
    router.push('/login')
  } catch (error) {
    message.error(error.message)
  }
}
</script>

<template>
  <div class="auth-page">
    <n-card class="auth-panel" title="注册账号">
      <n-form :model="form" label-placement="top">
        <n-form-item label="用户名"><n-input v-model:value="form.username" /></n-form-item>
        <n-form-item label="昵称"><n-input v-model:value="form.nickname" /></n-form-item>
        <n-form-item label="密码"><n-input v-model:value="form.password" type="password" show-password-on="click" /></n-form-item>
        <n-form-item label="确认密码"><n-input v-model:value="form.confirmPassword" type="password" show-password-on="click" /></n-form-item>
        <n-button type="primary" block @click="submit">注册</n-button>
      </n-form>
      <n-divider />
      <n-button text @click="router.push('/login')">已有账号，去登录</n-button>
    </n-card>
  </div>
</template>
