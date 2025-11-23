# PowerShell script to fix Gradle cache issues
Write-Host "إصلاح كاش Gradle..." -ForegroundColor Green

# Delete specific corrupted cache folder
$corruptedCache = "$env:USERPROFILE\.gradle\caches\8.7\kotlin-dsl\scripts\779558434197cfbbc8de843fa4772832"
if (Test-Path $corruptedCache) {
    Write-Host "حذف الكاش التالف: $corruptedCache" -ForegroundColor Yellow
    Remove-Item -Recurse -Force $corruptedCache -ErrorAction SilentlyContinue
}

# Delete kotlin-dsl cache folder
$kotlinDslCache = "$env:USERPROFILE\.gradle\caches\8.7\kotlin-dsl"
if (Test-Path $kotlinDslCache) {
    Write-Host "حذف كاش kotlin-dsl..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $kotlinDslCache -ErrorAction SilentlyContinue
}

# Delete scripts cache
$scriptsCache = "$env:USERPROFILE\.gradle\caches\8.7\scripts"
if (Test-Path $scriptsCache) {
    Write-Host "حذف كاش scripts..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $scriptsCache -ErrorAction SilentlyContinue
}

# Clean project build folders
Write-Host "تنظيف مجلدات البناء في المشروع..." -ForegroundColor Yellow
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Remove-Item -Recurse -Force "$projectPath\android\.gradle" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$projectPath\android\app\build" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$projectPath\android\build" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$projectPath\build" -ErrorAction SilentlyContinue

Write-Host "تم الإصلاح بنجاح! جرب البناء الآن." -ForegroundColor Green

