#!/usr/bin/env node
// Smoke test for TypeScript-on-PATH — run: hello [name] [--loud]

import { ok, step, warn } from '../lib/utils.ts';

type Greeting = {
  name: string;
  loud: boolean;
};

const args = process.argv.slice(2);

const greeting: Greeting = {
  name: args.find((arg) => !arg.startsWith('-')) ?? 'world',
  loud: args.includes('--loud'),
};

const message = `Hello, ${greeting.name}!`;

step('Running a TypeScript command straight from zsh');
ok(greeting.loud ? message.toUpperCase() : message);
ok(`Node ${process.version} — types stripped at runtime, no build step`);

if (args.includes('--fail')) {
  warn('Exiting with code 1 so you can check $? in the shell');
  process.exit(1);
}
