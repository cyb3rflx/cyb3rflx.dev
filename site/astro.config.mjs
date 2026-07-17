// @ts-check
import { defineConfig, envField } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  env: {
    schema: {
      GITHUB_TOKEN: envField.string({ context: "server", access: "secret"}),
    },
  },
  vite: {
    plugins: [tailwindcss()]
  }
});