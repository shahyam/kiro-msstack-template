#!/usr/bin/env node
/**
 * Validates .kiro/steering and .kiro/skills markdown files.
 * Checks:
 *  - Steering files have valid front-matter with a known `inclusion` value
 *  - No broken #[[file:...]] references
 *  - Skills files are non-empty markdown
 */

const fs = require('fs');
const path = require('path');

const VALID_INCLUSIONS = ['always', 'fileMatch', 'manual'];
const STEERING_DIR = '.kiro/steering';
const SKILLS_DIR = '.kiro/skills';

let errors = 0;
let warnings = 0;

function log(level, file, msg) {
  const prefix = level === 'ERROR' ? '❌' : '⚠️ ';
  console.log(`${prefix} [${level}] ${file}: ${msg}`);
  if (level === 'ERROR') errors++;
  else warnings++;
}

function parseFrontMatter(content) {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) return null;
  // Simple key: value parser (no full YAML needed)
  const result = {};
  for (const line of match[1].split(/\r?\n/)) {
    const kv = line.match(/^(\w+):\s*['"]?([^'"]+)['"]?$/);
    if (kv) result[kv[1].trim()] = kv[2].trim();
  }
  return result;
}

function validateFileRefs(content, filePath) {
  const refs = [...content.matchAll(/#\[\[file:([^\]]+)\]\]/g)];
  for (const ref of refs) {
    const refPath = ref[1].trim();
    if (!fs.existsSync(refPath)) {
      log('ERROR', filePath, `broken file reference: #[[file:${refPath}]]`);
    }
  }
}

function validateSteeringFiles() {
  if (!fs.existsSync(STEERING_DIR)) {
    console.log(`⚠️  Steering directory not found: ${STEERING_DIR}`);
    return;
  }

  const files = fs.readdirSync(STEERING_DIR).filter(f => f.endsWith('.md'));
  if (files.length === 0) {
    console.log('⚠️  No steering files found.');
    return;
  }

  for (const file of files) {
    const filePath = path.join(STEERING_DIR, file);
    const content = fs.readFileSync(filePath, 'utf8');

    if (content.trim().length === 0) {
      log('ERROR', filePath, 'file is empty');
      continue;
    }

    const fm = parseFrontMatter(content);
    if (!fm) {
      log('WARNING', filePath, 'missing front-matter block (---). Kiro will default to always included.');
    } else {
      if (!fm.inclusion) {
        log('WARNING', filePath, 'front-matter missing `inclusion` key');
      } else if (!VALID_INCLUSIONS.includes(fm.inclusion)) {
        log('ERROR', filePath, `invalid inclusion value "${fm.inclusion}". Must be one of: ${VALID_INCLUSIONS.join(', ')}`);
      }

      if (fm.inclusion === 'fileMatch' && !fm.fileMatchPattern) {
        log('ERROR', filePath, '`inclusion: fileMatch` requires a `fileMatchPattern` key');
      }
    }

    validateFileRefs(content, filePath);
    console.log(`✅ ${filePath}`);
  }
}

function validateSkillsFiles() {
  if (!fs.existsSync(SKILLS_DIR)) {
    console.log(`⚠️  Skills directory not found: ${SKILLS_DIR}`);
    return;
  }

  const files = fs.readdirSync(SKILLS_DIR).filter(f => f.endsWith('.md'));
  if (files.length === 0) {
    console.log('⚠️  No skills files found.');
    return;
  }

  for (const file of files) {
    const filePath = path.join(SKILLS_DIR, file);
    const content = fs.readFileSync(filePath, 'utf8');

    if (content.trim().length === 0) {
      log('ERROR', filePath, 'file is empty');
      continue;
    }

    if (!content.startsWith('# ')) {
      log('WARNING', filePath, 'skills file should start with a top-level heading (# Skill: ...)');
    }

    validateFileRefs(content, filePath);
    console.log(`✅ ${filePath}`);
  }
}

console.log('\n🔍 Validating Kiro steering and skills files...\n');
validateSteeringFiles();
console.log('');
validateSkillsFiles();

console.log(`\n--- Result: ${errors} error(s), ${warnings} warning(s) ---\n`);
if (errors > 0) process.exit(1);
