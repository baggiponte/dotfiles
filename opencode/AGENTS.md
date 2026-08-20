# Running code

- **Python:** run Python code and one-off scripts with `uv` (e.g. `uv run python ...`, `uv run script.py`). Do not use bare `python`, `pip`, or `venv` directly.
- **JS/Node:** prefer running packages with `pnpx` or `bunx` instead of installing them globally. If they are not available or discoverable, use `mise x`.
- Use `just` instead of `make`.
- Use `prek` instead of `pre-commit`.
- Place environment variables in `.env` files and run them with `uv run --env-file=.env -- ...`.
- Don't use `.env` files for configurations. Just for sensitive data.

# Toolchains

Should be managed with `mise`, except for Python which is _always_ managed with `uv`.

- Install global toolchains with mise and activate them.
- For one-off stuff, use `mise x ...`.

# Dont's

Don't validate Python code with `py_compile`. It's not real validation.
