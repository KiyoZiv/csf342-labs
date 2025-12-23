#!/usr/bin/env bash
set -e

LAB="$1"
NAME="$2"

if [ -z "$LAB" ] || [ -z "$NAME" ]; then
  echo "Usage: compile.sh <lab-folder> <artefact-name>"
  exit 1
fi

SRC="labs/${LAB}/src"
TB="labs/${LAB}/tb"

if [ ! -d "$SRC" ] || [ ! -d "$TB" ]; then
  echo "Error: lab folder not found"
  exit 1
fi

mkdir -p artefacts
mkdir -p artefacts/${LAB}

iverilog -g2012 -Wall   -o "artefacts/${LAB}/${NAME}.sim"   $SRC/*.v $TB/*.v

echo "Compiled to artefacts/${LAB}/${NAME}.sim"