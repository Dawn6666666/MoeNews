<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useMessage, useDialog } from 'naive-ui'
import { MdPreview } from 'md-editor-v3'
import { newsApi } from '../../api'
import { useAuthStore } from '../../stores/auth'
import { assetUrl } from '../../utils/url'
import heroImage from '../../assets/hero.png'

const route = useRoute()
const router = useRouter()
const message = useMessage()
const dialog = useDialog()
const auth = useAuthStore()
const detail = ref({})
const comments = ref([])
const content = ref('')
const pager = reactive({ page: 1, size: 10, itemCount: 0 })

const loadDetail = async () => {
  detail.value = await newsApi.detail(route.params.id)
}
const loadComments = async () => {
  const data = await newsApi.comments(route.params.id, pager)
  comments.value = data.records
  pager.itemCount = data.total
}
const submitComment = async () => {
  if (!auth.token) {
    router.push('/login')
    return
  }
  if (!content.value.trim()) {
    message.warning('评论内容不能为空')
    return
  }
  try {
    await newsApi.comment(route.params.id, { content: content.value })
    content.value = ''
    message.success('评论成功')
    loadComments()
  } catch (error) {
    message.error(error.message)
  }
}
const remove = (id) => {
  dialog.warning({
    title: '确认删除评论',
    content: '删除后前台将不再展示该评论。',
    positiveText: '删除',
    negativeText: '取消',
    onPositiveClick: async () => {
      await newsApi.deleteComment(id)
      message.success('删除成功')
      loadComments()
    }
  })
}

// 根据昵称计算二次元彩色头像背景色
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

onMounted(() => {
  loadDetail()
  loadComments()
})
</script>

<template>
  <section class="page" style="max-width: 860px;">
    <!-- 详情卡片 -->
    <n-card :bordered="false" style="border-radius: var(--radius-lg); box-shadow: var(--shadow-md); overflow: hidden;">
      <!-- 沉浸式横幅 -->
      <div class="detail-banner">
        <img class="detail-banner-img" :src="assetUrl(detail.coverImage, heroImage)" alt="新闻封面">
        <div class="detail-banner-overlay">
          <n-tag :bordered="false" type="primary" size="small" style="margin-bottom: 12px; border-radius: 6px; font-weight: 700; padding: 2px 10px;">
            {{ detail.categoryName || '资讯' }}
          </n-tag>
          <h1 class="detail-banner-title">{{ detail.title }}</h1>
          <n-space style="color: rgba(255,255,255,0.95); font-size: 14px;" :size="16">
            <span>发布于：{{ detail.createTime }}</span>
            <span>•</span>
            <span>{{ detail.viewCount || 0 }} 次浏览</span>
          </n-space>
        </div>
      </div>

      <!-- 正文渲染 -->
      <div style="padding: 12px 10px 20px;" class="moe-markdown">
        <MdPreview editor-id="front-preview" :model-value="detail.content || ''" />
      </div>
    </n-card>

    <!-- 评论区域 -->
    <n-card title="发表评论" style="margin-top: 24px; border-radius: var(--radius-lg); box-shadow: var(--shadow-md);">
      <n-input
        v-model:value="content"
        type="textarea"
        maxlength="500"
        show-count
        placeholder="发表你的友善评论，一起交流吧..."
        :rows="3"
        style="border-radius: var(--radius-sm);"
      />
      <n-space justify="end" style="margin-top: 14px">
        <n-button type="primary" round style="padding: 0 24px; font-weight: 700;" @click="submitComment">发表评论</n-button>
      </n-space>

      <n-divider title-placement="left" style="margin-top: 32px;">
        <span style="font-weight: 800; font-size: 16px; color: var(--text-main); font-family: Outfit, sans-serif;">评论列表 ({{ pager.itemCount }})</span>
      </n-divider>

      <!-- 空评论状态 -->
      <div v-if="comments.length === 0" style="padding: 40px 0; text-align: center;">
        <n-empty description="暂无评论，快来发表第一条评论吧！" size="large" />
      </div>

      <!-- 评论列表 -->
      <n-list v-else style="background: transparent;">
        <n-list-item
          v-for="item in comments"
          :key="item.id"
          class="comment-card slide-up-fade"
          style="padding: 16px 20px; margin-bottom: 16px; border-radius: var(--radius-md); background: #ffffff;"
        >
          <n-thing>
            <!-- 头像插槽 -->
            <template #avatar>
              <n-avatar
                round
                :size="42"
                :style="{ backgroundColor: getAvatarColor(item.nickname), color: '#ffffff', fontWeight: '800', boxShadow: '0 4px 10px rgba(0,0,0,0.05)' }"
              >
                {{ getAvatarLabel(item.nickname) }}
              </n-avatar>
            </template>
            <!-- 昵称与时间 -->
            <template #title>
              <div style="display: flex; align-items: center; gap: 8px;">
                <span style="font-weight: 700; color: var(--text-main); font-size: 14px;">{{ item.nickname }}</span>
                <!-- 管理员/读者标签 -->
                <n-tag v-if="item.userId === 1 || item.nickname === 'admin'" :bordered="false" size="mini" type="error" style="border-radius: 4px; font-size: 10px; font-weight: 800; padding: 0 6px;">
                  管理员
                </n-tag>
                <n-tag v-else :bordered="false" size="mini" type="info" style="border-radius: 4px; font-size: 10px; font-weight: 800; padding: 0 6px;">
                  读者
                </n-tag>
              </div>
            </template>
            <template #description>
              <span style="font-size: 11px; color: var(--text-muted); font-weight: 500;">{{ item.createTime }}</span>
            </template>
            <!-- 评论内容 -->
            <div style="font-size: 14px; color: var(--text-main); line-height: 1.6; margin-top: 6px; word-break: break-all;">
              {{ item.content }}
            </div>
            <!-- 底部删除操作 -->
            <template #footer>
              <n-space justify="end" v-if="auth.user?.id === item.userId || auth.user?.role === 'ADMIN'">
                <n-button text type="error" size="small" style="font-weight: 600; font-size: 12px;" @click="remove(item.id)">
                  删除评论
                </n-button>
              </n-space>
            </template>
          </n-thing>
        </n-list-item>
      </n-list>

      <!-- 评论分页 -->
      <n-space v-if="pager.itemCount > pager.size" justify="center" style="margin-top: 24px;">
        <n-pagination
          v-model:page="pager.page"
          :page-size="pager.size"
          :item-count="pager.itemCount"
          simple
          @update:page="loadComments"
        />
      </n-space>
    </n-card>
  </section>
</template>
