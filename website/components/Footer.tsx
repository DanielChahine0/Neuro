import Link from "next/link";

export default function Footer() {
  return (
    <footer id="contact" className="border-t border-border py-12 px-6">
      <div className="max-w-6xl mx-auto flex flex-col sm:flex-row items-center justify-between gap-6">
        <div className="flex items-center gap-2">
          <div className="w-6 h-6 rounded-md bg-accent flex items-center justify-center">
            <svg
              width="12"
              height="12"
              viewBox="0 0 24 24"
              fill="none"
              stroke="white"
              strokeWidth="2.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="M12 2a10 10 0 1 0 10 10H12V2z" />
            </svg>
          </div>
          <span className="text-sm font-semibold">Neuro</span>
        </div>

        <div className="flex items-center gap-6 text-sm text-muted">
          <Link href="#" className="hover:text-foreground transition-colors">
            Privacy Policy
          </Link>
          <Link href="#" className="hover:text-foreground transition-colors">
            Terms of Service
          </Link>
          <a
            href="mailto:hello@neuro.app"
            className="hover:text-foreground transition-colors"
          >
            hello@neuro.app
          </a>
        </div>

        <p className="text-xs text-muted/60">
          &copy; {new Date().getFullYear()} Neuro. All rights reserved.
        </p>
      </div>
    </footer>
  );
}
