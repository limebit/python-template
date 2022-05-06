VENV_NAME?=.venv

USER_PYTHON ?= python3
VENV_PYTHON=${VENV_NAME}/bin/python

prepare-venv: $(VENV_NAME)/bin/activate

$(VENV_NAME)/bin/activate:
	test -d $(VENV_NAME) || ${USER_PYTHON} -m venv $(VENV_NAME)
	touch $(VENV_NAME)/bin/activate

initialize:
	sed -i "" s/custom_module/$(subst -,_,$(notdir $(CURDIR)))/g docker-compose.yml
	sed -i "" s/custom_module/$(subst -,_,$(notdir $(CURDIR)))/g setup.py
	mv custom_module $(subst -,_,$(notdir $(CURDIR)))

install: prepare-venv
	${VENV_PYTHON} -m pip install -U pip
	${VENV_PYTHON} -m pip install -r requirements.txt
	${VENV_PYTHON} -m pip install -e .

lint: install
	${VENV_PYTHON} -m flake8

format: install
	${VENV_PYTHON} -m black src

clean:
	rm -rf .venv
