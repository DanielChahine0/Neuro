"use client";

import { motion } from "framer-motion";
import Badge from "./Badge";

export default function Hero() {
  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-6 pt-16">
      <div className="relative z-10 flex flex-col items-center text-center max-w-3xl">
        <Badge>Coming soon for macOS</Badge>

        <h1 className="mt-8 text-5xl sm:text-6xl lg:text-7xl font-bold tracking-tight leading-[1.08]">
          Stay focused.
          <br />
          <span className="text-muted">Build better habits.</span>
        </h1>

        <p className="mt-6 text-lg text-muted max-w-lg leading-relaxed">
          Track your work sessions, detect distractions in real time, and block
          the apps that pull you off task. Lives in your menu bar.
        </p>

        <div className="mt-10 flex flex-col sm:flex-row items-center gap-4">
          <a
            href="#"
            className="inline-flex items-center gap-2 px-7 py-3.5 rounded-xl bg-accent text-white text-sm font-medium hover:bg-accent-hover transition-colors"
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
            Download for Mac
          </a>
          <a
            href="#features"
            className="inline-flex items-center gap-2 px-7 py-3.5 rounded-xl border border-border hover:border-border-hover text-sm font-medium text-muted hover:text-foreground transition-colors"
          >
            See how it works
          </a>
        </div>

        <p className="mt-5 text-xs text-muted/50">
          Free during beta &middot; Requires macOS 14+
        </p>
      </div>

      {/* Hero mockup */}
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8, delay: 0.2, ease: [0.16, 1, 0.3, 1] }}
        className="relative z-10 mt-16 w-full max-w-4xl"
      >
        <div className="rounded-2xl border border-border bg-surface p-1">
          <div className="rounded-xl bg-surface overflow-hidden">
            {/* Window chrome */}
            <div className="flex items-center gap-2 px-4 py-3 border-b border-border">
              <div className="w-3 h-3 rounded-full bg-[#ff5f57]" />
              <div className="w-3 h-3 rounded-full bg-[#febc2e]" />
              <div className="w-3 h-3 rounded-full bg-[#28c840]" />
              <span className="ml-3 text-xs text-muted/60 font-mono">
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
                  <p className="mt-1.5 text-sm text-muted">
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
                  <p className="mt-1.5 text-sm text-emerald-400 flex items-center gap-1.5 justify-end">
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400" />
                    Excellent focus
                  </p>
                </div>
              </div>
              {/* Activity bar */}
              <div className="mt-8 flex gap-0.75">
                {[20,26,31,29,23,17,16,20,26,31,29,23,17,16,20,26,31,29,23,17,16,20,26,31,29,23,17,16,20,26,31,29,23,17,16,20,26,31,29,23,17,16,20,26,31,29,23,17].map((h, i) => (
                  <div
                    key={i}
                    className={`flex-1 rounded-xs ${
                      [7, 8, 23, 24, 25, 38].includes(i)
                        ? "bg-red-500/40"
                        : "bg-accent/30"
                    }`}
                    style={{ height: `${h}px` }}
                  />
                ))}
              </div>
              <div className="mt-2 flex justify-between text-[10px] text-muted/50 font-mono">
                <span>0:00</span>
                <span>0:30</span>
                <span>1:00</span>
                <span>1:30</span>
              </div>
            </div>
          </div>
        </div>

        {/* Fade out at the bottom */}
        <div className="absolute bottom-0 left-0 right-0 h-24 bg-linear-to-t from-background to-transparent pointer-events-none" />
      </motion.div>
    </section>
  );
}
