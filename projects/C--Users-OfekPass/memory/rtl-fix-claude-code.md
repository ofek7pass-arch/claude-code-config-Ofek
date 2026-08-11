---
name: rtl-fix-claude-code
description: "How to make the Claude Code VS Code chat panel RTL — run the managed script, never re-derive the CSS"
metadata: 
  node_type: memory
  type: project
  originSessionId: 384c8d8f-548d-4bdf-a2f7-2755b21a09ab
  modified: 2026-08-11T11:11:13.337Z
---

RTL for the Claude Code VS Code extension is applied by appending a managed CSS block to `webview/index.css` of `~/.vscode/extensions/anthropic.claude-code-*`. Run `powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\scripts\rtl-fix.ps1"` (add `-Revert` to undo), then Reload Window. The script is idempotent and prints `applied/blocks/braces/size`. Re-run after every Claude Code version update, since the update ships a clean `index.css`.

**Why:** on 2026-08-11 an hour was lost re-deriving the CSS three times and injecting JavaScript into `index.js`. The decisive facts, none of which are visible in the code without looking:

- The composer is **two layers**. `.messageInput_*` is a transparent contenteditable (`color:#0000`, caret only); the visible text is painted by `.mentionMirror_*` (`position:absolute; inset:0; pointer-events:none`). Styling `messageInput_` alone moves the caret and nothing visible. This was the actual root cause of every failed attempt.
- `text-align: start` inside an `ltr` block resolves to **left**. `unicode-bidi: plaintext` reorders glyphs but never aligns; right-alignment requires `direction: rtl` on the block. A "plaintext without direction" approach cannot work.
- `direction: rtl` on a flex/grid container reverses item order and flips the mic button and toolbar — apply it only to text tags (`p`, `li`, headings, `blockquote`, `td`, `th`) and the two composer layers.
- Selectors must be hash-agnostic and pair `[class^="x_"]` with `[class*=" x_"]`; `^=` alone misses multi-class elements. This is why no class-name rescanning is needed across versions.
- `index.css` is loaded via `<link rel="stylesheet">` by `getHtmlForWebview` in `extension.js`, so CSS append beats JS injection (no CSP/nonce/timing dependency).

**How to apply:** run the script, verify `applied=True`, tell the user to Reload Window. Do not hand-write CSS, do not scan minified class names, do not inject JS. If it still fails, ask for a Webview DevTools Elements screenshot with a Hebrew line selected rather than guessing again. See [[working-style-ofek]].
