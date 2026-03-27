"use client";

import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import Badge from "./Badge";

const stagger = {
  hidden: {},
  visible: {
    transition: { staggerChildren: 0.08, delayChildren: 0.1 },
  },
};

const fadeUp = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.6, ease: "easeOut" } },
};

export default function Hero() {
  const [mousePos, setMousePos] = useState({ x: 50, y: 50 });

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      setMousePos({
        x: (e.clientX / window.innerWidth) * 100,
        y: (e.clientY / window.innerHeight) * 100,
      });
    };
    window.addEventListener("mousemove", handler);
    return () => window.removeEventListener("mousemove", handler);
  }, []);

  return (
    <section className="relative min-h-screen flex flex-col items-center justify-center px-6 pt-16 overflow-hidden">
      {/* Mouse-reactive gradient */}
      <div
        className="absolute inset-0 pointer-events-none transition-opacity duration-1000"
        style={{
          background: `radial-gradient(800px circle at ${mousePos.x}% ${mousePos.y}%, rgba(99, 102, 241, 0.06), transparent 40%)`,
        }}
      />

      {/* Ambient orbs */}
      <div
        className="absolute w-[700px] h-[700px] rounded-full blur-[140px] pointer-events-none opacity-50"
        style={{
          top: "30%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          background: "radial-gradient(circle, rgba(99, 102, 241, 0.08), transparent 70%)",
          animation: "aurora 20s ease-in-out infinite",
        }}
      />
      <div
        className="absolute w-[400px] h-[400px] rounded-full blur-[120px] pointer-events-none"
        style={{
          top: "20%",
          right: "15%",
          background: "radial-gradient(circle, rgba(139, 92, 246, 0.04), transparent 70%)",
          animation: "aurora 15s ease-in-out infinite reverse",
        }}
      />

      {/* Dot grid */}
      <div
        className="absolute inset-0 pointer-events-none opacity-40"
        style={{
          backgroundImage:
            "radial-gradient(circle, rgba(255,255,255,0.04) 1px, transparent 1px)",
          backgroundSize: "32px 32px",
        }}
      />

      {/* Content */}
      <motion.div
        variants={stagger}
        initial="hidden"
        animate="visible"
        className="relative z-10 flex flex-col items-center text-center max-w-4xl"
      >
        <motion.div variants={fadeUp}>
          <Badge>Neuro 1.0 for macOS</Badge>
        </motion.div>

        <motion.h1
          variants={fadeUp}
          className="mt-8 text-5xl sm:text-6xl lg:text-[5rem] font-bold tracking-tight leading-[1.05]"
        >
          <span className="text-transparent bg-clip-text bg-gradient-to-b from-foreground via-foreground to-foreground/50">
            Stay focused.
          </span>
          <br />
          <span className="font-display italic text-muted font-normal">
            Build better habits.
          </span>
        </motion.h1>

        <motion.p
          variants={fadeUp}
          className="mt-6 text-lg sm:text-xl text-muted max-w-xl leading-relaxed"
        >
          Track your work sessions, detect distractions in real time, block
          apps that steal your focus, and stay accountable — all from your
          menu bar.
        </motion.p>

        <motion.div variants={fadeUp} className="mt-10 flex flex-col sm:flex-row items-center gap-4">
          <a
            href="#"
            className="group relative inline-flex items-center gap-2 px-7 py-3.5 rounded-xl bg-accent text-white text-sm font-medium transition-all duration-300 hover:scale-[1.02] active:scale-[0.98] shadow-[0_0_20px_rgba(99,102,241,0.25)] hover:shadow-[0_0_40px_rgba(99,102,241,0.4)]"
          >
            <span className="absolute inset-0 rounded-xl bg-gradient-to-b from-white/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
            <svg
              width="16"
              height="16"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
              className="relative"
            >
              <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
              <polyline points="7 10 12 15 17 10" />
              <line x1="12" y1="15" x2="12" y2="3" />
            </svg>
            <span className="relative">Download for Mac</span>
          </a>
          <a
            href="#features"
            className="inline-flex items-center gap-2 px-7 py-3.5 rounded-xl bg-surface border border-border hover:border-border-hover text-sm font-medium text-muted hover:text-foreground transition-all duration-300 hover:scale-[1.02] active:scale-[0.98]"
          >
            See how it works
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <line x1="5" y1="12" x2="19" y2="12" />
              <polyline points="12 5 19 12 12 19" />
            </svg>
          </a>
        </motion.div>

        <motion.p variants={fadeUp} className="mt-5 text-xs text-muted/50">
          Free during beta &middot; Requires macOS 14+
        </motion.p>
      </motion.div>

      {/* Hero mockup */}
      <motion.div
        initial={{ opacity: 0, y: 60, scale: 0.95 }}
        animate={{ opacity: 1, y: 0, scale: 1 }}
        transition={{ duration: 1, delay: 0.5, ease: [0.16, 1, 0.3, 1] }}
        className="relative z-10 mt-16 w-full max-w-4xl"
      >
        {/* Glow behind the card */}
        <div className="absolute -inset-4 bg-accent/5 rounded-3xl blur-2xl pointer-events-none" />

        <div className="relative rounded-2xl border border-border bg-surface/60 backdrop-blur-sm p-1 shadow-2xl shadow-black/30">
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
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
                    Excellent focus
                  </p>
                </div>
              </div>
              {/* Activity bar */}
              <div className="mt-8 flex gap-[3px]">
                {Array.from({ length: 48 }).map((_, i) => (
                  <div
                    key={i}
                    className={`flex-1 rounded-[2px] transition-colors ${
                      [7, 8, 23, 24, 25, 38].includes(i)
                        ? "bg-red-500/40"
                        : "bg-accent/30"
                    }`}
                    style={{ height: `${20 + Math.sin(i * 0.5) * 12}px` }}
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
        <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-background to-transparent pointer-events-none" />
      </motion.div>
    </section>
  );
}
