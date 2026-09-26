#!/usr/bin/env bash
#
# skills-check.sh - the drift guard for the skills tree: frontmatter, the shared constitution block, the file
# pointers, the references coverage, the scripts/lib copies, and a token count per skill.
#
# The problem it solves: the kit's core lives in Agent Skills - one resident skill, hook-gauntlet/, plus one skill
# per phase, and every doc, brief, template, script and the Foundry kit itself lives inside one of those folders.
# The constitution block at the top of every SKILL.md is duplicated ON PURPOSE (an agent may load only a phase
# skill, and every rule must still bind), which makes the dangerous drift the silent kind: a phase skill still
# carrying an old constitution, a pointer whose file was renamed, a references/ file no skill points at, a phase
# skill missing from the resident's router table, a scripts/lib copy that diverged. Each passes review in a diff
# and fails the agent at runtime. This script measures all of it; --sync re-stamps the constitution block of every
# phase skill from the resident's copy.
#
# The pointer convention this checks: every file a SKILL.md names is written relative to its own directory, inside
# backticks - `references/...`, `scripts/...`, `foundry-kit/...` for its own files, `../<skill>/...` for a sibling's
# (one `..` only). Both forms resolve identically in the checkout and after installation, because the skills always
# land side by side. Inside the constitution block every pointer is the `../<skill>/` form, so the same text is
# valid from every directory it is copied into.
#
# Usage:   skills-check.sh [--sync] [--skills DIR]
#   --skills DIR  the directory that holds the skill folders (default: this script's grandparent); its <name>/
#                 directories are what is checked
#   --sync        first rewrite the constitution block (the markers inclusive) of every non-resident SKILL.md to
#                 the resident's, then run the checks. A skill whose markers are not exactly one begin then one
#                 end is REFUSED, never half-written
# Env:     MAX_TOKENS   if set, a skill whose on-entry token total exceeds it is a problem
# Output:  one "skills-check: <file>: <what>" line per problem, and the run keeps going; then one
#          "tokens <name>: skill=N on_entry=M total=T" line per skill (bytes/4; on_entry counts the files the
#          skill's "## Read on entry" section points at) and the "tokens baseline:" of the resident's AGENTS.md
#          plus the doctrine files (the upper-case *.md at the top of every references/). Last line:
#          "SKILLS CHECK PASSED: <n> skills, one constitution, <k> pointers resolve, every references/ file has a
#          skill that points at it." or "SKILLS CHECK FAILED: <n> problem(s)."
# Exit:    0 passed; 1 problem(s) found; 2 REFUSED - no skills dir, no resident skill, the resident's markers are
#          not one begin then one end, a bad MAX_TOKENS, or bad arguments: one line on stderr naming what.

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SKILLS="$(cd "$HERE/../.." && pwd)"
SYNC=0
MAX_TOKENS="${MAX_TOKENS:-}"

refuse() { echo "skills-check: REFUSED - $*" >&2; exit 2; }

while [ $# -gt 0 ]; do
  case "$1" in
    --sync) SYNC=1; shift ;;
    --skills) [ $# -ge 2 ] || refuse "--skills has no value."; SKILLS="$2"; shift 2 ;;
    -*) refuse "unknown argument '$1'." ;;
    *) refuse "unexpected argument '$1' (this script takes none)." ;;
  esac
done
SKILLS="$(cd "$SKILLS" 2> /dev/null && pwd)" || refuse "skills root '$SKILLS' cannot be entered."
[ -z "$MAX_TOKENS" ] || [[ $MAX_TOKENS =~ ^[0-9]+$ ]] || refuse "MAX_TOKENS='$MAX_TOKENS' is not a whole number."

RESIDENT="$SKILLS/hook-gauntlet/SKILL.md"
[ -d "$SKILLS/hook-gauntlet" ] || refuse "no skills directory or no resident skill folder at $SKILLS/hook-gauntlet."
[ -f "$RESIDENT" ] || refuse "no resident skill at hook-gauntlet/SKILL.md."

TMPD="$(mktemp -d)"; trap 'rm -rf "$TMPD"' EXIT
PTRS="$TMPD/pointers"; mkdir -p "$PTRS"
RBLOCK="$TMPD/resident.constitution"

trim() { local s="$1"; s="${s#"${s%%[![:space:]]*}"}"; printf '%s' "${s%"${s##*[![:space:]]}"}"; }

# markers <file>: "nb ne lb le" - how many constitution:begin / :end lines, and the line number of the first of each
markers() {
  LC_ALL=C awk '
    { sub(/\r$/, "") }
    /^<!-- constitution:begin/ { nb++; if (nb == 1) lb = NR }
    /^<!-- constitution:end/   { ne++; if (ne == 1) le = NR }
    END { printf "%d %d %d %d\n", nb + 0, ne + 0, lb + 0, le + 0 }' "$1"
}

read -r m_b m_e l_b l_e <<< "$(markers "$RESIDENT")"
{ [ "$m_b" = 1 ] && [ "$m_e" = 1 ] && [ "$l_b" -lt "$l_e" ]; } \
  || refuse "the resident's markers are not exactly one constitution:begin then one constitution:end."
sed -n "${l_b},${l_e}p" "$RESIDENT" > "$RBLOCK"

if [ "$SYNC" = 1 ]; then
  # every target is validated BEFORE anything is rewritten: a file without exactly one begin then one end is a
  # refusal for the whole run, so no file is ever half-written for another file's sake
  for f in "$SKILLS"/*/SKILL.md; do
    [ "$f" = "$RESIDENT" ] && continue
    [ -f "$f" ] || continue
    read -r m_b m_e l_b l_e <<< "$(markers "$f")"
    { [ "$m_b" = 1 ] && [ "$m_e" = 1 ] && [ "$l_b" -lt "$l_e" ]; } \
      || refuse "--sync cannot rewrite ${f#"$SKILLS"/}: its markers are not exactly one constitution:begin then one constitution:end."
  done
  for f in "$SKILLS"/*/SKILL.md; do
    [ "$f" = "$RESIDENT" ] && continue
    [ -f "$f" ] || continue
    read -r m_b m_e l_b l_e <<< "$(markers "$f")"
    # head/tail split on line numbers, never sed on the content: byte-safe against &, \ and a missing trailing newline
    { head -n "$((l_b - 1))" "$f"; cat "$RBLOCK"; tail -n "+$((l_e + 1))" "$f"; } > "$TMPD/new.md" \
      || refuse "--sync could not read ${f#"$SKILLS"/}."
    cat "$TMPD/new.md" > "$f" || refuse "--sync could not write ${f#"$SKILLS"/}."
    echo "synced: ${f#"$SKILLS"/} <- the resident's constitution block"
  done
fi

problems=0 npointers=0 nskills=0
prob() { echo "skills-check: $1: $2"; problems=$((problems + 1)); }

# pointers <file>: every backticked relative pointer, canonicalised to "<skill>/<path>" form, one per line.
#   `references/x`, `scripts/x`, `foundry-kit/x`   -> this skill's own file
#   `../<sibling>/x`                               -> a sibling skill's file (exactly one ..)
pointers() {
  grep -oE '`(\.\./[a-z0-9][a-z0-9-]*/)?(references|scripts|foundry-kit)/[A-Za-z0-9._/-]*`' "$1" \
    | tr -d '`' | sed 's/[.,:)]*$//'
}
canon() { # canon <skill> <pointer> -> "<skill>/<relpath>" ; empty if it escapes the skills root
  case "$2" in
    ../*/../*|*/../*|*/..) printf '' ;;
    ../[a-z0-9-]*/*) printf '%s\n' "${2#../}" ;;
    references/*|scripts/*|foundry-kit/*) printf '%s/%s\n' "$1" "$2" ;;
    *) printf '' ;;
  esac
}

for d in "$SKILLS"/*/; do
  sname="$(basename "$d")"; f="$d/SKILL.md"; frel="$sname/SKILL.md"
  if [ ! -f "$f" ]; then prob "skills/$sname" "has no SKILL.md"; continue; fi
  nskills=$((nskills + 1))

  # ---- 1. the YAML frontmatter: a --- block, name: is the directory, description: non-empty and short
  first="$(head -n 1 "$f")"
  if [[ ! $first =~ ^---[[:space:]]*$ ]]; then
    prob "$frel" "does not start with a '---' YAML frontmatter line"
  else
    close="$(LC_ALL=C awk '{ sub(/\r$/, "") } NR > 1 && /^---[[:space:]]*$/ { print NR; exit }' "$f")"
    if [ -z "$close" ]; then
      prob "$frel" "frontmatter has no closing '---' line"
    else
      fm="$(sed -n "2,${close}p" "$f")"
      nval="$(trim "$(printf '%s\n' "$fm" | grep -m1 '^name:' | sed 's/^name://')")"
      if [ -z "$nval" ]; then
        prob "$frel" "frontmatter has no 'name:' line"
      else
        [[ $nval =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || prob "$frel" "name '$nval' is not lower-case words joined by '-'"
        [ "$nval" = "$sname" ] || prob "$frel" "name '$nval' is not its directory name '$sname'"
      fi
      dval="$(trim "$(printf '%s\n' "$fm" | grep -m1 '^description:' | sed 's/^description://')")"
      if [ -z "$dval" ]; then
        prob "$frel" "frontmatter has no non-empty 'description:' line"
      elif [ "${#dval}" -gt 1024 ]; then
        prob "$frel" "description is ${#dval} characters, over the 1024 limit"
      fi
    fi
  fi

  # ---- 2. the constitution block: one begin then one end, byte-identical to the resident's
  read -r m_b m_e l_b l_e <<< "$(markers "$f")"
  if [ "$m_b" != 1 ] || [ "$m_e" != 1 ]; then
    prob "$frel" "has $m_b constitution:begin and $m_e constitution:end marker(s) - exactly one of each is required"
  elif [ "$l_b" -ge "$l_e" ]; then
    prob "$frel" "constitution:begin (line $l_b) is not before constitution:end (line $l_e)"
  elif ! sed -n "${l_b},${l_e}p" "$f" | cmp -s - "$RBLOCK"; then
    prob "$frel" "its constitution block differs from the resident's (skills-check.sh --sync re-stamps it)"
  fi

  # ---- 3. dead path conventions and pointer resolution
  while IFS= read -r bad; do
    prob "$frel" "names the dead path '$bad' - pointers are relative now (references/, scripts/, ../<skill>/)"
  done < <(grep -oE '`(<kit>/|doctrine/|briefs/|state/)[A-Za-z0-9._/-]+`' "$f" | tr -d '`' | sort -u)

  : > "$PTRS/$sname"
  while IFS= read -r p; do
    c="$(canon "$sname" "$p")"
    [ -n "$c" ] || { prob "$frel" "pointer '$p' escapes the skills root - no '..' after the first segment"; continue; }
    printf '%s\n' "$c" >> "$PTRS/$sname"
    npointers=$((npointers + 1))
    [ -e "$SKILLS/$c" ] || prob "$frel" "points at '$p' ($c), which does not exist"
  done < <(pointers "$f")
done

# ---- 4. coverage: every references/*.md file is pointed at by at least one SKILL.md (a pointer at a file or at
# an ancestor directory of it both count; foundry-kit trees are pointed at as directories)
while IFS= read -r doc; do
  rel="${doc#"$SKILLS"/}"
  found=""
  for pf in "$PTRS"/*; do
    while IFS= read -r p; do
      p="${p%/}"
      [ "$rel" = "$p" ] && { found=1; break 2; }
      case "$rel" in "$p/"*) [ -d "$SKILLS/$p" ] && { found=1; break 2; } ;; esac
    done < "$pf"
  done
  [ -n "$found" ] || prob "$rel" "no SKILL.md points at it"
done < <(find "$SKILLS" -path '*/references/*' -name '*.md' -type f)

# ---- 5. the router table: the resident's constitution names exactly the phase skills, and they all exist
router="$(grep -oE '`hook-gauntlet-[a-z]+`' "$RBLOCK" | tr -d '`' | sort -u | tr '\n' ' ')"
router=" ${router% } "
for r in $router; do
  [ -d "$SKILLS/$r" ] || prob "hook-gauntlet/SKILL.md" "its router table names \`$r\`, which is not a skills directory"
done
for d in "$SKILLS"/*/; do
  sname="$(basename "$d")"; [ "$sname" = hook-gauntlet ] && continue
  case "$router" in
    *" $sname "*) ;;
    *) prob "$sname" "the resident's router table does not name it" ;;
  esac
done

# ---- 6. scripts/lib parity: the same helper, wherever it is copied, is the same bytes
while IFS= read -r lf; do
  base="$(basename "$lf")"
  first="$(find "$SKILLS" -path "*/scripts/lib/$base" -type f | sort | head -n 1)"
  while IFS= read -r other; do
    cmp -s "$first" "$other" || prob "${other#"$SKILLS"/}" "its lib/$base differs from ${first#"$SKILLS"/}"
  done < <(find "$SKILLS" -path "*/scripts/lib/$base" -type f | sort | tail -n +2)
done < <(find "$SKILLS" -path '*/scripts/lib/*' -type f)

# ---- 7. the measurement, always printed: tokens = bytes/4; on_entry counts the files under "## Read on entry"
for d in "$SKILLS"/*/; do
  sname="$(basename "$d")"; f="$d/SKILL.md"
  [ -f "$f" ] || continue
  n=$(($(wc -c < "$f") / 4))
  m=0
  while IFS= read -r p; do
    c="$(canon "$sname" "$p")"
    [ -n "$c" ] && [ -f "$SKILLS/$c" ] && m=$((m + $(wc -c < "$SKILLS/$c") / 4))
  done < <(LC_ALL=C awk '/^## Read on entry/ { one = 1; next } one && /^## / { one = 0 } one { print }' "$f" \
             | grep -oE '`(\.\./[a-z0-9][a-z0-9-]*/)?(references|scripts|foundry-kit)/[A-Za-z0-9._/-]*`' \
             | tr -d '`' | sed 's/[.,:)]*$//' | sort -u)
  t=$((n + m))
  echo "tokens $sname: skill=$n on_entry=$m total=$t"
  if [ -n "$MAX_TOKENS" ] && [ "$t" -gt "$MAX_TOKENS" ]; then
    prob "$sname/SKILL.md" "its on-entry total is $t tokens, over MAX_TOKENS=$MAX_TOKENS"
  fi
done
base=0
for f in "$SKILLS"/*/references/; do
  for g in "$f"[A-Z]*.md; do
    [ -f "$g" ] || continue
    case "$(basename "$g")" in QUICKSTART.md) continue ;; esac
    base=$((base + $(wc -c < "$g") / 4))
  done
done
echo "tokens baseline: AGENTS.md + the doctrine files = $base"

if [ "$problems" -gt 0 ]; then
  echo "SKILLS CHECK FAILED: $problems problem(s)."
  exit 1
fi
echo "SKILLS CHECK PASSED: $nskills skills, one constitution, $npointers pointers resolve, every references/ file has a skill that points at it."
