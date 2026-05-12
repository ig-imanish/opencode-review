#!/usr/bin/env bash
# opencode-review installer
# Usage:
#   Install globally:      curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash
#   Install to project:    curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash -s -- --project

set -e

REPO="ig-imanish/opencode-review"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"

COMMANDS=("review.md" "review-security.md" "explain.md")

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

mode="global"
if [[ "$1" == "--project" ]]; then
  mode="project"
fi

if [[ "$mode" == "global" ]]; then
  DEST="$HOME/.config/opencode/commands"
  echo "Installing commands globally to $DEST"
else
  DEST="$(pwd)/.opencode/commands"
  echo "Installing commands to project at $DEST"
fi

mkdir -p "$DEST"

for cmd in "${COMMANDS[@]}"; do
  echo "  Downloading $cmd..."
  curl -fsSL "$BASE_URL/.opencode/commands/$cmd" -o "$DEST/$cmd"
done

echo -e "${GREEN}Done! Commands installed:${NC}"
echo "  /review           — full code review"
echo "  /review-security  — security audit"
echo "  /explain          — codebase explanation"

if [[ "$mode" == "project" ]]; then
  if [[ ! -f "CONTEXT.md" ]]; then
    echo ""
    echo "Downloading CONTEXT.md template..."
    curl -fsSL "$BASE_URL/CONTEXT.md" -o "CONTEXT.md"
    echo -e "${YELLOW}Next: fill in CONTEXT.md with your project's conventions.${NC}"
  else
    echo "CONTEXT.md already exists, skipping."
  fi
fi

echo ""
echo "Run 'opencode' in your project, then type /review to get started."