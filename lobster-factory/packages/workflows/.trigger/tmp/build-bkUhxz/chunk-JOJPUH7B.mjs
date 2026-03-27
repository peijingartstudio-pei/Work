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

// src/trigger/create-wp-site.ts
init_esm();
var InputSchema = external_exports.object({
  organizationId: external_exports.string().uuid(),
  workspaceId: external_exports.string().uuid(),
  projectId: external_exports.string().uuid(),
  siteId: external_exports.string().uuid(),
  siteName: external_exports.string().min(1),
  manifestSlug: external_exports.literal("wc-core")
});
var createWpSite = task({
  id: "create-wp-site",
  run: /* @__PURE__ */ __name(async (payload) => {
    const input = InputSchema.parse(payload);
    logger.info("Starting WP site creation", input);
    const workflowRunId = newUuid();
    const dbWorkflowRunInsert = buildWorkflowRunInsertSql({
      id: workflowRunId,
      workflowVersionId: LobsterCatalogIds.workflows.createWpSiteWorkflowVersionId,
      organizationId: input.organizationId,
      workspaceId: input.workspaceId,
      projectId: input.projectId,
      siteId: input.siteId,
      environmentId: null,
      parentRunId: null,
      triggerType: "create-wp-site",
      triggerRef: input.siteName,
      actorType: "system",
      actorRef: null,
      status: "pending",
      riskLevel: "medium",
      inputSnapshot: input,
      outputSnapshot: {},
      artifacts: []
    });
    const enableWrites = (process.env.LOBSTER_ENABLE_DB_WRITES || "").toLowerCase() === "true" || (process.env.LOBSTER_ENABLE_DB_WRITES || "") === "1";
    let executed = false;
    if (enableWrites) {
      const supabaseUrl = process.env.LOBSTER_SUPABASE_URL || "";
      const serviceRoleKey = process.env.LOBSTER_SUPABASE_SERVICE_ROLE_KEY || "";
      if (!supabaseUrl || !serviceRoleKey) {
        throw new Error(
          "LOBSTER_ENABLE_DB_WRITES=true but missing LOBSTER_SUPABASE_URL or LOBSTER_SUPABASE_SERVICE_ROLE_KEY"
        );
      }
      const workflowRunRow = buildWorkflowRunRow(dbWorkflowRunInsert.spec);
      await supabaseRestInsert(
        { supabaseUrl, serviceRoleKey },
        "workflow_runs",
        workflowRunRow
      );
      executed = true;
    }
    const next = {
      createStagingEnvironmentRecord: "TODO",
      createWpRootOnHostingProvider: "TODO",
      installWordPress: "TODO",
      applyManifestViaWorkflow: {
        workflowId: "apply-manifest",
        manifestSlug: input.manifestSlug,
        // At runtime, environmentId comes from createStagingEnvironmentRecord.
        environmentId: "createStagingEnvironmentRecord.environmentId",
        organizationId: input.organizationId,
        workspaceId: input.workspaceId,
        projectId: input.projectId,
        siteId: input.siteId
      },
      runSmokeTests: "TODO",
      writeArtifactsAndLogs: "TODO",
      db: {
        workflowRunInsert: dbWorkflowRunInsert,
        workflowRunRow: buildWorkflowRunRow(dbWorkflowRunInsert.spec),
        packageInstallRunWritePoint: "TODO",
        runOutputWritePoint: "TODO",
        writeExecution: {
          enabled: enableWrites,
          executed,
          insertedWorkflowRunId: workflowRunId
        }
      }
    };
    return {
      status: "pending_next_step",
      input,
      next
    };
  }, "run")
});

export {
  createWpSite
};
//# sourceMappingURL=chunk-JOJPUH7B.mjs.map
