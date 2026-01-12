# Recipes
all: init

init: network
	make mariadb
network:
	@docker network create -d bridge databases-network 2>/dev/null || true
	@docker network create -d bridge global-default 2>/dev/null || true

portainer:
	@./.make/cmd.sh -f container-visibility/docker-compose.yml up -d
portainer-down:
	@docker rm -f portainer 2>/dev/null || true

#Databases
mariadb: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-mariadb.yaml up -d
mariadb-down:
	@docker rm -f mariadb 2>/dev/null || true
mysql: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-mysql.yaml up -d
mysql-down:
	@docker rm -f mysql 2>/dev/null || true
postgres: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-postgres.yaml up -d
postgres-down:
	@docker rm -f postgres pgadmin 2>/dev/null || true
mongo: network
	@./.make/cmd.sh -f databases/docker-compose.yml -f databases/docker-compose-mongo.yaml up -d
mongo-down:
	@docker rm -f mongodb mongodb-express 2>/dev/null || true

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

rabbitmq:
	@./.make/cmd.sh -f queues/docker-compose-rabbitmq.yaml up -d
rabbitmq-down:
	@docker rm -f rabbitmq 2>/dev/null || true

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

# VPN
openvpn:
	@./.make/cmd.sh -f vpn/docker-compose.yml up -d

openvpn-down:
	@docker rm -f openvpn-as 2>/dev/null || true

openvpn-logs:
	@docker logs -f openvpn-as

openvpn-change-password:
	@echo "Digite a nova senha para o usuário 'openvpn':"
	@read -p "Nova senha: " senha && docker exec openvpn-as /usr/local/openvpn_as/scripts/confdba -u -p openvpn -k pass -v "$$senha" && echo "✅ Senha alterada com sucesso!"

openvpn-users:
	@docker exec openvpn-as /usr/local/openvpn_as/scripts/userdba --show

.PHONY: all
