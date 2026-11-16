#!/bin/sh
# Render project bằng pipeline gốc; readcheck là QA gate mặc định.
set -eu

if [ $# -lt 1 ]; then
  echo "usage: sh scripts/render.sh <project-dir> [fps]" >&2
  exit 2
fi

PROJECT=$1
FPS=${2:-24}
WORKERS=${WORKERS:-2}
CHECK=${CHECK:-1}

if [ -n "${LEMO_HOME:-}" ]; then
  LIB=$LEMO_HOME
elif [ -n "${AGENT_HOME:-}" ]; then
  LIB=$AGENT_HOME/video-studio/lemo-opuscar
else
  LIB=$HOME/lemo-opuscar
fi
case "$LIB" in /*|[A-Za-z]:[/\\]*) ;; *) LIB=$(pwd)/$LIB ;; esac

[ -d "$PROJECT" ] || { echo "project not found: $PROJECT" >&2; exit 2; }
PROJECT=$(cd "$PROJECT" && pwd)
[ -f "$PROJECT/index.html" ] || { echo "no index.html in $PROJECT" >&2; exit 2; }
[ -f "$LIB/core/render/video.mjs" ] || { echo "library not installed; run scripts/setup.sh" >&2; exit 2; }

mkdir -p "$PROJECT/out"
cd "$LIB"

if [ "$CHECK" != 0 ]; then
  echo "→ readcheck"
  node core/render/readcheck.mjs "$PROJECT"
fi

echo "→ render $PROJECT @ ${FPS}fps, ${WORKERS} worker(s)"
node core/render/video.mjs "$PROJECT" --fps "$FPS" --workers "$WORKERS" --out "$PROJECT/out/video.mp4"

echo "video: $PROJECT/out/video.mp4"
