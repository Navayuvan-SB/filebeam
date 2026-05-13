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

# ── Token ─────────────────────────────────────────────────────────────────────

configure_token() {
  printf "\n"
  info "GitHub token setup"
  printf "\n"
  dim "filebeam uploads to GitHub Gist and needs a Personal Access Token"
  dim "with the 'gist' scope. Generate one at:"
  printf "\n"
  printf "  ${CYAN}https://github.com/settings/tokens/new?scopes=gist&description=filebeam${RESET}\n"
  printf "\n"

  # Read from /dev/tty so it works when the script is piped via curl | sh.
  # Test that /dev/tty can actually be opened before using it.
  printf "  ${BOLD}Paste your GitHub Personal Access Token (Enter to skip):${RESET} "
  stty -echo 2>/dev/null || true
  if { true </dev/tty; } 2>/dev/null; then
    read -r GITHUB_TOKEN </dev/tty
  else
    read -r GITHUB_TOKEN
  fi
  stty echo 2>/dev/null || true
  printf "\n"

  # Strip any trailing whitespace or carriage returns
  GITHUB_TOKEN=$(printf '%s' "$GITHUB_TOKEN" | tr -d '[:space:]')

  if [ -z "$GITHUB_TOKEN" ]; then
    warn "Skipped — run 'filebeam config github-gist <token>' later"
    return
  fi

  filebeam config github-gist "$GITHUB_TOKEN" >/dev/null
  success "Token saved"
}

# ── Skill ─────────────────────────────────────────────────────────────────────

install_skill() {
  if ! command -v npx >/dev/null 2>&1; then
    warn "Skipping skill install — npx not found (install Node.js to enable)"
    return
  fi

  info "Installing agent skill..."
  npx --yes skills add navayuvan-sb/filebeam
  success "Agent skill installed"
}

# ── Run ───────────────────────────────────────────────────────────────────────

printf "\n"
printf "  ${BOLD}filebeam${RESET} installer\n"
printf "  $(printf '%0.s─' $(seq 1 20))\n"
printf "\n"

install_cli
configure_token
install_skill

printf "\n"
printf "  ${GREEN}${BOLD}All done!${RESET}  Run: ${CYAN}filebeam upload <file>${RESET}\n"
printf "\n"
