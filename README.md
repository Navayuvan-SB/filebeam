# filebeam

A minimal CLI tool to beam files up to storage providers. Point it at a file, get a URL back.

Ships with **GitHub Gist** support today. Built with a provider abstraction so adding S3, Cloudflare R2, Pastebin, or anything else is a matter of implementing one class.

---

## Installation

```bash
pip install filebeam
```

Or from source:

```bash
git clone https://github.com/your-username/filebeam
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

## License

MIT — see [LICENSE](LICENSE).
