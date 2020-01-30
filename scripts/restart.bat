@echo off

rem TODO: verify if git and docker minimum required versions are installed.

rem NOTE: https://stackoverflow.com/questions/25033155/my-batch-script-only-works-the-second-time
setlocal enabledelayedexpansion

git rev-parse --show-toplevel > nul
if ERRORLEVEL 1 (
  rem You must be inside a git repository to run this script!
  pause
) else (
  for /f %%i in ('git rev-parse --show-toplevel') do set repository_root=%%i

  call !repository_root!\scripts\kill.bat

  call !repository_root!\scripts\start.bat
)
