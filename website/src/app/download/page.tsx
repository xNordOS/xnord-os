export default function DownloadPage() {
  return (
    <div className="min-h-screen">
      <div className="max-w-4xl mx-auto px-4 py-24">
        <span className="text-[10px] font-mono tracking-[0.3em] text-[#4A90A4] uppercase block mb-4">
          SYSTEM // FILE DIRECTORY
        </span>
        <h1 className="text-3xl sm:text-4xl font-mono font-light mb-16">
          DOWNLOAD
        </h1>

        <p className="text-xl font-mono tracking-widest uppercase text-[#FFFFFF] mb-12">
          THIS IS NOT WINDOWS. THIS IS BETTER.
        </p>

        <a
          href="https://download.xnord.co.uk/xnord-os-1.0-amd64.iso"
          className="inline-block border border-[#333] px-8 py-3 text-[10px] font-mono tracking-widest uppercase mb-12"
        >
          DOWNLOAD ISO
        </a>

        <div className="border border-[#333] p-6">
          <div className="text-[10px] font-mono text-[#666] mb-6">
            $ ls -la /releases/
          </div>
          <div className="space-y-4 font-mono text-sm">
            <div className="flex flex-wrap items-baseline gap-4 border-b border-[#333] pb-4">
              <span className="text-[#4A90A4]">xnord-os-1.0-amd64.iso</span>
              <span className="text-[#666]">~4.5G</span>
              <a
                href="https://download.xnord.co.uk/xnord-os-1.0-amd64.iso"
                className="text-[10px] border border-[#333] px-3 py-1 uppercase"
              >
                $ wget
              </a>
            </div>
            <div className="text-[10px] text-[#666]">
              SHA256: [Verify after download]
            </div>
            <div className="text-xs text-[#666] mt-6">
              $ sha256sum -c xnord-os-1.0-amd64.iso.sha256
            </div>
          </div>
        </div>

        <div className="mt-12 border border-[#333] p-6">
          <div className="text-[10px] font-mono text-[#666] uppercase mb-4">
            REQUIREMENTS
          </div>
          <div className="font-mono text-xs text-[#FFFFFF] space-y-2">
            <div>RAM: 8GB minimum / 16GB recommended for AI</div>
            <div>Storage: 30GB minimum</div>
            <div>Architecture: x86_64 (amd64)</div>
          </div>
        </div>
      </div>
    </div>
  );
}
