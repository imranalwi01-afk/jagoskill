#!/bin/bash

set -e

DEPLOYPATH="${DEPLOYPATH:-$HOME/public_html/jagoskill.com}"
REPOPATH="${REPOPATH:-$(pwd)}"

mkdir -p "$DEPLOYPATH"
mkdir -p "$DEPLOYPATH/storage"
mkdir -p "$DEPLOYPATH/bootstrap/cache"
mkdir -p "$DEPLOYPATH/app"
mkdir -p "$DEPLOYPATH/bootstrap"
mkdir -p "$DEPLOYPATH/config"
mkdir -p "$DEPLOYPATH/database"
mkdir -p "$DEPLOYPATH/lang"
mkdir -p "$DEPLOYPATH/public"
mkdir -p "$DEPLOYPATH/resources"
mkdir -p "$DEPLOYPATH/routes"
mkdir -p "$DEPLOYPATH/tests"

# Copy application source while keeping the production .env in place.
/bin/cp -a "$REPOPATH/app/." "$DEPLOYPATH/app/"
/bin/cp -a "$REPOPATH/bootstrap/." "$DEPLOYPATH/bootstrap/"
/bin/cp -a "$REPOPATH/config/." "$DEPLOYPATH/config/"
/bin/cp -a "$REPOPATH/database/." "$DEPLOYPATH/database/"
/bin/cp -a "$REPOPATH/lang/." "$DEPLOYPATH/lang/"
/bin/cp -a "$REPOPATH/public/." "$DEPLOYPATH/public/"
/bin/cp -a "$REPOPATH/resources/." "$DEPLOYPATH/resources/"
/bin/cp -a "$REPOPATH/routes/." "$DEPLOYPATH/routes/"
/bin/cp -a "$REPOPATH/tests/." "$DEPLOYPATH/tests/"
/bin/cp -a "$REPOPATH/artisan" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/composer.json" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/composer.lock" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/package.json" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/package-lock.json" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/vite.config.js" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/webpack.mix.js" "$DEPLOYPATH/"
/bin/cp -a "$REPOPATH/.htaccess" "$DEPLOYPATH/"

if [ -f "$REPOPATH/.env.example" ]; then
  /bin/cp -a "$REPOPATH/.env.example" "$DEPLOYPATH/.env.example"
fi
