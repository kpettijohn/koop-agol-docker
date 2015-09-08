#!/bin/bash

# Make sure docker-compose is always run from the repo's root
cd "$( dirname "${BASH_SOURCE[0]}" )" 
cd ../../

DB_WAIT_TIME=${DB_WAIT_TIME:-8}

sub_create () {
  docker-compose build koop
  docker-compose up -d data
  docker-compose up -d redis
  docker-compose up -d postgis
  # Let the master come online
  echo "Sleeping for $DB_WAIT_TIME seconds while PostgreSQL starts..."
  sleep $DB_WAIT_TIME
  docker-compose up -d --no-deps koop
  sleep 3
  docker-compose up -d --no-deps export agol
  docker-compose up --no-deps test
}

sub_destroy () {
 # Stop all running containers
  docker-compose stop
  # Force delete all containers
  docker-compose rm -f
}

sub_recreate () {
  sub_destroy
  sub_create
}

sub_export () {
  docker-compose up -d backup
  id=`docker-compose ps -q backup`
  docker export $id > data.tar
  tar --extract --file=data.tar koop_data.tar
  mkdir -p koop_data
  tar xf koop_data.tar -C koop_data --strip-components=3
  rm data.tar koop_data.tar
}

sub_help(){
    echo "Usage: $ProgName <subcommand> [options]"
    echo "Subcommands:"
    echo "    create"
    echo "    destroy"
    echo "    recreate"
    echo "    export"
    echo ""
    echo "For help with each subcommand run:"
    echo "$ProgName <subcommand> -h|--help"
    echo ""
}

subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac
