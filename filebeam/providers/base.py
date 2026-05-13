from abc import ABC, abstractmethod
from dataclasses import dataclass
from pathlib import Path


@dataclass
class UploadResult:
    url: str
    provider: str
    file_name: str


class StorageProvider(ABC):
    name: str

    @abstractmethod
    def upload(self, file_path: Path, description: str = "", public: bool = True) -> UploadResult:
        ...
