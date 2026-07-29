#!/usr/bin/env node
// Show what is listening on TCP ports — run: ports [filter]
// The filter matches a port number or a process name: ports 3000, ports node

import { probe, warn } from '../lib/utils.ts';

type Listener = {
  port: number;
  address: string;
  command: string;
  pid: string;
  user: string;
};

const filter = process.argv.slice(2).find((arg) => !arg.startsWith('-'));

// +c 0 keeps full process names — lsof truncates them to 9 characters by default.
const { ok, output } = probe('lsof -nP +c 0 -iTCP -sTCP:LISTEN');

if (!ok && !output.trim()) {
  warn('lsof returned nothing — nothing is listening, or it needs sudo for other users');
  process.exit(1);
}

const listeners: Listener[] = [];

// A row looks like: node 18896 slavarazum 14u IPv4 0x49… 0t0 TCP 127.0.0.1:64915 (LISTEN)
const seen = new Set<string>();

for (const line of output.split('\n').slice(1)) {
  const columns = line.trim().split(/\s+/).filter((column) => column !== '(LISTEN)');
  if (columns.length < 9) continue;

  const [command, pid, user] = columns;
  const name = columns.at(-1)!;
  const port = Number(name.split(':').at(-1));
  if (!Number.isFinite(port)) continue;

  // IPv4 and IPv6 bindings show up as separate rows for the same socket.
  const key = `${pid}:${port}`;
  if (seen.has(key)) continue;
  seen.add(key);

  listeners.push({
    port,
    address: name.slice(0, name.lastIndexOf(':')) || '*',
    command: command!.replaceAll('\\x20', ' '),
    pid: pid!,
    user: user!,
  });
}

const matched = listeners
  .filter(({ port, command }) => {
    if (!filter) return true;
    return String(port) === filter || command.toLowerCase().includes(filter.toLowerCase());
  })
  .sort((a, b) => a.port - b.port);

if (matched.length === 0) {
  console.log(filter ? `Nothing listening matches "${filter}"` : 'Nothing is listening on TCP');
  process.exit(0);
}

const dim = (s: string) => `\x1b[2m${s}\x1b[0m`;
const cyan = (s: string) => `\x1b[36m${s}\x1b[0m`;

const columns = [
  { header: 'PORT', value: (l: Listener) => String(l.port), paint: cyan },
  { header: 'PROCESS', value: (l: Listener) => l.command },
  { header: 'PID', value: (l: Listener) => l.pid, paint: dim },
  { header: 'USER', value: (l: Listener) => l.user, paint: dim },
  { header: 'ADDRESS', value: (l: Listener) => l.address, paint: dim },
];

const widths = columns.map((column) =>
  Math.max(column.header.length, ...matched.map((l) => column.value(l).length)),
);

const row = (cells: string[], paint = false) =>
  cells
    .map((cell, i) => {
      const padded = cell.padEnd(widths[i]!);
      const paintCell = columns[i]!.paint;
      return paint && paintCell ? paintCell(padded) : padded;
    })
    .join('  ')
    .trimEnd();

console.log(dim(row(columns.map((column) => column.header))));
for (const listener of matched) {
  console.log(row(columns.map((column) => column.value(listener)), true));
}
