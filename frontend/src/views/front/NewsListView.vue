<script setup>
import { onMounted, reactive, ref } from 'vue'
import { newsApi } from '../../api'
import heroImage from '../../assets/hero.png'
import { assetUrl } from '../../utils/url'

const loading = ref(false)
const news = ref([])
const categories = ref([])
const pager = reactive({ page: 1, size: 9, itemCount: 0 })
const query = reactive({ keyword: '', categoryId: null })

const loadCategories = async () => {
  const data = await newsApi.categories()
  categories.value = data.map((item) => ({ label: item.name, value: item.id }))
}

const loadNews = async () => {
  loading.value = true
  try {
    const data = await newsApi.list({ page: pager.page, size: pager.size, keyword: query.keyword, categoryId: query.categoryId })
    news.value = data.records
    pager.itemCount = data.total
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadCategories()
  loadNews()
})
</script>

<template>
  <section class="page">
    <div class="toolbar">
      <n-input v-model:value="query.keyword" clearable placeholder="搜索新闻标题" style="max-width: 280px" />
      <n-select v-model:value="query.categoryId" clearable :options="categories" placeholder="选择分类" style="max-width: 220px" />
      <n-button type="primary" @click="pager.page = 1; loadNews()">查询</n-button>
      <n-button @click="query.keyword = ''; query.categoryId = null; pager.page = 1; loadNews()">重置</n-button>
    </div>
    <n-spin :show="loading">
      <div class="news-grid">
        <n-card v-for="item in news" :key="item.id" hoverable>
          <template #cover>
            <img class="news-cover" :src="assetUrl(item.coverImage, heroImage)" alt="">
          </template>
          <h3>{{ item.title }}</h3>
          <p>{{ item.summary }}</p>
          <n-space justify="space-between" align="center">
            <n-tag size="small">{{ item.categoryName || '未分类' }}</n-tag>
            <span>{{ item.viewCount }} 次浏览</span>
          </n-space>
          <template #action>
            <n-button type="primary" text @click="$router.push(`/news/${item.id}`)">阅读详情</n-button>
          </template>
        </n-card>
      </div>
      <n-pagination v-model:page="pager.page" :page-size="pager.size" :item-count="pager.itemCount" style="margin-top: 20px" @update:page="loadNews" />
    </n-spin>
  </section>
</template>
