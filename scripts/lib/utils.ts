import { execSync } from 'node:child_process';
import { existsSync, lstatSync, mkdirSync, readlinkSync, renameSync, symlinkSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { homedir } from 'node:os';

export const dryRun = process.argv.includes('--dry-run');

export const home = homedir();

const blue = (s: string) => `\x1b[34m${s}\x1b[0m`;
const green = (s: string) => `\x1b[32m${s}\x1b[0m`;
const yellow = (s: string) => `\x1b[33m${s}\x1b[0m`;
const dim = (s: string) => `\x1b[2m${s}\x1b[0m`;

export const step = (msg: string) => console.log(`\n${blue('▸')} ${msg}`);
export const ok = (msg: string) => console.log(`${green('✓')} ${msg}`);
export const warn = (msg: string) => console.log(`${yellow('!')} ${msg}`);

export function run(command: string, options: { silent?: boolean } = {}) {
  if (dryRun) {
    console.log(`${dim('would run:')} ${command}`);
    return;
  }
  execSync(command, { stdio: options.silent ? 'pipe' : 'inherit' });
}

/**
 * Result of a read-only command: whether it succeeded, plus combined
 * stdout+stderr (brew reports failures on stderr).
 * Runs in --dry-run too — only use for commands that change nothing.
 */
export function probe(command: string): { ok: boolean; output: string } {
  try {
    return { ok: true, output: execSync(command, { stdio: 'pipe', encoding: 'utf8' }) };
  } catch (error) {
    const { stdout, stderr } = error as { stdout?: Buffer | string; stderr?: Buffer | string };
    return { ok: false, output: `${stdout ?? ''}${stderr ?? ''}` };
  }
}

let backupDir: string | null = null;

function backupPath(): string {
  if (!backupDir) {
    const stamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
    backupDir = join(home, '.dotfiles-backup', stamp);
  }
  return backupDir;
}

/** Symlink target → source, backing up whatever was there before. */
export function link(source: string, target: string) {
  const isLink = isSymlink(target);

  if (isLink && readlinkSync(target) === source) {
    ok(`${target} ${dim('already linked')}`);
    return;
  }

  if (dryRun) {
    console.log(`${dim('would link:')} ${target} → ${source}`);
    return;
  }

  if (existsSync(target) || isLink) {
    const backup = backupPath();
    mkdirSync(backup, { recursive: true });
    renameSync(target, join(backup, target.split('/').at(-1)!));
    warn(`moved existing ${target} to ${backup}`);
  }

  mkdirSync(dirname(target), { recursive: true });
  symlinkSync(source, target);
  ok(`${target} → ${source}`);
}

function isSymlink(path: string): boolean {
  try {
    return lstatSync(path).isSymbolicLink();
  } catch {
    return false;
  }
}
