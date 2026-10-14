# DEVLOG — negotiation-coach skill

## 2026-10-14 — Claude (Fable 5.1, orchestrating Sonnet/Opus agents) — Skill built from the course «Коммуникации и влияние»

### What we built
- A self-contained personal skill `negotiation-coach` (SKILL.md 13.6 KB + three references: `frameworks.md` 27 KB,
  `phrases.md` 28 KB, `prep-sheet.md` 13 KB) with four modes: Подготовка (лист подготовки for both sides, карта,
  seven-step script), Конфликт с коллегой (strategy from the matrix, states, «око за око», plan, phrases), Здесь и
  сейчас (a fixed 120-word contract: diagnosis, 2–3 labeled replies, one «не делать»), Разбор после встречи
  (plan-vs-fact table, steps, power, state, next round with the closing instrument).
- Installed by symlinks `~/.agents/skills/negotiation-coach` → repo and `~/.claude/skills/negotiation-coach` →
  `../../.agents/skills/…`; the harness listed the skill immediately.
- Dev artifacts in `dev/`: spec, four scenarios with observable criteria, RED baseline runs (no skill), GREEN runs
  (with skill), review notes, package gate `dev/check.sh` (frontmatter limits, locator words, sizes).
- Course text exports and the mined phrase files stay outside the repo in the course's Codex service folder
  (`…/Коммуникации и влияние/skill-dev/{sources,mined}`), because they contain the full course text.

### Timing
| Stage | Time |
|---|---|
| Orientation, design conversation, spec and scenarios | 15:00–15:25 |
| Eight pane agents stuck on the trust dialog (cwd drift into the new repo) | 15:23–16:21 |
| RED baselines (4 × Sonnet) and transcript mining (4 × Sonnet) | 16:21–16:51 |
| SKILL.md, frameworks.md, prep-sheet.md; delta merged | 16:30–17:10 |
| phrases.md distilled (Opus, one API drop, resumed by message) | 16:55–17:30 |
| GREEN runs (4 × Sonnet) and fidelity lens (Opus); lens fixes; S1 second-turn run | 17:33–18:10 |

### Key decisions
- **Self-contained knowledge, no locators in answers** (owner): all course knowledge lives inside `references/`;
  answers never cite slides, webinars, lecturers or timestamps. Fidelity is checked once at build time instead.
- **One skill, four modes** instead of four skills or a runtime link to the course library/RAG: one knowledge base,
  one trigger description, works on any device.
- **Recipe form, not prohibitions.** The baseline failures were shape failures (walls of text with four questions,
  essays instead of ready replies, generic advice without the other side's numbers), so each mode is an output
  contract; the only hard prohibitions are the course's own (no unconditional concession, no shown high interest).
- **Fidelity corrections taken from the mining and the delta**: «санкция» is a cheat-sheet label, not a course
  instrument (closing has three instruments; an отлагательное условие is a covenant switched on by an event);
  the «2–3 раза» rule is triggered by unanswered cooperative moves, not by repeated hard style; moderate interest
  is a defence under pressure, not an opening declaration; the signal formula «если бы …, то мы могли бы …» was
  invented and replaced by the course's intent + reciprocity check; the «после трёх попыток» number came from ASR.
- **No persistent case state** (necessity row in `dev/spec.md`): the debrief accepts the sheet pasted or retold.

### Evidence
- RED: `dev/baseline/README.md` — S1 fails C1–C3, S2 fails C1–C3, S3 fails C1–C3 (≈450 words, the one phrase
  raises shown interest), S4 fails C2–C3.
- GREEN: `dev/with-skill/README.md` — all four scenarios meet their criteria (S1 238 words with one question;
  S3 111 words with three labeled replies; S2 strategy + states + «око за око»; S4 table + steps + closing + letter).
  Second-turn prep run (S1b, 3084 words): full sheet for both sides, priorities 100/100, exchanges, ZOPA, карта,
  seven-step script with phrases from phrases.md; all checks met.
- Package gate: `bash dev/check.sh` → `GATE: PASS` (frontmatter 818 chars, no locator words, references ≤ 28 KB).
- Fidelity lens (Opus, `dev/review/fidelity.md`): critical 0, important 6, minor 13, no locators. All 19 applied
  (26 anchored edits across the four files), e.g. «настраивайте их друг против друга» restored for потенциальный
  конфликт, «замри» = freeze not «silently boiling», hierarchy = not negotiations (check whether the manager allows
  discussion), strategy-choice conditions rewritten to the course's own, the «цена балла» advice corrected to scoring
  a whole deal version, ZOPA «none» = no deal or a way out. Gate rerun after the edits: `GATE: PASS` (SKILL.md 1980 words).

### Insights — worth remembering
- `New Recording 21` is a second ASR copy of the webinar «Управление балансом сил», not a separate lecture; the
  miner used it to repair the webinar transcript's degenerate windows.
- The mined phrase files (97 + 175 + 180 KB) were worth it: the live-mode replies in GREEN are the lecturer's spoken
  formulas adapted to the case, not generic politeness.
- A Sonnet baseline «softens» an ultimatum by raising shown interest («мы хотим работать именно с вами»); the course
  lever says the opposite. That single observation justified the live-mode contract.

### What went wrong
- 58 minutes lost: the eight pane agents were spawned right after a `cd "$REPO" && git init` call had moved the
  session cwd into the untrusted new repo; all eight sat on «Is this a project you trust? ❯ No, exit». Fixed for
  all panes at once through the swarm tmux socket (`send-keys Up`, verify, `Enter`). Rule recorded in memory: never
  `cd` in a Bash call, use absolute paths or a subshell.
- The Opus distiller lost its API connection mid-run; the agent process survived with 230k tokens of context, so a
  `SendMessage` «продолжай» resumed it without re-reading.

### Next
- Owner: use it on a real case; refine phrasing where the live mode feels off. Commit when the owner says so.
