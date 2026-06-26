<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const auth = useAuthStore()

const logout = () => {
  auth.logout()
  router.push('/login')
}

const getAvatarColor = (nickname) => {
  if (!nickname) return '#FF6B8B'
  let hash = 0
  for (let i = 0; i < nickname.length; i++) {
    hash = nickname.charCodeAt(i) + ((hash << 5) - hash)
  }
  const colors = ['#FF6B8B', '#4EA8DE', '#FF8E3C', '#B388FF', '#FF80AB', '#80D8FF', '#FFD180']
  return colors[Math.abs(hash) % colors.length]
}

const getAvatarLabel = (nickname) => {
  return nickname ? nickname.charAt(0).toUpperCase() : 'M'
}

const dropdownOptions = computed(() => [
  {
    label: auth.user?.nickname || '用户',
    key: 'nickname',
    disabled: true
  },
  {
    type: 'divider',
    key: 'd1'
  },
  {
    label: '个人信息',
    key: 'profile'
  },
  {
    label: '退出账号',
    key: 'logout'
  }
])

const handleSelect = (key) => {
  if (key === 'profile') {
    router.push('/profile')
  } else if (key === 'logout') {
    logout()
  }
}
</script>

<template>
  <div style="display: flex; flex-direction: column; min-height: 100vh;">
    <header class="front-header">
      <div class="front-nav">
        <router-link class="brand" to="/news">MoeNews</router-link>
        <div id="header-toolbar-target"></div>
        <nav class="front-actions" aria-label="前台导航">
          <router-link class="front-link" to="/news">新闻</router-link>
          <router-link v-if="auth.user?.role === 'ADMIN'" class="front-link" to="/admin/dashboard">后台</router-link>
          <n-dropdown v-if="auth.token" :options="dropdownOptions" @select="handleSelect" trigger="click">
            <n-avatar
              round
              size="medium"
              :style="{ backgroundColor: getAvatarColor(auth.user?.nickname), color: '#ffffff', fontWeight: 'bold', cursor: 'pointer' }"
            >
              {{ getAvatarLabel(auth.user?.nickname) }}
            </n-avatar>
          </n-dropdown>
          <n-button v-else type="primary" round @click="router.push('/login')">登录</n-button>
        </nav>
      </div>
    </header>
    <main style="flex: 1; padding: 40px 0 80px;">
      <router-view />
    </main>
    <footer class="footer">
      <div class="page">
        <div class="footer-grid">
          <div class="footer-col">
            <h4 style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-size: 22px; font-weight: 800; margin: 0 0 16px; font-family: Outfit, sans-serif; letter-spacing: -0.5px;">MoeNews</h4>
            <p style="font-size: 14px; line-height: 1.6; margin: 0; color: var(--text-muted);">提供客观、真实、温暖的萌新趣味与实事新闻。在这里，您可以浏览新鲜资讯并发表看法。</p>
          </div>
          <div class="footer-col">
            <h4>快捷导航</h4>
            <ul>
              <li><router-link to="/news">新闻主页</router-link></li>
              <li><router-link v-if="auth.token" to="/profile">个人中心</router-link></li>
              <li><router-link v-if="auth.user?.role === 'ADMIN'" to="/admin/dashboard">系统后台</router-link></li>
            </ul>
          </div>
          <div class="footer-col">
            <h4>服务支持</h4>
            <ul>
              <li>联系邮箱：contact@moenews.com</li>
              <li>微信公众号：MoeNews趣味圈</li>
            </ul>
          </div>
        </div>
        <div class="footer-bottom">
          <p style="margin: 0; color: var(--text-muted);">© 2026 MoeNews. 保留所有权利。</p>
        </div>
      </div>
    </footer>
  </div>
</template>
