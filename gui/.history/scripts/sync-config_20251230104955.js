import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Read project config
const configPath = join(__dirname, '..', '..', 'project-config.json');
const config = JSON.parse(readFileSync(configPath, 'utf-8'));

// Read package.json
const packagePath = join(__dirname, '..', 'package.json');
const pkg = JSON.parse(readFileSync(packagePath, 'utf-8'));

// Update package.json with project config
pkg.name = `${config.project.name.toLowerCase().replace(/_/g, '-')}-gui`;
pkg.version = config.project.version;
pkg.description = `GUI for ${config.project.displayName}`;

// Write updated package.json
import { writeFileSync } from 'fs';
writeFileSync(packagePath, JSON.stringify(pkg, null, 2) + '\n');

console.log(`✓ Updated package.json: ${pkg.name}@${pkg.version}`);
