declare global {
  interface Window {
    dataLayer?: Array<Record<string, unknown>>;
  }
}

export function track(event: string, properties: Record<string, unknown> = {}) {
  const payload = { event, ...properties };

  window.dataLayer?.push(payload);
  window.dispatchEvent(new CustomEvent("pinkall:analytics", { detail: payload }));
}
