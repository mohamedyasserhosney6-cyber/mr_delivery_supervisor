@echo off
echo ============================================
echo   MR DELIVERY - APK Build Script
echo ============================================
echo.

REM حذف الملفات المؤقتة
echo [1/5] تنظيف الملفات المؤقتة...
if exist ".dart_tool\flutter_build" rmdir /s /q ".dart_tool\flutter_build"
if exist "android\app\build\intermediates" rmdir /s /q "android\app\build\intermediates"

REM تنظيف Flutter
echo [2/5] تنظيف Flutter...
flutter clean

REM تحديث الحزم
echo [3/5] تحديث الحزم...
flutter pub get

REM محاولة البناء
echo [4/5] بناء APK...
flutter build apk --release

REM التحقق من النتيجة
echo [5/5] التحقق من النتيجة...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ============================================
    echo   تم البناء بنجاح! ^_^
    echo   المسار: build\app\outputs\flutter-apk\app-release.apk
    echo ============================================
    explorer build\app\outputs\flutter-apk
) else (
    echo.
    echo ============================================
    echo   فشل البناء! :(
    echo   جرب الحل البديل أدناه
    echo ============================================
    echo.
    echo الحل البديل:
    echo 1. flutter channel beta
    echo 2. flutter upgrade
    echo 3. flutter build apk --release
)

pause
