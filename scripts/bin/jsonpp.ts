#!/usr/bin/env node
// Pretty-print JSON from a pipe or a file — run: cat data.json | jsonpp [--compact]
// Also handy for APIs: curl -s ipinfo.io | jsonpp

import { readFileSync } from 'node:fs';

const args = process.argv.slice(2);
const compact = args.includes('--compact');
const file = args.find((arg) => !arg.startsWith('-'));

const input = file ? readFileSync(file, 'utf8') : readFileSync(0, 'utf8');

if (!input.trim()) {
  console.error('jsonpp: no input — pipe JSON in or pass a file path');
  process.exit(1);
}

let data: unknown;

try {
  data = JSON.parse(input);
} catch (error) {
  console.error(`jsonpp: invalid JSON — ${(error as Error).message}`);
  process.exit(1);
}

const output = JSON.stringify(data, null, compact ? 0 : 2);

// Colorize only for a terminal, so `jsonpp | grep` and redirects stay clean.
console.log(process.stdout.isTTY ? colorize(output) : output);

function colorize(json: string): string {
  const green = (s: string) => `\x1b[32m${s}\x1b[0m`;
  const yellow = (s: string) => `\x1b[33m${s}\x1b[0m`;
  const magenta = (s: string) => `\x1b[35m${s}\x1b[0m`;
  const cyan = (s: string) => `\x1b[36m${s}\x1b[0m`;

  return json.replace(
    /("(\\.|[^"\\])*")(\s*:)?|\b(true|false|null)\b|-?\d+(\.\d+)?([eE][+-]?\d+)?/g,
    (match, string, _escape, colon) => {
      if (string) return colon ? `${cyan(string)}${colon}` : green(string);
      if (match === 'true' || match === 'false' || match === 'null') return magenta(match);
      return yellow(match);
    },
  );
}
