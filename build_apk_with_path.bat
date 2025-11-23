@echo off
REM Build APK using Flutter with custom path
REM Update FLUTTER_PATH below to your Flutter installation

set FLUTTER_PATH=C:\src\flutter
REM Alternative paths to try:
REM set FLUTTER_PATH=C:\flutter
REM set FLUTTER_PATH=%USERPROFILE%\flutter

REM Check if Flutter exists at specified path
if not exist "%FLUTTER_PATH%\bin\flutter.bat" (
    echo ========================================
    echo Flutter not found at: %FLUTTER_PATH%
    echo ========================================
    echo.
    echo Please update FLUTTER_PATH in this file to point to your Flutter installation.
    echo.
    echo Common locations:
    echo   C:\src\flutter
    echo   C:\flutter
    echo   %USERPROFILE%\flutter
    echo.
    echo Or install Flutter from:
    echo   https://docs.flutter.dev/get-started/install/windows
    echo.
    pause
    exit /b 1
)

echo ========================================
echo Building MR DELIVERY Supervisor APK
echo Using Flutter: %FLUTTER_PATH%
echo ========================================
echo.

REM Navigate to project directory
cd /d "%~dp0"

echo [1/4] Getting Flutter packages...
call "%FLUTTER_PATH%\bin\flutter.bat" pub get
if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to get packages
    pause
    exit /b 1
)

echo.
echo [2/4] Cleaning previous builds...
call "%FLUTTER_PATH%\bin\flutter.bat" clean
if %ERRORLEVEL% neq 0 (
    echo WARNING: Clean failed, continuing...
)

echo.
echo [3/4] Building APK (Debug)...
call "%FLUTTER_PATH%\bin\flutter.bat" build apk --debug
if %ERRORLEVEL% neq 0 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [4/4] Build complete!
echo.
echo APK location:
echo %CD%\build\app\outputs\flutter-apk\app-debug.apk
echo.
pause

