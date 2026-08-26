# Análise do Uso de IA — Aula 02 TF

## Prompt Utilizado

Crie um docker-compose.yml para uma aplicação Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistência. Todos os serviços devem estar na mesma rede bridge customizada. Use variáveis de ambiente com interpolação de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy unless-stopped.

## Output Original do Kiro

version: "3.9"

# ─── Rede customizada ────────────────────────────────────────────────────────
networks:
  app-network:
    driver: bridge

# ─── Volumes nomeados ────────────────────────────────────────────────────────
volumes:
  postgres-data:
    driver: local

# ─── Serviços ────────────────────────────────────────────────────────────────
services:

  # ── PostgreSQL 15 ──────────────────────────────────────────────────────────
  postgres:
    image: postgres:15-alpine
    container_name: ${COMPOSE_PROJECT_NAME:-portfolio}-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 20s

  # ── Redis 7 ────────────────────────────────────────────────────────────────
  redis:
    image: redis:7-alpine
    container_name: ${COMPOSE_PROJECT_NAME:-portfolio}-redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD} --appendonly yes
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  # ── API Node.js 20 ─────────────────────────────────────────────────────────
  api:
    build:
      context: ./app
      dockerfile: Dockerfile
      args:
        NODE_ENV: ${NODE_ENV:-production}
    image: ${COMPOSE_PROJECT_NAME:-portfolio}-api:latest
    container_name: ${COMPOSE_PROJECT_NAME:-portfolio}-api
    restart: unless-stopped
    ports:
      - "${API_PORT:-3000}:3000"
    environment:
      NODE_ENV: ${NODE_ENV:-production}
      PORT: 3000
      # Banco de dados
      DB_HOST: postgres
      DB_PORT: 5432
      DB_NAME: ${POSTGRES_DB}
      DB_USER: ${POSTGRES_USER}
      DB_PASSWORD: ${POSTGRES_PASSWORD}
      DATABASE_URL: postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
      # Cache
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: ${REDIS_PASSWORD}
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
    networks:
      - app-network
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:3000/health || exit 1"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 30s


## Alterações que Fiz Manualmente

| O que mudei | Por quê |
|------------|---------|
| [Ex: Adicionei healthcheck no Redis] | [O Kiro não incluiu, é boa prática] |
| [Ex: Mudei senhas para usar .env] | [Estavam hardcoded no output do Kiro] |
| [Ex: Corrigi imagem do Redis] | [Kiro usou versão que não existe] |
| ... | ... |

## O que o Kiro Acertou

- [Liste pontos positivos do output da IA]

## O que o Kiro Errou ou Omitiu

- [Liste problemas ou omissões]

## Minha Avaliação

- **Tempo economizado usando IA:** [estimativa em minutos]
- **Tempo gasto validando/corrigindo:** [estimativa em minutos]
- **Nota para o output da IA (1-10):** [sua nota]
- **Usaria novamente para este tipo de tarefa?** [sim/não e por quê]