import { useForm } from "@formspree/react";
import { FormEvent, useEffect, useRef, useState } from "react";
import { CheckCircle } from "@phosphor-icons/react";
import { track } from "../lib/analytics";

type WaitlistSubmission = {
  email: string;
  intent: string;
  source: string;
  submittedAt: string;
  _subject: string;
};

interface WaitlistEmailFormProps {
  idPrefix: string;
  source: "hero" | "footer";
}

export function WaitlistEmailForm({ idPrefix, source }: WaitlistEmailFormProps) {
  const [formspreeState, submitToFormspree, resetFormspree] =
    useForm<WaitlistSubmission>("mlgqrqpo");
  const [validationError, setValidationError] = useState("");
  const hasStarted = useRef(false);
  const hasTrackedSuccess = useRef(false);
  const inputRef = useRef<HTMLInputElement>(null);
  const inputId = `${idPrefix}-email`;
  const hasServerError = formspreeState.errors !== null;
  const errorMessage = validationError ||
    (hasServerError
      ? "L’inscription n’a pas pu être transmise. Vérifie ton email et réessaie."
      : "");

  useEffect(() => {
    if (!formspreeState.succeeded || hasTrackedSuccess.current) return;
    hasTrackedSuccess.current = true;
    track("waitlist_submitted", { source });
  }, [formspreeState.succeeded, source]);

  useEffect(() => {
    if (!hasServerError) return;
    track("waitlist_error", { source });
  }, [hasServerError, source]);

  const showError = (errorMessage: string) => {
    setValidationError(errorMessage);
    inputRef.current?.focus();
  };

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    const email = inputRef.current?.value.trim() ?? "";

    if (!email) {
      showError("Entre ton email.");
      track("waitlist_validation_error", { source, reason: "empty" });
      return;
    }

    if (!inputRef.current?.checkValidity()) {
      showError("Entre un email valide, par exemple toi@startup.com.");
      track("waitlist_validation_error", { source, reason: "invalid_email" });
      return;
    }

    const payload = {
      email,
      intent: "waitlist",
      source: `${source}_waitlist_v3`,
      submittedAt: new Date().toISOString(),
      _subject: "Nouvelle inscription à la waitlist Pinkall",
    };

    setValidationError("");
    hasTrackedSuccess.current = false;
    await submitToFormspree(payload);
  };

  if (formspreeState.succeeded) {
    return (
      <div className="waitlist-success" id={idPrefix} role="status">
        <CheckCircle aria-hidden="true" />
        <div>
          <strong>Tu es sur la liste.</strong>
          <span>Nous t’écrirons quand les premiers appels pourront être testés.</span>
        </div>
      </div>
    );
  }

  return (
    <form className="waitlist-form" id={idPrefix} onSubmit={handleSubmit} noValidate>
      <label htmlFor={inputId}>Ton email</label>
      <div className="waitlist-row">
        <input
          ref={inputRef}
          id={inputId}
          name="email"
          type="email"
          autoComplete="email"
          inputMode="email"
          placeholder="toi@startup.com"
          required
          aria-describedby={`${idPrefix}-help${errorMessage ? ` ${idPrefix}-error` : ""}`}
          aria-invalid={Boolean(errorMessage)}
          onChange={() => {
            if (validationError) setValidationError("");
            if (hasServerError) resetFormspree();
          }}
          onFocus={() => {
            if (hasStarted.current) return;
            hasStarted.current = true;
            track("waitlist_started", { source });
          }}
        />
        <button
          className="button button-primary"
          type="submit"
          disabled={formspreeState.submitting}
        >
          {formspreeState.submitting ? "Inscription en cours" : "Rejoindre la waitlist"}
        </button>
      </div>
      <p className="waitlist-help" id={`${idPrefix}-help`}>
        Bêta privée. Aucun paiement. Ton email servira uniquement à t’inviter aux
        premiers tests.
      </p>
      {errorMessage ? (
        <p className="waitlist-error" id={`${idPrefix}-error`} role="alert">
          {errorMessage}
        </p>
      ) : null}
    </form>
  );
}
