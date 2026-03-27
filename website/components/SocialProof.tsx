"use client";

import { useEffect, useRef, useState } from "react";
import { motion, useInView, animate } from "framer-motion";

function Counter({
  value,
  suffix = "",
  prefix = "",
}: {
  value: number;
  suffix?: string;
  prefix?: string;
}) {
  const [display, setDisplay] = useState(0);
  const ref = useRef(null);
  const inView = useInView(ref, { once: true });

  useEffect(() => {
    if (inView) {
      const controls = animate(0, value, {
        duration: 2,
        ease: [0.16, 1, 0.3, 1],
        onUpdate: (v) => setDisplay(Math.round(v)),
      });
      return () => controls.stop();
    }
  }, [inView, value]);

  return (
    <span ref={ref} className="tabular-nums">
      {prefix}
      {display.toLocaleString()}
      {suffix}
    </span>
  );
}

const stats = [
  { value: 50000, suffix: "+", label: "Sessions tracked" },
  { value: 12000, suffix: "+", label: "Hours of deep work" },
  { value: 92, suffix: "%", label: "Avg focus score" },
  { value: 4200, suffix: "+", label: "Active users" },
];

const testimonials = [
  {
    quote:
      "Neuro completely changed how I work. I went from 2 hours of focused work to consistently hitting 6+ hours daily.",
    name: "Alex Chen",
    role: "Software Engineer",
    initials: "AC",
  },
  {
    quote:
      "The social accountability feature keeps my whole team honest. We've seen a 40% increase in deep work hours since adopting Neuro.",
    name: "Sarah Kim",
    role: "Product Lead",
    initials: "SK",
  },
  {
    quote:
      "Finally, an app that actually helps you focus instead of just tracking time. The distraction detection is like having a coach.",
    name: "Marcus Rivera",
    role: "Designer",
    initials: "MR",
  },
];

export default function SocialProof() {
  return (
    <section className="relative py-32 px-6 overflow-hidden">
      {/* Decorative top line */}
      <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-border to-transparent" />

      <div className="max-w-6xl mx-auto">
        {/* Stats */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.6 }}
          className="grid grid-cols-2 md:grid-cols-4 gap-8 md:gap-4 mb-24"
        >
          {stats.map((stat, i) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.1, duration: 0.5 }}
              className="text-center"
            >
              <p className="text-3xl sm:text-4xl font-bold font-mono">
                <Counter value={stat.value} suffix={stat.suffix} />
              </p>
              <p className="mt-2 text-sm text-muted">{stat.label}</p>
            </motion.div>
          ))}
        </motion.div>

        {/* Testimonials */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.5 }}
          className="text-center mb-12"
        >
          <p className="text-xs text-accent font-mono uppercase tracking-widest mb-3">
            Testimonials
          </p>
          <h2 className="text-3xl sm:text-4xl font-bold tracking-tight">
            Loved by people who{" "}
            <span className="font-display italic font-normal text-muted">
              get things done
            </span>
          </h2>
        </motion.div>

        <div className="grid md:grid-cols-3 gap-6">
          {testimonials.map((t, i) => (
            <motion.div
              key={t.name}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.1 + 0.2, duration: 0.5 }}
              className="group relative p-6 rounded-2xl bg-surface border border-border hover:border-border-hover transition-all duration-300 hover:shadow-[0_8px_32px_rgba(0,0,0,0.4)]"
            >
              {/* Hover glow */}
              <div className="absolute -inset-px rounded-2xl bg-gradient-to-b from-accent/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none" />

              <div className="relative">
                {/* Quote mark */}
                <svg
                  width="24"
                  height="24"
                  viewBox="0 0 24 24"
                  fill="none"
                  className="text-accent/30 mb-4"
                >
                  <path
                    d="M11 7.5H6.5C5.67 7.5 5 8.17 5 9v3.5c0 .83.67 1.5 1.5 1.5H9l-1 3h2.5l1-3c.33-1 .5-1.67.5-2V9c0-.83-.67-1.5-1.5-1.5H11zm8 0h-4.5c-.83 0-1.5.67-1.5 1.5v3.5c0 .83.67 1.5 1.5 1.5H17l-1 3h2.5l1-3c.33-1 .5-1.67.5-2V9c0-.83-.67-1.5-1.5-1.5H19z"
                    fill="currentColor"
                  />
                </svg>

                <p className="text-sm text-muted leading-relaxed mb-6">
                  {t.quote}
                </p>

                <div className="flex items-center gap-3">
                  <div className="w-9 h-9 rounded-full bg-accent/10 border border-accent/20 flex items-center justify-center text-xs font-bold text-accent">
                    {t.initials}
                  </div>
                  <div>
                    <p className="text-sm font-medium">{t.name}</p>
                    <p className="text-xs text-muted">{t.role}</p>
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
