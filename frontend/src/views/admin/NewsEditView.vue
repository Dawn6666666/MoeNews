<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useMessage } from 'naive-ui'
import { useRoute, useRouter } from 'vue-router'
import { MdEditor } from 'md-editor-v3'
import { SaveOutline, ArrowBackOutline } from '@vicons/ionicons5'
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
  if (!form.title.trim()) {
    message.warning('新闻标题不能为空')
    return
  }
  if (!form.categoryId) {
    message.warning('请选择新闻分类')
    return
  }
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
  <n-card :title="id ? '编辑新闻' : '发布新闻'" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm);">
    <n-form :model="form" label-placement="top">
      <n-grid :cols="2" :x-gap="20" responsive="screen">
        <n-form-item-gi label="新闻标题">
          <n-input v-model:value="form.title" placeholder="请输入引人入胜的标题..." style="border-radius: var(--radius-sm);" />
        </n-form-item-gi>
        <n-form-item-gi label="新闻分类">
          <n-select v-model:value="form.categoryId" :options="categories" placeholder="请选择新闻分类" style="border-radius: var(--radius-sm);" />
        </n-form-item-gi>
        <n-form-item-gi label="发布状态">
          <n-select v-model:value="form.status" :options="newsStatusOptions" placeholder="请选择发布状态" style="border-radius: var(--radius-sm);" />
        </n-form-item-gi>
        <n-form-item-gi label="新闻封面图">
          <n-space vertical :size="12" style="width: 100%;">
            <n-upload :custom-request="upload" :max="1" accept=".jpg,.jpeg,.png" :show-file-list="false">
              <n-button type="info" dashed block style="border-radius: var(--radius-sm);">上传封面图片</n-button>
            </n-upload>
            <div v-if="form.coverImage" style="border: 1px dashed var(--border-color); border-radius: var(--radius-sm); padding: 8px; background: #fafafa; display: inline-block; box-shadow: var(--shadow-sm);">
              <n-image :src="assetUrl(form.coverImage)" alt="封面预览" width="200" style="border-radius: 4px; display: block;" />
            </div>
          </n-space>
        </n-form-item-gi>
      </n-grid>
      
      <n-form-item label="新闻摘要">
        <n-input v-model:value="form.summary" type="textarea" :rows="3" placeholder="请输入简短的内容摘要，用于列表页展示..." style="border-radius: var(--radius-sm);" />
      </n-form-item>
      
      <n-form-item label="新闻正文内容">
        <MdEditor v-model="form.content" style="height: 520px; border-radius: var(--radius-sm); overflow: hidden; border: 1px solid var(--border-color);" />
      </n-form-item>
      
      <n-space justify="end" :size="16" style="margin-top: 16px;">
        <n-button round @click="router.push('/admin/news')">
          <template #icon>
            <n-icon><ArrowBackOutline /></n-icon>
          </template>
          返回列表
        </n-button>
        <n-button type="primary" round @click="save">
          <template #icon>
            <n-icon><SaveOutline /></n-icon>
          </template>
          保存发布
        </n-button>
      </n-space>
    </n-form>
  </n-card>
</template>

