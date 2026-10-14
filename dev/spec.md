# negotiation-coach — design spec (2026-10-14)

Owner: Dmitry. Approved in chat 2026-10-14 (design sections: modes, shared rules, files, testing).
Execution follows the superpowers:writing-skills checklist (RED baseline → GREEN skill → REFACTOR); no separate plan document.

## Goal

A self-contained personal skill that applies the Sber Mini-MBA course «Коммуникации и влияние» (a negotiations
course: Setup → Design → Deal) to the owner's real situations: preparing for negotiations and difficult meetings,
conflicts with colleagues, in-the-moment help ("they said X, what do I answer?"), and post-meeting debriefs.
Works in Claude Code and Codex from `~/.agents/skills`; the same package can be uploaded to claude.ai.

## Owner decisions (settled)

| # | Decision | Consequence |
|---|---|---|
| D1 | Self-contained: all course knowledge lives inside `references/`; no runtime dependence on the course folder, RAG or scripts | references are larger; works on any device |
| D2 | Answers never cite course locators (slides, webinars, timestamps) | locators stay out of references too; fidelity is checked once at build time |
| D3 | Course vocabulary and models only; no outside negotiation schools | where the course is silent the skill says so and offers the nearest course tool |
| D4 | Four modes in one skill (prep, conflict, live, debrief) | one knowledge base, one trigger description |
| D5 | No persistent case state; saving the prep sheet to a file is optional, only when the user asks and files are writable | nothing to maintain; debrief accepts the sheet pasted or retold |

Necessity row (persistent state): omitted. Cost of omitting = user pastes the prep sheet into the debrief.
Cheapest alternative = a file the user names. Measurement that would justify a case store: the owner asks for it twice.

## Modes (input → behaviour → output)

**1. Подготовка (prep).** Input: a situation in the user's words or pasted correspondence.
Gate: is it a negotiation (mutual interest + each side can say «нет»)? If not, say what comes first
(create interest = «продажа»; or build alternatives/НАОС) and stop at a short plan for that.
Then ask only the missing inputs from the ТВЁРДОСТЬ / ГИБКОСТЬ / ЧЁТКОСТЬ question lists: one question per turn,
at most five before the first draft; everything inferable is filled in and marked as hypothesis.
Output: лист подготовки for both sides (МЫ / ОНИ): interest & dependence, НАОС, the four lever actions made concrete;
3–7 conditions with идеал / край / обоснование / priority out of 100 (ours real, theirs as hypothesis); ZOPA check;
modeled exchanges «когда они нам …, то мы им …»; questions for the counterpart; closing instruments
(обязательства, гарантии, ковенанты, санкции, отлагательные условия). Plus a переговорная карта with обратный ход
when more than two parties matter, and a 7-step meeting script with phrases adapted to the case.

**2. Конфликт с коллегой (conflict).** Input: a disagreement with a colleague/manager/adjacent team.
Diagnose: is there a deal to be made (→ short prep) or is it about relationship and positioning.
Choose the strategy from the matrix (результат для меня × результат для визави) and state why; apply the
«око за око» protocol; check emotional states of both sides (болото / пляж / ринг / амфитеатр) and the
reaction (бей / беги / замри); output a short conversation plan and 2–3 opening phrases.

**3. Здесь и сейчас (live).** Input: what the counterpart just said or did, possibly in a hurry.
Output contract, ≤120 words unless asked for more: (a) one line «что происходит» in course terms (step, technique,
tactic); (b) 2–3 ready replies, each labeled with its intent (запросить обоснование, обусловленная уступка,
сигнал, цена за «да», резюме и пауза, закрытие); (c) one «не делать».

**4. Разбор после встречи (debrief).** Input: what happened, optionally with the prep sheet.
Output: plan vs fact per condition (ideal / edge / result; what was given away unconditionally); which step broke
(no agenda, no justification, no signal exchange, no exploring, single-issue haggling instead of a package,
no closing with commitments); what we showed about our interest and alternatives; the emotional state we were in;
next round: three concrete actions and the closing to obtain.

## Shared rules (all modes)

- Course models and vocabulary only (D3); translate «conditions» into the owner's internal currency: сроки, объём,
  люди и бюджет, приоритет, кто что делает, SLA, поддержка после запуска.
- Always both sides; unknowns about the other side are hypotheses and are labeled so.
- Never advise an unconditional concession; every «нет» becomes a price for «да»; each next concession smaller.
- Russian output; coach tone, direct, «охотник, а не жертва» toward the counterpart, never toward the user.
- No locators, slide numbers, lecturer attributions or timestamps in answers (D2).
- Out of scope: exam preparation (the trainer exists), legal contract wording, sending anything anywhere.

## Files

```
skills/negotiation-coach/
  SKILL.md                      # when to use, mode selection, per-mode recipes, shared rules, pitfalls
  references/frameworks.md      # the course model: power, map, strategies, 3 stages & 7 steps, engine,
                                #   prep algorithm, ZOPA & points, closing, mindset & emotions
  references/phrases.md         # phrase bank by step and technique; responses to pressure and hard style
  references/prep-sheet.md      # template of the лист подготовки (both sides), field guide, course example
```
Targets: SKILL.md ≤ ~1,800 words; each reference ≤ ~25 KB. Prose in English with Russian domain terms and all
user-facing phrases in Russian (house convention, as in tg-channel-post / html-to-video).
Knowledge sources at build time: exam cheat sheet, explanations of the 90 verified exam items, ДЗ2 handouts,
the four decks, lecture and webinar transcripts (phrases only; no numbers taken from ASR).

Trigger description (draft, third person, "Use when…"): preparing for negotiations, a difficult meeting or a
conversation where the user needs agreement, commitment, budget, people or priority from someone (руководитель,
коллега, смежная команда, подрядчик, клиент); a conflict or disagreement with a colleague; mid-negotiation
help («они сказали…, что ответить?», давят, ультиматум, торг, уступка); a debrief of a meeting that went badly or
ended without a clear result. Russian triggers listed verbatim. Not for course exam prep.

## Testing (writing-skills TDD)

Four scenarios in `dev/scenarios.md`, one per mode, realistic internal-bank situations (not the owner's real cases).
RED: run each with a fresh Sonnet subagent, no skill, no file access; save verbatim to `dev/baseline/`.
GREEN: same scenarios with the skill loaded; save to `dev/with-skill/`; check the per-scenario criteria in
`dev/scenarios.md`. One source-fidelity lens (Opus) over `references/` against the course sources; findings and
fixes in `dev/review/`. Review budget: ≤3 subagents per round. REFACTOR until criteria hold.

## Deployment

Repo `~/Downloads/Project/negotiation-coach-skill` (local git). Symlinks:
`~/.agents/skills/negotiation-coach → <repo>/skills/negotiation-coach`,
`~/.claude/skills/negotiation-coach → ../../.agents/skills/negotiation-coach`.
DEVLOG.md in the repo; one pointer entry in the course DEVLOG. Not pushed anywhere unless the owner asks.
