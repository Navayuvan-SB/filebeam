<h1 align="center">filebeam</h1>

<p align="center">
  <b>Beam files up to storage providers from your terminal. Point it at a file, get a URL back.</b>
</p>

<p align="center">
  <a href="https://pypi.org/project/filebeam"><img src="https://img.shields.io/pypi/v/filebeam?label=pypi&color=orange" alt="PyPI version"></a>
  <a href="https://github.com/navayuvan-sb/filebeam/blob/main/LICENSE"><img src="https://img.shields.io/github/license/navayuvan-sb/filebeam?color=brightgreen" alt="License"></a>
  <a href="https://github.com/navayuvan-sb/filebeam/commits/main"><img src="https://img.shields.io/github/last-commit/navayuvan-sb/filebeam?color=brightgreen" alt="Last commit"></a>
</p>

<p align="center">
  <a href="https://github.com/navayuvan-sb/filebeam/actions/workflows/publish.yml"><img src="https://github.com/navayuvan-sb/filebeam/actions/workflows/publish.yml/badge.svg" alt="CI"></a>
</p>

Ships with **GitHub Gist** support today. Built with a provider abstraction so adding S3, Cloudflare R2, Pastebin, or anything else is a matter of implementing one class.

---

## Installation

```bash
pip install filebeam
```

Or from source:

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

**2. Upload a file**

```bash
filebeam upload notes.md
# https://gist.github.com/abc123...
```

The URL is printed to stdout — pipe it anywhere:

```bash
filebeam upload script.py | pbcopy        # copy to clipboard (macOS)
filebeam upload report.txt | xclip        # copy to clipboard (Linux)
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
| `--provider` | `-p` | Provider to upload to (default: `github-gist`) |
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

## Providers

### Available now

| Provider | Command | Notes |
|----------|---------|-------|
| **GitHub Gist** | `filebeam config github-gist <token>` | Needs `gist` scope |

### Planned

| Provider | Status |
|----------|--------|
| **AWS S3** | Planned — upload to a bucket, returns object URL |
| **Cloudflare R2** | Planned — S3-compatible, no egress fees |
| **Pastebin** | Planned — text-only, wide reach |
| **0x0.st** | Planned — anonymous, no account needed |

Want to add one? See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Claude Code skill

filebeam ships a [Claude Code](https://claude.ai/code) skill so any AI agent in your project can upload files without you having to explain the CLI.

**Install the skill:**

```bash
npx skills add navayuvan-sb/filebeam
```

Once installed, the agent understands commands like _"upload this file to Gist"_ or _"beam notes.md and give me the URL"_ — and knows how to handle tokens, errors, and provider flags.

---

## License

MIT — see [LICENSE](LICENSE).
