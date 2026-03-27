"use client";

import { motion } from "framer-motion";
import { useEffect, useState } from "react";
import Badge from "./Badge";

function AnimatedTimer() {
  const [seconds, setSeconds] = useState(5662); // starts at ~01:34:22

  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds((s) => s + 1);
    }, 1000);
    return () => clearInterval(interval);
  }, []);

  const h = Math.floor(seconds / 3600).toString().padStart(2, "0");
  const m = Math.floor((seconds % 3600) / 60).toString().padStart(2, "0");
  const s = (seconds % 60).toString().padStart(2, "0");

  return (
    <>
      {h}:{m}:{s}
    </>
  );
}

const activityBars = [
  20, 26, 31, 29, 23, 17, 16, 20, 26, 31, 29, 23, 17, 16, 20, 26, 31, 29, 23,
  17, 16, 20, 26, 31, 29, 23, 17, 16, 20, 26, 31, 29, 23, 17, 16, 20, 26, 31,
  29, 23, 17, 16, 20, 26, 31, 29, 23, 17,
];
const distractedSet = new Set([7, 8, 23, 24, 25, 38]);

export default function Hero() {
  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-6 pt-16 overflow-hidden">
      {/* Atmospheric background */}
      <div className="absolute inset-0 pointer-events-none" aria-hidden>
        {/* Primary glow */}
        <div
          className="absolute top-[35%] left-1/2 -translate-x-1/2 -translate-y-1/2 w-[900px] h-[560px] rounded-full"
          style={{
            background:
              "radial-gradient(ellipse at center, rgba(99,102,241,0.07) 0%, transparent 65%)",
            animation: "glow-breathe 5s ease-in-out infinite",
          }}
        />
        {/* Secondary bottom glow */}
        <div
          className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[600px] h-[320px]"
          style={{
            background:
              "radial-gradient(ellipse at bottom, rgba(99,102,241,0.05) 0%, transparent 60%)",
          }}
        />
        {/* Dot grid */}
        <div
          className="absolute inset-0 opacity-[0.03]"
          style={{
            backgroundImage:
              "radial-gradient(circle, rgba(255,255,255,0.8) 1px, transparent 1px)",
            backgroundSize: "36px 36px",
          }}
        />
      </div>

      {/* Text content */}
      <div className="relative z-10 flex flex-col items-center text-center max-w-3xl">
        <motion.div
          initial={{ opacity: 0, y: 14 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
        >
          <Badge>Coming soon for macOS</Badge>
        </motion.div>

        <motion.h1
          initial={{ opacity: 0, y: 24 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.1, ease: [0.16, 1, 0.3, 1] }}
          className="mt-8 text-5xl sm:text-6xl lg:text-7xl font-bold tracking-tight leading-[1.06]"
        >
          Stay focused.
          <br />
          <span className="font-display italic font-normal text-muted">
            Build better habits.
          </span>
        </motion.h1>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.2, ease: [0.16, 1, 0.3, 1] }}
          className="mt-6 text-lg text-muted max-w-[420px] leading-relaxed"
        >
          Track your work sessions, detect distractions in real time, and block
          the apps that pull you off task. Lives in your menu bar.
        </motion.p>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.3, ease: [0.16, 1, 0.3, 1] }}
          className="mt-10 flex flex-col sm:flex-row items-center gap-3"
        >
          <a
            href="#"
            className="inline-flex items-center gap-2 px-7 py-3.5 rounded-xl bg-accent text-white text-sm font-medium hover:bg-accent-hover transition-all duration-200 hover:shadow-[0_0_28px_rgba(99,102,241,0.45)] hover:-translate-y-px"
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
            className="group inline-flex items-center gap-2 px-7 py-3.5 rounded-xl border border-border hover:border-border-hover text-sm font-medium text-muted hover:text-foreground transition-all duration-200"
          >
            See how it works
            <svg
              className="transition-transform duration-200 group-hover:translate-x-0.5"
              width="14"
              height="14"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </a>
        </motion.div>

        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.45 }}
          className="mt-5 text-xs text-muted/40 tracking-wide"
        >
          Free during beta &middot; Requires macOS 14+
        </motion.p>
      </div>

      {/* Hero mockup */}
      <motion.div
        initial={{ opacity: 0, y: 50 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1, delay: 0.35, ease: [0.16, 1, 0.3, 1] }}
        className="relative z-10 mt-16 w-full max-w-4xl"
      >
        {/* Ambient glow behind mockup */}
        <div
          className="absolute -inset-8 -z-10 rounded-full pointer-events-none"
          style={{
            background:
              "radial-gradient(ellipse at 50% 55%, rgba(99,102,241,0.1) 0%, transparent 55%)",
            animation: "glow-breathe 4s ease-in-out infinite 1s",
          }}
        />

        {/* Floating stat: streak */}
        <motion.div
          initial={{ opacity: 0, x: -14 }}
          animate={{
            opacity: 1,
            x: 0,
            y: [0, -7, 0],
          }}
          transition={{
            opacity: { delay: 1.1, duration: 0.5 },
            x: { delay: 1.1, duration: 0.5, ease: [0.16, 1, 0.3, 1] },
            y: {
              delay: 1.6,
              duration: 5,
              repeat: Infinity,
              ease: "easeInOut",
            },
          }}
          className="absolute hidden lg:flex -left-4 xl:-left-20 top-8 items-center gap-2.5 px-3.5 py-2.5 rounded-xl bg-surface border border-border shadow-[0_8px_32px_rgba(0,0,0,0.6)] z-20"
        >
          <div className="w-8 h-8 rounded-lg bg-orange-500/10 flex items-center justify-center flex-shrink-0">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none">
              <path
                d="M12 2c-2.5 4-4 6-4 9a4 4 0 1 0 8 0c0-3-1.5-5-4-9z"
                fill="#f97316"
              />
            </svg>
          </div>
          <div>
            <p className="text-xs font-semibold text-orange-400 leading-none">
              12 day streak
            </p>
            <p className="text-[10px] text-muted mt-0.5">Keep it going!</p>
          </div>
        </motion.div>

        {/* Floating stat: apps blocked */}
        <motion.div
          initial={{ opacity: 0, x: 14 }}
          animate={{
            opacity: 1,
            x: 0,
            y: [0, -6, 0],
          }}
          transition={{
            opacity: { delay: 1.3, duration: 0.5 },
            x: { delay: 1.3, duration: 0.5, ease: [0.16, 1, 0.3, 1] },
            y: {
              delay: 1.9,
              duration: 6,
              repeat: Infinity,
              ease: "easeInOut",
            },
          }}
          className="absolute hidden lg:flex -right-4 xl:-right-20 top-20 items-center gap-2.5 px-3.5 py-2.5 rounded-xl bg-surface border border-border shadow-[0_8px_32px_rgba(0,0,0,0.6)] z-20"
        >
          <div className="w-8 h-8 rounded-lg bg-red-500/10 flex items-center justify-center flex-shrink-0">
            <svg
              width="14"
              height="14"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#f87171"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <circle cx="12" cy="12" r="9" />
              <line x1="5.2" y1="5.2" x2="18.8" y2="18.8" />
            </svg>
          </div>
          <div>
            <p className="text-xs font-semibold text-red-400 leading-none">
              4 apps blocked
            </p>
            <p className="text-[10px] text-muted mt-0.5">During session</p>
          </div>
        </motion.div>

        {/* Main window mockup */}
        <div className="rounded-2xl border border-border/60 bg-surface overflow-hidden shadow-[0_32px_80px_rgba(0,0,0,0.7),0_0_0_1px_rgba(255,255,255,0.03)]">
          {/* Window chrome */}
          <div className="flex items-center gap-2 px-4 py-3 border-b border-border bg-surface-raised">
            <div className="w-3 h-3 rounded-full bg-[#ff5f57]" />
            <div className="w-3 h-3 rounded-full bg-[#febc2e]" />
            <div className="w-3 h-3 rounded-full bg-[#28c840]" />
            <span className="ml-3 text-xs text-muted/60 font-mono flex-1">
              Neuro — Focus Session
            </span>
            <span className="flex items-center gap-1.5 text-[10px] text-emerald-400 font-mono tracking-widest uppercase">
              <motion.span
                animate={{ opacity: [1, 0.15, 1] }}
                transition={{
                  repeat: Infinity,
                  duration: 2,
                  ease: "easeInOut",
                }}
                className="w-1.5 h-1.5 rounded-full bg-emerald-400 inline-block"
              />
              Live
            </span>
          </div>

          {/* App content */}
          <div className="p-8">
            <div className="flex items-start justify-between">
              <div>
                <p className="text-xs text-muted font-mono uppercase tracking-widest">
                  Current Session
                </p>
                <p className="mt-2 text-4xl font-bold font-mono tabular-nums tracking-tight">
                  <AnimatedTimer />
                </p>
                <p className="mt-1.5 text-sm text-muted">
                  Deep work — Project Neuro
                </p>
              </div>
              <div className="text-right">
                <p className="text-xs text-muted font-mono uppercase tracking-widest">
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

            {/* Activity bars */}
            <div className="mt-8 flex items-end gap-[3px]">
              {activityBars.map((h, i) => (
                <div
                  key={i}
                  className={`flex-1 rounded-[2px] ${
                    distractedSet.has(i) ? "bg-red-500/35" : "bg-accent/25"
                  }`}
                  style={{ height: `${h}px` }}
                />
              ))}
            </div>
            <div className="mt-2 flex justify-between text-[10px] text-muted/40 font-mono">
              <span>0:00</span>
              <span>0:30</span>
              <span>1:00</span>
              <span>1:30</span>
            </div>
          </div>
        </div>

        {/* Bottom fade */}
        <div className="absolute bottom-0 left-0 right-0 h-28 bg-gradient-to-t from-background to-transparent pointer-events-none" />
      </motion.div>
    </section>
  );
}
