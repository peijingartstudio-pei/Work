# Release Gates Checklist (Required)

> Use this checklist before any production deployment.

## Context

- Tenant:
- Site:
- Release ID:
- Target environment: staging -> production
- Change owner:
- Planned window:

## Pre-Deployment Gates (must be PASS)

- [ ] **Backup Gate**: fresh DB + uploads backup exists and is restorable.
- [ ] **Security Gate**: admin access, MFA policy, secret handling verified.
- [ ] **Compatibility Gate**: WP/theme/plugins version compatibility confirmed.
- [ ] **Function Gate**: key user flows pass on staging.
- [ ] **Rollback Gate**: rollback steps tested or validated with evidence.

## Deployment Decision

- Decision: GO / NO-GO
- Approver:
- Timestamp:
- Reason:

## Post-Deployment Checks

- [ ] Homepage available
- [ ] Admin login works
- [ ] Primary conversion path works
- [ ] Error logs show no critical spikes

## Evidence Links

- Backup proof:
- Preflight result:
- Postcheck result:
- Rollback procedure:
