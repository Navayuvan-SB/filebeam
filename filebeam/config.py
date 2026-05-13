import json
from pathlib import Path
from typing import Optional


def _config_path() -> Path:
    return Path.home() / ".filebeam-config"


def load() -> dict:
    path = _config_path()
    if not path.exists():
        return {}
    return json.loads(path.read_text())


def save(data: dict) -> None:
    _config_path().write_text(json.dumps(data, indent=2))


def get_token(provider: str) -> Optional[str]:
    return load().get("providers", {}).get(provider, {}).get("token")


def set_token(provider: str, token: str) -> None:
    data = load()
    data.setdefault("providers", {}).setdefault(provider, {})["token"] = token
    save(data)
