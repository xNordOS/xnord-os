"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const links = [
  { href: "/", label: "HOME" },
  { href: "/features", label: "FEATURES" },
  { href: "/download", label: "DOWNLOAD" },
  { href: "/about", label: "ABOUT" },
];

export function NavLinks() {
  const pathname = usePathname();
  return (
    <div className="flex gap-8 text-[10px] font-mono tracking-widest uppercase">
      {links.map(({ href, label }) => (
        <Link
          key={href}
          href={href}
          className={pathname === href ? "text-[#4A90A4]" : "text-[#FFFFFF]"}
        >
          {label}
        </Link>
      ))}
    </div>
  );
}
