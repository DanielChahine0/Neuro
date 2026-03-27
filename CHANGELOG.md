# Changelog

All notable changes to Neuro will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### macOS App
- Focus session start/stop from menu bar
- Real-time active app monitoring (Accessibility API)
- Distraction detection and automatic logging
- App blocking during active sessions
- Focus Score calculation (focused time / total session time)
- Session summary screen with distraction breakdown
- Weekly and monthly stats charts
- Streak tracking
- Onboarding flow and first-run setup
- App preferences pane

### Firebase Backend
- Firebase project setup and Firestore schema
- Sign in with Apple authentication
- Session and distraction data sync
- Focus Score history
- Social features: friend connections, live session presence, kudos
- Cloud Functions for push notification triggers

### Website
- Waitlist / early access email capture
- Privacy policy and terms of service pages
- Blog / changelog page
- TestFlight / download link (post-beta)

---

## [0.1.0] — 2025-Q4 — Website Launch

### Added
- Marketing website built with Next.js 16 (App Router), Tailwind CSS v4, and Framer Motion
- Hero section with tagline and early access CTA
- Feature section with interactive app UI mockups (sessions, blocking, score, stats, social)
- Social proof section
- Pricing page
- Dark-themed design system with indigo accent (#6366f1) and Geist fonts

---

[Unreleased]: https://github.com/danielchahine/neuro/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/danielchahine/neuro/releases/tag/v0.1.0
