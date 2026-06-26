<script setup>
import { onMounted, ref } from 'vue'
import { adminApi } from '../../api'

const stats = ref({})
const labels = {
  userCount: '用户总数',
  newsCount: '新闻总数',
  categoryCount: '分类总数',
  commentCount: '评论总数',
  publishedNewsCount: '已发布新闻',
  draftNewsCount: '草稿新闻',
  offlineNewsCount: '已下架新闻'
}

onMounted(async () => {
  stats.value = await adminApi.statistics()
})
</script>

<template>
  <div class="stat-grid">
    <n-card v-for="(label, key) in labels" :key="key">
      <n-statistic :label="label" :value="stats[key] || 0" />
    </n-card>
  </div>
</template>
