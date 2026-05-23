#!/bin/sh
set -eo pipefail

# الحصول على الـ IP أو العودة للـ Localhost
host="$(hostname -i || echo '127.0.0.1')"
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$user}"
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

# تنفيذ الأمر مباشرة بدون استخدام Arrays (Bash-only feature)
if [ "$(echo 'SELECT 1' | psql --host "$host" --username "$user" --dbname "$db" --quiet --no-align --tuples-only)" = '1' ]; then
    exit 0
fi

exit 1

###!/bin/bash
#set -eo pipefail

#host="$(hostname -i || echo '127.0.0.1')"
#user="${POSTGRES_USER:-postgres}"
#db="${POSTGRES_DB:-$POSTGRES_USER}"
#export PGPASSWORD="${POSTGRES_PASSWORD:-}"

#args=(
#	# force postgres to not use the local unix socket (test "external" connectibility)
#	--host "$host"
#	--username "$user"
#	--dbname "$db"
#	--quiet --no-align --tuples-only
#)

#if select="$(echo 'SELECT 1' | psql "${args[@]}")" && [ "$select" = '1' ]; then
#	exit 0
#fi

#exit 1
