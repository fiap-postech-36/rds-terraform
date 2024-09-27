#!/bin/bash

if [ -z "$1" ]; then
    echo "[terraform] Erro: Nenhum método especificado (plan, apply, etc.)."
    exit 1
fi

METHOD=$1
shift

PARAMS="$@"