export type SupabaseRestConfig = {
  supabaseUrl: string;
  serviceRoleKey: string;
};

/**
 * Phase 1: do not call by default.
 * This adapter exists so later you can execute the returned row payloads via PostgREST.
 */
export async function supabaseRestInsert(
  config: SupabaseRestConfig,
  table: string,
  row: Record<string, unknown>
) {
  const fetchImpl = (globalThis as any).fetch as typeof fetch;
  if (!fetchImpl) throw new Error("global fetch is not available in this runtime");

  const res = await fetchImpl(`${config.supabaseUrl}/rest/v1/${table}`, {
    method: "POST",
    headers: {
      apikey: config.serviceRoleKey,
      Authorization: `Bearer ${config.serviceRoleKey}`,
      "Content-Type": "application/json",
      Prefer: "return=representation",
    },
    body: JSON.stringify([row]),
  });

  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(
      `Supabase REST insert failed for ${table}: ${res.status} ${res.statusText} ${text}`
    );
  }

  const json = (await res.json()) as unknown;
  return json;
}

