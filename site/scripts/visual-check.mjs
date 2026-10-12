import { mkdir } from "node:fs/promises";
import { chromium } from "playwright";

const baseUrl = process.env.LANDING_URL ?? "http://127.0.0.1:5173";
const outputDir = new URL("../artifacts/", import.meta.url);

await mkdir(outputDir, { recursive: true });

const browser = await chromium.launch({ headless: true });
const results = [];

for (const scenario of [
  { name: "desktop-light", width: 1440, height: 900, colorScheme: "light" },
  { name: "mobile-light", width: 390, height: 844, colorScheme: "light" },
  { name: "desktop-dark", width: 1440, height: 900, colorScheme: "dark" },
]) {
  const context = await browser.newContext({
    viewport: { width: scenario.width, height: scenario.height },
    colorScheme: scenario.colorScheme,
    reducedMotion: "no-preference",
  });
  const page = await context.newPage();
  const errors = [];

  // Keep visual regression runs deterministic and avoid creating real
  // Formspree waitlist entries with fixture addresses.
  await page.route("https://formspree.io/f/mlgqrqpo", (route) =>
    route.fulfill({
      status: 200,
      contentType: "application/json",
      body: JSON.stringify({ next: "/" }),
    }),
  );

  page.on("console", (message) => {
    if (message.type() === "error") errors.push(`console: ${message.text()}`);
  });
  page.on("pageerror", (error) => errors.push(`page: ${error.message}`));

  await page.goto(baseUrl, { waitUntil: "networkidle" });
  await page.waitForTimeout(1200);
  await page.screenshot({ path: new URL(`${scenario.name}-viewport.png`, outputDir).pathname, fullPage: false });

  const motionSampleA = await page.evaluate(() =>
    [".call-window", ".phone-shell", ".advice-card", ".liquid-flow-back"].map(
      (selector) => getComputedStyle(document.querySelector(selector)).transform,
    ),
  );
  await page.waitForTimeout(420);
  const motionSampleB = await page.evaluate(() =>
    [".call-window", ".phone-shell", ".advice-card", ".liquid-flow-back"].map(
      (selector) => getComputedStyle(document.querySelector(selector)).transform,
    ),
  );
  const motionTransformsChanged = motionSampleA.some((value, index) => value !== motionSampleB[index]);

  for (const selector of [".flow-rail", ".coaching-sequence", ".source-list"]) {
    await page.locator(selector).scrollIntoViewIfNeeded();
    await page.waitForTimeout(850);
  }

  await page.locator(".coaching-sequence").scrollIntoViewIfNeeded();
  await page.waitForTimeout(500);
  await page.evaluate(() => document.activeElement?.blur?.());
  const coachingBox = await page.locator(".coaching-sequence").boundingBox();
  if (coachingBox) {
    await page.screenshot({
      path: new URL(`${scenario.name}-coaching.png`, outputDir).pathname,
      clip: coachingBox,
    });
  }
  await page.screenshot({ path: new URL(`${scenario.name}.png`, outputDir).pathname, fullPage: true });

  const metrics = await page.evaluate(() => {
    const h1 = document.querySelector("h1");
    const h1Style = h1 ? getComputedStyle(h1) : null;
    const h1Lines = h1 && h1Style ? Math.round(h1.getBoundingClientRect().height / Number.parseFloat(h1Style.lineHeight)) : 0;
    const buttons = Array.from(document.querySelectorAll("button"));
    const wrappedButtons = buttons
      .filter((button) => button.scrollHeight > button.clientHeight + 2)
      .map((button) => button.textContent?.trim());
    const ids = Array.from(document.querySelectorAll("[id]"), (element) => element.id);
    const duplicateIds = ids.filter((id, index) => ids.indexOf(id) !== index);

    return {
      viewportWidth: window.innerWidth,
      scrollWidth: document.documentElement.scrollWidth,
      horizontalOverflow: document.documentElement.scrollWidth > window.innerWidth + 1,
      h1Lines,
      navHeight: document.querySelector(".site-header")?.getBoundingClientRect().height ?? 0,
      buttonCount: buttons.length,
      wrappedButtons,
      duplicateIds,
      unlabeledInputs: Array.from(document.querySelectorAll("input")).filter((field) => {
        const id = field.getAttribute("id");
        return !id || !document.querySelector(`label[for="${id}"]`);
      }).length,
      unnamedButtons: buttons.filter((button) => !button.textContent?.trim() && !button.getAttribute("aria-label")).length,
      activeAnimations: document.getAnimations().filter((animation) => animation.playState === "running").length,
      macOSMentions: (document.body.textContent?.match(/macOS/g) ?? []).length,
      revealCount: document.querySelectorAll("[data-reveal].is-visible").length,
    };
  });

  const interactionChecks = {};

  if (scenario.name === "desktop-light") {
    await page.locator("#waitlist-email").fill("camille@example.com");
    await page.locator("#waitlist").getByRole("button", { name: "Rejoindre la waitlist" }).click();
    await page.locator("#waitlist.waitlist-success").waitFor({ state: "visible" });
    interactionChecks.waitlistSuccess = await page.getByText("Tu es sur la liste.").isVisible();

    await page.locator("#waitlist-bottom").getByRole("button", { name: "Rejoindre la waitlist" }).click();
    interactionChecks.inlineErrorVisible = await page.getByText("Entre ton email.").isVisible();
    interactionChecks.errorFocusReturned = await page.evaluate(
      () => document.activeElement?.id === "waitlist-bottom-email",
    );
  }

  results.push({ scenario: scenario.name, errors, motionTransformsChanged, ...metrics, ...interactionChecks });
  await context.close();
}

const reducedContext = await browser.newContext({
  viewport: { width: 1440, height: 900 },
  colorScheme: "light",
  reducedMotion: "reduce",
});
const reducedPage = await reducedContext.newPage();
await reducedPage.goto(baseUrl, { waitUntil: "networkidle" });
const reducedMotion = await reducedPage.evaluate(() => ({
  scrollBehavior: getComputedStyle(document.documentElement).scrollBehavior,
  activeAnimationCount: document.getAnimations().length,
}));
results.push({ scenario: "reduced-motion", ...reducedMotion });
await reducedContext.close();

await browser.close();
process.stdout.write(`${JSON.stringify(results, null, 2)}\n`);
