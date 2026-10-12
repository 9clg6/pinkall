# Pinkall — locked product design system

This is the visual source of truth for the iOS, Android and macOS app. Pinkall
is a professional calling workbench for founders and sales teams. It must feel
calm, precise and alive — never like an admin dashboard, a telephony demo or a
collection of Material components.

## Direction

- Genre: **modern-minimal with restrained atmospheric depth**.
- App macrostructure: **Workbench** — the current task and real data are the
  interface; marketing headlines do not belong inside the product.
- Composition reference: Amplemarket’s hierarchy and product restraint.
- Motion reference: Jeton’s anchored content with a moving environment.
- Information reference: Dovetail’s dense, evidence-led master/detail views.
- Telephony reference: Allo’s clear call semantics.

The transferable rule is: **anchor the content, animate the environment**. Do
not reproduce any reference site’s pixels, illustrations or copy.

## Product hierarchy

Every screen has one dominant object and one dominant action:

- Before a call: the number or selected prospect → **Call**.
- During a call: the person and conversation → **Hang up**.
- After a call: the next action → **Prepare follow-up**.
- In CRM: the selected prospect → **Call or update context**.

Technical details such as Telnyx, SIP, WebRTC, model names, backend state and
webhooks are diagnostics, never primary UI.

## Palette

- Paper: `#F6F5F3`.
- Raised paper: `#FBFAF8`.
- Carbon: `#171519`.
- Carbon soft: `#4A464B`.
- Muted: `#777177`.
- Rule: carbon at 8–10% opacity.
- Pinkall signal: `#D31E7D`.
- Pale rose: `#F7DCE9`.
- Spectral lilac: `#D9C9FF`, environment only.
- Warm spectral peach: `#F4C5AD`, environment only.

Pink is a signal, not a surface. Outside an active-call environment, it should
occupy less than roughly 5% of the viewport. Never use it simultaneously for
navigation, status, icon tiles and the primary action.

## Typography

Use the platform grotesque with native optical metrics. The hierarchy is
compact and operational:

- Focal value or person: 32–40 px, weight 600, tight tracking.
- Screen title: 22–26 px, weight 600.
- Control/title: 15–17 px, weight 550–600.
- Working text: 14–16 px, weight 400.
- Metadata: 11–13 px, weight 500, slightly increased tracking.
- Durations and phone numbers: tabular figures.

No marketing-size hero inside the app. Never repeat the wordmark, a rhetorical
question and the same action label on one screen.

## Structure and chrome

### macOS and wide desktop

- Use one continuous scene, not a page surrounded by a dark sidebar.
- A 52–56 px top toolbar contains the wordmark, text destinations and compact
  contextual controls. Navigation selection is an underline or tonal shift,
  never a filled tile.
- The main workspace may split into task and context panes. Separate panes with
  spacing or a fine rule, not independent floating cards.
- Reveal a prospect/context pane only when real context exists or the width can
  support it without shrinking the primary task.

### iOS and Android

- Use a compact bottom destination bar with labels and consistent 20 px line
  icons. The current action remains above it.
- Prospect details and coaching context use native sheets.
- Never collapse the desktop chrome into a blocky sidebar or hamburger panel.

## Surfaces and shape

- The page itself is the surface. Avoid a giant card wrapping the workspace.
- Long transcript and CRM regions are opaque and quiet.
- Inputs use a single stable baseline/hairline; do not wrap each field in a
  thick rounded rectangle.
- Standard controls use 8–12 px radii. Context panels use 14–18 px. Pills are
  reserved for genuinely compact status or segmented selection.
- Circular geometry is reserved for call controls and small avatars — not every
  icon or keypad key.
- Depth comes from lightness, overlap and one whisper shadow, not stacked borders
  and shadows.

## Atmospheric material

One slow, low-contrast rose/lilac/peach field may live behind the workbench.
It is a single environmental layer, not a gradient on components.

Liquid glass is limited to layers that truly float above content:

- compact navigation chrome;
- active-call control island;
- one live coaching prompt;
- modal sheets and contextual overlays.

Glass requires visible content or colour behind it. Never place translucent grey
glass over an empty white field. Never blur scrolling transcript or CRM content.

## Iconography

- One outline icon voice, 18–22 px, consistent optical weight.
- No large icon tiles in navigation.
- No mixing filled Material, outlined Material and Cupertino icons in one view.
- Prefer text labels where the icon would merely repeat the label.
- The only expressive brand gesture is the Pinkall waveform/halo.

## Motion

Use at most three motion primitives per screen:

1. state morph/crossfade;
2. anchored contextual panel entrance;
3. environmental waveform or light movement.

- Micro feedback: 100–160 ms.
- Minor state transition: 220–300 ms.
- Major call-state transition: 320–420 ms.
- Enter with emphasized ease-out; exit faster; never bounce.
- Dial → call preserves the number and turns it into the call identity.
- Call → debrief calms the waveform into a divider before content reorganises.
- Ambient movement stops when the window is inactive.
- Reduced motion uses opacity-only transitions of at most 150 ms.

## Screen rules

### Dialer

- No in-product hero headline and no wrapping outer card.
- The number is the focal object. The keypad is visually quiet and borderless;
  keyboard entry is equally first-class on macOS.
- Show one call action. Status is a small point plus text, not a large capsule.
- Real prospect context sits adjacent on wide layouts and in a sheet on mobile.

### Active call

- Immersive carbon scene with one restrained spectral light source.
- Identity and duration lead; waveform supports them.
- Transcript remains readable and stable. The coach shows one recommendation,
  not a chatbot or score dashboard.
- Mute, audio route and keypad are neutral. Hang-up is unmistakable.

### Debrief

- Editorial reading order: next action, concise summary, evidence, follow-up,
  one improvement for the next call.
- No score grid or equal-weight cards.

### CRM

- Continuous master/detail workspace with fine separators.
- Dense but calm rows: identity, company, stage/market, last interaction and
  next action when real data exists.
- Pink only marks the selected prospect or primary action.
- On mobile, use a list and a native detail sheet.

## Forbidden patterns

- Permanent dark navigation sidebar.
- Filled pink navigation tiles or oversized active indicators.
- Giant rounded card containing bordered controls and circular keypad buttons.
- Card-in-card layouts, uniform 24–28 px radii and stacked shadows.
- Marketing copy inside an operational screen.
- Multiple status pills competing with the primary action.
- Decorative glass over blank paper.
- Mixed icon families or an icon inside a coloured tile for every feature.
- Infinite decorative animation, hover-scale on every surface or elastic easing.
- Fake contacts, fake transcripts, invented metrics or simulated call data.

## Content rules

- Speak in the user’s language: call, prospect, notes, advice, follow-up.
- Prefer short, specific labels and one primary action per view.
- Never show POC/debug copy in the product surface.
- Never claim that a transcript, suggestion or contact exists before the backend
  returns it.
