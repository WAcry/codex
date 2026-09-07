#!/usr/bin/env python3
"""只在 CI 或发布任务的临时 checkout 中写入 workspace 版本。"""

import os
import sys
from pathlib import Path


def main() -> None:
    base_version = os.environ.get("BASE_VERSION", "").strip()
    target_version = os.environ.get("TARGET_VERSION", "").strip()
    if not base_version:
        raise SystemExit("BASE_VERSION is empty")
    if not target_version:
        raise SystemExit("TARGET_VERSION is empty")

    cargo_toml = Path("codex-rs/Cargo.toml")
    text = cargo_toml.read_text(encoding="utf-8")
    needle = f'version = "{base_version}"'
    if needle not in text:
        raise SystemExit(f"{cargo_toml} does not contain {needle}")
    cargo_toml.write_text(
        text.replace(needle, f'version = "{target_version}"', 1),
        encoding="utf-8",
    )
    print(f"updated {cargo_toml} workspace version to {target_version}")


if __name__ == "__main__":
    sys.exit(main())
