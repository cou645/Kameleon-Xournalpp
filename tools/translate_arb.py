#!/usr/bin/env python3
"""Translate Flutter ARB files using the local `hashtext` binary.

Usage:
  tools/translate_arb.py [de pt es ...]

The script reads lib/l10n/intl_en.arb, translates any missing strings into the
requested languages, and writes/updates lib/l10n/intl_<lng>.arb.
"""

import json
import subprocess
import sys
import time
from pathlib import Path

ARB_DIR = Path(__file__).parent.parent / "lib" / "l10n"
SOURCE = ARB_DIR / "intl_en.arb"


def translate(text: str, lang: str, attempts: int = 5, delay: float = 1.5) -> str:
    """Translate a single string, retrying until the cache is populated."""
    for _ in range(attempts):
        result = (
            subprocess.check_output(["hashtext", lang, text], text=True)
            .strip()
        )
        if result != text:
            return result
        time.sleep(delay)
    print(f"  warning: could not translate to {lang}: {text!r}", file=sys.stderr)
    return text


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <lang> [<lang> ...]", file=sys.stderr)
        sys.exit(1)

    langs = sys.argv[1:]
    with SOURCE.open("r", encoding="utf-8") as f:
        source_data = json.load(f)

    for lang in langs:
        target_path = ARB_DIR / f"intl_{lang}.arb"
        if target_path.exists():
            with target_path.open("r", encoding="utf-8") as f:
                target_data = json.load(f)
        else:
            target_data = {}

        updated = False
        for key, value in source_data.items():
            if key in target_data:
                continue
            if not isinstance(value, str):
                target_data[key] = value
                updated = True
                continue
            print(f"[{lang}] {key}: {value!r}")
            target_data[key] = translate(value, lang)
            updated = True

        if updated:
            with target_path.open("w", encoding="utf-8") as f:
                json.dump(target_data, f, ensure_ascii=False, indent=2)
                f.write("\n")
            print(f"Wrote {target_path}")
        else:
            print(f"{target_path} is up to date")


if __name__ == "__main__":
    main()
