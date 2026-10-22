import react from '@vitejs/plugin-react'
import { defineConfig, loadEnv } from 'vite'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  // Mock Prism phục vụ path theo openapi.yaml (không có tiền tố /api), backend Spring thì có
  const stripApiPrefix = env.API_STRIP_PREFIX === 'true'

  return {
    plugins: [react()],
    server: {
      proxy: {
        '/api': {
          target: env.API_PROXY_TARGET || 'http://localhost:8080',
          changeOrigin: true,
          rewrite: stripApiPrefix ? (path) => path.replace(/^\/api/, '') : undefined,
        },
      },
    },
  }
})
