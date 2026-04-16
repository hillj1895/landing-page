#!/bin/bash
set -e

ENV=${1:-aws}
DIST=dist

if [[ "$ENV" != "aws" && "$ENV" != "local" ]]; then
  echo "Usage: ./build.sh [aws|local]"
  exit 1
fi

rm -rf "$DIST"
cp -r src "$DIST"

if [ "$ENV" = "aws" ]; then
  BANNER='<div class="env-banner">Cloud-hosted version \&#8212; <a href="https://local.joe-hill.me">visit the home server mirror<\/a><\/div>'
else
  BANNER='<div class="env-banner">Home server mirror \&#8212; <a href="https://joe-hill.me">visit the primary site<\/a><\/div>'
fi

# & and / are special in sed replacement strings, so they are pre-escaped above.
# sed -i.bak works on both macOS and Linux (backup file is cleaned up after)
find "$DIST" -name "*.html" -exec sed -i.bak "s|<!--ENV_BANNER-->|$BANNER|g" {} \;
find "$DIST" -name "*.bak" -delete

echo "Built for '$ENV' -> $DIST/"
