# إصلاح سريع لمشكلة صلاحيات Flutter Build
Write-Host "========================================" -ForegroundColor Green
Write-Host "إصلاح مشكلة صلاحيات Flutter Build" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# الانتقال إلى مجلد المشروع
Set-Location $PSScriptRoot

Write-Host "[1/5] إيقاف عمليات Flutter/Gradle/Java..." -ForegroundColor Yellow
Get-Process | Where-Object { 
    $_.ProcessName -like "*flutter*" -or 
    $_.ProcessName -like "*dart*" -or 
    $_.ProcessName -like "*java*" -or 
    $_.ProcessName -like "*gradle*" 
} | Stop-Process -Force -ErrorAction SilentlyContinue

Start-Sleep -Seconds 2

Write-Host "[2/5] حذف مجلدات البناء..." -ForegroundColor Yellow
$folders = @("build", ".dart_tool", "android\.gradle", "android\app\build")
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "  حذف $folder..." -ForegroundColor Gray
        Remove-Item -Recurse -Force $folder -ErrorAction SilentlyContinue
    }
}

Write-Host "[3/5] تنظيف Flutter..." -ForegroundColor Yellow
flutter clean

Write-Host "[4/5] تحديث الحزم..." -ForegroundColor Yellow
flutter pub get

Write-Host "[5/5] البناء..." -ForegroundColor Yellow
Write-Host ""
flutter build apk --debug

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "تم!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

pause

