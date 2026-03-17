export default function FeaturesPage() {
  const features = [
    {
      code: "MOD-01",
      title: "Windows-style UX",
      desc: "Taskbar, start menu, system tray. Familiar layout for users migrating from Windows.",
    },
    {
      code: "MOD-02",
      title: "Local AI Assistant",
      desc: "Ollama + Llama 3. Runs entirely on-device. No cloud. Full privacy.",
    },
    {
      code: "MOD-03",
      title: "Custom Theme",
      desc: "Plymouth boot splash, SDDM login, KDE Plasma colour scheme. Nordic aesthetic.",
    },
    {
      code: "MOD-04",
      title: "5-Step Installer",
      desc: "Calamares. Simple for non-technical users. Welcome, disk, user, summary, install.",
    },
    {
      code: "MOD-05",
      title: "Curated App Store",
      desc: "Flatpak via Discover. Sandboxed applications. Flathub integration.",
    },
    {
      code: "MOD-06",
      title: "Base System",
      desc: "Ubuntu 24.04 LTS. KDE Plasma 5.27. Kernel 6.8. Support to 2029.",
    },
  ];

  return (
    <div className="min-h-screen">
      <div className="max-w-4xl mx-auto px-4 py-24">
        <span className="text-[10px] font-mono tracking-[0.3em] text-[#4A90A4] uppercase block mb-4">
          CLASSIFIED // BRIEFING DOCUMENT
        </span>
        <h1 className="text-3xl sm:text-4xl font-mono font-light mb-8">
          FEATURES
        </h1>

        <p className="text-sm font-mono text-[#FFFFFF] mb-16 max-w-2xl">
          Every component serves a purpose. No bloat. No telemetry. No compromises. What you see below is what you get.
        </p>

        <div className="border border-[#333]">
          <table className="w-full">
            <thead>
              <tr className="border-b border-[#333]">
                <th className="text-left py-4 px-6 text-[10px] font-mono tracking-widest uppercase text-[#666]">
                  REF
                </th>
                <th className="text-left py-4 px-6 text-[10px] font-mono tracking-widest uppercase text-[#666]">
                  COMPONENT
                </th>
              </tr>
            </thead>
            <tbody>
              {features.map((f) => (
                <tr key={f.code} className="border-b border-[#333] last:border-b-0">
                  <td className="py-6 px-6 text-[10px] font-mono text-[#4A90A4] align-top">
                    {f.code}
                  </td>
                  <td className="py-6 px-6">
                    <div className="text-sm font-mono uppercase mb-2">{f.title}</div>
                    <div className="text-xs font-mono text-[#666]">{f.desc}</div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
