@echo off

rem TODO: verify if git and docker minimum required versions are installed.

git rev-parse --show-toplevel > nul
if ERRORLEVEL 1 (
  rem You must be inside a git repository to run this script!
  pause
) else (
  for /f %%i in ('git rev-parse --show-toplevel') do set repository_root=%%i

  call %repository_root%\scripts\kill.bat

  call %repository_root%\scripts\start.bat
)
