<script setup>
import { computed, h } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { NIcon } from 'naive-ui'
import { ChatboxEllipsesOutline, GridOutline, NewspaperOutline, PeopleOutline, PricetagsOutline } from '@vicons/ionicons5'
import { useAuthStore } from '../stores/auth'

const route = useRoute()
const router = useRouter()
const auth = useAuthStore()

const renderIcon = (icon) => () => h(NIcon, null, { default: () => h(icon) })
const menuOptions = [
  { label: () => h(RouterLink, { to: '/admin/dashboard' }, { default: () => '首页统计' }), key: '/admin/dashboard', icon: renderIcon(GridOutline) },
  { label: () => h(RouterLink, { to: '/admin/users' }, { default: () => '用户管理' }), key: '/admin/users', icon: renderIcon(PeopleOutline) },
  { label: () => h(RouterLink, { to: '/admin/categories' }, { default: () => '分类管理' }), key: '/admin/categories', icon: renderIcon(PricetagsOutline) },
  { label: () => h(RouterLink, { to: '/admin/news' }, { default: () => '新闻管理' }), key: '/admin/news', icon: renderIcon(NewspaperOutline) },
  { label: () => h(RouterLink, { to: '/admin/comments' }, { default: () => '评论管理' }), key: '/admin/comments', icon: renderIcon(ChatboxEllipsesOutline) }
]
const activeKey = computed(() => menuOptions.find((item) => route.path.startsWith(item.key))?.key)

const logout = () => {
  auth.logout()
  router.push('/login')
}
</script>

<template>
  <n-layout has-sider class="admin-shell">
    <n-layout-sider class="admin-sider" :width="220" collapse-mode="width" :collapsed-width="64" show-trigger bordered>
      <div style="height: 56px; display: grid; place-items: center; font-weight: 800; font-size: 18px">MoeNews</div>
      <n-menu :value="activeKey" :options="menuOptions" />
    </n-layout-sider>
    <n-layout>
      <n-layout-header class="admin-header">
        <strong>新闻发布与管理系统</strong>
        <n-space align="center">
          <span>{{ auth.user?.nickname }}</span>
          <n-button quaternary @click="router.push('/news')">前台</n-button>
          <n-button type="primary" ghost @click="logout">退出</n-button>
        </n-space>
      </n-layout-header>
      <n-layout-content class="admin-content">
        <router-view />
      </n-layout-content>
    </n-layout>
  </n-layout>
</template>
