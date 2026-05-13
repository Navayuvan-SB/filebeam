import json
import urllib.request
import urllib.error
from pathlib import Path
from typing import Optional

from .base import StorageProvider, UploadResult
from .. import config as cfg

GIST_API = "https://api.github.com/gists"


class GitHubGistProvider(StorageProvider):
    name = "github-gist"

    def __init__(self, token: Optional[str] = None):
        self.token = token or cfg.get_token(self.name)
        if not self.token:
            raise ValueError(
                "GitHub token not configured. Run: filebeam config set-token <token>"
            )

    def upload(self, file_path: Path, description: str = "", public: bool = True) -> UploadResult:
        content = file_path.read_text(encoding="utf-8", errors="replace")
        payload = json.dumps({
            "description": description,
            "public": public,
            "files": {file_path.name: {"content": content}},
        }).encode()

        req = urllib.request.Request(
            GIST_API,
            data=payload,
            headers={
                "Authorization": f"Bearer {self.token}",
                "Accept": "application/vnd.github+json",
                "Content-Type": "application/json",
                "X-GitHub-Api-Version": "2022-11-28",
            },
            method="POST",
        )

        try:
            with urllib.request.urlopen(req) as resp:
                data = json.loads(resp.read())
        except urllib.error.HTTPError as e:
            body = e.read().decode()
            raise RuntimeError(f"GitHub API error {e.code}: {body}") from e

        return UploadResult(
            url=data["html_url"],
            provider=self.name,
            file_name=file_path.name,
        )
