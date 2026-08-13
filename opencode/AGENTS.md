# Core rules

## Running code

- **Python:** run Python code and one-off scripts with `uv` (e.g. `uv run python ...`, `uv run script.py`). Do not use bare `python`, `pip`, or `venv` directly.
- **JS/Node:** prefer running packages with `pnpx` or `bunx` instead of installing them globally. If they are not available or discoverable, use `mise x`.
- Toolchains, except for `uv`, should be managed with `mise`.

## Dont's

Don't validate Python code with `py_compile`.
