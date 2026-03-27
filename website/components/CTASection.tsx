"use client";

import { motion } from "framer-motion";

export default function CTASection() {
  return (
    <section className="relative py-32 px-6">
      <div className="border-t border-border" />

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-100px" }}
        transition={{ duration: 0.5 }}
        className="max-w-2xl mx-auto text-center pt-24"
      >
        <h2 className="text-3xl sm:text-4xl font-bold tracking-tight">
          Ready to take back your focus?
        </h2>

        <p className="mt-5 text-muted text-lg max-w-md mx-auto">
          Download Neuro and start your first session in under a minute.
        </p>

        <div className="mt-10">
          <a
            href="#"
            className="inline-flex items-center gap-2 px-8 py-4 rounded-xl bg-accent text-white text-sm font-medium hover:bg-accent-hover transition-colors"
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
            Download for Mac
          </a>
        </div>

        <p className="mt-5 text-xs text-muted/50">
          Free during beta &middot; No credit card required
        </p>
      </motion.div>
    </section>
  );
}
