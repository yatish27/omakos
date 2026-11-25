PYTHON ?= python3

.PHONY: check lint security test

check: lint security test

lint:
	bash scripts/lint.sh
	ruff check .
	ruff format --check .
	$(PYTHON) scripts/check_configs.py

security:
	bandit -r scripts tests
	gitleaks dir . --redact --no-banner
	gitleaks git . --redact --no-banner
	pip-audit -r requirements-dev.txt

test:
	$(PYTHON) -m unittest discover -s tests -v
