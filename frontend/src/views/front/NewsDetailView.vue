<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useMessage, useDialog } from 'naive-ui'
import { MdPreview } from 'md-editor-v3'
import { newsApi } from '../../api'
import { useAuthStore } from '../../stores/auth'
import { assetUrl } from '../../utils/url'

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
    content: '删除后前台不再展示该评论。',
    positiveText: '删除',
    negativeText: '取消',
    onPositiveClick: async () => {
      await newsApi.deleteComment(id)
      message.success('删除成功')
      loadComments()
    }
  })
}

onMounted(() => {
  loadDetail()
  loadComments()
})
</script>

<template>
  <section class="page">
    <n-card>
      <img v-if="detail.coverImage" class="news-cover" :src="assetUrl(detail.coverImage)" alt="">
      <h1>{{ detail.title }}</h1>
      <n-space>
        <n-tag>{{ detail.categoryName }}</n-tag>
        <span>{{ detail.createTime }}</span>
        <span>{{ detail.viewCount }} 次浏览</span>
      </n-space>
      <n-divider />
      <MdPreview editor-id="front-preview" :model-value="detail.content || ''" />
    </n-card>
    <n-card title="评论" style="margin-top: 16px">
      <n-input v-model:value="content" type="textarea" maxlength="500" show-count placeholder="写下你的评论" />
      <n-button type="primary" style="margin-top: 12px" @click="submitComment">发表评论</n-button>
      <n-list style="margin-top: 16px">
        <n-list-item v-for="item in comments" :key="item.id">
          <n-thing :title="item.nickname" :description="item.createTime">
            {{ item.content }}
            <template #footer>
              <n-button v-if="auth.user?.id === item.userId" text type="error" @click="remove(item.id)">删除</n-button>
            </template>
          </n-thing>
        </n-list-item>
      </n-list>
    </n-card>
  </section>
</template>
