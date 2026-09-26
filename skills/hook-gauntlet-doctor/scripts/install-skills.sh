#!/usr/bin/env bash
#
# install-skills.sh - copy the skill folders into a harness's skills directory.
#
# The problem it solves: each harness reads skills from a different directory. A hook-gauntlet skill is
# self-contained - what it points at lives in its own references/, scripts/ or foundry-kit/, or in a sibling
# skill's, reached by paths relative to the skill folder. The skills always land side by side, so installing IS
# copying: no path is ever rewritten, and the same tree passes the drift guard before and after. This script runs
# skills-check.sh on the source tree first and on the installed tree after, and it never deletes a directory it
# cannot identify as one of this kit's skills.
#
# Where the directories come from (verified 2026-09-26): the Claude Code skills page (code.claude.com/docs - skills
# live in ~/.claude/skills and <project>/.claude/skills), the Codex skills page (developers.openai.com/codex/skills -
# ~/.agents/skills and <project>/.agents/skills, the shared agents convention), and the Devin CLI docs
# (extensibility/skills/overview - ${XDG_CONFIG_HOME:-~/.config}/devin/skills and <project>/.devin/skills).
#
# Usage:   install-skills.sh --harness claude|codex|devin|agents [--project DIR] [--force] [--dry-run]
#          install-skills.sh --dest DIR [--force] [--dry-run]
#   --harness H    H's conventional skills directory: user level, or under DIR with --project DIR
#   --dest DIR     an explicit destination directory
#   --force        replace an existing DEST/<name> - only when its own SKILL.md's name: starts with "hook-gauntlet";
#                  anything else is refused, never deleted
#   --dry-run      print what would be done; write nothing
# Output:  "installed <name> -> <dest>" per skill, then the drift guard on the installed tree, then
#          "installed: <n> skills into <DEST>"
# Exit:    0 installed; 1 the drift guard failed on the installed copy; 2 REFUSED - bad arguments, the source
#          tree does not pass skills-check.sh, or a destination exists that may not be replaced.

set -uo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SKILLS="$(cd "$HERE/../.." && pwd)"
HARNESS="" PROJECT="" DEST="" FORCE=0 DRY=0

refuse() { echo "install-skills: REFUSED - $*" >&2; exit 2; }

while [ $# -gt 0 ]; do
  case "$1" in
    --harness) [ $# -ge 2 ] || refuse "--harness has no value."; HARNESS="$2"; shift 2 ;;
    --project) [ $# -ge 2 ] || refuse "--project has no value."; PROJECT="$2"; shift 2 ;;
    --dest) [ $# -ge 2 ] || refuse "--dest has no value."; DEST="$2"; shift 2 ;;
    --force) FORCE=1; shift ;;
    --dry-run) DRY=1; shift ;;
    *) refuse "unknown argument '$1'." ;;
  esac
done

{ [ -z "$HARNESS" ] || [ -z "$DEST" ]; } || refuse "either --harness or --dest, not both."
[ -n "$HARNESS$DEST" ] || refuse "one of --harness or --dest is required."
{ [ -z "$PROJECT" ] || [ -n "$HARNESS" ]; } || refuse "--project goes with --harness, not with --dest."
[ -d "$SKILLS/hook-gauntlet" ] || refuse "no skills tree found beside this script (expected $SKILLS/hook-gauntlet)."

if [ -n "$HARNESS" ]; then
  case "$HARNESS" in
    claude | codex | devin | agents) ;;
    *) refuse "--harness '$HARNESS' is not one of: claude, codex, devin, agents." ;;
  esac
  if [ -n "$PROJECT" ]; then
    case "$PROJECT" in /*) ;; *) PROJECT="$PWD/$PROJECT" ;; esac
    case "$HARNESS" in
      claude) DEST="$PROJECT/.claude/skills" ;;
      codex | agents) DEST="$PROJECT/.agents/skills" ;;
      devin) DEST="$PROJECT/.devin/skills" ;;
    esac
  else
    case "$HARNESS" in
      claude) DEST="$HOME/.claude/skills" ;;
      codex | agents) DEST="$HOME/.agents/skills" ;;
      devin) DEST="${XDG_CONFIG_HOME:-$HOME/.config}/devin/skills" ;;
    esac
  fi
fi
case "$DEST" in /*) ;; *) DEST="$PWD/$DEST" ;; esac

# the gate first: a tree that fails the drift guard is not installed
[ -f "$HERE/skills-check.sh" ] || refuse "$HERE/skills-check.sh is missing."
if ! "$HERE/skills-check.sh" --skills "$SKILLS"; then
  refuse "skills-check.sh does not pass on this skills tree; not installing."
fi

# the plan is validated before anything is written: a DEST/<name> that exists may be replaced only by --force, and
# --force only when its own SKILL.md names it as one of this kit's skills - anything else is never deleted
names=()
for d in "$SKILLS"/*/; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"; t="$DEST/$name"
  if [ -e "$t" ]; then
    [ "$FORCE" = 1 ] || refuse "$t exists - rerun with --force to replace an installed hook-gauntlet skill."
    [ -d "$t" ] || refuse "$t exists and is not a directory - it is left alone."
    [ -f "$t/SKILL.md" ] || refuse "$t has no SKILL.md - cannot tell it is one of this kit's skills; left alone."
    oname="$(sed -n 's/^name:[[:space:]]*//p' "$t/SKILL.md" | head -n 1)"
    oname="${oname%"${oname##*[![:space:]]}"}"
    case "$oname" in
      hook-gauntlet*) ;;
      *) refuse "$t is not a hook-gauntlet skill (its SKILL.md names '$oname') - never deleted, refusing." ;;
    esac
  fi
  names+=("$name")
done
[ "${#names[@]}" -gt 0 ] || refuse "no skills under $SKILLS."

if [ "$DRY" = 1 ]; then
  for name in "${names[@]}"; do
    if [ -e "$DEST/$name" ]; then echo "would replace $DEST/$name"; else echo "would copy $SKILLS/$name -> $DEST/$name"; fi
  done
  echo "dry-run: would install ${#names[@]} skills into $DEST"
  exit 0
fi

mkdir -p "$DEST" || refuse "cannot create $DEST."
installed=0
for name in "${names[@]}"; do
  t="$DEST/$name"
  if [ -e "$t" ]; then rm -rf "$t" || refuse "could not remove $t for --force."; fi
  cp -R "$SKILLS/$name" "$DEST/" || refuse "could not copy $SKILLS/$name into $DEST."
  echo "installed $name -> $t"
  installed=$((installed + 1))
done

# what was written is checked, not assumed: the drift guard runs on the installed tree itself - the relative
# pointers resolve there exactly as they did in the checkout, or something is wrong with the copy
if ! "$HERE/skills-check.sh" --skills "$DEST"; then
  echo "install-skills: FAILED - the installed copy did not pass the drift guard."
  exit 1
fi
echo "installed: $installed skills into $DEST"
