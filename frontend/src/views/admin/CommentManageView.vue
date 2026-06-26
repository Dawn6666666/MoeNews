<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { NButton, NSpace, NTag, NIcon, useDialog, useMessage } from 'naive-ui'
import { 
  SearchOutline, 
  RefreshOutline, 
  TrashOutline, 
  EyeOutline, 
  EyeOffOutline 
} from '@vicons/ionicons5'
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
  content: '删除采用逻辑删除，删除后前台将不再展示该评论。',
  positiveText: '删除',
  negativeText: '取消',
  onPositiveClick: async () => { await adminApi.deleteComment(id); message.success('删除成功'); load() }
})

// 格式化标签与按钮样式以匹配 Soybean Admin 柔和风格并整合微图标
const columns = [
  { title: 'ID', key: 'id', width: 70 },
  { title: '新闻', key: 'newsTitle' },
  { title: '用户', key: 'nickname', width: 120 },
  { title: '内容', key: 'content' },
  { 
    title: '状态', 
    key: 'status', 
    width: 100, 
    render: (row) => h(
      NTag, 
      { type: row.status ? 'success' : 'error', bordered: false, style: { fontWeight: '600' } }, 
      { default: () => row.status ? '显示' : '隐藏' }
    ) 
  },
  { title: '操作', key: 'actions', width: 190, render: (row) => h(NSpace, null, { default: () => [
    h(NButton, { size: 'small', type: row.status ? 'warning' : 'success', secondary: true, round: true, onClick: () => adminApi.commentStatus(row.id, row.status ? 0 : 1).then(load) }, { 
      default: () => row.status ? '隐藏' : '显示',
      icon: () => h(NIcon, null, { default: () => h(row.status ? EyeOffOutline : EyeOutline) })
    }),
    h(NButton, { size: 'small', type: 'error', secondary: true, round: true, onClick: () => remove(row.id) }, { 
      default: () => '删除',
      icon: () => h(NIcon, null, { default: () => h(TrashOutline) })
    })
  ]}) }
]
onMounted(load)
</script>

<template>
  <div class="toolbar">
    <n-input v-model:value="query.keyword" clearable placeholder="搜索评论内容..." style="max-width: 240px" @keyup.enter="query.page = 1; load()" />
    <n-select v-model:value="query.status" clearable :options="commentStatusOptions" placeholder="选择状态" style="max-width: 150px" @update:value="query.page = 1; load()" />
    <n-button type="primary" round @click="query.page = 1; load()">
      <template #icon><n-icon><SearchOutline /></n-icon></template>
      查询
    </n-button>
    <n-button round @click="query.keyword = ''; query.status = null; query.page = 1; load()">
      <template #icon><n-icon><RefreshOutline /></n-icon></template>
      重置
    </n-button>
  </div>
  
  <n-card title="评论列表" style="border-radius: var(--radius-md); box-shadow: var(--shadow-sm);">
    <n-data-table :columns="columns" :data="rows" :pagination="false" :bordered="false" />
    
    <n-space justify="end" style="margin-top: 20px">
      <n-pagination 
        v-model:page="query.page" 
        :page-size="query.size" 
        :item-count="query.itemCount" 
        show-size-picker
        :page-sizes="[10, 20, 50]"
        @update:page="load" 
        @update:page-size="(val) => { query.size = val; query.page = 1; load(); }"
      />
    </n-space>
  </n-card>
</template>


