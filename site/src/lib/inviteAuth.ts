import {
  createClient,
  type AuthFlowType,
  type SupabaseClient,
} from "@supabase/supabase-js";

export type PasswordValidation =
  | { valid: true }
  | { valid: false; message: string };

let inviteClient: SupabaseClient | undefined;

export function getInviteAuthFlow(location: Pick<Location, "hash" | "search">): AuthFlowType {
  const hash = new URLSearchParams(location.hash.replace(/^#/, ""));
  const search = new URLSearchParams(location.search);

  if (
    hash.has("access_token") ||
    hash.has("refresh_token") ||
    hash.has("error") ||
    hash.has("error_description")
  ) {
    return "implicit";
  }

  if (search.has("code")) return "pkce";

  return "pkce";
}

export function getInviteUrlError(location: Pick<Location, "hash" | "search">): string | null {
  const hash = new URLSearchParams(location.hash.replace(/^#/, ""));
  const search = new URLSearchParams(location.search);
  const message = hash.get("error_description") ?? search.get("error_description");

  return message ? message.replace(/\+/g, " ") : null;
}

export function validateInvitePassword(
  password: string,
  confirmation: string,
): PasswordValidation {
  if (password.length < 8) {
    return {
      valid: false,
      message: "Choisis un mot de passe d’au moins 8 caractères.",
    };
  }

  if (password !== confirmation) {
    return {
      valid: false,
      message: "Les deux mots de passe ne correspondent pas.",
    };
  }

  return { valid: true };
}

export function getInviteSupabaseClient(): SupabaseClient {
  if (inviteClient) return inviteClient;

  const url = import.meta.env.VITE_PINKALL_SUPABASE_URL?.trim();
  const publishableKey = import.meta.env.VITE_PINKALL_SUPABASE_PUBLISHABLE_KEY?.trim();

  if (!url || !publishableKey) {
    throw new Error("Pinkall Auth n’est pas configuré pour cet environnement.");
  }

  if (publishableKey.startsWith("sb_secret_")) {
    throw new Error("La configuration Pinkall Auth utilise une clé non publique.");
  }

  inviteClient = createClient(url, publishableKey, {
    auth: {
      autoRefreshToken: true,
      detectSessionInUrl: true,
      flowType: getInviteAuthFlow(window.location),
      persistSession: true,
      storageKey: "pinkall-invite-auth",
    },
  });

  return inviteClient;
}
