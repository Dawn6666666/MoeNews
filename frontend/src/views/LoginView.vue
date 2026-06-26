<script setup>
import { reactive } from 'vue'
import { useMessage } from 'naive-ui'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const message = useMessage()
const auth = useAuthStore()
const form = reactive({ username: 'admin', password: '123456' })

const submit = async () => {
  try {
    const user = await auth.login(form)
    message.success('登录成功')
    router.push(user.role === 'ADMIN' ? '/admin/dashboard' : '/news')
  } catch (error) {
    message.error(error.message)
  }
}
</script>

<template>
  <div class="auth-page">
    <n-card class="auth-panel" title="登录 MoeNews">
      <n-form :model="form" label-placement="top">
        <n-form-item label="用户名">
          <n-input v-model:value="form.username" placeholder="请输入用户名" />
        </n-form-item>
        <n-form-item label="密码">
          <n-input v-model:value="form.password" type="password" placeholder="请输入密码" show-password-on="click" />
        </n-form-item>
        <n-button type="primary" block @click="submit">登录</n-button>
      </n-form>
      <n-divider />
      <n-button text @click="router.push('/register')">没有账号，去注册</n-button>
    </n-card>
  </div>
</template>
