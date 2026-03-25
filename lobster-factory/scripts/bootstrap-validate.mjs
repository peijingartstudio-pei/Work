import { execSync } from "node:child_process";
import path from "node:path";
import fs from "node:fs";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, "..");

function assertExists(relPath) {
  const p = path.join(repoRoot, relPath);
  if (!fs.existsSync(p)) {
    throw new Error(`Missing required file: ${relPath} (${p})`);
  }
}

// 1) structural presence checks
const required = [
  "packages/db/migrations/0001_core.sql",
  "packages/db/migrations/0002_factory.sql",
  "packages/db/migrations/0003_agents_approvals_observability.sql",
  "packages/db/migrations/0004_rls_helpers.sql",
  "packages/db/migrations/0005_seed_minimum.sql",
  "packages/db/migrations/0006_seed_catalog.sql",
  "packages/manifests/wc-core.json",
  "packages/agents/src/configs/repair-agent.json",
  "packages/policies/approval/production-deploy-policy.json",
  "packages/policies/tool/repair-agent-policy.json",
  "scripts/validate-manifests.mjs",
  "scripts/validate-governance-configs.mjs",
];

for (const r of required) assertExists(r);

// 2) run content validation
console.log("Running manifest validation...");
execSync(`node "${path.join(repoRoot, "scripts", "validate-manifests.mjs")}"`, {
  stdio: "inherit",
});

console.log("Running governance validation...");
execSync(`node "${path.join(repoRoot, "scripts", "validate-governance-configs.mjs")}"`, {
  stdio: "inherit",
});

console.log("Bootstrap validation PASSED ✅");

