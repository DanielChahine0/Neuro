"use client";

import { motion } from "framer-motion";

export default function CTASection() {
  return (
    <section className="py-32 px-6">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-100px" }}
        transition={{ duration: 0.5 }}
        className="max-w-2xl mx-auto text-center"
      >
        <h2 className="text-3xl sm:text-4xl font-bold tracking-tight">
          Ready to take back your focus?
        </h2>
        <p className="mt-4 text-muted text-lg">
          Download Neuro and start your first session in under a minute.
        </p>
        <a
          href="#"
          className="mt-8 inline-flex items-center gap-2 px-8 py-3.5 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-medium transition-colors"
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
        <p className="mt-3 text-xs text-muted/60">Free during beta</p>
      </motion.div>
    </section>
  );
}
