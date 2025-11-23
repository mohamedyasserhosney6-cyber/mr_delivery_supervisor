# PowerShell script to completely fix Gradle cache
Write-Host "إصلاح كامل لكاش Gradle..." -ForegroundColor Green

# Stop any running Gradle daemons first
Write-Host "إيقاف Gradle daemons..." -ForegroundColor Yellow
$gradlewPath = "$PSScriptRoot\android\gradlew.bat"
if (Test-Path $gradlewPath) {
    try {
        & $gradlewPath --stop 2>&1 | Out-Null
    } catch {
        # Ignore errors
    }
}

# Delete the entire Gradle 8.7 cache
Write-Host "حذف كامل لكاش Gradle 8.7..." -ForegroundColor Yellow
$gradleCache87 = "$env:USERPROFILE\.gradle\caches\8.7"
if (Test-Path $gradleCache87) {
    Write-Host "حذف: $gradleCache87" -ForegroundColor Yellow
    Remove-Item -Recurse -Force $gradleCache87 -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Also delete kotlin-dsl and scripts from all versions
Write-Host "حذف كاش kotlin-dsl و scripts..." -ForegroundColor Yellow
$kotlinDslPath = "$env:USERPROFILE\.gradle\caches\*\kotlin-dsl"
Get-ChildItem -Path "$env:USERPROFILE\.gradle\caches" -Filter "kotlin-dsl" -Recurse -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "حذف: $($_.FullName)" -ForegroundColor Yellow
    Remove-Item -Recurse -Force $_.FullName -ErrorAction SilentlyContinue
}

$scriptsPath = "$env:USERPROFILE\.gradle\caches\*\scripts"
Get-ChildItem -Path "$env:USERPROFILE\.gradle\caches" -Filter "scripts" -Recurse -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "حذف: $($_.FullName)" -ForegroundColor Yellow
    Remove-Item -Recurse -Force $_.FullName -ErrorAction SilentlyContinue
}

# Clean project build folders
Write-Host "تنظيف مجلدات البناء في المشروع..." -ForegroundColor Yellow
$projectPath = $PSScriptRoot
$foldersToClean = @(
    "$projectPath\android\.gradle",
    "$projectPath\android\app\build",
    "$projectPath\android\build",
    "$projectPath\build"
)

foreach ($folder in $foldersToClean) {
    if (Test-Path $folder) {
        Write-Host "حذف: $folder" -ForegroundColor Yellow
        Remove-Item -Recurse -Force $folder -ErrorAction SilentlyContinue
    }
}

# Clean Kotlin daemon
Write-Host "تنظيف Kotlin daemon..." -ForegroundColor Yellow
$kotlinDaemon = "$env:USERPROFILE\.kotlin\daemon"
if (Test-Path $kotlinDaemon) {
    Remove-Item -Recurse -Force $kotlinDaemon -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "تم الإصلاح بنجاح!" -ForegroundColor Green
Write-Host "الآن جرب: flutter pub get" -ForegroundColor Cyan
Write-Host "ثم: flutter build apk --debug" -ForegroundColor Cyan

