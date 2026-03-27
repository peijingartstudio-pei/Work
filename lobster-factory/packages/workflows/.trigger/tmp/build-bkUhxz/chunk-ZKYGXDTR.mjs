import {
  LobsterCatalogIds,
  buildWorkflowRunInsertSql,
  buildWorkflowRunRow,
  newUuid,
  supabaseRestInsert
} from "./chunk-33ONJEBH.mjs";
import {
  task
} from "./chunk-C6SFAHUG.mjs";
import {
  external_exports,
  logger
} from "./chunk-SZHP2B4O.mjs";
import {
  __name,
  init_esm
} from "./chunk-J4P35T43.mjs";

// src/trigger/apply-manifest.ts
init_esm();
import fs from "node:fs/promises";
import path from "node:path";

// src/db/sql/packageInstallRunsSql.ts
init_esm();
function buildPackageInstallRunInsertSql(spec) {
  const columns = [
    "id",
    "organization_id",
    "workspace_id",
    "site_id",
    "environment_id",
    "package_version_id",
    "manifest_id",
    "workflow_run_id",
    "triggered_by_user_id",
    "triggered_by_agent_id",
    "status",
    "result_summary",
    "logs_ref",
    "rollback_run_id",
    "metadata"
  ];
  const values = [
    `'${spec.id}'`,
    `'${spec.organizationId}'`,
    `'${spec.workspaceId}'`,
    `'${spec.siteId}'`,
    `'${spec.environmentId}'`,
    `'${spec.packageVersionId}'`,
    `'${spec.manifestId}'`,
    spec.workflowRunId ? `'${spec.workflowRunId}'` : "NULL",
    spec.triggeredByUserId ? `'${spec.triggeredByUserId}'` : "NULL",
    spec.triggeredByAgentId ? `'${spec.triggeredByAgentId}'` : "NULL",
    `'${spec.status}'`,
    `'${JSON.stringify(spec.resultSummary).replace(/'/g, "''")}'::jsonb`,
    spec.logsRef ? `'${spec.logsRef}'` : "NULL",
    spec.rollbackRunId ? `'${spec.rollbackRunId}'` : "NULL",
    `'${JSON.stringify(spec.metadata).replace(/'/g, "''")}'::jsonb`
  ];
  return {
    sql: `insert into package_install_runs (${columns.join(", ")}) values (${values.join(
      ", "
    )}) returning id;`,
    spec
  };
}
__name(buildPackageInstallRunInsertSql, "buildPackageInstallRunInsertSql");
function buildPackageInstallRunRow(spec) {
  return {
    id: spec.id,
    organization_id: spec.organizationId,
    workspace_id: spec.workspaceId,
    site_id: spec.siteId,
    environment_id: spec.environmentId,
    package_version_id: spec.packageVersionId,
    manifest_id: spec.manifestId,
    workflow_run_id: spec.workflowRunId,
    triggered_by_user_id: spec.triggeredByUserId,
    triggered_by_agent_id: spec.triggeredByAgentId ?? null,
    status: spec.status,
    result_summary: spec.resultSummary,
    logs_ref: spec.logsRef,
    rollback_run_id: spec.rollbackRunId,
    metadata: spec.metadata
  };
}
__name(buildPackageInstallRunRow, "buildPackageInstallRunRow");

// src/trigger/apply-manifest.ts
var InputSchema = external_exports.object({
  // Used for multi-tenant FK fields when we later enable DB writes.
  organizationId: external_exports.string().uuid(),
  workspaceId: external_exports.string().uuid(),
  projectId: external_exports.string().uuid(),
  siteId: external_exports.string().uuid(),
  environmentId: external_exports.string().uuid(),
  wpRootPath: external_exports.string().min(1),
  manifestPath: external_exports.string().min(1),
  environmentType: external_exports.enum(["staging", "production"])
});
var ManifestStepSchema = external_exports.object({
  id: external_exports.string(),
  type: external_exports.enum(["install_theme", "install_plugin", "conditional_plugin"]),
  slug: external_exports.string().optional(),
  condition: external_exports.string().optional()
});
var ManifestSchema = external_exports.object({
  name: external_exports.string(),
  version: external_exports.string(),
  schemaVersion: external_exports.string(),
  target: external_exports.literal("staging-only"),
  description: external_exports.string().optional(),
  guardrails: external_exports.object({
    allowEnvironments: external_exports.array(external_exports.string()),
    requireBackup: external_exports.boolean(),
    blockIfProduction: external_exports.boolean()
  }),
  dependencies: external_exports.array(external_exports.unknown()),
  conflicts: external_exports.array(external_exports.unknown()),
  steps: external_exports.array(ManifestStepSchema).min(1),
  postInstall: external_exports.array(external_exports.record(external_exports.unknown())).optional(),
  verification: external_exports.array(external_exports.record(external_exports.unknown())).optional(),
  rollback: external_exports.object({
    strategy: external_exports.string()
  }).optional()
});
function buildInstallPlan(manifest) {
  return {
    name: manifest.name,
    version: manifest.version,
    steps: manifest.steps,
    postInstall: manifest.postInstall ?? [],
    verification: manifest.verification ?? [],
    rollback: manifest.rollback ?? { strategy: "restore_backup_snapshot" },
    // Keep guardrails in the plan so the shell adapter can enforce them too.
    guardrails: manifest.guardrails
  };
}
__name(buildInstallPlan, "buildInstallPlan");
var applyManifest = task({
  id: "apply-manifest",
  run: /* @__PURE__ */ __name(async (payload) => {
    const input = InputSchema.parse(payload);
    if (input.environmentType !== "staging") {
      throw new Error("Manifest install is blocked outside staging");
    }
    const raw = await fs.readFile(path.resolve(input.manifestPath), "utf8");
    const parsedRaw = JSON.parse(raw);
    const manifest = ManifestSchema.parse(parsedRaw);
    if (manifest.name !== "wc-core") {
      throw new Error(
        `Phase 1 apply-manifest only supports manifest.name="wc-core" (got "${manifest.name}")`
      );
    }
    if (!manifest.guardrails.blockIfProduction) {
      throw new Error("Manifest guardrails: blockIfProduction must be true");
    }
    if (!manifest.guardrails.allowEnvironments.includes("staging")) {
      throw new Error("Manifest guardrails: allowEnvironments must include staging");
    }
    logger.info("Loaded manifest", {
      // schema-level validation happens later in the API layer
      manifest: {
        name: manifest?.name,
        version: manifest?.version
      }
    });
    const installPlan = buildInstallPlan(manifest);
    const workflowRunId = newUuid();
    const dbWorkflowRunInsert = buildWorkflowRunInsertSql({
      id: workflowRunId,
      workflowVersionId: LobsterCatalogIds.workflows.applyManifestWorkflowVersionId,
      organizationId: input.organizationId,
      workspaceId: input.workspaceId,
      projectId: input.projectId,
      siteId: input.siteId,
      environmentId: input.environmentId,
      parentRunId: null,
      triggerType: "apply-manifest",
      triggerRef: input.manifestPath,
      actorType: "system",
      actorRef: null,
      status: "pending",
      riskLevel: "medium",
      inputSnapshot: {
        environmentId: input.environmentId,
        organizationId: input.organizationId,
        workspaceId: input.workspaceId,
        projectId: input.projectId,
        siteId: input.siteId,
        wpRootPath: input.wpRootPath,
        manifestPath: input.manifestPath,
        environmentType: input.environmentType
      },
      outputSnapshot: {},
      artifacts: []
    });
    const packageInstallRunId = newUuid();
    const dbPackageInstallRunInsert = buildPackageInstallRunInsertSql({
      id: packageInstallRunId,
      organizationId: input.organizationId,
      workspaceId: input.workspaceId,
      siteId: input.siteId,
      environmentId: input.environmentId,
      packageVersionId: LobsterCatalogIds.wcCore.packageVersionId,
      manifestId: LobsterCatalogIds.wcCore.manifestId,
      workflowRunId,
      triggeredByUserId: null,
      triggeredByAgentId: null,
      status: "pending",
      resultSummary: {},
      logsRef: null,
      rollbackRunId: null,
      metadata: {
        manifestPath: input.manifestPath,
        wpRootPath: input.wpRootPath,
        environmentType: input.environmentType
      }
    });
    const enableWrites = (process.env.LOBSTER_ENABLE_DB_WRITES || "").toLowerCase() === "true" || (process.env.LOBSTER_ENABLE_DB_WRITES || "") === "1";
    const dbWriteExecution = enableWrites ? (() => {
      const supabaseUrl = process.env.LOBSTER_SUPABASE_URL || "";
      const serviceRoleKey = process.env.LOBSTER_SUPABASE_SERVICE_ROLE_KEY || "";
      if (!supabaseUrl || !serviceRoleKey) {
        throw new Error(
          "LOBSTER_ENABLE_DB_WRITES=true but missing LOBSTER_SUPABASE_URL or LOBSTER_SUPABASE_SERVICE_ROLE_KEY"
        );
      }
      return {
        supabaseUrl,
        serviceRoleKey,
        enabled: true
      };
    })() : { enabled: false };
    let executed = false;
    if (enableWrites) {
      const workflowRunRow = buildWorkflowRunRow(dbWorkflowRunInsert.spec);
      const packageInstallRunRow = buildPackageInstallRunRow(
        dbPackageInstallRunInsert.spec
      );
      const resWorkflow = await supabaseRestInsert(
        { supabaseUrl: dbWriteExecution.supabaseUrl, serviceRoleKey: dbWriteExecution.serviceRoleKey },
        "workflow_runs",
        workflowRunRow
      );
      const resPackage = await supabaseRestInsert(
        { supabaseUrl: dbWriteExecution.supabaseUrl, serviceRoleKey: dbWriteExecution.serviceRoleKey },
        "package_install_runs",
        packageInstallRunRow
      );
      executed = true;
      logger.info("DB inserts executed (optional)", {
        workflowRunId,
        packageInstallRunId,
        workflowInsertResponseType: typeof resWorkflow,
        packageInsertResponseType: typeof resPackage
      });
    }
    return {
      status: "pending_shell_execution",
      manifest: {
        name: manifest.name,
        version: manifest.version,
        target: manifest.target
      },
      installPlan,
      input,
      // Phase 1: write points (templates only).
      db: {
        workflowRunInsert: dbWorkflowRunInsert,
        packageInstallRunInsert: dbPackageInstallRunInsert,
        workflowRunRow: buildWorkflowRunRow(dbWorkflowRunInsert.spec),
        packageInstallRunRow: buildPackageInstallRunRow(dbPackageInstallRunInsert.spec),
        packageInstallRunWritePoint: "adapter optional (PostgREST insert) + status updates",
        writeExecution: {
          enabled: enableWrites,
          executed,
          insertedWorkflowRunId: workflowRunId,
          insertedPackageInstallRunId: packageInstallRunId
        }
      }
    };
  }, "run")
});

export {
  applyManifest
};
//# sourceMappingURL=chunk-ZKYGXDTR.mjs.map
