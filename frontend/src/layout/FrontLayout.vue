<script setup>
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const auth = useAuthStore()

const logout = () => {
  auth.logout()
  router.push('/login')
}
</script>

<template>
  <div>
    <header class="front-header">
      <div class="page front-nav">
        <router-link class="brand" to="/news">MoeNews</router-link>
        <n-space>
          <n-button text @click="router.push('/news')">新闻</n-button>
          <n-button v-if="auth.user?.role === 'ADMIN'" text @click="router.push('/admin/dashboard')">后台</n-button>
          <n-button v-if="auth.token" text @click="router.push('/profile')">{{ auth.user?.nickname }}</n-button>
          <n-button v-if="auth.token" quaternary @click="logout">退出</n-button>
          <n-button v-else type="primary" @click="router.push('/login')">登录</n-button>
        </n-space>
      </div>
    </header>
    <main style="padding: 24px 0 40px">
      <router-view />
    </main>
  </div>
</template>
