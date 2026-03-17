export default function AboutPage() {
  return (
    <div className="min-h-screen">
      <div className="max-w-2xl mx-auto px-4 py-24">
        <span className="text-[10px] font-mono tracking-[0.3em] text-[#4A90A4] uppercase block mb-4">
          RESTRICTED // MANIFESTO
        </span>
        <h1 className="text-3xl sm:text-4xl font-mono font-light mb-16">
          ABOUT
        </h1>

        <div className="font-mono text-sm text-[#FFFFFF] leading-relaxed space-y-6">
          <p>
            x-Nord OS is a Linux distribution built on Ubuntu 24.04 LTS with KDE Plasma. The design philosophy is Nordic-inspired: minimal, clean, fast, private, and precise.
          </p>
          <p>
            The system provides a Windows-style user experience for users migrating from proprietary operating systems. Taskbar, start menu, system tray. Familiar patterns. No relearning.
          </p>
          <p>
            A built-in AI assistant runs entirely on-device. Ollama and Llama 3. No cloud. No telemetry. All inference occurs locally. Data never leaves the machine.
          </p>
          <p>
            Custom themes apply the x-Nord aesthetic across the boot sequence, login screen, and desktop. Black, white, slate blue. No gradients. No decoration. Function only.
          </p>
          <p>
            The installer is a 5-step process. Calamares. Non-technical users can complete installation without documentation. The app store is curated. Flatpak. Sandboxed.
          </p>
          <p>
            This project exists to provide an alternative. Minimal. Private. Yours.
          </p>
          <p className="pt-12 border-t border-[#333] mt-12">
            Built by humans who were tired of being tracked. Contact: hello@xnord.co.uk
          </p>
        </div>
      </div>
    </div>
  );
}
