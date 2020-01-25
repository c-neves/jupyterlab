@echo off

rem Attribute a specific port for each git repository.
set PORT=8888

rem TODO: verify if git and docker minimum required versions are installed.

git rev-parse --show-toplevel > nul
if ERRORLEVEL 1 (
  rem You must be inside a git repository to run this script!
  pause
) else (
  for /f %%i in ('git config --get remote.origin.url') do set repository_url=%%i
  for /F %%i in ('%repository_url%') do set repository_name=%%~ni
  for /f %%i in ('git rev-parse --show-toplevel') do set repository_root=%%i

  echo.
  echo + docker run --name %repository_name% --volume %repository_root%:/%repository_name% --workdir /%repository_name% --publish %PORT%:8888 --entrypoint jupyter --detach --rm cneves/jupyterlab lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token=''
  docker run ^
    --name %repository_name% ^
    --volume %repository_root%:/%repository_name% ^
    --workdir /%repository_name% ^
    --publish %PORT%:8888 ^
    --entrypoint jupyter ^
    --detach ^
    --rm ^
    cneves/jupyterlab ^
    lab --allow-root --ip=0.0.0.0 --no-browser --NotebookApp.token=''

  echo.
  echo + start http://localhost:%PORT%/lab
  start http://localhost:%PORT%/lab
)
