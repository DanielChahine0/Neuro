"use client";

import { motion } from "framer-motion";
import Badge from "./Badge";

export default function Hero() {
  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-6 pt-16 overflow-hidden">
      {/* Background glow */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-accent/5 rounded-full blur-[120px] pointer-events-none" />

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="relative z-10 flex flex-col items-center text-center max-w-3xl"
      >
        <Badge>NEW — Neuro 1.0 for macOS</Badge>

        <h1 className="mt-8 text-5xl sm:text-6xl lg:text-7xl font-bold tracking-tight leading-[1.1]">
          Stay focused.
          <br />
          <span className="text-muted">Get more done.</span>
        </h1>

        <p className="mt-6 text-lg text-muted max-w-xl leading-relaxed">
          Track your work sessions, detect distractions in real time, block
          apps that steal your focus, and build better habits — all from your
          menu bar.
        </p>

        <div className="mt-10 flex items-center gap-4">
          <a
            href="#"
            className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-medium transition-colors"
          >
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
              <polyline points="7 10 12 15 17 10" />
              <line x1="12" y1="15" x2="12" y2="3" />
            </svg>
            Get for Mac
          </a>
          <a
            href="#features"
            className="inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-surface border border-border hover:border-muted/40 text-sm font-medium text-muted hover:text-foreground transition-colors"
          >
            See how it works
          </a>
        </div>

        <p className="mt-4 text-xs text-muted/60">
          Requires macOS 14 or later
        </p>
      </motion.div>

      {/* Hero mockup */}
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, delay: 0.3, ease: "easeOut" }}
        className="relative z-10 mt-16 w-full max-w-4xl"
      >
        <div className="rounded-2xl border border-border bg-surface/60 backdrop-blur-sm p-1">
          <div className="rounded-xl bg-surface overflow-hidden">
            {/* Window chrome */}
            <div className="flex items-center gap-2 px-4 py-3 border-b border-border">
              <div className="w-3 h-3 rounded-full bg-[#ff5f57]" />
              <div className="w-3 h-3 rounded-full bg-[#febc2e]" />
              <div className="w-3 h-3 rounded-full bg-[#28c840]" />
              <span className="ml-3 text-xs text-muted font-mono">
                Neuro — Focus Session
              </span>
            </div>
            {/* App content mockup */}
            <div className="p-8">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-xs text-muted font-mono uppercase tracking-wider">
                    Current Session
                  </p>
                  <p className="mt-2 text-4xl font-bold font-mono tabular-nums">
                    01:34:22
                  </p>
                  <p className="mt-1 text-sm text-muted">
                    Deep work — Project Neuro
                  </p>
                </div>
                <div className="text-right">
                  <p className="text-xs text-muted font-mono uppercase tracking-wider">
                    Focus Score
                  </p>
                  <p className="mt-2 text-4xl font-bold text-accent font-mono">
                    94%
                  </p>
                  <p className="mt-1 text-sm text-emerald-400">
                    Excellent focus
                  </p>
                </div>
              </div>
              {/* Activity bar */}
              <div className="mt-8 flex gap-1">
                {Array.from({ length: 48 }).map((_, i) => (
                  <div
                    key={i}
                    className={`flex-1 h-8 rounded-sm ${
                      [7, 8, 23, 24, 25, 38].includes(i)
                        ? "bg-red-500/40"
                        : "bg-accent/30"
                    }`}
                  />
                ))}
              </div>
              <div className="mt-2 flex justify-between text-xs text-muted font-mono">
                <span>0:00</span>
                <span>0:30</span>
                <span>1:00</span>
                <span>1:30</span>
              </div>
            </div>
          </div>
        </div>
      </motion.div>
    </section>
  );
}
