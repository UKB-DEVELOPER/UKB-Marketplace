import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [svelte()],
  base: './',
  build:{
    emptyOutDir: true,
    outDir: '../interface',
    reportCompressedSize: false,
    minify: true,
    target: 'chrome91',
    sourcemap: false,
    rollupOptions: {
      output:{
        entryFileNames: '[name].js',
        chunkFileNames: '[name].js',
        assetFileNames: '[name].[ext]',
      }
    },
  },
  clearScreen: true
})
