<script setup>
import { h, onMounted, reactive, ref } from 'vue'
import { NButton, NSpace, NTag, useDialog, useMessage } from 'naive-ui'
import { adminApi } from '../../api'
import { roleOptions, statusOptions } from '../../utils/options'

const message = useMessage()
const dialog = useDialog()
const rows = ref([])
const show = ref(false)
const resetShow = ref(false)
const editingId = ref(null)
const resetId = ref(null)
const newPassword = ref('123456')
const query = reactive({ page: 1, size: 10, keyword: '', role: null, status: null, itemCount: 0 })
const form = reactive({ username: '', password: '123456', nickname: '', email: '', phone: '', role: 'USER', status: 1 })

const load = async () => {
  const data = await adminApi.users(query)
  rows.value = data.records
  query.itemCount = data.total
}
const open = (row) => {
  editingId.value = row?.id || null
  Object.assign(form, row || { username: '', password: '123456', nickname: '', email: '', phone: '', role: 'USER', status: 1 })
  show.value = true
}
const save = async () => {
  try {
    editingId.value ? await adminApi.updateUser(editingId.value, form) : await adminApi.createUser(form)
    message.success('保存成功')
    show.value = false
    load()
  } catch (error) {
    message.error(error.message)
  }
}
const remove = (id) => dialog.warning({
  title: '确认删除用户',
  content: '删除采用逻辑删除，用户密码不会返回前端。',
  positiveText: '删除',
  negativeText: '取消',
  onPositiveClick: async () => { await adminApi.deleteUser(id); message.success('删除成功'); load() }
})
const reset = async () => {
  await adminApi.resetPassword(resetId.value, newPassword.value)
  message.success('密码已重置')
  resetShow.value = false
}
const columns = [
  { title: 'ID', key: 'id', width: 70 },
  { title: '用户名', key: 'username' },
  { title: '昵称', key: 'nickname' },
  { title: '角色', key: 'role', render: (row) => h(NTag, { type: row.role === 'ADMIN' ? 'info' : 'default' }, { default: () => row.role }) },
  { title: '状态', key: 'status', render: (row) => h(NTag, { type: row.status ? 'success' : 'warning' }, { default: () => row.status ? '启用' : '禁用' }) },
  { title: '操作', key: 'actions', width: 280, render: (row) => h(NSpace, null, { default: () => [
    h(NButton, { size: 'small', onClick: () => open(row) }, { default: () => '编辑' }),
    h(NButton, { size: 'small', onClick: () => { resetId.value = row.id; resetShow.value = true } }, { default: () => '重置密码' }),
    h(NButton, { size: 'small', type: row.status ? 'warning' : 'success', onClick: () => adminApi.userStatus(row.id, row.status ? 0 : 1).then(load) }, { default: () => row.status ? '禁用' : '启用' }),
    h(NButton, { size: 'small', type: 'error', onClick: () => remove(row.id) }, { default: () => '删除' })
  ]}) }
]

onMounted(load)
</script>

<template>
  <n-card title="用户管理">
    <div class="toolbar">
      <n-input v-model:value="query.keyword" clearable placeholder="用户名" style="max-width: 200px" />
      <n-select v-model:value="query.role" clearable :options="roleOptions" placeholder="角色" style="max-width: 150px" />
      <n-select v-model:value="query.status" clearable :options="statusOptions" placeholder="状态" style="max-width: 150px" />
      <n-button type="primary" @click="query.page = 1; load()">查询</n-button>
      <n-button @click="query.keyword = ''; query.role = null; query.status = null; query.page = 1; load()">重置</n-button>
      <n-button type="primary" ghost @click="open()">新增用户</n-button>
    </div>
    <n-data-table :columns="columns" :data="rows" :pagination="false" />
    <n-pagination v-model:page="query.page" :page-size="query.size" :item-count="query.itemCount" style="margin-top: 16px" @update:page="load" />
  </n-card>
  <n-modal v-model:show="show" preset="card" title="用户信息" style="width: 560px">
    <n-form :model="form" label-placement="left" label-width="90">
      <n-form-item label="用户名"><n-input v-model:value="form.username" :disabled="!!editingId" /></n-form-item>
      <n-form-item v-if="!editingId" label="密码"><n-input v-model:value="form.password" type="password" /></n-form-item>
      <n-form-item label="昵称"><n-input v-model:value="form.nickname" /></n-form-item>
      <n-form-item label="邮箱"><n-input v-model:value="form.email" /></n-form-item>
      <n-form-item label="手机号"><n-input v-model:value="form.phone" /></n-form-item>
      <n-form-item label="角色"><n-select v-model:value="form.role" :options="roleOptions" /></n-form-item>
      <n-form-item label="状态"><n-select v-model:value="form.status" :options="statusOptions" /></n-form-item>
    </n-form>
    <template #footer><n-button type="primary" @click="save">保存</n-button></template>
  </n-modal>
  <n-modal v-model:show="resetShow" preset="dialog" title="重置密码" positive-text="确认" negative-text="取消" @positive-click="reset">
    <n-input v-model:value="newPassword" type="password" />
  </n-modal>
</template>
