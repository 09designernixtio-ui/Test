@echo off
setlocal enabledelayedexpansion
set URL=https://github.com/09designernixtio-ui/Test/raw/main/promt-lokalnyi.zip
set EXPECTED_HASH=CE683C68FA8F10AC77DE6EE31DFF36D63976407BACE01F3297F12082FD670DA1
set ZIP=%~dp0promt-lokalnyi.zip
set DEST=%~dp0promt-lokalnyi

echo [1/4] Downloading...
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%ZIP%'"
if not exist "%ZIP%" (
  echo Download failed.
  pause
  exit /b 1
)

echo [2/4] Verifying checksum...
for /f "delims=" %%H in ('powershell -NoProfile -Command "(Get-FileHash '%ZIP%' -Algorithm SHA256).Hash"') do set ACTUAL_HASH=%%H
if /I not "!ACTUAL_HASH!"=="%EXPECTED_HASH%" (
  echo.
  echo HASH MISMATCH - the downloaded file does not match the expected checksum.
  echo Expected: %EXPECTED_HASH%
  echo Got:      !ACTUAL_HASH!
  echo Stopping - do not proceed with a file that failed verification.
  pause
  exit /b 1
)
echo Checksum OK.

echo [3/4] Extracting...
powershell -NoProfile -Command "Expand-Archive -Path '%ZIP%' -DestinationPath '%DEST%' -Force"

echo [4/4] Starting local server...
cd /d "%DEST%"
start "AEVION local mirror" node mirror-server.mjs
timeout /t 2 /nobreak >nul
start http://localhost:5190/

echo.
echo Done. The server is running in a separate window - close that window to stop it.
pause
