# TachoBook — Claude Code Environment Setup Record

Recorded: 2026-10-17 · Executor: Claude Code (Claude Opus 5.5, `claude-opus-5-5`) in the Claude desktop app (Code tab)
Project: `/Users/sorlenko/iOSDev/TachoBook/claude/TachoBookByClaude` (independent Xcode project, no Git remote)
Baseline commit: `e0c1cb939f034a92d743943352e0d65af675309a` ("Initial Commit", branch `main`)

Status legend: **TESTED** = exercised successfully in this session · **CONNECTED** = reachable/authenticated, not fully exercised · **CONFIGURED** = present in config only · **NOT AVAILABLE** · **NOT TESTED**

## A. Environment

| Component | Version |
| --- | --- |
| macOS | 26.6.2 (25G83) |
| Xcode | 26.6 (17F113), developer dir `/Applications/Xcode.app/Contents/Developer` |
| Swift | 6.3.3 (swiftlang-6.3.3.1.3), target arm64-apple-macosx26.0 |
| Claude Code CLI | 2.1.121 |
| Git | 2.50.1 (Apple Git-155) |
| GitHub CLI (`gh`) | NOT AVAILABLE (not installed) |
| Node.js / npx | v24.15.0 / 11.12.1 |
| Skills CLI | `skills@1.7.2` via `npx` (vercel-labs/skills) |
| iOS runtimes | 26.2, 26.4, 26.4.1, 26.5 |

Project facts: scheme `TachoBookByClaude`; targets `TachoBookByClaude`, `TachoBookByClaudeTests` (Swift Testing), `TachoBookByClaudeUITests` (XCTest UI); deployment target iOS 26.5; Swift language mode 5.0; `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`; approachable concurrency on; device family iPhone + iPad; bundle id `com.grifano.TachoBookByClaude`. Starter app is the Xcode SwiftData template (`Item`, `ContentView`).

## B. MCP integrations

| Integration | Source | Status | Evidence |
| --- | --- | --- | --- |
| Xcode | `claude mcp add` user scope: `xcode` → `xcrun mcpbridge` (stdio) | **TESTED** | XcodeListWindows (tab `windowtab1` = this project), XcodeLS, XcodeRead, XcodeListNavigatorIssues, GetTestList (4 tests), BuildProject (succeeded, iOS Simulator 26.5 SDK), GetBuildLog, RunSomeTests (1/1 passed), DocumentationSearch, RenderPreview (ContentView rendered) |
| Figma | claude.ai **Figma** connector (official remote MCP, `mcp.figma.com`) | **TESTED** | whoami (Serhii Orlenko, "My Projects" Full seat), get_metadata, get_screenshot, get_variable_defs, get_design_context, SVG asset download |
| Figma plugin MCP | `figma@claude-plugins-official` 2.2.127 (user scope) | **CONFIGURED**, needs auth | Plugin skills are used (`figma:figma-design-to-code`, `figma:figma-swiftui`, …); its own MCP server is unauthenticated and duplicates the connector |
| Figma desktop (`figma-desktop`, `127.0.0.1:3845/mcp`) | Figma desktop app Dev Mode MCP | **CONNECTED** (probed), not registered in Claude Code | Server responds, but it reads whichever file is frontmost in the desktop app |
| Notion | claude.ai **Notion** connector (official Notion MCP) | **TESTED** | notion-get-self (workspace "Serhii's Notion"); fetched MVP, Regulatory Rules Specification v1, Backlog, Product Design workflow, and Task "9/11 h Rest Calculator + Tests" |
| `plugin:design:*`, `plugin:engineering:*` servers | claude.ai org plugins | needs auth / failed | Not required for TachoBook; duplicates of connectors above |

No secrets were written to project files. No Notion or Figma content was modified.

## C. Agent skills

| Codex skill | Claude Code equivalent | Source | Installed / built-in | Scope | Verification |
| --- | --- | --- | --- | --- | --- |
| swiftui-pro | `swiftui-pro` | twostraws/swiftui-agent-skill | Installed (pre-existing) | Project `.claude/skills` | Discoverable |
| swiftdata-pro | `swiftdata-pro` | twostraws/swiftdata-agent-skill | Installed (pre-existing) | Project | Discoverable |
| swift-testing-pro | `swift-testing-pro` | twostraws/swift-testing-agent-skill | Installed (pre-existing) | Project | Discoverable |
| test-driven-development | `test-driven-development` | obra/superpowers | Installed 2026-10-17 | Project | SKILL.md == upstream HEAD; discoverable |
| systematic-debugging | `systematic-debugging` | obra/superpowers | Installed 2026-10-17 | Project | SKILL.md == upstream HEAD; discoverable |
| verification-before-completion | `verification-before-completion` | obra/superpowers | Installed 2026-10-17 | Project | SKILL.md == upstream HEAD; invoked successfully |
| figma / figma-implement-design | `figma:figma-design-to-code`, `figma:figma-swiftui`, `figma:figma-use` | figma@claude-plugins-official | Plugin | User | `figma:figma-design-to-code` invoked successfully |
| code-review | `/code-review` | Claude Code built-in | Built-in | — | Discoverable (not invoked) |
| security-best-practices | `/security-review` | Claude Code built-in | Built-in | — | Discoverable (not invoked) |
| writing-plans | Plan mode / Plan agent | Claude Code built-in | Built-in (Serhii's decision) | — | — |
| brainstorming | Direct clarifying questions | Claude Code built-in | Built-in (Serhii's decision) | — | — |
| find-skills | Plugin catalog search / skill suggestions | Claude Code built-in | Built-in | — | — |

Rejected: `obra/superpowers` `brainstorming` and `writing-plans`. They auto-trigger on every feature task, write and commit docs under `docs/superpowers/`, add a hard design gate, and reference sibling skills that are not installed, which conflicts with approved-task rules in AGENTS.md. `vercel-labs/skills` `find-skills` is rejected because it runs global `-g -y` installs without approval; `getsentry/skills` `code-review` is rejected because its name collides with the built-in `/code-review`.

Known cosmetic duplicate: upstream `swiftui-pro` and `swift-testing-pro` ship a nested Claude plugin copy (`skills/<name>/SKILL.md`), so `swiftui-pro:swiftui-pro` and `swift-testing-pro:swift-testing-pro` also appear. Content is equivalent; left as installed.

Reinstall: `npx skills@1.7.2 experimental_install` restores from `skills-lock.json`.

## D. Xcode verification

Simulator: **iPhone 17, iOS 26.5**, UDID `58100FDB-1DF2-45ED-8789-DA7FBCDE0F82` (stock device; the `TachoBook Codex …` simulators were not used).

| Check | Tool / command | Result |
| --- | --- | --- |
| Project and scheme detected | `xcodebuild -list -project TachoBookByClaude.xcodeproj`; Xcode MCP `XcodeListWindows` | **TESTED** |
| Build | Xcode MCP `BuildProject` (Debug, iOS Simulator 26.5 SDK) | **TESTED**: succeeded, 0 errors, 0 navigator issues |
| Unit test via MCP | Xcode MCP `RunSomeTests` → `TachoBookByClaudeTests/example()` | **TESTED**: 1 passed |
| Full test suite | `xcodebuild test -project TachoBookByClaude.xcodeproj -scheme TachoBookByClaude -destination 'platform=iOS Simulator,id=58100FDB-1DF2-45ED-8789-DA7FBCDE0F82' -derivedDataPath <scratch>/DerivedData -resultBundlePath <scratch>/TestResults.xcresult` | **TESTED**: `** TEST SUCCEEDED **`, exit 0. xcresult: 4 tests, 4 passed, 0 failed, 0 skipped (`testLaunch` ran in 4 UI configurations; `testLaunchPerformance` 70 s). Xcode ran these on parallel clones of iPhone 17. |
| Install and launch | `xcrun simctl install` and `xcrun simctl launch … com.grifano.TachoBookByClaude` | **TESTED**: process running (PID 88607) |
| Screenshot | `xcrun simctl io … screenshot`; Claude iOS Simulator tool `screenshot` | **TESTED**: starter list with "+" and "Edit" |
| UI interaction | Claude iOS Simulator tool `tap` on "+" | **TESTED**: new row appeared. The app was uninstalled afterwards to discard the template SwiftData store. |
| SwiftUI preview render | Xcode MCP `RenderPreview` (ContentView) | **TESTED** |
| Figma vs app comparison | — | **NOT TESTED** (no app screens exist yet) |
| Multiple iPhone widths | — | **NOT TESTED** (no UI under development) |

## E. Instructions

- `AGENTS.md` and `CLAUDE.md` are byte-identical to `grifano/tachobook` `main` at `4c733fb5e836540e376f39da4d0c02098e96cca4` (SHA-256 of AGENTS.md `9c8bdbe0…aeafdcb4`).
- Loading: `CLAUDE.md` contains `@AGENTS.md`. Native AGENTS.md reading needs Claude Code ≥ 2.1.277; the installed CLI is 2.1.121, so the import is required. It stays correct after an upgrade because, when `CLAUDE.md` exists, Claude reads `CLAUDE.md` plus its import.
- Verified: AGENTS.md content is present in session context via the import.
- Sync check (read-only), run before each task:

```bash
curl -fsSL https://raw.githubusercontent.com/grifano/tachobook/main/AGENTS.md | diff - AGENTS.md && echo "AGENTS.md in sync"
```

## F. Open issues

1. **Figma file content.** Through the remote MCP, the approved file `rpZZnwAC53fG7zjQy42Snq` lists only page `0:1 Cover` (frame `1:41`). No app screens were found. UI tasks need node-specific Figma URLs.
2. **AGENTS.md vs setup brief (Figma server).** AGENTS.md line 12 says to use the local `figma-desktop` MCP server. This setup uses the official remote connector, which is file-key based and already authenticated. Only Serhii can update the canonical AGENTS.md.
3. **Repository for Claude's runs (resolved 2026-10-17).** Serhii updated the Task: Claude Code works only in `grifano/tachobookbyclaude`, with its own base SHA, a `claude/…` feature branch, and a PR there. The Codex repo `grifano/tachobook` is not touched. The remote was empty; Serhii approved publishing this baseline (template + setup commit) to `main` and installing `gh`.
4. **Setup files and IDE state (resolved 2026-10-17).** The baseline commit versions `AGENTS.md`, `CLAUDE.md`, `.claude/skills/`, `skills-lock.json`, and this record. It also adds a `.gitignore` and stops tracking `xcuserdata/…/xcschememanagement.plist`.
5. **Duplicate MCP servers.** Figma (connector, plugin MCP, desktop) and Notion (connector, `plugin:engineering:notion`) have overlapping integrations. Use the connectors; leave the plugin MCP servers unauthenticated.
6. **Terminal CLI sessions.** The Figma and Notion connectors were verified in the desktop app session. In a plain terminal `claude` session, confirm they appear under `/mcp`.
