"""Validate repository config syntax and reject duplicate configuration keys."""

import json

# Only Git file enumeration; no shell execution.
import subprocess  # nosec B404
import tomllib
from pathlib import Path

import json5
import yaml


class UniqueKeyLoader(yaml.SafeLoader):
    """Reject YAML keys that would otherwise silently override earlier values."""


def unique_pairs(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate key: {key!r}")
        result[key] = value
    return result


def unique_yaml_mapping(loader, node):
    return unique_pairs(
        (loader.construct_object(key), loader.construct_object(value)) for key, value in node.value
    )


UniqueKeyLoader.add_constructor(yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, unique_yaml_mapping)


def load_yaml(text):
    loader = UniqueKeyLoader(text)
    try:
        return loader.get_single_data()
    finally:
        loader.dispose()


def main():
    root = Path(__file__).resolve().parents[1]
    # Fixed Git arguments, no user-supplied command or shell.
    # Git is a required developer tool on PATH.
    result = subprocess.run(  # nosec B603 B607
        ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"],
        cwd=root,
        check=True,
        capture_output=True,
    )
    count = 0
    for name in sorted(set(result.stdout.decode().rstrip("\0").split("\0"))):
        path = root / name
        suffix = path.suffix
        if suffix not in {".json", ".toml", ".yml", ".yaml"} and name != "configs/gemrc":
            continue
        try:
            text = path.read_text()
            if name == "configs/zed/settings.json":
                # Zed accepts JSON with comments and trailing commas.
                json5.loads(text, allow_duplicate_keys=False)
            elif suffix == ".json":
                json.loads(text, object_pairs_hook=unique_pairs)
            elif suffix == ".toml":
                tomllib.loads(text)
            else:
                # This loader derives from SafeLoader; it cannot create Python objects.
                load_yaml(text)
        except (ValueError, yaml.YAMLError) as error:
            raise SystemExit(f"{name}: {error}") from error
        count += 1
    print(f"Validated {count} configuration files")


if __name__ == "__main__":
    main()
