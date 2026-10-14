# negotiation-coach

A personal Claude Code / Codex skill that applies the Sber Mini-MBA course «Коммуникации и влияние» (negotiations:
Setup → Design → Deal) to real situations: preparing for negotiations and difficult meetings, conflicts with
colleagues, in-the-moment help («они сказали …, что ответить?») and post-meeting debriefs. Self-contained: all
course knowledge lives in `skills/negotiation-coach/references/`.

- `skills/negotiation-coach/` — the skill (SKILL.md + references). Symlinked from `~/.agents/skills/negotiation-coach`
  and `~/.claude/skills/negotiation-coach`.
- `dev/` — spec, test scenarios with criteria, baseline (no skill) and with-skill runs, review notes, package gate
  (`bash dev/check.sh`).

Knowledge is distilled from the course decks, webinars, lecture transcripts and homework handouts; answers never cite
them. The course exam has its own trainer and is out of scope here.
