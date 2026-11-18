FLAKE8_EXCLUDE = --exclude=.venv,moulinette,__pycache__
MYPY_EXCLUDE = --exclude '(\.venv|moulinette|__pycache__)'
export UV_CACHE_DIR = /goinfre/$(USER)/.cache/uv
export HF_HOME = /goinfre/$(USER)/.cache/huggingface
export UV_PYTHON_INSTALL_DIR = /goinfre/$(USER)/.cache/uv/python

.PHONY: install-42 install run debug clean fclean re re-42 lint lint-strict doc sandbox

install-42:
	@which uv > /dev/null 2>&1 || pip install --user uv
	mkdir -p /goinfre/$(USER)/AgentSmith_env
	mkdir -p $(UV_CACHE_DIR)
	mkdir -p $(HF_HOME)
	uv venv /goinfre/$(USER)/AgentSmith_env/.venv
	ln -sfn /goinfre/$(USER)/AgentSmith_env/.venv .venv
	uv sync

install:
	@which uv > /dev/null 2>&1 || pip install --user uv
	uv sync

run:
	uv run python -m

sandbox:
	uv run sandbox

debug:
	uv run python -m

clean:
	find . -path ./.venv -prune -o -path ./moulinette -prune -o -name "__pycache__" -exec rm -rf {} +
	find . -path ./.venv -prune -o -path ./moulinette -prune -o -name ".mypy_cache" -exec rm -rf {} +
	rm -rf *.egg-info

fclean: clean
	rm -rf /goinfre/$(USER)/AgentSmith_env
	rm -rf $(UV_CACHE_DIR)
	rm -rf $(HF_HOME)
	rm -rf .venv

re: fclean install

re-42: fclean install-42

lint:
	uv run flake8 $(FLAKE8_EXCLUDE)
	uv run mypy --warn-return-any --warn-unused-ignores --ignore-missing-imports --disallow-untyped-defs --check-untyped-defs . $(MYPY_EXCLUDE)

lint-strict:
	uv run flake8 $(FLAKE8_EXCLUDE)
	uv run mypy --strict . $(MYPY_EXCLUDE)

doc:
	uv run pydocstyle src