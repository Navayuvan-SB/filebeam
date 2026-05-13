from .base import StorageProvider, UploadResult
from .github_gist import GitHubGistProvider

PROVIDERS: "dict[str, type[StorageProvider]]" = {
    GitHubGistProvider.name: GitHubGistProvider,
}

DEFAULT_PROVIDER = GitHubGistProvider.name

__all__ = ["StorageProvider", "UploadResult", "GitHubGistProvider", "PROVIDERS", "DEFAULT_PROVIDER"]
