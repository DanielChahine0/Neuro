import Link from "next/link";

export default function Footer() {
  return (
    <footer id="contact" className="relative pt-16 pb-12 px-6">
      <div className="absolute top-0 left-0 right-0 h-px bg-gradient-to-r from-transparent via-border to-transparent" />

      <div className="max-w-6xl mx-auto">
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-10 mb-14">
          {/* Brand */}
          <div className="sm:col-span-2 md:col-span-1">
            <div className="flex items-center gap-2 mb-4">
              <div className="w-7 h-7 rounded-lg bg-accent flex items-center justify-center">
                <svg
                  width="14"
                  height="14"
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
            <p className="text-sm text-muted leading-relaxed max-w-xs">
              Focus tracking and productivity for macOS. Built for people who
              care about doing their best work.
            </p>
          </div>

          {/* Product */}
          <div>
            <p className="text-xs font-mono uppercase tracking-wider text-muted mb-4">
              Product
            </p>
            <ul className="space-y-2.5">
              <li>
                <Link
                  href="/#features"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Features
                </Link>
              </li>
              <li>
                <Link
                  href="/pricing"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Pricing
                </Link>
              </li>
              <li>
                <Link
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Changelog
                </Link>
              </li>
              <li>
                <Link
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Download
                </Link>
              </li>
            </ul>
          </div>

          {/* Company */}
          <div>
            <p className="text-xs font-mono uppercase tracking-wider text-muted mb-4">
              Company
            </p>
            <ul className="space-y-2.5">
              <li>
                <Link
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  About
                </Link>
              </li>
              <li>
                <a
                  href="mailto:hello@neuro.app"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Contact
                </a>
              </li>
              <li>
                <Link
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Terms of Service
                </Link>
              </li>
            </ul>
          </div>

          {/* Connect */}
          <div>
            <p className="text-xs font-mono uppercase tracking-wider text-muted mb-4">
              Connect
            </p>
            <ul className="space-y-2.5">
              <li>
                <a
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Twitter / X
                </a>
              </li>
              <li>
                <a
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  GitHub
                </a>
              </li>
              <li>
                <a
                  href="#"
                  className="text-sm text-muted hover:text-foreground transition-colors"
                >
                  Discord
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom */}
        <div className="pt-8 border-t border-border flex flex-col sm:flex-row items-center justify-between gap-4">
          <p className="text-xs text-muted/50">
            &copy; {new Date().getFullYear()} Neuro. All rights reserved.
          </p>
          <p className="text-xs text-muted/40">
            Crafted for people who focus.
          </p>
        </div>
      </div>
    </footer>
  );
}
