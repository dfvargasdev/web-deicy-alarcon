# Script PowerShell para deployar a GitHub Pages
# Uso: .\deploy-gh-pages.ps1

Write-Host "🚀 Iniciando deploy a GitHub Pages..." -ForegroundColor Green

# 1. Verificar que estamos en main
$currentBranch = git branch --show-current
if ($currentBranch -ne "main") {
    Write-Host "❌ Error: Debes estar en la rama 'main' para ejecutar este script" -ForegroundColor Red
    exit 1
}

# 2. Verificar que no hay cambios sin committear
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "❌ Error: Hay cambios sin committear. Haz commit primero." -ForegroundColor Red
    exit 1
}

# 3. Construir proyecto
Write-Host "📦 Construyendo proyecto para producción..." -ForegroundColor Yellow
ng build --configuration production

# 4. Cambiar a rama gh-pages
Write-Host "🌿 Cambiando a rama gh-pages..." -ForegroundColor Yellow
git checkout gh-pages

# 5. Limpiar archivos anteriores (mantener solo archivos de git)
Write-Host "🧹 Limpiando archivos anteriores..." -ForegroundColor Yellow
Get-ChildItem -Path . -Exclude .git | Remove-Item -Recurse -Force

# 6. Copiar archivos de build
Write-Host "📋 Copiando archivos de producción..." -ForegroundColor Yellow
Copy-Item -Path "dist\neuropsicologia-deicy\browser\*" -Destination "." -Recurse

# 7. Commit y push
Write-Host "💾 Subiendo cambios..." -ForegroundColor Yellow
git add .
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "deploy: Update GitHub Pages - $timestamp"
git push origin gh-pages

# 8. Regresar a main
Write-Host "🔄 Regresando a rama main..." -ForegroundColor Yellow
git checkout main

Write-Host "✅ Deploy completado!" -ForegroundColor Green
Write-Host "🌐 El sitio estará disponible en: https://dfvargasdev.github.io/web-deicy-alarcon/" -ForegroundColor Cyan
