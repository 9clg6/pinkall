/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_PINKALL_SUPABASE_URL?: string;
  readonly VITE_PINKALL_SUPABASE_PUBLISHABLE_KEY?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
