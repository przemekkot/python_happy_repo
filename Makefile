.PHONY: help clean clean-build clean-pyc clean-test coverage check_code dist dist-upload docs document docker format_code install lint requirements servedocs test test-all virtualenv activate env test-xunit

.DEFAULT_GOAL := help

define BROWSER_PYSCRIPT
import os, webbrowser, sys

try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

BROWSER := python -c "$$BROWSER_PYSCRIPT"

PACKAGE_NAME=happy_repo

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

activate:
	source .venv/bin/activate

commit:
	make lint
	git commit

clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache

coverage: ## check code coverage quickly with the default Python
	coverage run --source $(PACKAGE_NAME) -m pytest
	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

check_code:
	pycodestyle ./$(PACKAGE_NAME)/*
	pycodestyle ./tests/*

dist: clean
	rm -rf dist/*
	python setup.py sdist
	python setup.py bdist_wheel

dist-test-upload:
	twine upload --repository-url https://test.pypi.org/legacy/  dist/* -u ${PYPI_USER} -p ${PYPI_PASS}

dist-upload:
	twine upload dist/* -u ${PYPI_USER} -p ${PYPI_PASS}

docs: ## generate Sphinx HTML documentation, including API docs
	rm -f docs/happy_repo.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ $(PACKAGE_NAME)
	$(MAKE) -C docs clean
	$(MAKE) -C docs html
	$(BROWSER) docs/_build/html/index.html

document:
	pycco -spi -d docs/literate $(PACKAGE_NAME)/*

docker: clean
	docker build -t $(PACKAGE_NAME):latest .

env:
	make virtualenv
	make activate

format_code:
	autopep8 -i -r -aaa ./$(PACKAGE_NAME)/*
	autopep8 -i -r -aaa ./tests/*

install-self:
	pip install $(PACKAGE_NAME)

install: clean ## install the package to the active Python's site-packages
	python setup.py install

lint: ## check style with flake8
	flake8 $(PACKAGE_NAME) tests

pipeline:
	make lint
	make test-all
	make test-xunit
	make coverage
	make push-to-test
	make dist
	make dist-test-upload PYPI_USER=${PYPI_USER} PYPI_PASS=${PYPI_PASS}
	make push-to-master
	make push-to-przemek
	make push-to-release
	make dist
	make dist-upload PYPI_USER=${PYPI_USER} PYPI_PASS=${PYPI_PASS}

push-tags:
	git push origin --tags

push-to-tests:
	git checkout origin/tests
	git merge origin/dev
	git push origin origin/tests

push-to-master:
	git checkout origin/master
	git merge origin/tests
	git push origin origin/master

push-to-przemek:
	git checkout origin/master
	git push przemekkot --tags
	git push przemekkot origin/master

push-to-oren:
	git checkout origin/release
	git push orenkot --tags
	git push orenkot refs/heads/release:refs/heads/master

requirements:
	.venv/bin/pip freeze --local > requirements.txt

servedocs: docs ## compile the docs watching for changes
	watchmedo shell-command -p '*.rst' -c '$(MAKE) -C docs html' -R -D .

test:
	python -m pytest \
		-v \
		tests/

test-xunit:
	mkdir -p build
	python -m pytest \
		--junitxml=build/output_pytest.xml \
		-v \
		tests/

test-all: ## run tests on every Python version with tox
	tox

virtualenv:
	virtualenv --prompt '|> happy_repo <| ' .venv
	.venv/bin/pip install -r requirements-dev.txt
	.venv/bin/python setup.py develop
	@echo
	@echo "VirtualENV Setup Complete. Now run: source .venv/bin/activate"
	@echo

