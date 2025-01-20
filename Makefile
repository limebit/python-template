VENV_NAME?=.venv

USER_PYTHON ?= python3
VENV_PYTHON=${VENV_NAME}/bin/python

.PHONY = prepare-venv install test lint format clean

.DEFAULT_GOAL = install

prepare-venv: $(VENV_NAME)/bin/python

$(VENV_NAME)/bin/python:
	make clean && ${USER_PYTHON} -m venv $(VENV_NAME)

install: prepare-venv
	${VENV_PYTHON} -m pip install -U pip
	${VENV_PYTHON} -m pip install -e .

test: install
	${VENV_PYTHON} -m pytest -W error
	cargo test

lint: install
	${VENV_PYTHON} -m ruff check
	${VENV_PYTHON} -m ruff check --select I
	${VENV_PYTHON} -m pyright

format: install
	${VENV_PYTHON} -m ruff check --select I --fix
	${VENV_PYTHON} -m ruff format

clean:
	rm -rf $(VENV_NAME)
	rm -rf .ruff_cache
	rm -rf custom_module.egg-info
	rm -f .vscode/*.log
	find ./custom_module -name __pycache__ -type d -exec rm -r {} +
