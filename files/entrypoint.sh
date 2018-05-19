#!/bin/bash
set -e

if [ "$1" = 'start' ]; then
    exec /start.sh
fi

if [ "$1" = '--help ' ]; then
    echo "LAMP phpList Docker"
fi

exec "$@"
