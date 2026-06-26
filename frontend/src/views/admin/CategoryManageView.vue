<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { NButton, NSpace, NTag, useDialog, useMessage } from 'naive-ui'
import { adminApi } from '../../api'
import { statusOptions } from '../../utils/options'

const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const show = ref(false)
const editingId = ref(null)
const query = reactive({ page: 1, size: 10, keyword: '', status: null, itemCount: 0 })
const form = reactive({ name: '', description: '', sort: 0, status: 1 })

const load = async () => {
  const data = await adminApi.categories(query)
  rows.value = data.records
  query.itemCount = data.total
}
const open = (row) => {
  editingId.value = row?.id || null
  Object.assign(form, row || { name: '', description: '', sort: 0, status: 1 })
  show.value = true
}
const save = async () => {
  try {
    editingId.value ? await adminApi.updateCategory(editingId.value, form) : await adminApi.createCategory(form)
    message.success('保存成功')
    show.value = false
    load()
  } catch (error) {
    message.error(error.message)
  }
}
const remove = (id) => {
  dialog.warning({
    title: '确认删除分类',
    content: '分类下存在新闻时后端会拒绝删除。',
    positiveText: '删除',
    negativeText: '取消',
    onPositiveClick: async () => {
      await adminApi.deleteCategory(id)
      message.success('删除成功')
      load()
    }
  })
}
const columns = [
  { title: 'ID', key: 'id', width: 70 },
  { title: '名称', key: 'name' },
  { title: '描述', key: 'description' },
  { title: '排序', key: 'sort', width: 90 },
  { title: '状态', key: 'status', render: (row) => h(NTag, { type: row.status ? 'success' : 'warning' }, { default: () => row.status ? '启用' : '禁用' }) },
  { title: '操作', key: 'actions', render: (row) => h(NSpace, null, { default: () => [
    h(NButton, { size: 'small', onClick: () => open(row) }, { default: () => '编辑' }),
    h(NButton, { size: 'small', type: row.status ? 'warning' : 'success', onClick: () => adminApi.categoryStatus(row.id, row.status ? 0 : 1).then(load) }, { default: () => row.status ? '禁用' : '启用' }),
    h(NButton, { size: 'small', type: 'error', onClick: () => remove(row.id) }, { default: () => '删除' })
  ]}) }
]

onMounted(load)
</script>

<template>
  <n-card title="新闻分类管理">
    <div class="toolbar">
      <n-input v-model:value="query.keyword" clearable placeholder="分类名称" style="max-width: 220px" />
      <n-select v-model:value="query.status" clearable :options="statusOptions" placeholder="状态" style="max-width: 160px" />
      <n-button type="primary" @click="query.page = 1; load()">查询</n-button>
      <n-button @click="query.keyword = ''; query.status = null; query.page = 1; load()">重置</n-button>
      <n-button type="primary" ghost @click="open()">新增分类</n-button>
    </div>
    <n-data-table :columns="columns" :data="rows" :pagination="false" />
    <n-pagination v-model:page="query.page" :page-size="query.size" :item-count="query.itemCount" style="margin-top: 16px" @update:page="load" />
  </n-card>
  <n-modal v-model:show="show" preset="card" title="分类信息" style="width: 520px">
    <n-form :model="form" label-placement="left" label-width="80">
      <n-form-item label="名称"><n-input v-model:value="form.name" /></n-form-item>
      <n-form-item label="描述"><n-input v-model:value="form.description" /></n-form-item>
      <n-form-item label="排序"><n-input-number v-model:value="form.sort" /></n-form-item>
      <n-form-item label="状态"><n-select v-model:value="form.status" :options="statusOptions" /></n-form-item>
    </n-form>
    <template #footer><n-button type="primary" @click="save">保存</n-button></template>
  </n-modal>
</template>
