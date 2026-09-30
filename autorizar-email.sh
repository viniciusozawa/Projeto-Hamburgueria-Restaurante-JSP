#!/usr/bin/env bash
#
# Autoriza um destinatário no domínio sandbox da Mailgun.
#
# O sandbox só entrega para endereços autorizados — até 5. Cada um recebe um
# email da Mailgun e PRECISA clicar no link de confirmação; antes disso fica
# como "pendente" e continua não recebendo nada.
#
#   ./autorizar-email.sh                      lista quem já está autorizado
#   ./autorizar-email.sh fulano@gmail.com     autoriza um
#   ./autorizar-email.sh a@x.com b@y.com      autoriza vários
#
# A chave sai do .env — não passe por argumento, senão ela fica no histórico
# do shell.

set -u

# --- acha a chave, na mesma ordem que o Config.java ---
ENV_FILE="${BIGTITES_ENV:-$(dirname "$0")/.env}"

if [ -z "${MAILGUN_API_KEY:-}" ] && [ -f "$ENV_FILE" ]; then
    MAILGUN_API_KEY=$(grep -E '^[[:space:]]*MAILGUN_API_KEY=' "$ENV_FILE" \
                      | tail -1 | cut -d= -f2- | tr -d '"'"'"' \r')
fi

if [ -z "${MAILGUN_API_KEY:-}" ]; then
    echo "Erro: MAILGUN_API_KEY não encontrada."
    echo "      Preencha em $ENV_FILE ou exporte a variável."
    exit 1
fi

API="https://api.mailgun.net/v5/sandbox/auth_recipients"

listar() {
    echo "=== destinatários autorizados ==="
    curl -s "$API" --user "api:$MAILGUN_API_KEY" --max-time 25 | python -c "
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    print('  resposta inesperada da Mailgun'); sys.exit(1)

lista = d.get('recipients', [])
limite = d.get('limit', 5)
for r in lista:
    estado = 'ativado' if r.get('activated') else 'PENDENTE (falta clicar no link)'
    print('  %-34s %s' % (r.get('email', '?'), estado))
if not lista:
    print('  (nenhum)')
print('')
print('  usando %d de %d vagas' % (len(lista), limite))
"
}

autorizar() {
    local email="$1"
    printf '  %-34s ' "$email"
    local resposta
    resposta=$(curl -s -X POST "$API?email=$email" \
                    --user "api:$MAILGUN_API_KEY" --max-time 25 -w '\n%{http_code}')
    local codigo="${resposta##*$'\n'}"
    local corpo="${resposta%$'\n'*}"

    case "$codigo" in
        200|201) echo "convite enviado — peça para clicar no link da Mailgun" ;;
        400)     echo "recusado: $corpo" ;;
        401)     echo "chave inválida" ;;
        *)       echo "HTTP $codigo: $corpo" ;;
    esac
}

if [ $# -eq 0 ]; then
    listar
else
    echo "=== autorizando ==="
    for email in "$@"; do
        autorizar "$email"
    done
    echo
    listar
fi
