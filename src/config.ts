import { existsSync, mkdirSync } from "node:fs";
import process from "node:process";

export const paths = {
  rootDir: process.env.DATA_DIRECTORY ?? "./src/data",
  appDir: process.env.APP_DIRECTORY ?? `${process.env.DATA_DIRECTORY ?? "./src/data"}/app`,
  // Keep any other paths that existed in the original file
};

export function ensureDirectoriesExist(): void {
  const directories = [paths.rootDir, paths.appDir];
  
  for (const dir of directories) {
    // Since synchronous methods are used by the project, we'll continue using them
    // but with proper error handling
    try {
      if (!existsSync(dir)) {
        mkdirSync(dir, { recursive: true });
      }
    } catch (error) {
      // Handle potential errors
      console.error(`Failed to create directory: ${dir}`, error);
    }
  }
}