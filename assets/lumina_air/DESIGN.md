# Design System Strategy: Atmospheric Clarity

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"Atmospheric Clarity."** 

Unlike traditional "flat" or "brutalist" frameworks that rely on rigid grids and heavy borders, this system treats the interface as a living environment. It is inspired by the fluidity of air and the precision of high-end editorial layouts. We move beyond the "template" look by utilizing intentional asymmetry, varying depths of field, and dramatic typography scales. 

The goal is to create a UI that feels less like a software tool and more like a premium digital concierge—airy, intelligent, and breathable. We achieve this by prioritizing negative space and using "glass" as a functional material rather than just a decorative effect.

---

## 2. Colors & Surface Philosophy
The palette is rooted in a crisp, high-latitude white background, punctuated by deep "Google" blues and vital environmental greens.

### The "No-Line" Rule
Standard 1px borders are strictly prohibited for sectioning. Boundaries must be defined solely through background color shifts. For instance, a dashboard section should use `surface-container-low` (#f3f4f5) to sit against the main `surface` (#f8f9fa). Contrast is achieved through tone, not lines.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. Use the surface-container tiers to create nested depth:
- **Base Layer:** `surface` (#f8f9fa)
- **Sectioning:** `surface-container-low` (#f3f4f5)
- **Content Cards:** `surface-container-lowest` (#ffffff)
- **Interactive Overlays:** Glassmorphism (see below)

### The "Glass & Gradient" Rule
To elevate the "futuristic" feel, floating elements (like navigation bars or hovering data tooltips) must use glassmorphism. 
- **Recipe:** Apply `surface-container-lowest` at 70% opacity with a `backdrop-blur` of 24px–40px. 
- **Gradients:** Use subtle vertical gradients for primary actions, transitioning from `primary` (#0058bd) at the top to `primary_container` (#2771df) at the bottom. This adds "visual soul" and prevents the vibrant blue from feeling flat.

---

## 3. Typography
We use a high-contrast pairing to balance technical precision with editorial elegance.

*   **Display & Headlines (Plus Jakarta Sans):** These are our "Statement" styles. Use `display-lg` (3.5rem) for hero stats (like Air Quality Index numbers) to create a bold, authoritative focal point. The generous x-height of Plus Jakarta Sans feels modern and friendly.
*   **Body & Labels (Manrope):** Manrope is used for all functional text. Its geometric nature ensures readability at small scales (`body-sm` at 0.75rem).
*   **Editorial Hierarchy:** Do not be afraid of "wasted" space. A single headline-lg should often sit alone in a wide margin to signal importance and allow the user's eyes to "breathe."

---

## 4. Elevation & Depth
This design system rejects traditional drop shadows in favor of **Tonal Layering** and **Ambient Light**.

*   **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` background. The subtle shift from #f3f4f5 to #ffffff creates a natural, soft lift that mimics fine paper or frosted glass.
*   **Ambient Shadows:** When a component must "float" (e.g., a primary CTA or a modal), use an extra-diffused shadow.
    *   **Blur:** 40px–60px.
    *   **Opacity:** 4%–8%.
    *   **Color:** Use a tinted version of `on-surface` (#191c1d) to mimic natural light dispersion rather than a "dirty" grey shadow.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` (#c2c6d5) at 15% opacity. Never use 100% opaque borders.

---

## 5. Components

### Cards
Cards are the primary container. 
- **Corner Radius:** Always use `xl` (3rem / 48px) for outer containers and `lg` (2rem / 32px) for inner nested cards.
- **Styling:** No dividers. Use vertical white space or a subtle shift to `surface-variant` (#e1e3e4) for internal grouping.

### Buttons
- **Primary:** Gradient-fill (Primary to Primary Container), `full` roundedness (9999px), and a subtle ambient shadow.
- **Secondary:** `surface-container-high` background with `on-primary-fixed-variant` text. No border.

### Chips & Tags
Used for air quality categories (e.g., "Good", "Moderate").
- **Success/Environmental Green:** Use `tertiary` (#0d6b24) text on `tertiary_fixed` (#9ff79f) background.
- **Shape:** `full` roundedness.

### Input Fields
- **Background:** `surface-container-highest` (#e1e3e4) with 0% border.
- **Focus State:** 2px "Ghost Border" using `primary` at 40% opacity and a subtle `surface-tint` glow.

### Custom Icons
Icons for wind, pollution, and air quality should be "Airy":
- **Weight:** 1.5pt to 2pt strokes.
- **Terminals:** Rounded (never butt or square).
- **Color:** Use `secondary` (#495e89) for standard icons and `tertiary` (#0d6b24) for positive environmental indicators.

---

## 6. Do's and Don'ts

### Do:
*   **Do** use asymmetrical layouts where content "bleeds" off the grid slightly to create a futuristic, custom feel.
*   **Do** use `display-lg` for key data points. Numbers are the stars of this show.
*   **Do** prioritize "Tonal Layering" over shadows.

### Don't:
*   **Don't** use 1px solid borders. It shatters the "Atmospheric" illusion.
*   **Don't** use pure black (#000000) for text. Always use `on-surface` (#191c1d) to maintain a premium, soft feel.
*   **Don't** crowd the edges. If a component feels "tight," double the padding. This system lives and dies by its breathing room.
*   **Don't** use standard "Material Design" blue. Stick to the signature `primary` (#0058bd) and its tiered variants to maintain brand soul.