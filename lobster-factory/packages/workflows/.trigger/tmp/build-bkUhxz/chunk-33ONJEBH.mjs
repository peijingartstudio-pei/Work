import {
  __name,
  init_esm
} from "./chunk-J4P35T43.mjs";

// src/utils/uid.ts
init_esm();
function newUuid() {
  return crypto.randomUUID();
}
__name(newUuid, "newUuid");

// src/db/sql/workflowRunsSql.ts
init_esm();
function buildWorkflowRunInsertSql(spec) {
  const columns = [
    "id",
    "workflow_version_id",
    "organization_id",
    "workspace_id",
    "project_id",
    "site_id",
    "environment_id",
    "parent_run_id",
    "trigger_type",
    "trigger_ref",
    "actor_type",
    "actor_ref",
    "status",
    "risk_level",
    "input_snapshot",
    "output_snapshot",
    "artifacts"
  ];
  const values = [
    `'${spec.id}'`,
    `'${spec.workflowVersionId}'`,
    `'${spec.organizationId}'`,
    spec.workspaceId ? `'${spec.workspaceId}'` : "NULL",
    spec.projectId ? `'${spec.projectId}'` : "NULL",
    spec.siteId ? `'${spec.siteId}'` : "NULL",
    spec.environmentId ? `'${spec.environmentId}'` : "NULL",
    spec.parentRunId ? `'${spec.parentRunId}'` : "NULL",
    `'${spec.triggerType}'`,
    spec.triggerRef ? `'${spec.triggerRef}'` : "NULL",
    `'${spec.actorType}'`,
    spec.actorRef ? `'${spec.actorRef}'` : "NULL",
    `'${spec.status}'`,
    `'${spec.riskLevel}'`,
    `'${JSON.stringify(spec.inputSnapshot).replace(/'/g, "''")}'::jsonb`,
    `'${JSON.stringify(spec.outputSnapshot).replace(/'/g, "''")}'::jsonb`,
    `'${JSON.stringify(spec.artifacts).replace(/'/g, "''")}'::jsonb`
  ];
  return {
    sql: `insert into workflow_runs (${columns.join(", ")}) values (${values.join(", ")}) returning id;`,
    spec
  };
}
__name(buildWorkflowRunInsertSql, "buildWorkflowRunInsertSql");
function buildWorkflowRunRow(spec) {
  return {
    id: spec.id,
    workflow_version_id: spec.workflowVersionId,
    organization_id: spec.organizationId,
    workspace_id: spec.workspaceId,
    project_id: spec.projectId,
    site_id: spec.siteId,
    environment_id: spec.environmentId,
    parent_run_id: spec.parentRunId,
    trigger_type: spec.triggerType,
    trigger_ref: spec.triggerRef,
    actor_type: spec.actorType,
    actor_ref: spec.actorRef,
    status: spec.status,
    risk_level: spec.riskLevel,
    input_snapshot: spec.inputSnapshot,
    output_snapshot: spec.outputSnapshot,
    artifacts: spec.artifacts
  };
}
__name(buildWorkflowRunRow, "buildWorkflowRunRow");

// src/db/catalogIds.ts
init_esm();
var LobsterCatalogIds = {
  wcCore: {
    packageVersionId: "9819a867-36b9-4470-bdb9-611a0751dba6",
    manifestId: "8760d0ba-35ae-483a-8fa6-abd19f5c6d4d"
  },
  workflows: {
    createWpSiteWorkflowVersionId: "d6d3cfe2-5aba-4458-84a6-37237d6df347",
    applyManifestWorkflowVersionId: "0161fdd2-2381-4ab5-bcf9-fe247507ac05"
  }
};

// src/db/supabase/supabaseRestInsert.ts
init_esm();
var sleep = /* @__PURE__ */ __name((ms) => new Promise((resolve) => setTimeout(resolve, ms)), "sleep");
async function supabaseRestInsert(config, table, row, options = {}) {
  const fetchImpl = globalThis.fetch;
  if (!fetchImpl) throw new Error("global fetch is not available in this runtime");
  const maxRetries = Math.max(0, Number(options.maxRetries ?? 2));
  const baseDelayMs = Math.max(50, Number(options.baseDelayMs ?? 250));
  const traceId = options.traceId ?? `trace-${Date.now()}`;
  let lastError = "";
  for (let attempt = 0; attempt <= maxRetries; attempt += 1) {
    const res = await fetchImpl(`${config.supabaseUrl}/rest/v1/${table}`, {
      method: "POST",
      headers: {
        apikey: config.serviceRoleKey,
        Authorization: `Bearer ${config.serviceRoleKey}`,
        "Content-Type": "application/json",
        Prefer: "return=representation",
        "x-lobster-trace-id": traceId
      },
      body: JSON.stringify([row])
    });
    if (res.ok) {
      options.onAttempt?.({ attempt, table, traceId, status: res.status });
      const json = await res.json();
      return json;
    }
    const text = await res.text().catch(() => "");
    lastError = `${res.status} ${res.statusText} ${text}`.trim();
    options.onAttempt?.({
      attempt,
      table,
      traceId,
      status: res.status,
      error: lastError
    });
    const retryable = res.status >= 500 || res.status === 429;
    if (!retryable || attempt >= maxRetries) break;
    const delay = baseDelayMs * 2 ** attempt;
    await sleep(delay);
  }
  throw new Error(
    `Supabase REST insert failed for ${table} [traceId=${traceId}] after ${maxRetries + 1} attempts: ${lastError}`
  );
}
__name(supabaseRestInsert, "supabaseRestInsert");

export {
  newUuid,
  buildWorkflowRunInsertSql,
  buildWorkflowRunRow,
  LobsterCatalogIds,
  supabaseRestInsert
};
//# sourceMappingURL=chunk-33ONJEBH.mjs.map
