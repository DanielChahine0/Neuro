"use client";

import { useRef, useState } from "react";
import { motion } from "framer-motion";

interface Feature {
  number: string;
  title: string;
  description: string;
  mockup: React.ReactNode;
}

function TiltCard({ children }: { children: React.ReactNode }) {
  const ref = useRef<HTMLDivElement>(null);
  const [style, setStyle] = useState({});

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    const x = (e.clientX - rect.left) / rect.width - 0.5;
    const y = (e.clientY - rect.top) / rect.height - 0.5;
    setStyle({
      transform: `perspective(800px) rotateX(${-y * 4}deg) rotateY(${x * 4}deg) scale(1.01)`,
      transition: "transform 0.15s ease-out",
    });
  };

  return (
    <div
      ref={ref}
      onMouseMove={handleMouseMove}
      onMouseLeave={() =>
        setStyle({
          transform: "perspective(800px) rotateX(0deg) rotateY(0deg) scale(1)",
          transition: "transform 0.4s ease-out",
        })
      }
      style={style}
    >
      {children}
    </div>
  );
}

function WindowChrome() {
  return (
    <div className="flex items-center gap-2 px-4 py-2.5 border-b border-border">
      <div className="w-2.5 h-2.5 rounded-full bg-[#ff5f57]" />
      <div className="w-2.5 h-2.5 rounded-full bg-[#febc2e]" />
      <div className="w-2.5 h-2.5 rounded-full bg-[#28c840]" />
    </div>
  );
}

function WorkSessionMockup() {
  return (
    <TiltCard>
      <div className="rounded-xl bg-surface border border-border overflow-hidden shadow-lg shadow-black/10 hover:shadow-xl hover:shadow-accent/5 hover:border-border-hover transition-all duration-500">
        <WindowChrome />
        <div className="p-6">
          <div className="flex items-center justify-between mb-4">
            <div>
              <p className="text-xs text-muted font-mono uppercase tracking-wider">
                Active Session
              </p>
              <p className="text-3xl font-bold font-mono tabular-nums mt-1">
                02:15:47
              </p>
            </div>
            <div className="px-3 py-1.5 rounded-lg bg-emerald-500/10 border border-emerald-500/20">
              <span className="text-xs font-medium text-emerald-400 flex items-center gap-1.5">
                <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse" />
                In Focus
              </span>
            </div>
          </div>
          <div className="space-y-2">
            <div className="flex items-center justify-between text-sm">
              <span className="text-muted">Task</span>
              <span className="font-medium">Frontend redesign</span>
            </div>
            <div className="flex items-center justify-between text-sm">
              <span className="text-muted">Started</span>
              <span className="font-mono text-muted">9:30 AM</span>
            </div>
            <div className="w-full h-2 rounded-full bg-border mt-3 overflow-hidden">
              <div className="h-full w-3/4 rounded-full bg-gradient-to-r from-accent to-accent-hover" />
            </div>
            <p className="text-xs text-muted">75% of 3h goal</p>
          </div>
        </div>
      </div>
    </TiltCard>
  );
}

function DistractionMockup() {
  const items = [
    { app: "Twitter / X", icon: "𝕏", time: "4m 32s", color: "text-red-400", barWidth: "75%" },
    { app: "YouTube", icon: "▶", time: "2m 18s", color: "text-red-400", barWidth: "45%" },
    { app: "Slack", icon: "◆", time: "1m 45s", color: "text-yellow-400", barWidth: "30%" },
    { app: "Mail", icon: "✉", time: "0m 52s", color: "text-yellow-400", barWidth: "15%" },
  ];
  return (
    <TiltCard>
      <div className="rounded-xl bg-surface border border-border overflow-hidden shadow-lg shadow-black/10 hover:shadow-xl hover:shadow-accent/5 hover:border-border-hover transition-all duration-500">
        <WindowChrome />
        <div className="p-6">
          <p className="text-xs text-muted font-mono uppercase tracking-wider mb-4">
            Distractions Today
          </p>
          <div className="space-y-3">
            {items.map((item) => (
              <div
                key={item.app}
                className="relative py-2.5 px-3 rounded-lg bg-background/50 overflow-hidden"
              >
                <div
                  className="absolute inset-y-0 left-0 bg-red-500/5"
                  style={{ width: item.barWidth }}
                />
                <div className="relative flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-sm w-5 text-center text-muted">{item.icon}</span>
                    <span className="text-sm font-medium">{item.app}</span>
                  </div>
                  <span className={`text-sm font-mono ${item.color}`}>
                    {item.time}
                  </span>
                </div>
              </div>
            ))}
          </div>
          <div className="mt-4 pt-4 border-t border-border flex items-center justify-between">
            <span className="text-sm text-muted">Total distracted</span>
            <span className="text-sm font-mono text-red-400 font-medium">
              9m 27s
            </span>
          </div>
        </div>
      </div>
    </TiltCard>
  );
}

function AppBlockingMockup() {
  const apps = [
    { name: "Twitter / X", blocked: true },
    { name: "YouTube", blocked: true },
    { name: "Reddit", blocked: true },
    { name: "Instagram", blocked: false },
  ];
  return (
    <TiltCard>
      <div className="rounded-xl bg-surface border border-border overflow-hidden shadow-lg shadow-black/10 hover:shadow-xl hover:shadow-accent/5 hover:border-border-hover transition-all duration-500">
        <WindowChrome />
        <div className="p-6">
          <p className="text-xs text-muted font-mono uppercase tracking-wider mb-4">
            Blocked Apps
          </p>
          <div className="space-y-2">
            {apps.map((app) => (
              <div
                key={app.name}
                className="flex items-center justify-between py-2.5 px-3 rounded-lg bg-background/50"
              >
                <span className="text-sm font-medium">{app.name}</span>
                <div
                  className={`w-10 h-6 rounded-full flex items-center transition-colors duration-200 ${
                    app.blocked
                      ? "bg-accent justify-end"
                      : "bg-border justify-start"
                  }`}
                >
                  <div className="w-4 h-4 rounded-full bg-white mx-1 shadow-sm" />
                </div>
              </div>
            ))}
          </div>
          <div className="mt-4 px-3 py-2.5 rounded-lg bg-red-500/5 border border-red-500/10">
            <p className="text-xs text-red-400 flex items-center gap-2">
              <svg
                width="12"
                height="12"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
              >
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
              </svg>
              3 apps blocked during focus sessions
            </p>
          </div>
        </div>
      </div>
    </TiltCard>
  );
}

function FocusScoreMockup() {
  return (
    <TiltCard>
      <div className="rounded-xl bg-surface border border-border overflow-hidden shadow-lg shadow-black/10 hover:shadow-xl hover:shadow-accent/5 hover:border-border-hover transition-all duration-500">
        <WindowChrome />
        <div className="p-6 flex flex-col items-center">
          <p className="text-xs text-muted font-mono uppercase tracking-wider mb-6">
            Focus Score
          </p>
          <div className="relative w-36 h-36">
            <svg
              className="w-full h-full -rotate-90"
              viewBox="0 0 120 120"
            >
              <circle
                cx="60"
                cy="60"
                r="52"
                fill="none"
                stroke="#1f1f1f"
                strokeWidth="8"
              />
              <circle
                cx="60"
                cy="60"
                r="52"
                fill="none"
                stroke="url(#scoreGradient)"
                strokeWidth="8"
                strokeDasharray={`${2 * Math.PI * 52 * 0.87} ${
                  2 * Math.PI * 52 * 0.13
                }`}
                strokeLinecap="round"
              />
              <defs>
                <linearGradient
                  id="scoreGradient"
                  x1="0%"
                  y1="0%"
                  x2="100%"
                  y2="0%"
                >
                  <stop offset="0%" stopColor="#6366f1" />
                  <stop offset="100%" stopColor="#818cf8" />
                </linearGradient>
              </defs>
            </svg>
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <span className="text-3xl font-bold font-mono">87%</span>
              <span className="text-xs text-emerald-400">Great</span>
            </div>
          </div>
          <div className="mt-6 w-full grid grid-cols-2 gap-3">
            <div className="px-3 py-2.5 rounded-lg bg-background/50 text-center">
              <p className="text-lg font-bold font-mono">2h 41m</p>
              <p className="text-xs text-muted">Focused</p>
            </div>
            <div className="px-3 py-2.5 rounded-lg bg-background/50 text-center">
              <p className="text-lg font-bold font-mono">24m</p>
              <p className="text-xs text-muted">Distracted</p>
            </div>
          </div>
        </div>
      </div>
    </TiltCard>
  );
}

function StatsMockup() {
  const days = ["M", "T", "W", "T", "F", "S", "S"];
  const heights = [65, 80, 45, 90, 100, 30, 55];
  return (
    <TiltCard>
      <div className="rounded-xl bg-surface border border-border overflow-hidden shadow-lg shadow-black/10 hover:shadow-xl hover:shadow-accent/5 hover:border-border-hover transition-all duration-500">
        <WindowChrome />
        <div className="p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <p className="text-xs text-muted font-mono uppercase tracking-wider">
                This Week
              </p>
              <p className="text-2xl font-bold mt-1">18h 24m</p>
            </div>
            <div className="text-right">
              <p className="text-xs text-muted font-mono uppercase tracking-wider">
                Streak
              </p>
              <p className="text-2xl font-bold text-accent mt-1 flex items-center gap-1 justify-end">
                <span className="text-orange-400">12d</span>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                  <path
                    d="M12 2c-2.5 4-4 6-4 9a4 4 0 1 0 8 0c0-3-1.5-5-4-9z"
                    fill="currentColor"
                    className="text-orange-400"
                  />
                </svg>
              </p>
            </div>
          </div>
          <div className="flex items-end gap-2 h-28">
            {days.map((day, i) => (
              <div
                key={day + i}
                className="flex-1 flex flex-col items-center gap-1.5"
              >
                <div
                  className="w-full rounded-md bg-gradient-to-t from-accent/20 to-accent/40 hover:from-accent/30 hover:to-accent/60 transition-colors duration-200"
                  style={{ height: `${heights[i]}%` }}
                />
                <span className="text-[10px] text-muted font-mono">
                  {day}
                </span>
              </div>
            ))}
          </div>
          <div className="mt-5 pt-4 border-t border-border grid grid-cols-2 gap-2">
            <div className="px-3 py-2 rounded-lg bg-background/50">
              <p className="text-xs text-muted">Longest session</p>
              <p className="text-sm font-bold font-mono">4h 12m</p>
            </div>
            <div className="px-3 py-2 rounded-lg bg-background/50">
              <p className="text-xs text-muted">Best day</p>
              <p className="text-sm font-bold font-mono">6h 38m</p>
            </div>
          </div>
        </div>
      </div>
    </TiltCard>
  );
}

function SocialMockup() {
  const friends = [
    { name: "Alex", status: "In session", time: "1h 23m", active: true },
    { name: "Sarah", status: "Completed", time: "3h 10m", active: false },
    { name: "Marcus", status: "In session", time: "0h 45m", active: true },
  ];
  return (
    <TiltCard>
      <div className="rounded-xl bg-surface border border-border overflow-hidden shadow-lg shadow-black/10 hover:shadow-xl hover:shadow-accent/5 hover:border-border-hover transition-all duration-500">
        <WindowChrome />
        <div className="p-6">
          <p className="text-xs text-muted font-mono uppercase tracking-wider mb-4">
            Activity Feed
          </p>
          <div className="space-y-3">
            {friends.map((f) => (
              <div
                key={f.name}
                className="flex items-center justify-between py-2.5 px-3 rounded-lg bg-background/50"
              >
                <div className="flex items-center gap-3">
                  <div className="relative w-8 h-8 rounded-full bg-accent/15 flex items-center justify-center text-xs font-bold text-accent">
                    {f.name[0]}
                    {f.active && (
                      <span className="absolute -bottom-0.5 -right-0.5 w-2.5 h-2.5 rounded-full bg-emerald-400 border-2 border-surface" />
                    )}
                  </div>
                  <div>
                    <p className="text-sm font-medium">{f.name}</p>
                    <p className="text-xs text-muted">
                      {f.status} — {f.time}
                    </p>
                  </div>
                </div>
                {!f.active && (
                  <button className="px-3 py-1 rounded-lg bg-accent/10 text-xs font-medium text-accent hover:bg-accent/20 transition-colors">
                    Congrats
                  </button>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    </TiltCard>
  );
}

const features: Feature[] = [
  {
    number: "01",
    title: "Work Sessions",
    description:
      "Start timed deep work sessions that monitor your activity in real time. Neuro tracks which apps you use, flags when you drift off-task, and helps you stay locked in.",
    mockup: <WorkSessionMockup />,
  },
  {
    number: "02",
    title: "Distraction Detection",
    description:
      "Every distraction is logged automatically — which apps and websites pulled your focus, and exactly how long you spent on each. No more guessing where your time went.",
    mockup: <DistractionMockup />,
  },
  {
    number: "03",
    title: "App Blocking",
    description:
      "Block distracting apps and websites on your Mac during focus sessions. Once a session starts, blocked apps can't be opened until it's over.",
    mockup: <AppBlockingMockup />,
  },
  {
    number: "04",
    title: "Focus Score",
    description:
      "Get a real-time percentage score showing how much of your session was productive versus distracted. Watch your focus improve over time.",
    mockup: <FocusScoreMockup />,
  },
  {
    number: "05",
    title: "Stats & Streaks",
    description:
      "Weekly and monthly charts track your hours worked, distraction counts, and focus trends. Hit personal bests and build streaks to stay consistent.",
    mockup: <StatsMockup />,
  },
  {
    number: "06",
    title: "Social Accountability",
    description:
      "Invite friends, see who's currently in a session, and view each other's logged time. Congratulate teammates after long focus sessions.",
    mockup: <SocialMockup />,
  },
];

export default function FeatureSection() {
  return (
    <section id="features" className="relative py-32 px-6">
      <div className="max-w-6xl mx-auto">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true, margin: "-100px" }}
          transition={{ duration: 0.5 }}
          className="text-center mb-24"
        >
          <p className="text-sm text-accent font-mono uppercase tracking-wider mb-3">
            Features
          </p>
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tight">
            Everything you need to{" "}
            <span className="font-display italic font-normal text-muted">
              focus
            </span>
          </h2>
          <p className="mt-4 text-muted max-w-lg mx-auto">
            Six powerful tools that work together to help you do your best work, every day.
          </p>
        </motion.div>

        <div className="space-y-32">
          {features.map((feature, index) => (
            <motion.div
              key={feature.number}
              initial={{ opacity: 0, y: 40 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-80px" }}
              transition={{ duration: 0.7, ease: [0.16, 1, 0.3, 1] }}
              className={`grid md:grid-cols-2 gap-12 lg:gap-20 items-center ${
                index % 2 === 1 ? "" : ""
              }`}
              style={{
                direction: index % 2 === 1 ? "rtl" : "ltr",
              }}
            >
              <div style={{ direction: "ltr" }} className="flex flex-col">
                {/* Large watermark number */}
                <div className="relative">
                  <span className="text-[8rem] font-bold font-mono leading-none text-transparent bg-clip-text bg-gradient-to-b from-surface-raised to-transparent select-none">
                    {feature.number}
                  </span>
                  <div className="absolute bottom-4 left-0">
                    <h3 className="text-2xl sm:text-3xl font-bold tracking-tight">
                      {feature.title}
                    </h3>
                  </div>
                </div>
                <p className="mt-4 text-muted leading-relaxed max-w-md text-lg">
                  {feature.description}
                </p>
              </div>
              <div style={{ direction: "ltr" }}>{feature.mockup}</div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  );
}
