---
name: add-e2e-test
description: "Record a browser flow with Playwright codegen and write it up as an E2E spec under apps/sonora/e2e/tests. Use when adding a new end-to-end test."
disable-model-invocation: true
argument-hint: <test name>
---

# Add E2E Test

Create a new Playwright E2E test. `$ARGUMENTS` is the test name.

> **The spec is written FROM A LIVE CODEGEN RECORDING, never from reading source.**
> This is non-negotiable. Reading `.tsx`/route source to *infer* the flow and writing the
> spec from that understanding is forbidden, no matter how well you think you know the app.
> Codegen is not optional. If you cannot launch it (no display, command fails, user
> declines), STOP and tell the user; do not substitute source-reading. Steps run in order:
> do not reach step 4 until codegen (step 3) has actually run and you hold the recording.

## Steps

1. Confirm the dev server is up (`$PORT` set and reachable). If not, tell the user to run
   `pnpm dev` first and stop. For reliable first-loads under test, start it as
   `E2E_WARMUP=1 pnpm dev`, which eagerly compiles every route at boot (Vite otherwise
   compiles them lazily on first request, so a cold route can fail the first time it loads).
2. Provision a throwaway tenant to record against (there is no shared session; every tenant
   is created on demand): `pnpm --filter sonora exec run scripts/e2e-tenant.ts create` prints
   `{ tenantId, subdomain, loginUrl }`. Keep the `loginUrl` and `tenantId`.
3. Launch Playwright codegen at that `loginUrl` (a no-email `/auth/magic` confirm page on the
   tenant's subdomain):
   `pnpm --filter sonora exec playwright codegen -o e2e/.codegen-recording.ts "<loginUrl>"`
   In the codegen browser, click **Continue** once to land authenticated, then record the flow.

   **`-o` is mandatory.** Codegen keeps the generated code only in the Inspector GUI and
   prints nothing to stdout, so without `-o` the recording is lost when the window closes.
   Its path is relative to `apps/sonora` (the `pnpm --filter sonora exec` cwd): write `e2e/…`,
   NOT `apps/sonora/e2e/…`. (`.codegen-recording.ts` sits at the `e2e/` root, outside the
   `e2e/tests/` glob, so the suite never picks it up.)

   Launch it, then **wait for the user to finish recording and close the window** (the
   background command exits when they do). The recorded file is the sole input to step 4.
   Afterward, drop the recording tenant: `pnpm --filter sonora exec run scripts/e2e-tenant.ts destroy <tenantId>`.
4. Read the recorded actions from `apps/sonora/e2e/.codegen-recording.ts`. If it is missing
   or empty, the recording failed: STOP and tell the user; do not invent the flow. From those
   recorded actions **and nothing else**, write the spec to
   `apps/sonora/e2e/tests/<name>.spec.ts`. Import `test`/`expect` from `../helpers/tenant`:
   every E2E test runs on its own freshly provisioned, seeded throwaway tenant (dropped on
   teardown), so tests never share or pollute state. See
   `apps/sonora/e2e/tests/enrichment-versioning.spec.ts` for the pattern.

   ```ts
   import { expect, test } from "../helpers/tenant";

   test("<what this verifies>", async ({ page }) => {
     await test.step("<an action, in words>", async () => {
       // driving code from the recording
       await expect(/* ... */).toBeVisible(); // <a condition to check, in words>
       await test.info().attach("<what this capture should show>", {
         body: await page.screenshot(),
         contentType: "image/png",
       });
     });
   });
   ```

5. Run it: `pnpm --filter sonora test:e2e`. View the report with
   `pnpm --filter sonora exec playwright show-report`.

## Report conventions

The run produces Playwright's built-in HTML report (`playwright show-report`), which renders
the `test`/`test.step` tree and any attachments. Two conventions keep it readable:

- **`test()` / `test.step()` titles ARE the labels.** Write them as plain, observable intent,
  one `step` per meaningful action. Keep them concrete.
- **Success screenshots are only what you attach** via `test.info().attach(...)` (the config
  auto-captures only on failure). Place each attach where the result is *visibly* on screen
  (e.g. open the "Columns" toggle to show a deleted column is gone), not behind a hidden
  assertion. If the user has not said what a screenshot should show, ask (use the question UI)
  before writing the spec.
