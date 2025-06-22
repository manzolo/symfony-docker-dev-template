#!/bin/sh
set -e

# 1. Imposta la variabile d'ambiente SYMFONY_FPM_HOST.
#    Questa sintassi assegna il valore di default 'symfony-php-fpm-default'
#    solo se SYMFONY_FPM_HOST non è già impostata o è vuota.
#    Il risultato viene direttamente assegnato e esportato.
export SYMFONY_FPM_HOST="${SYMFONY_FPM_HOST:-symfony-php-fpm}"

# DEBUG: Stampa il valore che verrà utilizzato da envsubst
echo "SYMFONY_FPM_HOST is set to: $SYMFONY_FPM_HOST"

# 2. Esegui envsubst.
#    Specificando '${SYMFONY_FPM_HOST}' ad envsubst, gli diciamo di sostituire
#    SOLO quella variabile. È una buona pratica per evitare sostituzioni indesiderate.
envsubst '${SYMFONY_FPM_HOST}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# 3. Esegui il comando principale del container (Nginx in questo caso)
exec "$@"