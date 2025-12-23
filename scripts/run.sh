#!/usr/bin/env bash
set -e

LAB="$1"
NAME="$2"

if [ -z "$LAB" ] || [ -z "$NAME" ]; then
  echo "Usage: run.sh <lab-folder> <artefact-name>"
  exit 1
fi

SIM="artefacts/${LAB}/${NAME}.sim"
VCD="artefacts/${LAB}/${NAME}.vcd"

if [ ! -f "$SIM" ]; then
  echo "Error: $SIM not found"
  exit 1
fi

vvp "$SIM" +vcd="$VCD"
echo "Generated $VCD"
