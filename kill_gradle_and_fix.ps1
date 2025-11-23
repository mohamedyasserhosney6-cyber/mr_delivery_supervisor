# PowerShell script to kill Gradle processes and fix cache
Write-Host "إيقاف عمليات Gradle..." -ForegroundColor Yellow

# Kill all Java/Gradle processes
Get-Process | Where-Object { 
    $_.ProcessName -like "*java*" -or 
    $_.ProcessName -like "*gradle*" -or
    $_.MainWindowTitle -like "*Gradle*"
} | ForEach-Object {
    try {
        Write-Host "إيقاف العملية: $($_.ProcessName) (ID: $($_.Id))" -ForegroundColor Yellow
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    } catch {
        # Ignore errors
    }
}

# Wait a moment
Start-Sleep -Seconds 3

Write-Host "حذف كاش Gradle 8.7..." -ForegroundColor Yellow
$gradleCache87 = "$env:USERPROFILE\.gradle\caches\8.7"
if (Test-Path $gradleCache87) {
    try {
        # Delete with retry
        for ($i = 1; $i -le 5; $i++) {
            try {
                Remove-Item -Recurse -Force $gradleCache87 -ErrorAction Stop
                Write-Host "تم حذف الكاش بنجاح" -ForegroundColor Green
                break
            } catch {
                if ($i -lt 5) {
                    Write-Host "المحاولة $i فشلت، إعادة المحاولة..." -ForegroundColor Yellow
                    Start-Sleep -Seconds 2
                    # Try to kill processes again
                    Get-Process | Where-Object { $_.ProcessName -like "*java*" } | Stop-Process -Force -ErrorAction SilentlyContinue
                    Start-Sleep -Seconds 1
                } else {
                    Write-Host "فشل حذف الكاش بعد 5 محاولات" -ForegroundColor Red
                    Write-Host "جرب إعادة تشغيل PowerShell كمسؤول" -ForegroundColor Yellow
                }
            }
        }
    } catch {
        Write-Host "خطأ في حذف الكاش: $_" -ForegroundColor Red
    }
} else {
    Write-Host "الكاش غير موجود" -ForegroundColor Green
}

Write-Host ""
Write-Host "تم الإصلاح! جرب البناء الآن" -ForegroundColor Green

