import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        background: "#000000",
        foreground: "#ffffff",
        accent: "#4A90A4",
        border: "#333333",
      },
      fontFamily: {
        mono: ["'IBM Plex Mono'", "monospace"],
      },
      borderRadius: {
        none: "0",
      },
    },
  },
  plugins: [],
};
export default config;
