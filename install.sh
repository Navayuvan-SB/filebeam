#!/bin/sh

PYPI_PACKAGE="filebeam"

# ── Colors ────────────────────────────────────────────────────────────────────

if [ -t 1 ]; then
  BOLD="\033[1m"
  DIM="\033[2m"
  GREEN="\033[32m"
  CYAN="\033[36m"
  YELLOW="\033[33m"
  RED="\033[31m"
  RESET="\033[0m"
else
  BOLD="" DIM="" GREEN="" CYAN="" YELLOW="" RED="" RESET=""
fi

info()    { printf "  ${CYAN}›${RESET} %s\n" "$1"; }
success() { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
warn()    { printf "  ${YELLOW}!${RESET} %s\n" "$1"; }
error()   { printf "  ${RED}✗${RESET} %s\n" "$1" >&2; exit 1; }

# ── Header ────────────────────────────────────────────────────────────────────

printf "\n"
printf "  ${BOLD}filebeam${RESET} installer\n"
printf "  $(printf '%0.s─' $(seq 1 20))\n"
printf "\n"

# ── Step 1: CLI ───────────────────────────────────────────────────────────────

if command -v pip3 >/dev/null 2>&1; then
  PIP=pip3
elif command -v pip >/dev/null 2>&1; then
  PIP=pip
else
  error "pip not found — install Python 3 first: https://python.org"
fi

info "Installing filebeam CLI..."
PIP_DISABLE_PIP_VERSION_CHECK=1 $PIP install --quiet --upgrade "$PYPI_PACKAGE"
success "CLI installed"

# ── Step 2: Agent skill ───────────────────────────────────────────────────────

if command -v npx >/dev/null 2>&1; then
  info "Installing agent skill..."
  # </dev/null prevents the npx TUI from consuming stdin when piped via curl | sh
  # --yes --global skips all interactive prompts
  npx skills add navayuvan-sb/filebeam --yes --global < /dev/null
  success "Agent skill installed"
else
  warn "Skipping skill install — npx not found (install Node.js to enable)"
fi

# ── Done ──────────────────────────────────────────────────────────────────────

i=5
while [ $i -gt 0 ]; do
  printf "\r  ${DIM}Continuing in ${i}s...${RESET}"
  sleep 1
  i=$((i - 1))
done
printf "\r%-30s\r" " "
printf "\n"
printf "  ${GREEN}${BOLD}All done!${RESET}\n"
printf "\n"
printf "  ${BOLD}Next —${RESET} configure your GitHub token to start uploading.\n"
printf "\n"
printf "  ${DIM}Generate a token with the 'gist' scope at:${RESET}\n"
printf "  ${CYAN}https://github.com/settings/tokens/new?scopes=gist&description=filebeam${RESET}\n"
printf "\n"
printf "  Then run:\n"
printf "  ${BOLD}${CYAN}filebeam config github-gist <your-token>${RESET}\n"
printf "\n"
