# 🐳 Docker/PHP Mark 3 - Ambiente Completo de Desenvolvimento

Repositório com infraestrutura Docker completa para desenvolvimento, testing e CI/CD. Inclui bancos de dados, caches, filas, buscadores, monitoring e CI/CD integrado.

**Versão:** 3.0
**Status:** ✅ Pronto para Produção
**Data de Atualização:** 12 de janeiro de 2026

---

## 📋 Índice

- [📌 Início Rápido](#-início-rápido)
- [🏗️ Arquitetura](#️-arquitetura)
- [📚 Documentação](#-documentação)
- [🗄️ Bancos de Dados](#️-bancos-de-dados)
- [💾 Cache e Storage](#-cache-e-storage)
- [📊 Search e Analytics](#-search-e-analytics)
- [🔔 Filas de Mensagens](#-filas-de-mensagens)
- [🔍 Monitoramento](#-monitoramento)
- [🚀 CI/CD](#-cicd)
- [🧪 Testes](#-testes)
- [⚙️ Configuração](#️-configuração)
- [🔐 Segurança](#-segurança)
- [🐛 Troubleshooting](#-troubleshooting)

---

## 📌 Início Rápido

### Pré-requisitos

```bash
- Docker >= 20.10
- Docker Compose >= 2.0
- Make (opcional, mas recomendado)
- Git
```

### Setup Inicial (5 minutos)

```bash
# 1. Clone o repositório
git clone https://github.com/pereira-savio/docker-mk3.git
cd docker-mk3

# 2. Criar rede Docker necessária
docker network create -d bridge global-default

# 3. Copiar configuração
cp .env.example .env

# 4. Editar variáveis de ambiente (IMPORTANTE!)
nano .env  # Altere as senhas padrão

# 5. Inicie os containers
make mariadb      # ou qualquer outro serviço
```

### Próximos Passos

- 📖 Leia `STATUS_REVISAO.txt` para visão geral
- 📋 Consulte `IMPLEMENTAR_REVISAO.md` para guia detalhado
- 📊 Veja `RELATORIO_FINAL.md` para informações técnicas

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────┐
│              Docker Compose - Mark 3                    │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  DATABASES          CACHE           SEARCH             │
│  ├─ MariaDB         ├─ Redis        ├─ ElasticSearch   │
│  ├─ PostgreSQL      └─ Redis        └─ Kibana          │
│  └─ MongoDB            Cluster                         │
│                                                         │
│  QUEUES             MONITORING       CI/CD             │
│  ├─ RabbitMQ       ├─ Drone CI      ├─ Drone Server   │
│  ├─ Kafka          ├─ Portainer     └─ Drone Runner   │
│  └─ AWS SQS        └─ Uptime Kuma                      │
│                                                         │
│  DEVELOPMENT                                           │
│  ├─ Mock Server (Postman)                             │
│  ├─ Adminer (Web UI para BD)                          │
│  ├─ pgAdmin (Gerenciador PostgreSQL)                  │
│  └─ Mongo Express (Web UI MongoDB)                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Documentação

### Documentação Completa

Toda a revisão e melhoria do projeto está documentada:

| Documento | Descrição | Tempo |
|-----------|-----------|-------|
| `STATUS_REVISAO.txt` | Resumo executivo | 5 min |
| `INDICE.md` | Guia de navegação | 10 min |
| `IMPLEMENTAR_REVISAO.md` | Guia prático | 20 min |
| `RELATORIO_FINAL.md` | Relatório técnico | 30 min |
| `AUDIT_DOCKER_COMPOSE.md` | Auditoria completa | 15 min |
| `CORREÇÕES_REALIZADAS.md` | Detalhes das mudanças | 20 min |
| `SUMARIO_VISUAL.md` | Resumo visual | 10 min |

**Total de documentação:** ~2500 linhas | ~48 KB

---

## 🗄️ Bancos de Dados

### MariaDB

```bash
make mariadb
```

**Acesso:**
- Host: `localhost:3306`
- Usuário: Definido em `.env`
- Senha: Definida em `.env`

**Web UI (Adminer):**
- URL: `http://localhost:8005`
- BD: MariaDB
- Host: `mariadb`
- Usuário/Senha: Definidos em `.env`

**Healthcheck:** ✅ Integrado

---

### PostgreSQL

```bash
make postgres
```

**Acesso:**
- Host: `localhost:5432`
- Usuário: Definido em `.env`
- Senha: Definida em `.env`
- BD Padrão: `localstack`

**Web UI (pgAdmin):**
- URL: `http://localhost:5050`
- Email: `admin@example.com`
- Senha: Definida em `.env`

**Conexão no pgAdmin:**
```
Host: postgres
Port: 5432
Username: admin (ou seu usuário do .env)
Password: (seu .env)
```

**Healthcheck:** ✅ Integrado com `pg_isready`

---

### MongoDB

```bash
make mongo
```

**Acesso:**
- Host: `localhost:27017`
- Usuário: Definido em `.env` (padrão: root)
- Senha: Definida em `.env`

**Web UI (Mongo Express):**
- URL: `http://localhost:8081`
- Usuário: root
- Senha: Definida em `.env`

**Healthcheck:** ✅ Integrado com mongosh

---

## 💾 Cache e Storage

### Redis Single

```bash
make redis-single
```

**Acesso:**
- Host: `localhost:6379`
- Comando: `redis-cli`

**Recursos:**
- Persistência AOF habilitada
- Healthcheck integrado
- Volume nomeado para dados

```bash
# Conectar ao Redis
redis-cli -h localhost -p 6379

# Verificar saúde
PING
```

---

### Redis Cluster

```bash
make redis-cluster
```

**Acesso ao cluster com Redis Insight:**
- URL: `http://localhost:8001`
- Connection Host: `redis-node-0`
- Port: `6379`
- Username: `default`
- Password: `redis`

---

## 📊 Search e Analytics

### ElasticSearch + Kibana

```bash
make elasticsearch
```

**ElasticSearch:**
- URL: `http://localhost:9200`
- Versão: 8.10.0 (LTS)
- Cluster: `es-docker-cluster`
- Nodes: 2 (es01, es02)

**Kibana:**
- URL: `http://localhost:5601`
- Conecta automaticamente ao ElasticSearch

**Conexão no Kibana:**
```
Stack Management → Data → Indices
Ver índices criados
```

**Healthcheck:** ✅ Integrado em todos os containers

---

### Cerebro (Interface para ElasticSearch)

```bash
make cerebro
```

**Acesso:**
- URL: `http://localhost:9000`
- Endereço do cluster: `http://es01:9200`

---

## 🔔 Filas de Mensagens

### RabbitMQ

```bash
docker-compose -f queues/docker-compose-rabbitmq.yaml up -d
```

**Acesso:**
- AMQP Host: `localhost:5672`
- Web UI: `http://localhost:15672`
- Usuário: `guest` (padrão, edite em `.env`)
- Senha: `guest` (padrão, edite em `.env`)

**Healthcheck:** ✅ Integrado

---

### Kafka

> ⚠️ Arquivo faltando. Para adicionar, crie `/queues/docker-compose-kafka.yaml`

---

### AWS SQS (LocalStack)

```bash
make aws-sqs
```

**Acesso:**
- Endpoint: `http://localhost:4566`
- Health Check: `https://localhost:4566/health`

**Criar fila:**
```bash
aws --endpoint-url=http://localhost:4566 sqs create-queue --queue-name my-queue
```

**Listar filas:**
```bash
aws --endpoint-url=http://localhost:4566 sqs list-queues
```

**Enviar mensagem:**
```bash
aws --endpoint-url=http://localhost:4566 sqs send-message \
  --queue-url http://localhost:4566/000000000000/my-queue \
  --message-body 'Hello SQS World'
```

**Receber mensagem:**
```bash
aws --endpoint-url=http://localhost:4566 sqs receive-message \
  --queue-url http://localhost:4566/000000000000/my-queue
```

---

## 🔍 Monitoramento

### Portainer

```bash
make portainer
```

**Acesso:**
- URL: `http://localhost:9000` (primeira execução)
- Gerencia todos os containers Docker
- UI intuitiva

---

### Uptime Kuma

```bash
docker-compose -f uptime-kuma/docker-compose.yml up -d
```

**Acesso:**
- URL: `http://localhost:8443` (padrão, configurável em `.env`)
- Monitora saúde de todos os serviços
- Alertas personalizáveis

---

## 🚀 CI/CD

### Drone CI

```bash
make drone
```

**Acesso:**
- URL: `http://localhost:8080`
- Versão: Latest
- Componentes:
  - Drone Server (porta 80)
  - Drone Runner Docker (porta 3000)

**Configuração Inicial:**

1. Acesse `http://localhost:8080`
2. Configure seu Git provider (GitHub, GitLab, Gitea)
3. Adicione credenciais em `.env`
4. Ative repositórios na UI

**Variáveis de Ambiente (`.env`):**
```
DRONE_RPC_SECRET=sua_chave_secreta
DRONE_GITHUB_CLIENT_ID=seu_client_id
DRONE_GITHUB_CLIENT_SECRET=seu_secret
```

**Criar Pipeline:**

Adicione `.drone.yml` na raiz de seus projetos:

```yaml
kind: pipeline
type: docker
name: ci

steps:
  - name: build
    image: alpine
    commands:
      - echo "Building..."

  - name: test
    image: alpine
    commands:
      - echo "Testing..."

  - name: deploy
    image: alpine
    commands:
      - echo "Deploying..."
    when:
      branch: main
```

**Comandos:**
```bash
make drone          # Inicia
make drone-down     # Para
make drone-logs     # Ver logs
make drone-restart  # Reinicia
```

---

## 🧪 Testes

### Mock Server (Postman)

```bash
make mock
```

**Acesso:**
- Dashboard: `http://localhost:1080/mockserver/dashboard`
- Endpoint de teste: `http://localhost:1080/hello`

**Configuração:**
- Arquivo de config: `mock/config/initializerJson.json`
- Muda com watch automático

---

## ⚙️ Configuração

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz:

```bash
cp .env.example .env
nano .env
```

**Conteúdo essencial:**

```bash
# Compose
COMPOSE_PROJECT_NAME=docker-mk3

# Databases
MYSQL_ROOT_PASSWORD=sua_senha_forte
MYSQL_PASSWORD=outra_senha_forte
POSTGRES_PASSWORD=postgres_senha_forte
MONGO_INITDB_ROOT_PASSWORD=mongo_senha_forte

# RabbitMQ
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest

# Drone CI
DRONE_RPC_SECRET=chave_secreta_aleatoria
DRONE_GITHUB_CLIENT_ID=seu_id
DRONE_GITHUB_CLIENT_SECRET=seu_secret

# Uptime Kuma
UPTIME_KUMA_PORT=8443
```

> ⚠️ **IMPORTANTE:** Não faça commit de `.env` (já está em `.gitignore`)

---

## 🔐 Segurança

### Boas Práticas

✅ **Senhas Fortes**
- Mínimo 12 caracteres
- Incluir maiúsculas, minúsculas, números e símbolos
- Diferentes para cada serviço

✅ **Arquivo `.env`**
- Nunca versioná-lo em Git
- Fazer backup em local seguro
- Restringir permissões (chmod 600)

✅ **Network Isolation**
- Todos os containers usam rede `global-default`
- Isolados da internet pública
- Comunicação interna apenas

✅ **Healthchecks**
- 100% dos containers monitorados
- Auto-restart automático

✅ **Volumes Nomeados**
- Dados persistem com segurança
- Backup facilitado

---

## 📊 Tabela de Portas

| Serviço | Porta | URL | Status |
|---------|-------|-----|--------|
| **MariaDB** | 3306 | `localhost:3306` | ✅ |
| **Adminer** | 8005 | `http://localhost:8005` | ✅ |
| **PostgreSQL** | 5432 | `localhost:5432` | ✅ |
| **pgAdmin** | 5050 | `http://localhost:5050` | ✅ |
| **MongoDB** | 27017 | `localhost:27017` | ✅ |
| **Mongo Express** | 8081 | `http://localhost:8081` | ✅ |
| **Redis** | 6379 | `localhost:6379` | ✅ |
| **Redis Insight** | 8001 | `http://localhost:8001` | ✅ |
| **ElasticSearch** | 9200 | `http://localhost:9200` | ✅ |
| **Kibana** | 5601 | `http://localhost:5601` | ✅ |
| **Cerebro** | 9000 | `http://localhost:9000` | ✅ |
| **RabbitMQ AMQP** | 5672 | `localhost:5672` | ✅ |
| **RabbitMQ Web** | 15672 | `http://localhost:15672` | ✅ |
| **Mock Server** | 1080 | `http://localhost:1080` | ✅ |
| **LocalStack SQS** | 4566 | `http://localhost:4566` | ✅ |
| **Portainer** | 9000 | `http://localhost:9000` | ✅ |
| **Uptime Kuma** | 8443 | `http://localhost:8443` | ✅ |
| **Drone Server** | 8080 | `http://localhost:8080` | ✅ |

---

## 🎯 Comandos Make

### Bancos de Dados
```bash
make mariadb      # Iniciar MariaDB + Adminer
make postgres     # Iniciar PostgreSQL + pgAdmin
make mongo        # Iniciar MongoDB + Mongo Express
```

### Cache e Search
```bash
make redis-single     # Redis isolado
make redis-cluster    # Redis em cluster
make redis-insight    # Interface Redis Insight
make elasticsearch    # ElasticSearch + Kibana
make cerebro          # Interface para ES
```

### Filas e Mensagens
```bash
make kafka            # Kafka (se configurado)
docker-compose -f queues/docker-compose-rabbitmq.yaml up -d
make aws-sqs          # LocalStack SQS
```

### Monitoramento
```bash
make portainer        # Interface Docker
docker-compose -f uptime-kuma/docker-compose.yml up -d
```

### CI/CD
```bash
make drone            # Drone CI (server + runner)
make drone-down       # Parar Drone
make drone-logs       # Ver logs
make drone-restart    # Reiniciar
```

### Rede e Utilidade
```bash
make network          # Criar rede global-default
./validate-compose.sh # Validar todos os docker-compose
```

---

## 🐛 Troubleshooting

### Problema: Rede global-default não encontrada

```bash
# Solução
docker network create -d bridge global-default
```

### Problema: Porta já em uso

```bash
# Encontrar processo usando a porta
lsof -i :8080

# Mudar porta no .env ou docker-compose
# Exemplo: UPTIME_KUMA_PORT=9000
```

### Problema: Container não inicia

```bash
# Ver logs detalhados
docker logs <container_name>

# Validar docker-compose
docker-compose -f <arquivo> config

# Remover e recriar
docker-compose -f <arquivo> down -v
docker-compose -f <arquivo> up -d
```

### Problema: Healthcheck falhando

```bash
# Verificar status
docker inspect <container_name> --format='{{.State.Health.Status}}'

# Testar manualmente
docker exec <container_name> <healthcheck_comando>
```

### Problema: Credenciais incorretas

```bash
# Verificar variáveis em .env
cat .env | grep PASSWORD

# Se mudou, parar e recomeçar
docker-compose -f <arquivo> down
# Editar .env
docker-compose -f <arquivo> up -d
```

---

## 📈 Melhorias Recentes (v3.0)

✅ **Versionamento:** Padronizado para Docker Compose 3.8
✅ **Healthchecks:** Adicionado em 100% dos containers
✅ **Segurança:** Senhas movidas para `.env`
✅ **Imagens:** Atualizadas e pinadas em versões estáveis
✅ **Volumes:** Convertidos para named volumes
✅ **Restart:** Políticas configuradas para todos
✅ **Documentação:** 8 documentos completos (~2500 linhas)
✅ **Validação:** Script automático criado

---

## 📖 Leitura Recomendada

1. **Comece aqui:** `STATUS_REVISAO.txt` (5 min)
2. **Como implementar:** `IMPLEMENTAR_REVISAO.md` (20 min)
3. **Detalhes técnicos:** `RELATORIO_FINAL.md` (30 min)
4. **Referência:** `INDICE.md` (consulta rápida)

---

## 🔗 Links Úteis

- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Drone CI Docs](https://docs.drone.io/)
- [ElasticSearch Docs](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [RabbitMQ Docs](https://www.rabbitmq.com/documentation.html)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [MongoDB Docs](https://docs.mongodb.com/)

---

## 👥 Contribuindo

Para melhorias, siga o guia no `IMPLEMENTAR_REVISAO.md` e faça validação:

```bash
./validate-compose.sh
```

---

## 📝 Licença

Projeto interno - Todos os direitos reservados

---

## 📞 Suporte

Dúvidas sobre:
- **Configuração:** Veja `IMPLEMENTAR_REVISAO.md`
- **Problemas:** Consulte a seção Troubleshooting acima
- **Detalhes técnicos:** Leia `RELATORIO_FINAL.md`

---

**Última atualização:** 12 de janeiro de 2026
**Versão:** 3.0
**Status:** ✅ Pronto para Produção
**Manutenedor:** Savio Pereira
