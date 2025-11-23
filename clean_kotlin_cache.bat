@echo off
chcp 65001 >nul
echo تنظيف كاش Kotlin و Gradle...
echo.

cd /d "%~dp0android"

REM Stop Gradle daemon
if exist gradlew.bat (
    echo إيقاف Gradle daemon...
    call gradlew.bat --stop
)

REM Clean Flutter build
echo تنظيف Flutter build...
cd /d "%~dp0"
if exist "build" (
    rmdir /s /q "build" 2>nul
)

REM Clean Android build folders
cd /d "%~dp0android"
if exist "app\build" (
    rmdir /s /q "app\build" 2>nul
)
if exist ".gradle" (
    rmdir /s /q ".gradle" 2>nul
)

REM Clean Kotlin build cache in plugins
echo تنظيف كاش Kotlin في الإضافات...
for /d /r "%USERPROFILE%\.gradle\caches" %%d in (kotlin*) do (
    if exist "%%d" (
        echo حذف: %%d
        rmdir /s /q "%%d" 2>nul
    )
)

echo.
echo تم التنظيف بنجاح!
echo.
pause

