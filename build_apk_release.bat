@echo off
REM Build Release APK for MR DELIVERY Supervisor App

echo ========================================
echo Building MR DELIVERY Supervisor APK (Release)
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Flutter not found in PATH!
    echo Please install Flutter and add it to PATH.
    pause
    exit /b 1
)

REM Check if key.properties exists
if not exist "android\key.properties" (
    echo WARNING: key.properties not found!
    echo.
    echo To build Release APK, you need to:
    echo 1. Create a keystore:
    echo    keytool -genkey -v -keystore %USERPROFILE%\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    echo.
    echo 2. Create android\key.properties with:
    echo    storePassword=YOUR_PASSWORD
    echo    keyPassword=YOUR_PASSWORD
    echo    keyAlias=upload
    echo    storeFile=C:/Users/YOUR_USERNAME/upload-keystore.jks
    echo.
    echo Building Debug APK instead...
    call build_apk.bat
    exit /b 0
)

REM Navigate to project directory
cd /d "%~dp0"

echo [1/4] Getting Flutter packages...
call flutter pub get
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to get packages
    pause
    exit /b 1
)

echo.
echo [2/4] Cleaning previous builds...
call flutter clean
if %ERRORLEVEL% neq 0 (
    echo WARNING: Clean failed, continuing...
)

echo.
echo [3/4] Building APK (Release)...
call flutter build apk --release
if %ERRORLEVEL% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [4/4] Build complete!
echo.
echo APK location:
echo %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.
pause

