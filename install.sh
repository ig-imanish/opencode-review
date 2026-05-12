#!/usr/bin/env bash
# opencode-review installer
# Usage:
#   Install globally:      curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash
#   Install to project:    curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash -s -- --project

set -e

REPO="ig-imanish/opencode-review"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

COMMANDS=("mx-init-context.md" "mx-review.md" "mx-review-security.md" "mx-explain.md" "mx-fix.md" "mx-update-context.md")

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
echo "  /mx-init-context    — auto-generate CONTEXT.md for this project (run this first)"
echo "  /mx-update-context  — refresh CONTEXT.md after big changes"
echo "  /mx-review          — full code review: bugs, perf, style, tests"
echo "  /mx-review-security — security audit: injection, auth, secrets, data exposure"
echo "  /mx-explain         — deep codebase explanation for new contributors"
echo "  /mx-fix             — auto-fix issues found by /mx-review"
echo ""

if [[ "$mode" == "project" ]]; then
  if [[ ! -f "CONTEXT.md" ]]; then
    echo "Downloading CONTEXT.md template..."
    curl -fsSL "$BASE_URL/CONTEXT.md" -o "CONTEXT.md"
    echo ""
  fi
fi

echo -e "${CYAN}${BOLD}Prerequisites:${NC}"
echo ""
echo -e "  ${BOLD}1. Install OpenCode:${NC}"
echo "     curl -fsSL https://opencode.ai/install | bash"
echo "     # or: npm i -g opencode-ai@latest"
echo ""
echo -e "  ${BOLD}2. Configure a model:${NC}"
echo "     https://docs.opencode.ai/providers"
echo ""
echo ""
echo -e "${CYAN}${BOLD}Next steps:${NC}"
echo ""

if [[ "$mode" == "global" ]]; then
  echo -e "  ${BOLD}3. Go to your project:${NC}"
  echo "     cd ~/your-project"
  echo ""
  echo -e "  ${BOLD}4. Open OpenCode:${NC}"
  echo "     opencode"
  echo ""
  echo -e "  ${BOLD}5. Generate context for this project (do this once per project):${NC}"
  echo "     /mx-init-context"
  echo ""
  echo "     OpenCode will read your project and write a filled CONTEXT.md."
  echo "     Review it, correct anything wrong, then commit it."
  echo ""
  echo -e "  ${BOLD}6. Review your code:${NC}"
  echo "     /mx-review"
  echo ""
  echo -e "  ${YELLOW}For multiple projects: commands are global (installed once).${NC}"
  echo -e "  ${YELLOW}CONTEXT.md is per-project — run /mx-init-context in each project.${NC}"
else
  echo -e "  ${BOLD}3. Open OpenCode:${NC}"
  echo "     opencode"
  echo ""
  echo -e "  ${BOLD}4. Generate context for this project:${NC}"
  echo "     /mx-init-context"
  echo ""
  echo "     OpenCode reads your project and writes CONTEXT.md automatically."
  echo "     Review it, correct anything wrong, then commit:"
  echo "     git add CONTEXT.md && git commit -m 'chore: add opencode-review context'"
  echo ""
  echo -e "  ${BOLD}5. Start reviewing:${NC}"
  echo "     /mx-review              — before committing"
  echo "     /mx-review-security     — before merging to main"
  echo "     /mx-explain              — understand the whole codebase"
  echo "     /mx-fix                  — auto-fix issues from /mx-review"
  echo ""
  echo -e "  ${BOLD}6. After big refactors:${NC}"
  echo "     /mx-update-context       — keeps CONTEXT.md accurate over time"
  echo ""
  echo -e "  ${YELLOW}Commit CONTEXT.md to git so your whole team benefits from it.${NC}"
fi

echo ""
echo -e "Docs + source: https://github.com/$REPO"
