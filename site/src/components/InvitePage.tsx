import {
  ArrowLeft,
  Check,
  Eye,
  EyeSlash,
  LockKey,
  Sparkle,
} from "@phosphor-icons/react";
import { FormEvent, useEffect, useRef, useState } from "react";
import {
  getInviteSupabaseClient,
  getInviteUrlError,
  validateInvitePassword,
} from "../lib/inviteAuth";

type InviteState = "loading" | "ready" | "submitting" | "success" | "error";

function friendlyAuthError(message: string): string {
  const normalized = message.toLowerCase();

  if (
    normalized.includes("expired") ||
    normalized.includes("invalid") ||
    normalized.includes("otp") ||
    normalized.includes("session")
  ) {
    return "Ce lien d’invitation est invalide ou a expiré. Demande une nouvelle invitation à l’équipe Pinkall.";
  }

  if (normalized.includes("password")) {
    return "Ce mot de passe n’est pas accepté. Choisis-en un autre d’au moins 8 caractères.";
  }

  return "Impossible de finaliser l’invitation pour le moment. Réessaie dans quelques instants.";
}

export function InvitePage() {
  const [inviteState, setInviteState] = useState<InviteState>("loading");
  const [email, setEmail] = useState<string | null>(null);
  const [password, setPassword] = useState("");
  const [confirmation, setConfirmation] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [formError, setFormError] = useState<string | null>(null);
  const [pageError, setPageError] = useState<string | null>(null);
  const passwordInput = useRef<HTMLInputElement>(null);

  useEffect(() => {
    document.title = "Finaliser mon invitation — Pinkall";

    const callbackError = getInviteUrlError(window.location);
    if (callbackError) {
      setPageError(friendlyAuthError(callbackError));
      setInviteState("error");
      return undefined;
    }

    let active = true;

    try {
      const supabase = getInviteSupabaseClient();
      const {
        data: { subscription },
      } = supabase.auth.onAuthStateChange((event, session) => {
        if (!active || !session) return;
        if (event === "SIGNED_IN" || event === "PASSWORD_RECOVERY") {
          setEmail(session.user.email ?? null);
          setInviteState("ready");
        }
      });

      void supabase.auth.getSession().then(({ data, error }) => {
        if (!active) return;

        if (error) {
          setPageError(friendlyAuthError(error.message));
          setInviteState("error");
          return;
        }

        if (!data.session) {
          setPageError(
            "Ce lien d’invitation est invalide ou a déjà été utilisé. Demande une nouvelle invitation à l’équipe Pinkall.",
          );
          setInviteState("error");
          return;
        }

        setEmail(data.session.user.email ?? null);
        setInviteState("ready");
      });

      return () => {
        active = false;
        subscription.unsubscribe();
      };
    } catch (error) {
      setPageError(
        error instanceof Error
          ? error.message
          : "Pinkall Auth n’est pas disponible pour le moment.",
      );
      setInviteState("error");
      return undefined;
    }
  }, []);

  useEffect(() => {
    if (inviteState === "ready") passwordInput.current?.focus();
  }, [inviteState]);

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setFormError(null);

    const validation = validateInvitePassword(password, confirmation);
    if (!validation.valid) {
      setFormError(validation.message);
      return;
    }

    setInviteState("submitting");

    try {
      const supabase = getInviteSupabaseClient();
      const { error: updateError } = await supabase.auth.updateUser({ password });
      if (updateError) throw updateError;

      const { error: signOutError } = await supabase.auth.signOut({ scope: "local" });
      if (signOutError) throw signOutError;

      window.history.replaceState(window.history.state, "", "/auth/invite");
      setPassword("");
      setConfirmation("");
      setInviteState("success");
    } catch (error) {
      setFormError(
        friendlyAuthError(
          error instanceof Error ? error.message : "La mise à jour a échoué.",
        ),
      );
      setInviteState("ready");
    }
  }

  const isBusy = inviteState === "loading" || inviteState === "submitting";

  return (
    <div className="invite-page">
      <a className="skip-link" href="#invite-content">
        Aller au formulaire
      </a>

      <header className="invite-header">
        <a className="wordmark" href="/" aria-label="Pinkall, retour à l’accueil">
          <img className="wordmark-mark" src="/brand/pinkall-mark.svg" alt="" />
          <span className="wordmark-text">pinkall</span>
        </a>
        <span className="invite-private-label">
          <LockKey aria-hidden="true" />
          Invitation privée
        </span>
      </header>

      <main id="invite-content" className="invite-main">
        <section className="invite-shell" aria-labelledby="invite-title">
          <aside className="invite-aside" aria-label="Bienvenue dans Pinkall">
            <div className="invite-orbit" aria-hidden="true">
              <span />
              <span />
              <span />
            </div>
            <div className="invite-aside-copy">
              <span className="invite-eyebrow">
                <Sparkle aria-hidden="true" />
                Ta bêta Pinkall
              </span>
              <h1 id="invite-title">Ton coach IA est prêt à écouter.</h1>
              <p>
                Finalise ton accès, puis connecte-toi dans l’app pour préparer,
                comprendre et améliorer tes prochains calls.
              </p>
            </div>
            <p className="invite-aside-footnote">Un accès personnel. Une connexion sécurisée.</p>
          </aside>

          <div className="invite-form-panel">
            {inviteState === "loading" && (
              <div className="invite-status" role="status" aria-live="polite">
                <span className="invite-loader" aria-hidden="true" />
                <h2>Vérification de ton invitation</h2>
                <p>Nous sécurisons ton accès Pinkall…</p>
              </div>
            )}

            {inviteState === "error" && (
              <div className="invite-status invite-status-error" role="alert">
                <span className="invite-status-icon" aria-hidden="true">
                  <LockKey />
                </span>
                <h2>Invitation non disponible</h2>
                <p>{pageError}</p>
                <a className="invite-secondary-link" href="/">
                  <ArrowLeft aria-hidden="true" />
                  Retour à pinkall.app
                </a>
              </div>
            )}

            {(inviteState === "ready" || inviteState === "submitting") && (
              <div className="invite-form-wrap">
                <div className="invite-form-heading">
                  <span>Dernière étape</span>
                  <h2>Choisis ton mot de passe</h2>
                  <p>
                    {email
                      ? `Cet accès sera associé à ${email}.`
                      : "Cet accès sera associé à l’adresse invitée."}
                  </p>
                </div>

                <form className="invite-form" onSubmit={handleSubmit} noValidate>
                  <div className="invite-field">
                    <label htmlFor="invite-password">Mot de passe</label>
                    <div className="invite-password-control">
                      <input
                        ref={passwordInput}
                        id="invite-password"
                        name="password"
                        type={showPassword ? "text" : "password"}
                        value={password}
                        onChange={(event) => setPassword(event.target.value)}
                        minLength={8}
                        autoComplete="new-password"
                        aria-describedby="invite-password-help"
                        aria-invalid={Boolean(formError)}
                        disabled={isBusy}
                        required
                      />
                      <button
                        type="button"
                        className="invite-password-toggle"
                        onClick={() => setShowPassword((visible) => !visible)}
                        aria-label={showPassword ? "Masquer le mot de passe" : "Afficher le mot de passe"}
                        aria-pressed={showPassword}
                        disabled={isBusy}
                      >
                        {showPassword ? <EyeSlash aria-hidden="true" /> : <Eye aria-hidden="true" />}
                      </button>
                    </div>
                    <span id="invite-password-help">8 caractères minimum</span>
                  </div>

                  <div className="invite-field">
                    <label htmlFor="invite-confirmation">Confirmer le mot de passe</label>
                    <input
                      id="invite-confirmation"
                      name="confirmation"
                      type={showPassword ? "text" : "password"}
                      value={confirmation}
                      onChange={(event) => setConfirmation(event.target.value)}
                      minLength={8}
                      autoComplete="new-password"
                      aria-invalid={Boolean(formError)}
                      disabled={isBusy}
                      required
                    />
                  </div>

                  <div className="invite-form-feedback" aria-live="polite">
                    {formError ? <p role="alert">{formError}</p> : null}
                  </div>

                  <button
                    className="button invite-submit"
                    type="submit"
                    disabled={isBusy}
                  >
                    {inviteState === "submitting" ? (
                      <>
                        <span className="invite-button-loader" aria-hidden="true" />
                        Sécurisation…
                      </>
                    ) : (
                      "Finaliser mon accès"
                    )}
                  </button>
                </form>
              </div>
            )}

            {inviteState === "success" && (
              <div className="invite-status invite-status-success" role="status" aria-live="polite">
                <span className="invite-status-icon" aria-hidden="true">
                  <Check />
                </span>
                <span className="invite-success-kicker">Accès activé</span>
                <h2>Bienvenue dans Pinkall.</h2>
                <p>
                  Ton mot de passe est enregistré. Tu peux fermer cet onglet et te
                  connecter dans l’app avec ton email.
                </p>
                <a className="invite-secondary-link" href="/">
                  Découvrir Pinkall
                </a>
              </div>
            )}
          </div>
        </section>
      </main>

      <footer className="invite-footer">
        <span>© 2026 Pinkall</span>
        <span>Accès bêta sécurisé par Supabase</span>
      </footer>
    </div>
  );
}
