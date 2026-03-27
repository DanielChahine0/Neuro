"use client";

import { motion } from "framer-motion";

const trustPoints = [
  {
    label: "Data stays on your Mac",
    icon: (
      <svg
        width="12"
        height="12"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
      </svg>
    ),
  },
  {
    label: "No credit card required",
    icon: (
      <svg
        width="12"
        height="12"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
      </svg>
    ),
  },
  {
    label: "Ready in 60 seconds",
    icon: (
      <svg
        width="12"
        height="12"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
      >
        <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2" />
      </svg>
    ),
  },
];

export default function CTASection() {
  return (
    <section className="relative py-32 px-6 overflow-hidden">
      {/* Decorative top line */}
      <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-border to-transparent" />

      {/* Ambient glow */}
      <div
        className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[400px] rounded-full pointer-events-none"
        style={{
          background:
            "radial-gradient(ellipse at center, rgba(99,102,241,0.09) 0%, transparent 60%)",
          animation: "glow-breathe 4.5s ease-in-out infinite",
        }}
      />

      <motion.div
        initial={{ opacity: 0, y: 24 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-80px" }}
        transition={{ duration: 0.7, ease: [0.16, 1, 0.3, 1] }}
        className="relative z-10 max-w-2xl mx-auto text-center"
      >
        <h2 className="text-4xl sm:text-5xl font-bold tracking-tight leading-[1.08]">
          Ready to take back
          <br />
          <span className="font-display italic font-normal text-muted">
            your focus?
          </span>
        </h2>

        <p className="mt-5 text-muted text-lg max-w-sm mx-auto leading-relaxed">
          Download Neuro and start your first session in under a minute.
        </p>

        <div className="mt-10">
          <a
            href="#"
            className="inline-flex items-center gap-2.5 px-9 py-4 rounded-xl bg-accent text-white text-sm font-medium hover:bg-accent-hover transition-all duration-200 hover:shadow-[0_0_36px_rgba(99,102,241,0.5)] hover:-translate-y-px"
          >
            <svg
              width="18"
              height="18"
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
            Download for Mac — It&apos;s Free
          </a>
        </div>

        <div className="mt-8 flex items-center justify-center gap-6 flex-wrap">
          {trustPoints.map((point) => (
            <span
              key={point.label}
              className="flex items-center gap-1.5 text-xs text-muted/45"
            >
              {point.icon}
              {point.label}
            </span>
          ))}
        </div>
      </motion.div>
    </section>
  );
}
