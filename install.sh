#!/bin/sh
set -e

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
error()   { printf "  ${RED}✗${RESET} %s\n" "$1"; exit 1; }
dim()     { printf "  ${DIM}%s${RESET}\n" "$1"; }

# ── CLI ───────────────────────────────────────────────────────────────────────

install_cli() {
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
}

# ── Skill ─────────────────────────────────────────────────────────────────────

install_skill() {
  if ! command -v npx >/dev/null 2>&1; then
    warn "Skipping skill install — npx not found (install Node.js to enable)"
    return
  fi

  info "Installing agent skill..."
  # --yes passed to skills CLI (not npx) to skip interactive agent selector
  # </dev/tty ensures the TUI doesn't consume stdin when piped via curl | sh
  npx skills add navayuvan-sb/filebeam --yes </dev/tty
  success "Agent skill installed"
}

# ── Run ───────────────────────────────────────────────────────────────────────

printf "\n"
printf "  ${BOLD}filebeam${RESET} installer\n"
printf "  $(printf '%0.s─' $(seq 1 20))\n"
printf "\n"

install_cli
install_skill

printf "\n"
printf "  ${GREEN}${BOLD}All done!${RESET}\n"
printf "\n"
printf "  ${BOLD}Next:${RESET} configure your GitHub token to start uploading:\n"
printf "\n"
dim   "  Generate a token (gist scope only) at:"
printf "  ${CYAN}https://github.com/settings/tokens/new?scopes=gist&description=filebeam${RESET}\n"
printf "\n"
printf "  Then run:\n"
printf "  ${CYAN}filebeam config github-gist <your-token>${RESET}\n"
printf "\n"
