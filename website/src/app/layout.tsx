import type { Metadata } from "next";
import Image from "next/image";
import { NavLinks } from "./components/NavLinks";
import "./globals.css";

export const metadata: Metadata = {
  title: "x-Nord OS",
  description: "The operating system that does not compromise. Private by design. Fast by default. Yours entirely.",
  icons: { icon: "/xnord-logo.png" },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="dark">
      <body className="bg-[#000000] text-[#FFFFFF] font-mono antialiased min-h-screen flex flex-col">
        <nav className="border-b border-[#333] fixed top-0 left-0 right-0 z-50 bg-[#000000]">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between items-center h-14">
              <a href="/" className="flex items-center">
                <Image
                  src="/xnord-logo.png"
                  alt="x-Nord"
                  width={120}
                  height={32}
                  className="h-8 w-auto invert"
                  style={{ objectFit: "contain" }}
                  priority
                />
              </a>
              <NavLinks />
            </div>
          </div>
        </nav>
        <main className="pt-14 flex-1 flex flex-col">
          {children}
          <footer className="border-t border-[#333] mt-auto">
            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
              <div className="flex flex-col sm:flex-row justify-between items-center gap-4 text-[10px] font-mono tracking-widest uppercase">
                <a href="/" className="flex items-center">
                  <Image
                    src="/xnord-logo.png"
                    alt="x-Nord OS"
                    width={72}
                    height={24}
                    className="h-6 w-auto invert"
                    style={{ objectFit: "contain" }}
                  />
                </a>
                <a href="mailto:hello@xnord.co.uk" className="text-[#FFFFFF]">
                  hello@xnord.co.uk
                </a>
                <a
                  href="https://github.com/JosephSRobinson/xnord-os"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-[#FFFFFF]"
                >
                  github.com/JosephSRobinson/xnord-os
                </a>
              </div>
            </div>
          </footer>
        </main>
      </body>
    </html>
  );
}
