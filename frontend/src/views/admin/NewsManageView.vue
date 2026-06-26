<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import { NButton, NSpace, NTag, useDialog, useMessage } from 'naive-ui'
import { adminApi } from '../../api'
import { newsStatusOptions } from '../../utils/options'

const router = useRouter()
const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const categories = ref([])
const query = reactive({ page: 1, size: 10, keyword: '', categoryId: null, status: null, itemCount: 0 })

const loadCategories = async () => {
  const data = await adminApi.categories({ page: 1, size: 100, status: 1 })
  categories.value = data.records.map((item) => ({ label: item.name, value: item.id }))
}
const load = async () => {
  const data = await adminApi.adminNews(query)
  rows.value = data.records
  query.itemCount = data.total
}
const remove = (id) => dialog.warning({
  title: '确认删除新闻',
  content: '删除后前台不再展示该新闻。',
  positiveText: '删除',
  negativeText: '取消',
  onPositiveClick: async () => { await adminApi.deleteNews(id); message.success('删除成功'); load() }
})
const columns = [
  { title: 'ID', key: 'id', width: 70 },
  { title: '标题', key: 'title' },
  { title: '分类', key: 'categoryName', width: 120 },
  { title: '浏览量', key: 'viewCount', width: 90 },
  { title: '状态', key: 'status', width: 100, render: (row) => h(NTag, { type: row.status === 1 ? 'success' : row.status === 2 ? 'warning' : 'default' }, { default: () => newsStatusOptions.find((item) => item.value === row.status)?.label }) },
  { title: '操作', key: 'actions', width: 280, render: (row) => h(NSpace, null, { default: () => [
    h(NButton, { size: 'small', onClick: () => router.push(`/admin/news/edit/${row.id}`) }, { default: () => '编辑' }),
    h(NButton, { size: 'small', type: 'success', onClick: () => adminApi.newsStatus(row.id, 1).then(load) }, { default: () => '发布' }),
    h(NButton, { size: 'small', type: 'warning', onClick: () => adminApi.newsStatus(row.id, 2).then(load) }, { default: () => '下架' }),
    h(NButton, { size: 'small', type: 'error', onClick: () => remove(row.id) }, { default: () => '删除' })
  ]}) }
]
onMounted(() => { loadCategories(); load() })
</script>

<template>
  <n-card title="新闻管理">
    <div class="toolbar">
      <n-input v-model:value="query.keyword" clearable placeholder="新闻标题" style="max-width: 220px" />
      <n-select v-model:value="query.categoryId" clearable :options="categories" placeholder="分类" style="max-width: 170px" />
      <n-select v-model:value="query.status" clearable :options="newsStatusOptions" placeholder="状态" style="max-width: 150px" />
      <n-button type="primary" @click="query.page = 1; load()">查询</n-button>
      <n-button @click="query.keyword = ''; query.categoryId = null; query.status = null; query.page = 1; load()">重置</n-button>
      <n-button type="primary" ghost @click="router.push('/admin/news/add')">发布新闻</n-button>
    </div>
    <n-data-table :columns="columns" :data="rows" :pagination="false" />
    <n-pagination v-model:page="query.page" :page-size="query.size" :item-count="query.itemCount" style="margin-top: 16px" @update:page="load" />
  </n-card>
</template>
