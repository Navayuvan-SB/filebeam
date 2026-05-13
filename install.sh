#!/bin/sh
set -e

REPO="navayuvan-sb/filebeam"
PYPI_PACKAGE="filebeam"

echo ""
echo "  filebeam installer"
echo "  =================="
echo ""

# ── CLI ───────────────────────────────────────────────────────────────────────

install_cli() {
  if command -v pip3 >/dev/null 2>&1; then
    PIP=pip3
  elif command -v pip >/dev/null 2>&1; then
    PIP=pip
  else
    echo "  [error] pip not found. Install Python 3 first: https://python.org"
    exit 1
  fi

  echo "  [1/3] Installing filebeam CLI..."
  $PIP install --quiet --upgrade "$PYPI_PACKAGE"
  echo "  [1/3] CLI installed."
}

# ── Token ─────────────────────────────────────────────────────────────────────

configure_token() {
  echo ""
  echo "  [2/3] GitHub token setup"
  echo ""
  echo "  filebeam uploads to GitHub Gist. You need a personal access token"
  echo "  with the 'gist' scope."
  echo ""
  echo "  Generate one at:"
  echo "  https://github.com/settings/tokens/new?scopes=gist&description=filebeam"
  echo ""

  # stty -echo disables terminal echo so the token isn't visible as it's typed
  printf "  Paste your token (input hidden): "
  stty -echo 2>/dev/null || true
  read -r GITHUB_TOKEN
  stty echo 2>/dev/null || true
  echo ""

  if [ -z "$GITHUB_TOKEN" ]; then
    echo "  [2/3] No token entered — skipping. Run 'filebeam config github-gist <token>' later."
    return
  fi

  filebeam config github-gist "$GITHUB_TOKEN"
  echo "  [2/3] Token saved."
}

# ── Skill ─────────────────────────────────────────────────────────────────────

install_skill() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "  [3/3] Skipping skill install — npx not found (install Node.js to enable)."
    return
  fi

  echo "  [3/3] Installing agent skill..."
  npx --yes skills add "$REPO" --silent 2>/dev/null || \
    npx --yes skills add "$REPO"
  echo "  [3/3] Skill installed."
}

# ── Run ───────────────────────────────────────────────────────────────────────

install_cli
configure_token
install_skill

echo ""
echo "  All done! Try it:"
echo "  filebeam upload <file>"
echo ""
