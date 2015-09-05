#!/bin/bash

# Make sure docker-compose is always run from the repo's root
cd "$( dirname "${BASH_SOURCE[0]}" )" 
cd ../../

docker_compose_create () {
  s=5
  docker-compose build
  docker-compose up -d redis
  docker-compose up -d postgis
  # Let the master come online
  echo "Sleeping for $s seconds while PostgreSQL starts..."
  sleep $s
  docker-compose up -d --no-deps koop
  sleep 3
  docker-compose up -d --no-deps export agol
  docker-compose logs
}

docker_compose_destroy () {
 # Stop all running containers
  docker-compose stop
  # Force delete all containers
  docker-compose rm -f
}

docker_compose_recreate () {
  docker_compose_destroy
  docker_compose_create
}

if ([ "$1" != 'create' ] && [ "$1" != 'destroy' ] && [ "$1" != 're-create' ]); then
cat << EOF
Unknown param...

Example:
./koop.sh create
./koop.sh destroy
./koop.sh re-create
EOF
printf "\n"
fi

if [ "$1" = 'create' ]; then
  docker_compose_create
fi

if [ "$1" = 'destroy' ]; then
  docker_compose_destroy
fi

if [ "$1" = 're-create' ]; then
  docker_compose_recreate
fi
