import { execSync } from "child_process";
import customPlugin from "./plugin";

const activeAdminPath = execSync("bundle show activeadmin", {
  encoding: "utf-8",
}).trim();

// // const defaultTheme = require("tailwindcss/defaultTheme");

export default {
  content: [
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
    "../app/admin/**/*.{arb,erb,html,rb}",
    "../app/views/active_admin/**/*.{arb,erb,html,rb}",
    "../app/views/admin/**/*.{arb,erb,html,rb}",
    "../app/views/layouts/active_admin*.{erb,html}",
    "../app/javascript/**/*.js",
    "../public/*.html",
    "../app/helpers/**/*.rb",
    "../app/views/**/*.{erb,haml,html,slim}",
  ],
  darkMode: "selector",
  plugins: [customPlugin],
};
