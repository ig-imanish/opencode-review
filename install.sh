#!/usr/bin/env bash
# opencode-review installer
# Usage:
#   Install globally:      curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash
#   Install to project:    curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash -s -- --project

set -e

REPO="ig-imanish/opencode-review"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

COMMANDS=("review.md" "review-security.md" "explain.md" "init-context.md" "update-context.md")

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

mode="global"
if [[ "$1" == "--project" ]]; then
  mode="project"
fi

if [[ "$mode" == "global" ]]; then
  DEST="$HOME/.config/opencode/commands"
  echo "Installing commands globally to $DEST"
  echo "They will be available in every project on this machine."
  echo ""
else
  DEST="$(pwd)/.opencode/commands"
  echo "Installing commands to this project at $DEST"
  echo ""
fi

mkdir -p "$DEST"

for cmd in "${COMMANDS[@]}"; do
  echo "  Downloading $cmd..."
  curl -fsSL "$BASE_URL/.opencode/commands/$cmd" -o "$DEST/$cmd"
done

echo ""
echo -e "${GREEN}${BOLD}Commands installed:${NC}"
echo "  /init-context     — auto-generate CONTEXT.md for this project (run this first)"
echo "  /update-context   — refresh CONTEXT.md after big changes"
echo "  /review           — full code review: bugs, perf, style, tests"
echo "  /review-security  — security audit: injection, auth, secrets, data exposure"
echo "  /explain          — deep codebase explanation for new contributors"
echo ""

if [[ "$mode" == "project" ]]; then
  if [[ ! -f "CONTEXT.md" ]]; then
    echo "Downloading CONTEXT.md template..."
    curl -fsSL "$BASE_URL/CONTEXT.md" -o "CONTEXT.md"
    echo ""
  fi
fi

echo -e "${CYAN}${BOLD}Next steps:${NC}"
echo ""

if [[ "$mode" == "global" ]]; then
  echo -e "  ${BOLD}1. Go to your project:${NC}"
  echo "     cd ~/your-project"
  echo ""
  echo -e "  ${BOLD}2. Open OpenCode:${NC}"
  echo "     opencode"
  echo ""
  echo -e "  ${BOLD}3. Generate context for this project (do this once per project):${NC}"
  echo "     /init-context"
  echo ""
  echo "     OpenCode will read your project and write a filled CONTEXT.md."
  echo "     Review it, correct anything wrong, then commit it."
  echo ""
  echo -e "  ${BOLD}4. Review your code:${NC}"
  echo "     /review"
  echo ""
  echo -e "  ${YELLOW}For multiple projects: commands are global (installed once).${NC}"
  echo -e "  ${YELLOW}CONTEXT.md is per-project — run /init-context in each project.${NC}"
else
  echo -e "  ${BOLD}1. Open OpenCode:${NC}"
  echo "     opencode"
  echo ""
  echo -e "  ${BOLD}2. Generate context for this project:${NC}"
  echo "     /init-context"
  echo ""
  echo "     OpenCode reads your project and writes CONTEXT.md automatically."
  echo "     Review it, correct anything wrong, then commit:"
  echo "     git add CONTEXT.md && git commit -m 'chore: add opencode-review context'"
  echo ""
  echo -e "  ${BOLD}3. Start reviewing:${NC}"
  echo "     /review              — before committing"
  echo "     /review-security     — before merging to main"
  echo "     /explain             — understand the whole codebase"
  echo ""
  echo -e "  ${BOLD}4. After big refactors:${NC}"
  echo "     /update-context      — keeps CONTEXT.md accurate over time"
  echo ""
  echo -e "  ${YELLOW}Commit CONTEXT.md to git so your whole team benefits from it.${NC}"
fi

echo ""
echo -e "Docs + source: https://github.com/$REPO"
