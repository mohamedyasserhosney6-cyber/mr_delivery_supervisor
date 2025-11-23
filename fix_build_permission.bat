@echo off
REM إصلاح مشكلة الصلاحيات في Flutter Build
echo ========================================
echo إصلاح مشكلة صلاحيات Flutter Build
echo ========================================
echo.

REM الانتقال إلى مجلد المشروع
cd /d "%~dp0"

echo [1/5] إيقاف عمليات Flutter/Gradle/Java...
taskkill /F /IM flutter.exe /T 2>nul
taskkill /F /IM dart.exe /T 2>nul
taskkill /F /IM java.exe /T 2>nul
taskkill /F /IM javaw.exe /T 2>nul
taskkill /F /IM gradle.exe /T 2>nul
timeout /t 2 /nobreak >nul

echo [2/5] حذف مجلدات البناء...
if exist "build" (
    echo حذف build...
    rmdir /s /q "build" 2>nul
)

if exist ".dart_tool\flutter_build" (
    echo حذف .dart_tool\flutter_build...
    rmdir /s /q ".dart_tool\flutter_build" 2>nul
)

if exist ".dart_tool" (
    echo حذف .dart_tool...
    rmdir /s /q ".dart_tool" 2>nul
)

if exist "android\.gradle" (
    echo حذف android\.gradle...
    rmdir /s /q "android\.gradle" 2>nul
)

if exist "android\app\build" (
    echo حذف android\app\build...
    rmdir /s /q "android\app\build" 2>nul
)

echo [3/5] تنظيف Flutter...
flutter clean

echo [4/5] تحديث الحزم...
flutter pub get

echo [5/5] البناء...
flutter build apk --debug

echo.
echo ========================================
echo تم!
echo ========================================
pause

