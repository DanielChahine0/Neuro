# Contributing to Neuro

Thank you for your interest in contributing to Neuro. This document explains how
to get involved — whether you're fixing a bug, suggesting a feature, improving
the website, or helping with the macOS app.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [What We're Building](#what-were-building)
- [How to Report a Bug](#how-to-report-a-bug)
- [How to Suggest a Feature](#how-to-suggest-a-feature)
- [Development Setup](#development-setup)
  - [Website (Next.js)](#website-nextjs)
  - [macOS App (Swift) — coming soon](#macos-app-swift--coming-soon)
  - [Firebase Backend — coming soon](#firebase-backend--coming-soon)
- [Branch Naming](#branch-naming)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)
- [Code Style](#code-style)

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you agree to uphold it. Report unacceptable behavior to
**hello@neuro.app**.

---

## What We're Building

Neuro is a macOS menu bar app that helps people stay focused:

- **Focus Sessions** — timed deep work sessions with real-time app monitoring
- **Distraction Detection** — automatic logging of off-task app switches
- **App Blocking** — prevents blocked apps from opening during sessions
- **Focus Score** — a live percentage of focused vs. distracted time
- **Stats & Streaks** — weekly/monthly charts and streak tracking
- **Social Accountability** — see friends' sessions and send kudos

The repository currently contains:
- `website/` — Next.js 16 marketing site (active)
- macOS SwiftUI app — in development
- Firebase backend — planned

---

## How to Report a Bug

1. Search [existing issues](https://github.com/danielchahine/neuro/issues) to avoid duplicates.
2. Open a new issue using the **Bug Report** template.
3. Include: what you expected, what actually happened, steps to reproduce, and your OS/app version.

For security vulnerabilities, **do not open a public issue** — see [SECURITY.md](SECURITY.md) instead.

---

## How to Suggest a Feature

1. Check [existing issues and discussions](https://github.com/danielchahine/neuro/issues) first.
2. Open a new issue using the **Feature Request** template.
3. Describe the problem the feature solves, not just the solution.
4. For large proposals (new subsystems, major UX changes), open a discussion thread first.

---

## Development Setup

### Website (Next.js)

**Requirements:** Node.js 20+, npm 10+

```bash
# From the repo root
cd website
npm install
npm run dev       # starts dev server at http://localhost:3000
npm run build     # production build — run this before opening a PR
npm run lint      # ESLint (Next.js core-web-vitals + TypeScript)
```

**Key things to know:**
- Next.js 16 App Router — server components by default, add `"use client"` only when needed
- Tailwind CSS v4 — use design tokens from `app/globals.css`, never hardcode hex values
- Framer Motion for animations — use `whileInView`/`initial`/`animate` patterns
- Path alias `@/*` maps to the project root

### macOS App (Swift) — coming soon

Requirements and setup instructions will be added here once the Xcode project is scaffolded.
Planned stack: SwiftUI, Accessibility API, App Sandbox entitlements, Firebase SDK for Apple.

### Firebase Backend — coming soon

Requirements and setup instructions will be added here once the Firebase project is initialized.
Planned stack: Cloud Firestore, Firebase Auth (Sign in with Apple), Cloud Functions.

---

## Branch Naming

Use the following prefixes:

| Prefix | When to use |
|--------|-------------|
| `feat/` | New feature |
| `fix/` | Bug fix |
| `chore/` | Tooling, dependencies, config |
| `docs/` | Documentation only |
| `refactor/` | Code restructuring without behavior change |
| `style/` | Visual/design changes |

Examples: `feat/app-blocking-ui`, `fix/focus-score-calculation`, `docs/contributing`

---

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

**Types:** `feat`, `fix`, `chore`, `docs`, `refactor`, `style`, `test`, `perf`

**Scopes:** `website`, `app`, `firebase`, `ci`, `deps`

Examples:
```
feat(website): add waitlist email capture to hero section
fix(app): correct focus score calculation when session is paused
chore(deps): bump next from 16.2.0 to 16.2.1
```

Keep the subject line under 72 characters. Use the body to explain *why*, not *what*.

---

## Pull Request Process

1. Fork the repo and create a branch from `main`.
2. Make your changes. Run `npm run build` (website) to confirm no errors.
3. Fill out the PR template completely.
4. A maintainer will review within a few business days.
5. Address review feedback. PRs are merged by squash.
6. Keep PRs focused — one logical change per PR.

---

## Code Style

### TypeScript / Next.js
- TypeScript strict mode — no `any`, no type assertions without justification
- No hardcoded color values — use Tailwind design token classes (`bg-surface`, `text-muted`, `text-accent`)
- Server components by default; only add `"use client"` when browser APIs are required
- Feature mockup components live inside `FeatureSection.tsx`, not as separate files

### Swift
- Follow Swift API Design Guidelines
- SwiftUI views stay small — extract subviews when a body exceeds ~50 lines
- Use `@Observable` (Swift 5.9+) for state; avoid `ObservableObject` unless required

### General
- No dead code, commented-out blocks, or `TODO` left in PRs (file a GitHub issue instead)
- No `console.log` or `print` debug statements in merged code
