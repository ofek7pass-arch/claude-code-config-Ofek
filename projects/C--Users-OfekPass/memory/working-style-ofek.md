---
name: working-style-ofek
description: "Ofek expects existing tooling to be used before anything new is written, and verification before any success claim"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 384c8d8f-548d-4bdf-a2f7-2755b21a09ab
  modified: 2026-08-11T11:11:27.287Z
---

When a fix already exists as an installed script or command, run it — do not re-derive the solution. Verify against the real code (the actual CSS/DOM) before applying a change, and never report success without a concrete check backing it.

**Why:** stated sharply on 2026-08-11 during the RTL work ("למה אתה ממציא את הגלגל", "אל תחזור אליי בכלל בלי הצלחה בדוקה"). Three rounds of guessed CSS were shipped and announced as fixes before anyone looked at which element actually renders the visible text. The second round actively made things worse. The cost was not the bug — it was announcing a fix three times without evidence.

**How to apply:** first check whether a script/command already covers the task (`~/.claude/commands`, `~/.claude/scripts`, `~/.claude/skills`) and run it. When something does not work, get ground truth — read the real stylesheet, ask for a DevTools screenshot — before writing another attempt. State plainly what was verified and what was not; a static check is not a visual confirmation, and saying so is required. Reply in Hebrew. See [[rtl-fix-claude-code]].
