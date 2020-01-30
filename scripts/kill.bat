@echo off

rem TODO: verify if git and docker minimum required versions are installed.

git rev-parse --show-toplevel > nul
if ERRORLEVEL 1 (
  rem You must be inside a git repository to run this script!
  pause
) else (
  for /f %%i in ('git config --get remote.origin.url') do set repository_url=%%i
  for /f %%i in ("%repository_url%") do set repository_name=%%~ni

  echo.
  echo + docker kill %repository_name%
  docker kill %repository_name%
)
