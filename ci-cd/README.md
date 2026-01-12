# Drone CI - Integração Contínua

Setup completo do **Drone CI** para CI/CD de seus projetos.

## 🚀 Quick Start

### 1. Configurar variáveis de ambiente

```bash
cp .env.example .env
# Edite o arquivo .env e preencha as variáveis necessárias
```

### 2. Gerar RPC Secret

```bash
openssl rand -hex 16
```

Cole o resultado gerado no arquivo `.env` na variável `DRONE_RPC_SECRET`.

### 3. Iniciar os containers

```bash
docker-compose up -d
```

### 4. Acessar a interface

Acesse: **http://localhost:8080**

---

## 📋 Configuração por Provedor Git

### GitHub

1. Acesse: https://github.com/settings/developers
2. Crie uma nova "OAuth App"
3. Configure:
   - **Application name**: Drone CI
   - **Homepage URL**: http://localhost:8080
   - **Authorization callback URL**: http://localhost:8080/login/github/callback
4. Copie o `Client ID` e `Client Secret`
5. Adicione ao `.env`:

```env
DRONE_GITHUB_CLIENT_ID=seu-client-id
DRONE_GITHUB_CLIENT_SECRET=seu-client-secret
```

### GitLab

1. Acesse: https://gitlab.com/admin/applications
2. Crie uma nova aplicação
3. Configure:
   - **Name**: Drone CI
   - **Redirect URI**: http://localhost:8080/login/gitlab/callback
   - **Scopes**: api, read_user, read_repository
4. Copie o `Application ID` e `Secret`
5. Adicione ao `.env`:

```env
DRONE_GITLAB_CLIENT_ID=seu-application-id
DRONE_GITLAB_CLIENT_SECRET=seu-secret
```

### Gitea (Local)

1. Acesse a administração do Gitea: http://localhost:3000/admin
2. Crie uma nova aplicação OAuth
3. Configure:
   - **Application name**: Drone CI
   - **Redirect URL**: http://localhost:8080/login/gitea/callback
4. Copie o `Client ID` e `Client Secret`
5. Adicione ao `.env`:

```env
DRONE_GITEA_CLIENT_ID=seu-client-id
DRONE_GITEA_CLIENT_SECRET=seu-client-secret
```

---

## 📝 Criar Pipeline CI/CD

Crie um arquivo `.drone.yml` na raiz de seu repositório:

```yaml
kind: pipeline
type: docker
name: default

steps:
  - name: build
    image: alpine
    commands:
      - echo "Building the application..."
      - echo "Your build commands here"

  - name: test
    image: alpine
    commands:
      - echo "Running tests..."
      - echo "Your test commands here"

  - name: deploy
    image: alpine
    commands:
      - echo "Deploying..."
      - echo "Your deploy commands here"
    when:
      branch:
        - main
```

---

## 🐳 Containers

- **drone-server** (porta 8080): Servidor Drone
- **drone-runner** (porta 3000): Runner Docker para executar jobs

---

## 💾 Persistência de Dados

Os dados são salvos em volume Docker:
- `drone-data`: Banco de dados SQLite e configurações

Para usar PostgreSQL, descomente o serviço no `docker-compose.yml`.

---

## 🔧 Gerenciamento

### Ver logs

```bash
docker-compose logs -f drone-server
docker-compose logs -f drone-runner
```

### Parar

```bash
docker-compose down
```

### Reconstruir

```bash
docker-compose down -v
docker-compose up -d
```

---

## 🔐 Segurança

- **DRONE_RPC_SECRET**: Mude para uma chave forte em produção
- **DRONE_USER_CREATE**: Configure usuários admin
- Use HTTPS em produção (configure um reverse proxy como Nginx)

---

## 📚 Recursos

- [Documentação Oficial Drone](https://docs.drone.io/)
- [Exemplos de Pipeline](https://docs.drone.io/pipeline/overview/)
- [Integração com Git](https://docs.drone.io/server/provider/)

---

## 🎯 Próximos Passos

1. ✅ Configure seu provedor Git
2. ✅ Autentique-se no Drone
3. ✅ Ative seus repositórios
4. ✅ Crie o arquivo `.drone.yml` nos seus projetos
5. ✅ Faça um push para disparar o pipeline
