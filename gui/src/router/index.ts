import { createRouter, createWebHistory } from 'vue-router'
import PluginView from '../views/PluginView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'plugin',
      component: PluginView,
    },
  ],
})

export default router
