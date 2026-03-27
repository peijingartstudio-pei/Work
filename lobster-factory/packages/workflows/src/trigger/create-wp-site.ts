import { task, logger } from "@trigger.dev/sdk";
import { z } from "zod";
import { newUuid } from "../utils/uid";
import { buildWorkflowRunInsertSql } from "../db/sql/workflowRunsSql";
import { buildWorkflowRunRow } from "../db/sql/workflowRunsSql";
import { LobsterCatalogIds } from "../db/catalogIds";
import { supabaseRestInsert } from "../db/supabase/supabaseRestInsert";

const InputSchema = z.object({
  organizationId: z.string().uuid(),
  workspaceId: z.string().uuid(),
  projectId: z.string().uuid(),
  siteId: z.string().uuid(),
  siteName: z.string().min(1),
  manifestSlug: z.literal("wc-core"),
});

/**
 * Durable workflow: create staging environment record + provision WP + apply manifest.
 *
 * Phase 1 intentionally keeps DB persistence + hosting adapter as placeholders.
 * Guardrails: all steps must be staging-only.
 */
export const createWpSite = task({
  id: "create-wp-site",
  run: async (payload: unknown) => {
    const input = InputSchema.parse(payload);

    logger.info("Starting WP site creation", input);

    // Phase 1: emit DB insert templates (do not execute).
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
      artifacts: [],
    });

    const enableWrites =
      (process.env.LOBSTER_ENABLE_DB_WRITES || "").toLowerCase() === "true" ||
      (process.env.LOBSTER_ENABLE_DB_WRITES || "") === "1";
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

    // Phase 1: keep side effects out. Return a structured plan and clear "write points".
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
        siteId: input.siteId,
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
          insertedWorkflowRunId: workflowRunId,
        },
      },
    };

    return {
      status: "pending_next_step" as const,
      input,
      next,
    };
  },
});

