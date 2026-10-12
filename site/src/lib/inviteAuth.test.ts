import { describe, expect, it } from "vitest";
import {
  getInviteAuthFlow,
  getInviteUrlError,
  validateInvitePassword,
} from "./inviteAuth";

describe("getInviteAuthFlow", () => {
  it("detects an implicit callback from its access token fragment", () => {
    expect(
      getInviteAuthFlow({
        hash: "#access_token=public-session-token&type=invite",
        search: "",
      }),
    ).toBe("implicit");
  });

  it("detects a PKCE callback from its authorization code", () => {
    expect(
      getInviteAuthFlow({
        hash: "",
        search: "?code=authorization-code",
      }),
    ).toBe("pkce");
  });

  it("uses PKCE as the safe default outside a callback", () => {
    expect(getInviteAuthFlow({ hash: "", search: "" })).toBe("pkce");
  });
});

describe("getInviteUrlError", () => {
  it("reads and decodes a provider error from the callback URL", () => {
    expect(
      getInviteUrlError({
        hash: "#error=access_denied&error_description=Invite%20link%20expired",
        search: "",
      }),
    ).toBe("Invite link expired");
  });
});

describe("validateInvitePassword", () => {
  it("requires at least eight characters", () => {
    expect(validateInvitePassword("short", "short")).toEqual({
      valid: false,
      message: "Choisis un mot de passe d’au moins 8 caractères.",
    });
  });

  it("requires matching values", () => {
    expect(validateInvitePassword("long-enough", "different")).toEqual({
      valid: false,
      message: "Les deux mots de passe ne correspondent pas.",
    });
  });

  it("accepts a matching password of eight characters or more", () => {
    expect(validateInvitePassword("pinkall!", "pinkall!")).toEqual({ valid: true });
  });
});
