export default function Badge({ children }: { children: React.ReactNode }) {
  return (
    <span className="relative inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-xs font-medium bg-accent/8 text-accent border border-accent/20 overflow-hidden backdrop-blur-sm">
      <span className="absolute inset-0 bg-gradient-to-r from-transparent via-accent/10 to-transparent animate-[shimmer_3s_ease-in-out_infinite] bg-[length:200%_100%]" />
      <span className="relative w-1.5 h-1.5 rounded-full bg-accent">
        <span className="absolute inset-0 rounded-full bg-accent animate-[pulse-ring_2s_ease-out_infinite]" />
      </span>
      <span className="relative">{children}</span>
    </span>
  );
}
