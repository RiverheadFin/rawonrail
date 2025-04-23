import { existsSync, mkdirSync } from "fs";

export const paths = {
  rootDir: process.env.DATA_DIRECTORY || "./src/data",
  appDir: process.env.APP_DIRECTORY || `${process.env.DATA_DIRECTORY || "./src/data"}/app`,
  // Keep any other paths that existed in the original file
};

export function ensureDirectoriesExist() {
  const directories = [paths.rootDir, paths.appDir];
  
  for (const dir of directories) {
    if (!existsSync(dir)) {
      mkdirSync(dir, { recursive: true });
    }
  }
}