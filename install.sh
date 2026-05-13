#!/bin/sh
set -e

REPO="navayuvan-sb/filebeam"
PYPI_PACKAGE="filebeam"

echo ""
echo "  filebeam installer"
echo "  =================="
echo ""

# ── CLI ──────────────────────────────────────────────────────────────────────

install_cli() {
  if command -v pip3 >/dev/null 2>&1; then
    PIP=pip3
  elif command -v pip >/dev/null 2>&1; then
    PIP=pip
  else
    echo "  [error] pip not found. Install Python 3 first: https://python.org"
    exit 1
  fi

  echo "  [1/2] Installing filebeam CLI..."
  $PIP install --quiet --upgrade "$PYPI_PACKAGE"
  echo "  [1/2] CLI installed."
}

# ── Skill ─────────────────────────────────────────────────────────────────────

install_skill() {
  if ! command -v npx >/dev/null 2>&1; then
    echo "  [2/2] Skipping skill install — npx not found (install Node.js to enable)."
    return
  fi

  echo "  [2/2] Installing agent skill..."
  npx --yes skills add "$REPO" --silent 2>/dev/null || \
    npx --yes skills add "$REPO"
  echo "  [2/2] Skill installed."
}

# ── Run ───────────────────────────────────────────────────────────────────────

install_cli
install_skill

echo ""
echo "  Done! Verify with: filebeam --help"
echo ""
