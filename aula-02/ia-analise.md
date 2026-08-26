# Análise do Uso de IA — Aula 02 TF

## Prompt Utilizado

> "Crie um docker-compose.yml para uma aplicação Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistência. Todos os serviços devem estar na mesma rede bridge customizada. Use variáveis de ambiente com interpolação de arquivo .env. Adicione healthchecks, depends_on com condition, e restart policy unless-stopped."

---

## Output Original do Kiro

```yaml
version: "3.9"

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:7-alpine
    environment:
      REDIS_PASSWORD: ${REDIS_PASSWORD}
    networks:
      - app-network

  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      DB_HOST: postgres
      DB_PORT: 5432
      REDIS_HOST: redis
      REDIS_PORT: 6379
    networks:
      - app-network
    depends_on:
      - postgres
      - redis

networks:
  app-network:
    driver: bridge

volumes:
  postgres-data:
```

---

## Alterações que Fiz Manualmente

| O que mudei | Por quê |
|---|---|
| Adicionei `restart: unless-stopped` em todos os serviços | O Kiro omitiu; é boa prática para produção |
| Adicionei `container_name` com interpolação de `${COMPOSE_PROJECT_NAME}` | Melhor rastreabilidade dos containers |
| Adicionei `healthcheck` completo no PostgreSQL | O Kiro omitiu; essencial para `depends_on: condition: service_healthy` |
| Adicionei `healthcheck` no Redis | O Kiro omitiu; necessário para o `depends_on` funcionar corretamente |
| Adicionei `healthcheck` na API | O Kiro omitiu; good practice para monitoramento |
| Mudei `depends_on` para usar `condition: service_healthy` | O Kiro usou apenas `depends_on: [postgres, redis]` sem condition |
| Adicionei comando Redis com `--requirepass` e `--appendonly yes` | O Kiro não configurou autenticação nem persistência |
| Adicionei `DATABASE_URL` e `REDIS_URL` | Útil para ORMs como Sequelize/Prisma |
| Adicionei `start_period` nos healthchecks | Dá tempo para o serviço iniciar antes de começar a verificar |
| Adicionei comentários estruturados em cada seção | O Kiro não incluiu; melhoram legibilidade |
| Adicionei `API_PORT` como variável de ambiente | Maior flexibilidade de configuração |
| Corrigir build context: mudei `build: ./app` para `build: .` | O Kiro apontava para pasta incorreta |
| Adicionei argumentos de build (`NODE_ENV`) | O Kiro omitiu |
| Adicionei `image:` tag com `${COMPOSE_PROJECT_NAME}` | Melhor controle de versionamento |

---

## O que o Kiro Acertou

✅ Estrutura básica do `docker-compose.yml` (version, services, networks, volumes)  
✅ Escolha correta de imagens (postgres:15-alpine, redis:7-alpine, node:20)  
✅ Rede bridge customizada (`app-network`)  
✅ Volume nomeado para PostgreSQL (`postgres-data`)  
✅ Uso de variáveis de ambiente (${}  interpolação)  
✅ Mapeamento de porta 3000 para a API  
✅ Comunicação entre containers usando nome do serviço (`postgres`, `redis`)  
✅ Ideia de usar `depends_on` (mas incompleto)  

---

## O que o Kiro Errou ou Omitiu

❌ **Faltou `healthcheck` em todos os serviços** — essencial para `depends_on: condition: service_healthy`  
❌ **`depends_on` sem `condition: service_healthy`** — containers podem iniciar fora de ordem  
❌ **Faltou `restart: unless-stopped`** — em caso de crash, container não reinicia  
❌ **Redis sem autenticação (`--requirepass`)** — segurança inadequada  
❌ **Redis sem persistência (`--appendonly`)** — dados perdidos se container reiniciar  
❌ **Faltou `container_name`** — múltiplas instâncias teriam nomes genéricos/aleatórios  
❌ **Faltou `REDIS_URL`** — variável útil para conexão com cliente Redis  
❌ **Sem comentários explicativos** — dificulta manutenção futura  
❌ **Build context genérico** — não estava claro como Build funcionaria  
❌ **Faltou `.env.example`** — segundo precisam compartilhar credenciais de exemplo  

---

## Minha Avaliação

| Métrica | Valor |
|---|---|
| **Tempo economizado usando IA** | ~15 minutos (estrutura básica pronta) |
| **Tempo gasto validando/corrigindo** | ~20 minutos (adicionar boas práticas) |
| **Nota para o output da IA (1-10)** | **7/10** |
| **Usaria novamente para este tipo de tarefa?** | **Sim, mas com ressalvas** |

### Justificativa da Nota 7/10

**Pontos Positivos:**
- Forneceu uma base sólida e funcional
- Economizou tempo em estrutura e configuração básica
- Adia as imagens e versões corretas
- Exemplificou bem o uso de variáveis de ambiente

**Pontos Negativos:**
- Omitiu boas práticas críticas (healthchecks, restart policy)
- `depends_on` incompleto sem `condition: service_healthy`
- Falta de segurança (Redis sem autenticação)
- Sem documentação interna (comentários)

---

## Conclusão

A IA foi útil como **rascunho inicial**, economizando tempo de estruturação. Porém, **uma revisão crítica é absolutamente necessária** — o output inicial não estava pronto para produção. Um desenvolvedor sem experiência em Docker poderia copiá-lo cegamente e ter problemas de:

- Containers iniciando fora de ordem (race condition)
- Dados perdendo-se (Redis sem persistência)
- Segurança inadequada
- Problemas de orquestração

**Lição aprendida:** IA é excelente para boilerplate, mas você precisa conhecer o domínio para avaliar e refinar o output. Isso é o que diferencia um profissional que usa IA bem de quem apenas copia.

