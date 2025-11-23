@echo off
chcp 65001 >nul
echo نسخ APK إلى الأماكن المتوقعة...

REM إنشاء المجلد إذا لم يكن موجوداً
if not exist "build\app\outputs\flutter-apk" (
    mkdir "build\app\outputs\flutter-apk"
)

REM نسخ APK إلى المكان المتوقع
if exist "android\app\build\outputs\flutter-apk\app-debug.apk" (
    copy /Y "android\app\build\outputs\flutter-apk\app-debug.apk" "build\app\outputs\flutter-apk\app-debug.apk"
    echo تم نسخ APK إلى build\app\outputs\flutter-apk\app-debug.apk
)

REM نسخ APK إلى جذر المشروع أيضاً
if exist "android\app\build\outputs\flutter-apk\app-debug.apk" (
    copy /Y "android\app\build\outputs\flutter-apk\app-debug.apk" "app-debug.apk"
    echo تم نسخ APK إلى جذر المشروع: app-debug.apk
)

echo.
echo تم الانتهاء!
pause

