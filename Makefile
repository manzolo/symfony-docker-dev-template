COMPOSE_FILE := compose.dev.yaml
DB_SERVICE := symfony-mysql
WORKSPACE_SERVICE := symfony-workspace
DB_SERVICE := symfony-mysql

BACKUP_FILE := var/db_backup.sql
include .env
include .env.dev
export

build:
	docker compose -f $(COMPOSE_FILE) build

stop:
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) rm -f

restart:
	docker compose -f $(COMPOSE_FILE) down
	docker compose -f $(COMPOSE_FILE) rm -f
	docker compose -f $(COMPOSE_FILE) up -d

start:
	docker compose -f $(COMPOSE_FILE) up -d

status:
	docker compose -f $(COMPOSE_FILE) ps

test-mail:
	docker compose -f $(COMPOSE_FILE) exec $(WORKSPACE_SERVICE) /bin/bash -c 'bin/console mailer:test --from manzolo@example.it --subject Prova --body Corpo manzolo@target.it'

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

enter:
	docker compose -f $(COMPOSE_FILE) exec ${WORKSPACE_SERVICE} /bin/bash
root:
	docker compose -f $(COMPOSE_FILE) exec -u root ${WORKSPACE_SERVICE} /bin/bash

backupdb:
	docker compose -f $(COMPOSE_FILE) exec $(DB_SERVICE) /bin/bash -c 'mysqldump -h${DB_HOST} -uroot -p${DB_ROOT_PASSWORD} ${DB_DATABASE}' > var/db_backup_$(shell date +%Y%m%d_%H%M%S).sql
#	docker compose -f $(COMPOSE_FILE) exec $(DB_SERVICE) /bin/bash -c 'mysqldump -h${DB_HOST} -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_DATABASE}' > var/db_backup_$(shell date +%Y%m%d_%H%M%S).sql
#	docker compose -f $(COMPOSE_FILE) exec $(DB_SERVICE) /bin/bash -c 'mysqldump -h$${DB_HOST} -uroot -p$${DB_ROOT_PASSWORD} $${DB_DATABASE} > /tmp/backup_$$(date +%Y%m%d_%H%M%S).sql'
# docker compose run --remove-orphans -it $(DB_SERVICE)-backup bash -c 'mysqldump -h${DB_HOST} -uroot -p${DB_ROOT_PASSWORD} ${DB_DATABASE} > /backups/backup_$(date +%Y%m%d_%H%M%S).sql'
# docker compose run --remove-orphans -it $(DB_SERVICE)-backup bash -c 'mysql -h${DB_HOST} -uroot -p${DB_ROOT_PASSWORD} ${DB_DATABASE} < /backups/backup_YOUR_TIMESTAMP.sql'
restoredb:
# docker compose -f $(COMPOSE_FILE) exec $(DB_SERVICE) /bin/bash -c 'mysqldump -h${DB_HOST} -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_DATABASE}' > var/db_backup.sql
	docker compose -f $(COMPOSE_FILE) exec -T $(DB_SERVICE) /bin/bash -c 'mysql -h${DB_HOST} -u${DB_USERNAME} -p${DB_PASSWORD} ${DB_DATABASE}' < "${BACKUP_FILE}"
