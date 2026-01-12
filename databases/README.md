# Bancos de Dados - Docker Compose

## Visão Geral

Todos os bancos de dados agora compartilham a mesma rede Docker `databases-network`, permitindo que se comuniquem entre si usando os hostnames dos containers.

## Serviços Disponíveis

### PostgreSQL
- **Hostname**: `postgres`
- **Porta**: `5432`
- **Imagem**: `postgres:16-alpine`
- **Admin UI**: pgAdmin em `http://localhost:5050`

### MariaDB
- **Hostname**: `mariadb`
- **Porta**: `3306`
- **Imagem**: `mariadb:11.2`

### MongoDB
- **Hostname**: `mongo`
- **Porta**: `27017`
- **Imagem**: `mongo:7.0-alpine`
- **Admin UI**: Mongo Express em `http://localhost:8081`

## Como Usar

### Iniciar Todos os Bancos
```bash
make postgres
make mariadb
make mongo
```

Ou via docker-compose diretamente:
```bash
docker-compose -f databases/docker-compose.yml \
  -f databases/docker-compose-postgres.yaml \
  -f databases/docker-compose-mariadb.yaml \
  -f databases/docker-compose-mongo.yaml up -d
```

### Iniciar Serviços Individuais
```bash
make postgres  # PostgreSQL + pgAdmin
make mariadb   # MariaDB
make mongo     # MongoDB + Mongo Express
```

## Comunicação Entre Containers

Como todos estão na mesma rede (`databases-network`), você pode:

- PostgreSQL acessar MongoDB: `mongo:27017`
- PostgreSQL acessar MariaDB: `mariadb:3306`
- MongoDB acessar PostgreSQL: `postgres:5432`
- Etc...

## Variáveis de Ambiente

Configure as credenciais editando o arquivo `.env` ou passando variáveis ao docker-compose:

- `POSTGRES_USER` (padrão: `admin`)
- `POSTGRES_PASSWORD` (padrão: `secret`)
- `MYSQL_ROOT_PASSWORD` (padrão: `secret`)
- `MYSQL_USER` (padrão: `countryadmin`)
- `MYSQL_PASSWORD` (padrão: `rock4me`)
- `MONGO_INITDB_ROOT_USERNAME` (padrão: `root`)
- `MONGO_INITDB_ROOT_PASSWORD` (padrão: `secret`)

## Parar os Serviços

```bash
docker-compose -f databases/docker-compose.yml \
  -f databases/docker-compose-postgres.yaml \
  -f databases/docker-compose-mariadb.yaml \
  -f databases/docker-compose-mongo.yaml down
```

## Verificar Rede

```bash
# Listar redes
docker network ls

# Inspecionar a rede
docker network inspect databases-network
```
