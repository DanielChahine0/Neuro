import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";

export default function Pricing() {
  return (
    <>
      <Navbar />
      <main className="min-h-screen flex items-center justify-center px-6 pt-16">
        <div className="text-center">
          <p className="text-sm text-accent font-mono uppercase tracking-wider mb-3">
            Pricing
          </p>
          <h1 className="text-4xl font-bold tracking-tight">
            Free during beta
          </h1>
          <p className="mt-4 text-muted max-w-md mx-auto">
            Neuro is free while we&apos;re in beta. We&apos;ll announce pricing before
            any changes — early users will get a lifetime discount.
          </p>
          <a
            href="/"
            className="mt-8 inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-medium transition-all duration-200 hover:scale-[1.02] active:scale-[0.98] shadow-[0_0_20px_rgba(99,102,241,0.2)] hover:shadow-[0_0_30px_rgba(99,102,241,0.35)]"
          >
            Get for Mac
          </a>
        </div>
      </main>
      <Footer />
    </>
  );
}
