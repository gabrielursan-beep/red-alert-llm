@echo off
echo.
echo  ============================================
echo   Red Alert LLM - Setup for Windows
echo  ============================================
echo.
echo  This script downloads AI engines and models.
echo  Acest script descarca motoarele AI si modelele.
echo.
echo  Starting PowerShell setup script...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0setup-windows.ps1"
echo.
pause
