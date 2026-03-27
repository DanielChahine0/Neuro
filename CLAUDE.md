# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Neuro is a macOS productivity app for focus tracking, distraction detection, app blocking, and social accountability. This repo contains:
- `website/` — Next.js marketing site (currently the only active codebase)
- macOS app (SwiftUI) and Firebase backend are planned but not yet started

## Commands

All commands run from the `website/` directory:

```bash
npm run dev      # Start dev server on localhost:3000
npm run build    # Production build (use to verify no errors)
npm run lint     # ESLint with Next.js core-web-vitals + TypeScript rules
```

No test framework is configured yet.

## Architecture

### Website (`website/`)

**Next.js 16 (App Router)** with TypeScript strict mode, Tailwind CSS v4, and Framer Motion.

> **Important:** Next.js 16 has breaking API changes. Read `node_modules/next/dist/docs/` before using unfamiliar Next.js APIs.

**Key patterns:**
- **Server components by default.** Only add `"use client"` when the component needs browser APIs (scroll listeners, animations, state).
- **Framer Motion** for scroll-triggered entrance animations (`whileInView`, `initial`/`animate`).
- **CSS variables for theming** defined in `app/globals.css` using `@theme inline` — colors are referenced via Tailwind classes like `bg-surface`, `text-muted`, `text-accent`. Don't use hardcoded hex values; use the design tokens.
- **Path alias:** `@/*` maps to the project root (e.g., `@/components/Navbar`).

**Design tokens** (defined in `app/globals.css`):
- Background: `#0a0a0a`, Surface: `#141414`, Border: `#1f1f1f`
- Text: `#fafafa` (primary), `#888888` (muted)
- Accent: `#6366f1` (indigo)
- Fonts: Geist Sans (`--font-sans`), Geist Mono (`--font-mono`)

**Component convention:** Feature mockups (the fake app UI shown on the marketing site) are defined as local components within `FeatureSection.tsx`, not as separate files.
