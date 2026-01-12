# Recipes
all: init

init: network
	make mariadb
network:
	@docker network create -d bridge databases-network 2>/dev/null || true
	@docker network create -d bridge global-default 2>/dev/null || true

portainer:
	@./.make/cmd.sh -f container-visibility/docker-compose-portainer.yaml up -d

#Databases
mariadb: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-mariadb.yaml up -d
mysql: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-mysql.yaml up -d
postgres: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-postgres.yaml up -d
mongo: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-mongo.yaml up -d

#ElasticSearch
elasticsearch:
	@./.make/cmd.sh -f elasticsearch/docker-compose-cluster.yaml up -d
cerebro:
	@./.make/cmd.sh -f elasticsearch/docker-compose-cerebro.yaml up -d

#Redis
redis-single:
	@./.make/cmd.sh -f redis/docker-compose-redis-single.yaml up -d
redis-cluster:
	@./.make/cmd.sh -f redis/docker-compose-cluster.yaml up -d
redis-insight:
	@./.make/cmd.sh -f redis/docker-compose-insight.yaml up -d

kafka:
	@./.make/cmd.sh -f kafka/docker-compose-kafka.yaml up -d

#Mock
mock:
	@./.make/cmd.sh -f mock/docker-compose.yaml up -d

#AWS
aws-sqs:
	@./.make/cmd.sh -f aws/docker-compose-sqs.yaml up

sonarqube:
	@./.make/cmd.sh -f qa/docker-compose-sonarqube.yaml up -d

# CI/CD
drone:
	@./.make/cmd.sh -f ci-cd/docker-compose.yml up -d

drone-down:
	@./.make/cmd.sh -f ci-cd/docker-compose.yml down

drone-logs:
	@docker-compose -f ci-cd/docker-compose.yml logs -f

drone-restart:
	@./.make/cmd.sh -f ci-cd/docker-compose.yml restart

.PHONY: all
