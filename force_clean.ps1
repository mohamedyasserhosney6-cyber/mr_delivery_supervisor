# تنظيف قوي لإصلاح مشكلة صلاحيات Flutter Build
Write-Host "========================================" -ForegroundColor Green
Write-Host "تنظيف قوي لمشكلة صلاحيات Flutter Build" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# الانتقال إلى مجلد المشروع
Set-Location $PSScriptRoot

Write-Host "[1/6] إيقاف جميع العمليات..." -ForegroundColor Yellow

# إيقاف جميع العمليات المتعلقة
$processes = @("flutter", "dart", "java", "javaw", "gradle", "gradlew")
foreach ($proc in $processes) {
    Get-Process | Where-Object { $_.ProcessName -like "*$proc*" } | Stop-Process -Force -ErrorAction SilentlyContinue
}

# انتظار قليل
Start-Sleep -Seconds 3

Write-Host "[2/6] إغلاق الملفات المفتوحة في المجلدات..." -ForegroundColor Yellow
# محاولة إغلاق أي ملفات مفتوحة في المجلدات

Write-Host "[3/6] حذف مجلدات البناء بقوة..." -ForegroundColor Yellow

# قائمة المجلدات للحذف
$folders = @(
    "build",
    ".dart_tool",
    "android\.gradle",
    "android\app\build",
    "android\app\build\outputs",
    "ios\Flutter\ephemeral",
    "linux\flutter\ephemeral",
    "macos\Flutter\ephemeral",
    "windows\flutter\ephemeral"
)

foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "  محاولة حذف $folder..." -ForegroundColor Gray
        try {
            # محاولة إزالة السمات أولاً
            Get-ChildItem -Path $folder -Recurse -Force | ForEach-Object {
                $_.Attributes = "Normal"
            }
            Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 500
        } catch {
            Write-Host "    ⚠️  فشل حذف $folder (قد يكون مستخدم)" -ForegroundColor Yellow
        }
    }
}

Write-Host "[4/6] تنظيف Flutter..." -ForegroundColor Yellow
flutter clean 2>&1 | Out-Null

Write-Host "[5/6] تحديث الحزم..." -ForegroundColor Yellow
flutter pub get

Write-Host "[6/6] البناء..." -ForegroundColor Yellow
Write-Host ""

# محاولة البناء
flutter build apk --debug

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✅ تم البناء بنجاح!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK موجود في:" -ForegroundColor Cyan
    Write-Host "android\app\build\outputs\flutter-apk\app-debug.apk" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "❌ فشل البناء" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 حاول:" -ForegroundColor Yellow
    Write-Host "  1. أغلق Android Studio تماماً" -ForegroundColor White
    Write-Host "  2. أغلق VS Code" -ForegroundColor White
    Write-Host "  3. شغّل PowerShell كمسؤول" -ForegroundColor White
    Write-Host "  4. نفّذ هذا السكربت مرة أخرى" -ForegroundColor White
}

Write-Host ""
pause

