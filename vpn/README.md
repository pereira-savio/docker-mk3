# OpenVPN Access Server (AS)

## 📋 Informações de Acesso

### ✅ Credenciais Padrão
- **Usuário:** `openvpn`
- **Senha:** `hb3xNPR9N2kp`

### 🌐 URLs de Acesso
- **Painel Administrativo Web:** https://localhost:943/admin
- **Portal do Cliente:** https://localhost:943

## 🚀 Como Acessar

1. Abra seu navegador
2. Navegue para: **https://localhost:943/admin**
3. Faça login com:
   - Usuário: `openvpn`
   - Senha: `hb3xNPR9N2kp`

### ⚠️ Aviso de Certificado SSL
Você verá um aviso sobre certificado SSL autossinalado. Clique em:
- **"Prosseguir mesmo assim"** (Firefox/Chrome PT-BR)
- **"Advanced"** → **"Proceed to localhost"** (Chrome EN)

## 📡 Configuração do Serviço

### Docker Compose
```yaml
version: "2.1"
services:
  openvpn-as:
    image: openvpn/openvpn-as
    container_name: openvpn-as
    devices:
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - NET_ADMIN
      - MKNOD
    ports:
      - 943:943      # Admin Web UI
      - 443:443      # Client Web UI (HTTPS)
      - 1194:1194/udp # OpenVPN Protocol
    volumes:
      - openvpn:/openvpn
    restart: unless-stopped

volumes:
  openvpn:
```

### Portas Expostas
| Porta | Protocolo | Uso |
|-------|-----------|-----|
| 943 | TCP | Painel Administrativo |
| 443 | TCP | Portal do Cliente (HTTPS) |
| 1194 | UDP | Protocolo OpenVPN |

## 🔧 Gerenciamento de Usuários

### Adicionar Novo Usuário
```bash
docker exec openvpn-as /usr/local/openvpn_as/scripts/userdba --mkuser --user=novo_usuario
```

### Listar Usuários
```bash
docker exec openvpn-as /usr/local/openvpn_as/scripts/userdba --show
```

### Alterar Senha de Usuário
```bash
docker exec openvpn-as /usr/local/openvpn_as/scripts/confdba -u -p openvpn -k pass -v "nova_senha"
```

## 📊 Monitoramento

### Verificar Status do Container
```bash
docker ps | grep openvpn-as
```

### Ver Logs em Tempo Real
```bash
docker logs -f openvpn-as
```

### Verificar Saúde do Serviço
```bash
docker exec openvpn-as /usr/local/openvpn_as/scripts/userdba --show
```

## 🔄 Reiniciar o Serviço

```bash
docker restart openvpn-as
```

## 📁 Estrutura de Dados

O container OpenVPN AS usa um volume persistente chamado `openvpn` que armazena:
- Configurações (`/openvpn/etc/`)
- Banco de dados de usuários (`/openvpn/etc/db/`)
- Certificados SSL (`/openvpn/etc/web-ssl/`)

## ✨ Recursos Principais

- ✅ Web UI para gerenciamento fácil
- ✅ Suporte para até 2 conexões simultâneas (versão gratuita)
- ✅ VPN baseada em OpenVPN
- ✅ Gerenciamento de usuários e permissões
- ✅ Relatórios e logs de conexão

## 🐛 Troubleshooting

### Problema: Não consegue acessar o painel
**Solução:**
1. Verifique se o container está rodando: `docker ps | grep openvpn-as`
2. Reinicie o container: `docker restart openvpn-as`
3. Aguarde 30 segundos para que o serviço inicie completamente
4. Tente novamente em https://localhost:943/admin

### Problema: Erro de certificado SSL
**Solução:**
- Este é um aviso normal. Clique em "Avançado" e prossiga para o site
- Para usar certificados válidos, configure um domínio e obtenha um certificado Let's Encrypt

### Problema: Porta já está em uso
**Solução:**
- Altere a porta no `docker-compose.yml`
- Exemplo: `"8943:943"` para usar porta 8943 ao invés de 943

## 📚 Referências

- [OpenVPN Access Server Docs](https://openvpn.net/vpn-server-resources/)
- [Docker OpenVPN AS Image](https://hub.docker.com/r/openvpn/openvpn-as)

## 🔧 Resolução de Problemas de Autenticação

Se receber o erro **"LOCKOUT: user temporarily locked out due to multiple authentication failures"**:

1. O usuário foi bloqueado após múltiplas tentativas de login incorretas
2. Solução: Remover o volume e reiniciar o container (irá gerar nova senha)

```bash
docker stop openvpn-as
docker rm openvpn-as
docker volume rm vpn_openvpn
make openvpn
docker logs openvpn-as | grep "Auto-generated"
```

---

**Última atualização:** 12 de janeiro de 2026
**Última senha gerada:** `hb3xNPR9N2kp`
