.PHONY: up down test lint fmt

up:
	docker compose up --build

down:
	docker compose down

test:
	python -m pytest

lint:
	ruff check .

fmt:
	terraform -chdir=infra fmt
