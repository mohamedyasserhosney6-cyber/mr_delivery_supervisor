@echo off
REM Find Flutter installation on Windows

echo ========================================
echo Searching for Flutter installation...
echo ========================================
echo.

set FOUND=0

REM Check common locations
echo Checking common locations...
echo.

REM C:\src\flutter
if exist "C:\src\flutter\bin\flutter.bat" (
    echo [FOUND] C:\src\flutter
    set FLUTTER_PATH=C:\src\flutter
    set FOUND=1
    goto :found
)

REM C:\flutter
if exist "C:\flutter\bin\flutter.bat" (
    echo [FOUND] C:\flutter
    set FLUTTER_PATH=C:\flutter
    set FOUND=1
    goto :found
)

REM %USERPROFILE%\flutter
if exist "%USERPROFILE%\flutter\bin\flutter.bat" (
    echo [FOUND] %USERPROFILE%\flutter
    set FLUTTER_PATH=%USERPROFILE%\flutter
    set FOUND=1
    goto :found
)

REM %LOCALAPPDATA%\flutter
if exist "%LOCALAPPDATA%\flutter\bin\flutter.bat" (
    echo [FOUND] %LOCALAPPDATA%\flutter
    set FLUTTER_PATH=%LOCALAPPDATA%\flutter
    set FOUND=1
    goto :found
)

REM Program Files
if exist "C:\Program Files\flutter\bin\flutter.bat" (
    echo [FOUND] C:\Program Files\flutter
    set FLUTTER_PATH=C:\Program Files\flutter
    set FOUND=1
    goto :found
)

:found
if %FOUND%==1 (
    echo.
    echo ========================================
    echo Flutter found at: %FLUTTER_PATH%
    echo ========================================
    echo.
    echo To use this Flutter, update build_apk_with_path.bat:
    echo   set FLUTTER_PATH=%FLUTTER_PATH%
    echo.
    echo Or add to PATH:
    echo   %FLUTTER_PATH%\bin
    echo.
    echo Testing Flutter...
    "%FLUTTER_PATH%\bin\flutter.bat" --version
    echo.
) else (
    echo ========================================
    echo Flutter NOT FOUND in common locations
    echo ========================================
    echo.
    echo Please install Flutter from:
    echo   https://docs.flutter.dev/get-started/install/windows
    echo.
    echo Or if Flutter is installed elsewhere, update:
    echo   build_apk_with_path.bat
    echo.
)

pause

