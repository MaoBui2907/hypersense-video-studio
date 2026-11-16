#!/bin/sh
# Kiểm tra môi trường và 8 style trước khi sản xuất.
set -u

HERE=$(cd "$(dirname "$0")" && pwd)
if [ -n "${LEMO_HOME:-}" ]; then
  LIB=$LEMO_HOME
elif [ -n "${AGENT_HOME:-}" ]; then
  LIB=$AGENT_HOME/video-studio/lemo-opuscar
else
  LIB=$HOME/lemo-opuscar
fi
case "$LIB" in /*|[A-Za-z]:[/\\]*) ;; *) LIB=$(pwd)/$LIB ;; esac

fail=0
ok()  { printf 'OK   %s\n' "$1"; }
bad() { printf 'FAIL %s\n' "$1"; fail=1; }

if command -v node >/dev/null; then
  major=$(node -p 'process.versions.node.split(".")[0]')
  [ "$major" -ge 20 ] && ok "Node $(node -v)" || bad "Node 20+ required (found $(node -v))"
else
  bad "Node 20+ not found"
fi

if command -v ffmpeg >/dev/null; then
  major=$(ffmpeg -version 2>/dev/null | sed -n '1s/^ffmpeg version n\{0,1\}\([0-9][0-9]*\)\..*/\1/p')
  [ -n "$major" ] && [ "$major" -ge 7 ] && ok "ffmpeg $major.x" || bad "ffmpeg 7+ required (found ${major:-unknown}.x)"
else
  bad "ffmpeg 7+ not found"
fi

if command -v python3 >/dev/null; then
  python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3,11) else 1)' \
    && ok "Python $(python3 -V 2>&1 | awk '{print $2}')" \
    || bad "Python 3.11+ required (found $(python3 -V 2>&1 | awk '{print $2}'))"
else
  bad "Python 3.11+ not found"
fi

[ -f "$LIB/AGENTS.md" ] && [ -f "$LIB/core/render/video.mjs" ] \
  && ok "library $LIB" || bad "library missing at $LIB (clone the library first)"

[ -f "$LIB/node_modules/.lemo-ok" ] && ok "Node deps" || bad "Node deps missing (run upstream setup.sh deps)"
[ -x "$LIB/.venv/bin/python" ] && ok "Python venv" || bad "Python venv missing (run upstream setup.sh deps)"

while IFS='|' read -r slug name _; do
  [ -n "$slug" ] || continue
  [ -f "$LIB/styles/$slug/STYLE.md" ] && ok "style $name ($slug)" || bad "style missing: $slug"
done < "$HERE/styles.txt"

echo
[ "$fail" -eq 0 ] && echo "READY: $LIB" || echo "NOT READY: fix the FAIL lines above"
exit "$fail"
