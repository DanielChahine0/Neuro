"use client";

import { motion } from "framer-motion";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";

const plans = [
  {
    name: "Free",
    price: "$0",
    period: "forever",
    description: "Perfect for trying Neuro out.",
    features: [
      "1 focus session at a time",
      "Basic distraction detection",
      "Daily focus score",
      "7-day history",
    ],
    cta: "Download Free",
    highlighted: false,
  },
  {
    name: "Pro",
    price: "$8",
    period: "/month",
    description: "For individuals serious about productivity.",
    features: [
      "Unlimited focus sessions",
      "Advanced distraction detection",
      "App & website blocking",
      "Detailed focus score & analytics",
      "Unlimited history & trends",
      "Streak tracking",
      "Priority support",
    ],
    cta: "Start Free Trial",
    highlighted: true,
  },
  {
    name: "Team",
    price: "$6",
    period: "/user/mo",
    description: "Social accountability for your whole team.",
    features: [
      "Everything in Pro",
      "Social activity feed",
      "Team focus leaderboards",
      "Shared session goals",
      "Team admin dashboard",
      "Slack integration",
    ],
    cta: "Contact Sales",
    highlighted: false,
  },
];

const faqs = [
  {
    q: "Is there a free trial?",
    a: "Yes! During beta, all features are free. After launch, Pro and Team plans include a 14-day free trial.",
  },
  {
    q: "What happens to my data if I downgrade?",
    a: "Your data is always yours. If you downgrade, you keep access to your history — you just lose access to advanced features.",
  },
  {
    q: "Do you offer student discounts?",
    a: "Yes. Students with a valid .edu email get 50% off Pro. Reach out to us at hello@neuro.app.",
  },
  {
    q: "Is my data private?",
    a: "Absolutely. All tracking data stays on your Mac by default. Cloud sync is opt-in and encrypted end-to-end.",
  },
];

export default function Pricing() {
  return (
    <>
      <Navbar />
      <main className="min-h-screen pt-32 pb-20 px-6">
        <div className="max-w-5xl mx-auto">
          {/* Header */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.5 }}
            className="text-center mb-16"
          >
            <h1 className="text-4xl sm:text-5xl font-bold tracking-tight">
              Free during beta
            </h1>
            <p className="mt-4 text-muted text-lg max-w-md mx-auto">
              Early users will get a lifetime discount when we launch paid
              plans. No credit card needed.
            </p>
          </motion.div>

          {/* Plans */}
          <div className="grid md:grid-cols-3 gap-6 mb-24">
            {plans.map((plan, i) => (
              <motion.div
                key={plan.name}
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.1 + 0.2, duration: 0.5 }}
                className={`relative rounded-2xl p-6 border ${
                  plan.highlighted
                    ? "bg-surface border-accent/30"
                    : "bg-surface border-border hover:border-border-hover transition-colors"
                }`}
              >
                <div className="mb-6">
                  <p className="text-sm font-medium text-muted mb-2">
                    {plan.name}
                  </p>
                  <div className="flex items-baseline gap-1">
                    <span className="text-4xl font-bold font-mono">
                      {plan.price}
                    </span>
                    <span className="text-sm text-muted">{plan.period}</span>
                  </div>
                  <p className="mt-2 text-sm text-muted">
                    {plan.description}
                  </p>
                </div>

                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature) => (
                    <li
                      key={feature}
                      className="flex items-start gap-2.5 text-sm"
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
                        className={`mt-0.5 flex-shrink-0 ${
                          plan.highlighted ? "text-accent" : "text-muted"
                        }`}
                      >
                        <polyline points="20 6 9 17 4 12" />
                      </svg>
                      <span className="text-muted">{feature}</span>
                    </li>
                  ))}
                </ul>

                <a
                  href="#"
                  className={`block text-center py-3 px-4 rounded-xl text-sm font-medium transition-colors ${
                    plan.highlighted
                      ? "bg-accent text-white hover:bg-accent-hover"
                      : "border border-border hover:border-border-hover text-foreground"
                  }`}
                >
                  {plan.cta}
                </a>
              </motion.div>
            ))}
          </div>

          {/* FAQ */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="max-w-2xl mx-auto"
          >
            <h2 className="text-2xl font-bold tracking-tight text-center mb-10">
              Frequently asked questions
            </h2>
            <div className="space-y-6">
              {faqs.map((faq) => (
                <div key={faq.q} className="pb-6 border-b border-border last:border-0">
                  <p className="text-sm font-medium mb-2">{faq.q}</p>
                  <p className="text-sm text-muted leading-relaxed">
                    {faq.a}
                  </p>
                </div>
              ))}
            </div>
          </motion.div>
        </div>
      </main>
      <Footer />
    </>
  );
}
