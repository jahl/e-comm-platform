build:
	docker compose build server

up:
	docker compose up -d server

down:
	docker compose down --remove-orphans

run-ash:
	docker compose run server ash

run-console:
	docker compose run server rails c

logs:
	docker compose logs -f server

mongo-up:
	docker compose up -d mongo
