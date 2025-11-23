@echo off
chcp 65001 >nul
echo تنظيف كامل لكاش Gradle و Kotlin...
echo.

REM Clean Flutter
cd /d "%~dp0"
echo تنظيف Flutter build...
flutter clean 2>nul

REM Clean Android build folders
cd /d "%~dp0android"
if exist "app\build" (
    echo حذف app\build...
    rmdir /s /q "app\build" 2>nul
)
if exist ".gradle" (
    echo حذف .gradle...
    rmdir /s /q ".gradle" 2>nul
)
if exist "build" (
    echo حذف build...
    rmdir /s /q "build" 2>nul
)

REM Clean Gradle caches
echo تنظيف كاش Gradle...
echo حذف kotlin-dsl cache...
for /d /r "%USERPROFILE%\.gradle\caches" %%d in (kotlin-dsl) do (
    if exist "%%d" (
        echo حذف: %%d
        rmdir /s /q "%%d" 2>nul
    )
)
echo حذف scripts cache...
for /d /r "%USERPROFILE%\.gradle\caches" %%d in (scripts) do (
    if exist "%%d" (
        echo حذف: %%d
        rmdir /s /q "%%d" 2>nul
    )
)
REM Clean specific version caches
if exist "%USERPROFILE%\.gradle\caches\8.7" (
    echo حذف Gradle 8.7 cache...
    rmdir /s /q "%USERPROFILE%\.gradle\caches\8.7\kotlin-dsl" 2>nul
    rmdir /s /q "%USERPROFILE%\.gradle\caches\8.7\scripts" 2>nul
)

REM Clean Kotlin daemon
echo تنظيف Kotlin daemon...
if exist "%USERPROFILE%\.kotlin\daemon" (
    echo حذف Kotlin daemon...
    rmdir /s /q "%USERPROFILE%\.kotlin\daemon" 2>nul
)

REM Clean plugin cache that caused issues
if exist "%USERPROFILE%\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.16\android\build" (
    echo حذف shared_preferences_android build cache...
    rmdir /s /q "%USERPROFILE%\AppData\Local\Pub\Cache\hosted\pub.dev\shared_preferences_android-2.4.16\android\build" 2>nul
)

echo.
echo تم التنظيف بنجاح!
echo.
pause

