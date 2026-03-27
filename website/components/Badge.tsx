export default function Badge({ children }: { children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium bg-accent/10 text-accent border border-accent/20">
      <span className="w-1.5 h-1.5 rounded-full bg-accent animate-pulse" />
      {children}
    </span>
  );
}
