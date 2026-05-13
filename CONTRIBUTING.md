# Contributing to filebeam

Thanks for taking the time to contribute. This document covers how to set up the project locally, the conventions to follow, and how to add a new provider.

---

## Development setup

```bash
git clone https://github.com/navayuvan-sb/filebeam
cd filebeam
pip install -e .
```

Optionally install the Claude Code skill so your agent can use filebeam during development:

```bash
npx skills add navayuvan-sb/filebeam
```

Verify the CLI is wired up:

```bash
filebeam --help
```

No external dependencies — the project uses only the Python standard library.

---

## Project structure

```
filebeam/
├── cli.py               # Argument parsing and command dispatch
├── config.py            # Read/write ~/.filebeam-config
├── providers/
│   ├── base.py          # StorageProvider ABC + UploadResult dataclass
│   ├── __init__.py      # Provider registry (PROVIDERS dict)
│   └── github_gist.py   # GitHub Gist implementation
pyproject.toml
```

The two things that matter most:

- **`StorageProvider`** (`providers/base.py`) — the interface every provider must implement.
- **`PROVIDERS`** (`providers/__init__.py`) — the registry the CLI reads at startup. Adding an entry here is all it takes to make a provider available.

---

## Adding a new provider

### 1. Create the provider module

Add `filebeam/providers/<your_provider>.py`:

```python
from pathlib import Path
from typing import Optional
from .base import StorageProvider, UploadResult
from .. import config as cfg


class MyProvider(StorageProvider):
    name = "my-provider"          # used as the CLI name and config key

    def __init__(self, token: Optional[str] = None):
        self.token = token or cfg.get_token(self.name)
        if not self.token:
            raise ValueError(
                f"Token required. Run: filebeam config {self.name} <token>"
            )

    def upload(self, file_path: Path, description: str = "", public: bool = True) -> UploadResult:
        # ... call your provider's API here ...
        url = "https://example.com/your-uploaded-file"
        return UploadResult(url=url, provider=self.name, file_name=file_path.name)
```

### 2. Register it

In `filebeam/providers/__init__.py`, import and add it to `PROVIDERS`:

```python
from .my_provider import MyProvider

PROVIDERS: "dict[str, type[StorageProvider]]" = {
    GitHubGistProvider.name: GitHubGistProvider,
    MyProvider.name: MyProvider,           # add this line
}
```

That's it. The CLI automatically picks up the new provider:

```bash
filebeam config my-provider <token>
filebeam upload file.txt --provider my-provider
```

### 3. Notes

- The `name` attribute is the CLI-facing identifier. Use lowercase with hyphens (`aws-s3`, `cloudflare-r2`).
- If your provider uses multiple credentials (key + secret, region, bucket), store them as separate fields under the provider's config key — you can extend `get_token` / `set_token` in `config.py` or add dedicated helpers.
- Keep provider modules self-contained. Avoid adding dependencies beyond the standard library if possible; if a third-party SDK is truly necessary, add it to `pyproject.toml` as an optional dependency.

---

## Pull request checklist

- [ ] `filebeam --help` and `filebeam upload --help` still render cleanly
- [ ] `filebeam config show` works with the new provider
- [ ] No new mandatory dependencies unless justified
- [ ] README provider table updated if adding a new provider

---

## Reporting issues

Open an issue on GitHub with:

1. The command you ran
2. The full error output
3. Your Python version (`python3 --version`)
