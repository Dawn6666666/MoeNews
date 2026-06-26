<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { NButton, NSpace, NTag, useDialog, useMessage } from 'naive-ui'
import { adminApi } from '../../api'
import { commentStatusOptions } from '../../utils/options'

const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const query = reactive({ page: 1, size: 10, keyword: '', status: null, itemCount: 0 })
const load = async () => {
  const data = await adminApi.comments(query)
  rows.value = data.records
  query.itemCount = data.total
}
const remove = (id) => dialog.warning({
  title: '确认删除评论',
  positiveText: '删除',
  negativeText: '取消',
  onPositiveClick: async () => { await adminApi.deleteComment(id); message.success('删除成功'); load() }
})
const columns = [
  { title: 'ID', key: 'id', width: 70 },
  { title: '新闻', key: 'newsTitle' },
  { title: '用户', key: 'nickname', width: 120 },
  { title: '内容', key: 'content' },
  { title: '状态', key: 'status', width: 100, render: (row) => h(NTag, { type: row.status ? 'success' : 'warning' }, { default: () => row.status ? '显示' : '隐藏' }) },
  { title: '操作', key: 'actions', width: 180, render: (row) => h(NSpace, null, { default: () => [
    h(NButton, { size: 'small', type: row.status ? 'warning' : 'success', onClick: () => adminApi.commentStatus(row.id, row.status ? 0 : 1).then(load) }, { default: () => row.status ? '隐藏' : '显示' }),
    h(NButton, { size: 'small', type: 'error', onClick: () => remove(row.id) }, { default: () => '删除' })
  ]}) }
]
onMounted(load)
</script>

<template>
  <n-card title="评论管理">
    <div class="toolbar">
      <n-input v-model:value="query.keyword" clearable placeholder="评论内容" style="max-width: 220px" />
      <n-select v-model:value="query.status" clearable :options="commentStatusOptions" placeholder="状态" style="max-width: 150px" />
      <n-button type="primary" @click="query.page = 1; load()">查询</n-button>
      <n-button @click="query.keyword = ''; query.status = null; query.page = 1; load()">重置</n-button>
    </div>
    <n-data-table :columns="columns" :data="rows" :pagination="false" />
    <n-pagination v-model:page="query.page" :page-size="query.size" :item-count="query.itemCount" style="margin-top: 16px" @update:page="load" />
  </n-card>
</template>
