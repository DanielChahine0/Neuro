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
            className="mt-8 inline-flex items-center gap-2 px-6 py-3 rounded-xl bg-accent hover:bg-accent-hover text-white text-sm font-medium transition-colors"
          >
            Get for Mac
          </a>
        </div>
      </main>
      <Footer />
    </>
  );
}
