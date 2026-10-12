import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { Analytics } from "@vercel/analytics/react";
import "@fontsource-variable/onest/wght.css";
import App from "./App";
import { InvitePage } from "./components/InvitePage";
import "./styles-v2.css";
import "./styles-openship.css";

const normalizedPath = window.location.pathname.replace(/\/+$/, "") || "/";
const authHash = new URLSearchParams(window.location.hash.replace(/^#/, ""));
const hasInviteSessionAtRoot =
  normalizedPath === "/" &&
  (authHash.get("type") === "invite" ||
    authHash.has("access_token") ||
    authHash.has("refresh_token"));
const RootPage =
  normalizedPath === "/auth/invite" || hasInviteSessionAtRoot ? InvitePage : App;

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <RootPage />
    <Analytics />
  </StrictMode>,
);
