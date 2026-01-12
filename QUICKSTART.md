# ⚡ Quick Start - Docker Mark 3

Comece em 5 minutos! Guia rápido para iniciantes.

---

## 1️⃣ Pré-requisitos (1 min)

Certifique-se de ter instalado:
- **Docker:** `docker --version` (versão 20.10+)
- **Docker Compose:** `docker compose version` (versão 2.0+)
- **Make (opcional):** `make --version`

Se não tem, instale:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io docker-compose make

# macOS
brew install docker docker-compose make

# Windows
# Instale Docker Desktop (inclui Docker e Compose)
```

---

## 2️⃣ Clone o Repositório (1 min)

```bash
git clone https://github.com/pereira-savio/docker-mk3.git
cd docker-mk3
```

---

## 3️⃣ Configuração Inicial (2 min)

### Criar arquivo de configuração:

```bash
# Copiar template
cp .env.example .env

# Editar com suas credenciais
nano .env
```

**O mínimo para editar:**
```bash
MYSQL_ROOT_PASSWORD=sua_senha_forte
MYSQL_PASSWORD=outra_senha
POSTGRES_PASSWORD=outra_senha_2
MONGO_INITDB_ROOT_PASSWORD=outra_senha_3
DRONE_RPC_SECRET=$(openssl rand -hex 16)
```

### Criar rede Docker:

```bash
docker network create -d bridge global-default
```

---

## 4️⃣ Inicie os Serviços (2 min)

Escolha o que quer usar:

### Apenas Banco de Dados

```bash
# MariaDB
make mariadb

# PostgreSQL
make postgres

# MongoDB
make mongo
```

### Tudo de Uma Vez

```bash
# Inicie cada um em um terminal diferente
make mariadb
make postgres
make mongo
make redis-single
make elasticsearch
docker-compose -f queues/docker-compose-rabbitmq.yaml up -d
make mock
docker-compose -f uptime-kuma/docker-compose.yml up -d
make drone
```

---

## ✅ Testes Rápidos

### Verificar se está tudo funcionando:

```bash
# Ver containers rodando
docker ps

# Testar MariaDB
mysql -h localhost -u countryadmin -p -e "SELECT 1"

# Testar PostgreSQL
psql -h localhost -U admin -d localstack -c "SELECT 1"

# Testar Redis
redis-cli -h localhost ping

# Testar MongoDB
mongo mongodb://root:senha@localhost:27017/admin?authSource=admin
```

---

## 🌐 Acesse as Interfaces Web

Abra no seu navegador:

| Serviço | URL | Uso |
|---------|-----|-----|
| **MariaDB** | `http://localhost:8005` | Adminer |
| **PostgreSQL** | `http://localhost:5050` | pgAdmin |
| **MongoDB** | `http://localhost:8081` | Mongo Express |
| **ElasticSearch** | `http://localhost:9200` | API REST |
| **Kibana** | `http://localhost:5601` | Visualização |
| **RabbitMQ** | `http://localhost:15672` | Management |
| **Mock Server** | `http://localhost:1080` | Dashboard |
| **Drone CI** | `http://localhost:8080` | CI/CD |
| **Uptime Kuma** | `http://localhost:8443` | Monitoramento |

---

## 🛑 Parar os Serviços

```bash
# Parar um serviço
docker-compose -f databases/docker-compose-mariadb.yaml down

# Parar tudo
docker ps -q | xargs docker stop
```

---

## 🔧 Próximos Passos

1. **Ler documentação completa:** `README.md`
2. **Guia de implementação:** `IMPLEMENTAR_REVISAO.md`
3. **Detalhes técnicos:** `RELATORIO_FINAL.md`

---

## 🆘 Problemas Comuns

### "Permissão negada ao iniciar Docker"

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### "Porta já está em uso"

```bash
# Encontrar qual processo usa a porta
lsof -i :8005

# Mudar porta no .env se possível
```

### "Rede global-default não existe"

```bash
docker network create -d bridge global-default
```

### "Container falhou ao iniciar"

```bash
# Ver logs
docker logs <container_name>

# Validar arquivo
docker-compose -f <arquivo> config
```

---

## 📞 Ajuda Rápida

```bash
# Validar tudo
./validate-compose.sh

# Ver logs de um container
docker logs -f <container_name>

# Executar comando em container
docker exec -it <container_name> bash

# Listar containers
docker ps

# Listar volumes
docker volume ls

# Inspecionar container
docker inspect <container_name>
```

---

## 🎉 Pronto!

Você agora tem um ambiente completo com:
- ✅ 3 bancos de dados (MariaDB, PostgreSQL, MongoDB)
- ✅ Cache (Redis)
- ✅ Search (ElasticSearch)
- ✅ Filas (RabbitMQ)
- ✅ CI/CD (Drone)
- ✅ Monitoramento (Uptime Kuma)
- ✅ Mock Server

**Próximo:** Consulte `README.md` para documentação completa!

---

**Tempo total:** ~5 minutos ⏱️
**Status:** ✅ Pronto para usar
