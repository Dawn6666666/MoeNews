<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useMessage } from 'naive-ui'
import { useRoute, useRouter } from 'vue-router'
import { MdEditor } from 'md-editor-v3'
import { adminApi } from '../../api'
import { useAuthStore } from '../../stores/auth'
import { newsStatusOptions } from '../../utils/options'
import { assetUrl } from '../../utils/url'

const route = useRoute()
const router = useRouter()
const message = useMessage()
const auth = useAuthStore()
const id = computed(() => route.params.id)
const categories = ref([])
const form = reactive({
  title: '',
  summary: '',
  content: '',
  coverImage: '',
  categoryId: null,
  status: 0
})

const loadCategories = async () => {
  const data = await adminApi.categories({ page: 1, size: 100, status: 1 })
  categories.value = data.records.map((item) => ({ label: item.name, value: item.id }))
}
const loadDetail = async () => {
  if (!id.value) return
  Object.assign(form, await adminApi.adminNewsDetail(id.value))
}
const save = async () => {
  try {
    id.value ? await adminApi.updateNews(id.value, form) : await adminApi.createNews(form)
    message.success('保存成功')
    router.push('/admin/news')
  } catch (error) {
    message.error(error.message)
  }
}

// 上传组件需要自定义请求，以便携带 JWT 并读取后端统一返回结构。
const upload = ({ file, onFinish, onError }) => {
  const data = new FormData()
  data.append('file', file.file)
  fetch('http://localhost:8080/api/admin/upload/image', {
    method: 'POST',
    headers: { Authorization: `Bearer ${auth.token}` },
    body: data
  }).then((res) => res.json()).then((res) => {
    if (res.code !== 200) throw new Error(res.message)
    form.coverImage = res.data.url
    onFinish()
  }).catch((error) => {
    message.error(error.message)
    onError()
  })
}

onMounted(() => { loadCategories(); loadDetail() })
</script>

<template>
  <n-card :title="id ? '编辑新闻' : '发布新闻'">
    <n-form :model="form" label-placement="top">
      <n-grid :cols="2" :x-gap="16" responsive="screen">
        <n-form-item-gi label="标题"><n-input v-model:value="form.title" /></n-form-item-gi>
        <n-form-item-gi label="分类"><n-select v-model:value="form.categoryId" :options="categories" /></n-form-item-gi>
        <n-form-item-gi label="状态"><n-select v-model:value="form.status" :options="newsStatusOptions" /></n-form-item-gi>
        <n-form-item-gi label="封面">
          <n-upload :custom-request="upload" :max="1" accept=".jpg,.jpeg,.png">
            <n-button>上传封面</n-button>
          </n-upload>
        </n-form-item-gi>
      </n-grid>
      <n-form-item label="摘要"><n-input v-model:value="form.summary" type="textarea" /></n-form-item>
      <img v-if="form.coverImage" class="news-cover" :src="assetUrl(form.coverImage)" alt="" style="max-width: 360px; margin-bottom: 12px">
      <n-form-item label="正文">
        <MdEditor v-model="form.content" style="height: 520px" />
      </n-form-item>
      <n-space>
        <n-button type="primary" @click="save">保存</n-button>
        <n-button @click="router.push('/admin/news')">返回</n-button>
      </n-space>
    </n-form>
  </n-card>
</template>
