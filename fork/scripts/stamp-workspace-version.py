#!/usr/bin/env python3
"""只在发布任务的临时 checkout 中写入 workspace 版本。"""

import os
import sys
from pathlib import Path


def main() -> None:
    base_version = os.environ.get("BASE_VERSION", "").strip()
    version = os.environ.get("FORK_VERSION", "").strip()
    if not base_version:
        raise SystemExit("BASE_VERSION 为空")
    if not version:
        raise SystemExit("FORK_VERSION 为空")

    cargo_toml = Path("codex-rs/Cargo.toml")
    text = cargo_toml.read_text(encoding="utf-8")
    needle = f'version = "{base_version}"'
    if needle not in text:
        raise SystemExit(f"{cargo_toml} 中没有 {needle}")
    cargo_toml.write_text(text.replace(needle, f'version = "{version}"', 1), encoding="utf-8")
    print(f"已把 {cargo_toml} 的版本改为 {version}")


if __name__ == "__main__":
    sys.exit(main())
