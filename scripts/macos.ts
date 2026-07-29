#!/usr/bin/env node
// Curated macOS defaults — run: node scripts/macos.ts [--dry-run]
// Based on the classic https://mths.be/macos, trimmed to settings that still
// work and are actually wanted on a modern macOS.

import { execSync } from 'node:child_process';
import readline from 'node:readline/promises';
import { dryRun, ok, run, step } from './lib/utils.ts';

console.log('\n🍎 Applying macOS defaults' + (dryRun ? ' (dry run)' : ''));

// --- Machine name -----------------------------------------------------------

const current = execSync('scutil --get ComputerName', { encoding: 'utf8' }).trim();
const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const answer = (await rl.question(`Computer name [${current}]: `)).trim();
rl.close();

if (!dryRun) run('sudo -v');

if (answer && answer !== current) {
  // LocalHostName/NetBIOS only allow letters, digits and hyphens
  const hostSafe = answer.replace(/[^A-Za-z0-9-]+/g, '-').replace(/^-+|-+$/g, '');
  step(`Setting machine name to "${answer}"`);
  run(`sudo scutil --set ComputerName "${answer}"`);
  run(`sudo scutil --set HostName "${hostSafe}"`);
  run(`sudo scutil --set LocalHostName "${hostSafe}"`);
  run(
    `sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${hostSafe}"`,
  );
}

// --- Settings ---------------------------------------------------------------

const sections: Record<string, string[]> = {
  'General UI/UX': [
    // Sidebar icon size: medium
    'defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2',
    // Expand save and print panels by default
    'defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true',
    'defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true',
    'defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true',
    'defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true',
    // Quit the printer app once print jobs complete
    'defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true',
    // No smart quotes / auto spelling correction while typing code
    'defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false',
    'defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false',
  ],

  'Keyboard & input': [
    // Full keyboard access: Tab moves focus between all controls
    'defaults write NSGlobalDomain AppleKeyboardUIMode -int 3',
    // Key repeat instead of the press-and-hold accent popup
    'defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false',
  ],

  'Language & region': [
    'defaults write NSGlobalDomain AppleLanguages -array "en" "ru"',
    'defaults write NSGlobalDomain AppleLocale -string "en_UA@currency=USD"',
    'defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"',
    'defaults write NSGlobalDomain AppleMetricUnits -bool true',
    'sudo systemsetup -settimezone "Europe/Kyiv" > /dev/null',
  ],

  Security: [
    // Require password immediately after sleep or screen saver
    'defaults write com.apple.screensaver askForPassword -int 1',
    'defaults write com.apple.screensaver askForPasswordDelay -int 0',
  ],

  Finder: [
    'defaults write com.apple.finder ShowPathbar -bool true',
    'defaults write com.apple.finder _FXSortFoldersFirst -bool true',
    // Search the current folder by default
    'defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"',
    'defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false',
    // List view by default
    'defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"',
    // No .DS_Store litter on network or USB volumes
    'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true',
    'defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true',
    'chflags nohidden ~/Library',
  ],

  Dock: [
    'defaults write com.apple.dock autohide -bool true',
    'defaults write com.apple.dock autohide-delay -float 0',
    'defaults write com.apple.dock autohide-time-modifier -float 0',
    'defaults write com.apple.dock minimize-to-application -bool true',
    'defaults write com.apple.dock showhidden -bool true',
    'defaults write com.apple.dock show-recents -bool false',
    // Don’t rearrange Spaces by most recent use
    'defaults write com.apple.dock mru-spaces -bool false',
    // Hot corner top-right: put display to sleep
    'defaults write com.apple.dock wvous-tr-corner -int 10',
    'defaults write com.apple.dock wvous-tr-modifier -int 0',
  ],

  Power: [
    'sudo pmset -a lidwake 1',
    'sudo pmset -a displaysleep 15',
    'sudo pmset -c sleep 0',
    'sudo pmset -b sleep 5',
  ],

  'Software updates': [
    'defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true',
    'defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1',
    'defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1',
    'defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1',
  ],

  Misc: [
    // Don’t offer new disks for Time Machine backup
    'defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true',
    // Activity Monitor: show CPU usage in Dock icon, sort by CPU
    'defaults write com.apple.ActivityMonitor IconType -int 5',
    'defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"',
    'defaults write com.apple.ActivityMonitor SortDirection -int 0',
  ],
};

for (const [title, commands] of Object.entries(sections)) {
  step(title);
  for (const command of commands) run(command);
  ok(title);
}

step('Restarting affected apps');
for (const app of ['Finder', 'Dock', 'SystemUIServer']) {
  run(`killall "${app}" > /dev/null 2>&1 || true`);
}

console.log('\n✨ Done. Some changes need a logout/restart to take effect.');
