#!/bin/bash

# Script para deployar a GitHub Pages
# Uso: ./deploy-gh-pages.sh

set -e

echo "🚀 Iniciando deploy a GitHub Pages..."

# 1. Verificar que estamos en main
if [ "$(git branch --show-current)" != "main" ]; then
    echo "❌ Error: Debes estar en la rama 'main' para ejecutar este script"
    exit 1
fi

# 2. Verificar que no hay cambios sin committear
if [ -n "$(git status --porcelain)" ]; then
    echo "❌ Error: Hay cambios sin committear. Haz commit primero."
    exit 1
fi

# 3. Construir proyecto
echo "📦 Construyendo proyecto para producción..."
ng build --configuration production

# 4. Cambiar a rama gh-pages
echo "🌿 Cambiando a rama gh-pages..."
git checkout gh-pages

# 5. Limpiar archivos anteriores (excepto .git)
echo "🧹 Limpiando archivos anteriores..."
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} \;

# 6. Copiar archivos de build
echo "📋 Copiando archivos de producción..."
cp -r dist/neuropsicologia-deicy/browser/* .

# 7. Commit y push
echo "💾 Subiendo cambios..."
git add .
git commit -m "deploy: Update GitHub Pages - $(date '+%Y-%m-%d %H:%M:%S')"
git push origin gh-pages

# 8. Regresar a main
echo "🔄 Regresando a rama main..."
git checkout main

echo "✅ Deploy completado!"
echo "🌐 El sitio estará disponible en: https://dfvargasdev.github.io/web-deicy-alarcon/"
