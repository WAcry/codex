#!/usr/bin/env python3
"""Write FORK_VERSION into [workspace.package] for a release checkout only."""

from __future__ import annotations

import os
import sys
from pathlib import Path


def main() -> None:
    version = os.environ.get("FORK_VERSION", "").strip()
    if not version:
        raise SystemExit("FORK_VERSION is empty")

    cargo_toml = Path("codex-rs/Cargo.toml")
    text = cargo_toml.read_text(encoding="utf-8")
    needle = 'version = "0.0.0"'
    if needle not in text:
        raise SystemExit(f"{cargo_toml} does not contain {needle}")
    cargo_toml.write_text(text.replace(needle, f'version = "{version}"', 1), encoding="utf-8")
    print(f"stamped {cargo_toml} -> {version}")


if __name__ == "__main__":
    sys.exit(main())
