---
name: filebeam
description: "Upload files to storage providers via the filebeam CLI. Use when the user wants to upload a file to GitHub Gist or another provider, share a file and get a URL back, configure provider credentials, or check what tokens are stored."
compatibility: "Requires filebeam to be installed (`pip install filebeam`) and a token configured via `filebeam config <provider> <token>`."
license: MIT
metadata:
  author: Navayuvan
  version: "0.1.0"
---

# filebeam

CLI tool to upload files to storage providers. Prints the resulting URL to stdout.

## Core patterns

- Always check that the file exists before uploading.
- The default provider is `github-gist`. Pass `--provider` only when the user specifies a different one.
- If an upload fails with a credentials error, direct the user to run `filebeam config <provider> <token>` — do not ask for the token yourself.
- The URL is printed to stdout on success. Capture or display it to the user.
- Treat token values as secrets. Never echo them back or include them in output shown to the user.

## Commands

### Upload a file

```bash
filebeam upload <file>
filebeam up <file>                              # alias

filebeam upload <file> --description "..."     # attach a description
filebeam upload <file> --private               # secret/private upload
filebeam upload <file> --provider github-gist  # explicit provider
filebeam upload <file> --token <tok>           # one-off token override (not stored)
```

### Configure credentials

```bash
# Store a token for a provider (persisted to ~/.filebeam-config)
filebeam config github-gist <token>

# Show all stored tokens (values are masked)
filebeam config show
```

Tokens are stored in `~/.filebeam-config` as JSON. Never read or edit this file directly on behalf of the user — use the CLI commands above.

### Help

```bash
filebeam --help
filebeam upload --help
filebeam config --help
filebeam config github-gist --help
```

## Providers

| Provider | CLI name | Config command |
|----------|----------|----------------|
| GitHub Gist | `github-gist` | `filebeam config github-gist <token>` |

GitHub token needs only the `gist` scope. Generate at: **GitHub → Settings → Developer settings → Personal access tokens**.

## Common workflows

**Upload and copy URL to clipboard (macOS)**
```bash
filebeam upload notes.md | pbcopy
```

**Upload privately with a description**
```bash
filebeam upload script.py --description "deploy helper" --private
```

**First-time setup**
```bash
filebeam config github-gist ghp_xxxxxxxxxxxx
filebeam upload myfile.txt
```

## Error handling

| Error | Cause | Fix |
|-------|-------|-----|
| `Token required` | No token stored for provider | `filebeam config github-gist <token>` |
| `GitHub API error 401` | Token invalid or expired | Generate a new token and re-run config |
| `file not found` | Path does not exist | Verify the file path |
| `not a file` | Path is a directory | Provide a path to a specific file |
