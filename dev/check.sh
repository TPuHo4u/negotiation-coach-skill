#!/bin/bash
# Package gate for the negotiation-coach skill: frontmatter limits, no course locators, size budget.
SK="$(cd "$(dirname "$0")/.." && pwd)/skills/negotiation-coach"
fail=0
python3 -I - "$SK/SKILL.md" <<'PY' || fail=1
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
m=re.match(r'^---\n(.*?)\n---\n',t,flags=re.S)
assert m,'no frontmatter'
fm=m.group(1)
name=re.search(r'^name:\s*(.+)$',fm,flags=re.M).group(1).strip()
desc=re.search(r'^description:\s*(.+)$',fm,flags=re.M).group(1).strip()
assert re.fullmatch(r'[a-z0-9-]+',name), 'bad name: '+name
assert len(fm)<=1024, 'frontmatter too long: %d'%len(fm)
assert desc.startswith('Use when'), 'description must start with "Use when"'
print('frontmatter ok: name=%s, %d chars'%(name,len(fm)))
PY
# locator words that must not appear in user-facing knowledge (case-insensitive); the word «лекция» etc. too
pat='слайд|вебинар|лектор|лекци|таймкод|\[[0-9]{2}:[0-9]{2}:[0-9]{2}|сл\. ?[0-9]|по словам|Мини-МБА|Сбер'
for f in "$SK/SKILL.md" "$SK"/references/*.md; do
  n=$(grep -c -i -E "$pat" "$f")
  if [ "$n" -gt 0 ]; then echo "LOCATOR WORDS in $(basename "$f"): $n line(s)"; grep -n -i -E "$pat" "$f" | head -5; fail=1; fi
done
for f in "$SK"/references/*.md; do s=$(wc -c < "$f"); [ "$s" -gt 30000 ] && { echo "TOO BIG: $(basename "$f") $s bytes"; fail=1; }; done
w=$(wc -w < "$SK/SKILL.md"); [ "$w" -gt 2000 ] && { echo "SKILL.md too long: $w words"; fail=1; }
echo "sizes:"; wc -c "$SK/SKILL.md" "$SK"/references/*.md | sed 's/^/  /'
[ "$fail" -eq 0 ] && echo "GATE: PASS" || echo "GATE: FAIL"
exit $fail
