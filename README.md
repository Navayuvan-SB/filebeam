<h1 align="center">filebeam</h1>

<p align="center">
  <b>A CLI tool to upload files to the cloud and get a shareable URL — built for AI agents and developers.</b>
</p>

<p align="center">
  <a href="https://pypi.org/project/filebeam"><img src="https://img.shields.io/pypi/v/filebeam?label=pypi&color=orange" alt="PyPI version"></a>
  <a href="https://github.com/navayuvan-sb/filebeam/blob/main/LICENSE"><img src="https://img.shields.io/github/license/navayuvan-sb/filebeam?color=brightgreen" alt="License"></a>
  <a href="https://github.com/navayuvan-sb/filebeam/commits/main"><img src="https://img.shields.io/github/last-commit/navayuvan-sb/filebeam?color=brightgreen" alt="Last commit"></a>
  <img src="https://img.shields.io/badge/agent--ready-blueviolet" alt="Agent ready">
</p>

<p align="center">
  <a href="https://github.com/navayuvan-sb/filebeam/actions/workflows/publish.yml"><img src="https://github.com/navayuvan-sb/filebeam/actions/workflows/publish.yml/badge.svg" alt="CI"></a>
</p>

**filebeam** is a command-line tool to upload any file to cloud storage and instantly get a shareable URL back. Point it at a file, get a link — no browser, no GUI, no friction.

Designed to work seamlessly inside AI agent workflows (Claude Code, Codex, Cursor, Windsurf), but works just as well for developers who prefer the terminal.

Ships with **GitHub Gist** support today. Built with a pluggable provider system so adding AWS S3, Cloudflare R2, Pastebin, or any other cloud storage provider is a matter of implementing one class.

---

## Installation

**One-liner** *(recommended)* — installs the CLI and the agent skill in one shot:

```bash
curl -fsSL https://raw.githubusercontent.com/navayuvan-sb/filebeam/main/install.sh | sh
```

**CLI only:**

```bash
pip install filebeam
```

**From source:**

```bash
git clone https://github.com/navayuvan-sb/filebeam
cd filebeam
pip install -e .
```

---

## Quick start

**1. Save your token once**

```bash
filebeam config github-gist <your-token>
```

> Create a token at **GitHub → Settings → Developer settings → Personal access tokens**.  
> Only the `gist` scope is needed.

**2. Upload any file to the cloud**

```bash
filebeam upload notes.md
# https://gist.github.com/abc123...
```

The shareable URL is printed to stdout — pipe it anywhere:

```bash
filebeam upload script.py | pbcopy        # copy URL to clipboard (macOS)
filebeam upload report.txt | xclip        # copy URL to clipboard (Linux)
```

---

## Usage

```
filebeam upload <file> [options]
filebeam up     <file> [options]      # alias

filebeam config <provider> <token>
filebeam config show
```

### Upload flags

| Flag | Short | Description |
|------|-------|-------------|
| `--provider` | `-p` | Cloud storage provider (default: `github-gist`) |
| `--description` | `-d` | Description attached to the upload |
| `--private` | | Make the upload private / secret |
| `--token` | `-t` | Override the stored token for this run only |

### Config commands

```bash
# Store a token for a provider
filebeam config github-gist ghp_xxxxxxxxxxxx

# See what is stored (tokens are masked)
filebeam config show
```

Credentials are stored locally in `~/.filebeam-config`.

---

## Cloud storage providers

### Available now

| Provider | Command | Notes |
|----------|---------|-------|
| **GitHub Gist** | `filebeam config github-gist <token>` | Needs `gist` scope |

### Planned

| Provider | Status |
|----------|--------|
| **AWS S3** | Planned — upload files to a bucket, returns object URL |
| **Cloudflare R2** | Planned — S3-compatible cloud storage, no egress fees |
| **Pastebin** | Planned — text-only, wide reach |
| **0x0.st** | Planned — anonymous uploads, no account needed |

Want to add a provider? See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Agent skill

filebeam ships an agent skill so any AI coding agent can upload files to the cloud and get shareable URLs without any extra setup or explanation.

Works with **Claude Code**, **Codex**, **Cursor**, **Windsurf**, and any agent that supports the [skills ecosystem](https://github.com/vercel-labs/skills).

**Install:**

```bash
npx skills add navayuvan-sb/filebeam
```

Once installed, the agent understands requests like _"upload this file to Gist"_, _"beam notes.md and give me the URL"_, or _"share this script via filebeam"_ — and handles tokens, errors, and provider selection on its own.

---

## License

MIT — see [LICENSE](LICENSE).
