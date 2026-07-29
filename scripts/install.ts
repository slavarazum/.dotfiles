#!/usr/bin/env node
// Main installer — run from the repo root: node scripts/install.ts [--dry-run]

import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { dryRun, home, link, ok, probe, run, step, warn } from './lib/utils.ts';

const dotfiles = join(home, 'Development', '.dotfiles');

if (!existsSync(join(dotfiles, 'Brewfile'))) {
  console.error(`Expected the repo at ${dotfiles} — clone it there first.`);
  process.exit(1);
}

console.log('\n🖥  Setting up this Mac' + (dryRun ? ' (dry run)' : ''));

let incomplete = false;

step('Hiding "last login" message');
if (existsSync(join(home, '.hushlogin'))) {
  ok('~/.hushlogin already exists');
} else {
  if (!dryRun) writeFileSync(join(home, '.hushlogin'), '');
  ok('~/.hushlogin');
}

step('Installing Homebrew packages');
const brewfile = join(dotfiles, 'Brewfile');
const check = probe(`brew bundle check --verbose --file ${brewfile}`);

if (check.ok) {
  ok('all Brewfile packages already installed');
} else {
  const missing = check.output.split('\n').filter((line) => line.startsWith('→'));
  if (missing.length > 0) {
    warn(`${missing.length} missing or outdated:`);
    for (const line of missing) console.log(`    ${line.replace('→ ', '')}`);
  } else {
    warn('brew bundle check failed:');
    console.log(check.output.trim());
  }
  try {
    run(`brew bundle --file ${brewfile}`);
  } catch {
    incomplete = true;
    warn('some Brewfile packages failed — continuing; re-run `pnpm sync` to retry');
  }
}

step('Installing oh-my-zsh');
if (existsSync(join(home, '.oh-my-zsh'))) {
  ok('already installed');
} else {
  run(
    'RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"',
  );
}

step('Linking dotfiles');
link(join(dotfiles, '.zshrc'), join(home, '.zshrc'));
link(join(dotfiles, '.gitconfig'), join(home, '.gitconfig'));
link(join(dotfiles, '.inputrc'), join(home, '.inputrc'));
link(join(dotfiles, '.config', 'starship.toml'), join(home, '.config', 'starship.toml'));
link(join(dotfiles, '.config', 'ghostty', 'config'), join(home, '.config', 'ghostty', 'config'));
link(join(dotfiles, '.config', 'gh', 'config.yml'), join(home, '.config', 'gh', 'config.yml'));
link(join(dotfiles, '.claude', 'settings.json'), join(home, '.claude', 'settings.json'));

// ssh wants its directory private before anything is linked into it
if (!dryRun) mkdirSync(join(home, '.ssh'), { recursive: true, mode: 0o700 });
link(join(dotfiles, '.ssh', 'config'), join(home, '.ssh', 'config'));

if (dryRun) {
  console.log('\n🔍 Dry run — nothing was changed. Apply with: pnpm sync');
} else {
  if (incomplete) {
    console.log('\n⚠️  Finished with some failures — safe to re-run: pnpm sync');
  } else {
    console.log('\n✨ Done. Next steps:');
  }
  console.log('   • restart the terminal (or run: exec zsh)');
  console.log('   • optionally apply macOS defaults: node scripts/macos.ts');
  warn('anything replaced by symlinks was backed up to ~/.dotfiles-backup/');
}
process.exit(incomplete ? 1 : 0);
