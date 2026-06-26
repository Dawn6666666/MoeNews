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
        <nav class="front-actions" aria-label="前台导航">
          <router-link class="front-link" to="/news">新闻</router-link>
          <router-link v-if="auth.user?.role === 'ADMIN'" class="front-link" to="/admin/dashboard">后台</router-link>
          <router-link v-if="auth.token" class="front-link user-link" to="/profile">{{ auth.user?.nickname }}</router-link>
          <n-button v-if="auth.token" class="front-logout" secondary @click="logout">退出</n-button>
          <n-button v-else type="primary" @click="router.push('/login')">登录</n-button>
        </nav>
      </div>
    </header>
    <main style="padding: 24px 0 40px">
      <router-view />
    </main>
  </div>
</template>
