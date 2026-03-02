---
name: arf
description: Three-phase test-driven bug fix workflow. First write a passing test proving the bug exists, then flip assertions to define correct behavior (fails), then fix the production code. Use when fixing bugs, correcting wrong behavior, or closing gaps in existing logic.
---

# Assert-Refute-Fix

A three-phase workflow for test-driven bug fixes. Each phase requires user confirmation before proceeding to the next.

## Phase 1: ASSERT — Prove the bug exists

1. Read the relevant source code and existing tests to understand the current behavior and why it's wrong.
2. Write a test that **asserts the current (buggy) behavior**. This test passes today, demonstrating the bug is real and reproducible.
3. Name the test to describe the buggy behavior (e.g., "does not restore record when...").
4. Run the test to confirm it passes:
   ```bash
   /opt/dev/bin/dev test <test_file> --name="/<test_name_pattern>/"
   ```
5. Present the passing test to the user. Wait for confirmation before proceeding.

## Phase 2: REFUTE — Assert the correct behavior

1. Update the test name to describe what the behavior **should** be (e.g., "restores record when...").
2. Flip the assertions to assert the correct/desired behavior.
3. Run the test to confirm it now **fails**:
   ```bash
   /opt/dev/bin/dev test <test_file> --name="/<test_name_pattern>/"
   ```
4. Verify the failure is in the assertions about correct behavior, not a setup error or exception.
5. Present the updated test and failure output to the user. Wait for confirmation before proceeding.

## Phase 3: FIX — Make the test pass

1. Make the **smallest change** to production code that causes the failing test to pass.
2. Run the **full test file** to verify the fix doesn't break existing tests:
   ```bash
   /opt/dev/bin/dev test <test_file>
   ```
3. If existing tests break, adjust the fix (not the tests) until everything is green.
4. Present the production code change and green test output to the user.

## Rules

- Do not touch production code during ASSERT or REFUTE phases.
- Do not change tests during the FIX phase.
- Follow project testing conventions (Minitest, Mocha, assertion style, naming, parallel safety).
- Use `ensure` blocks to restore fixture state when modifying records in-place.
