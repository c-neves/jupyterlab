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
  for /f %%i in ("%repository_url%") do set repository_name=%%~ni
  for /f %%i in ('git rev-parse --show-toplevel') do set repository_root=%%i

  mkdir %repository_root%\.docker 2> nul

  docker ps -aq -f "name=^%repository_name%$" > "%repository_root%\.docker\hash"
  for %%i in ("%repository_root%\.docker\hash") do set container=%%~zi

  if "%container%" equ "0" (
    rem Container doesn't exit yet => `docker run`.
    echo.
    echo + docker run --name %repository_name% --volume %repository_root%:/%repository_name% --workdir /%repository_name% --publish %PORT%:8888 --entrypoint jupyter --detach cneves/jupyterlab:rpy2-3.2 lab --allow-root --ip=0.0.0.0 --NotebookApp.token='' --no-browser
    docker run ^
      --name %repository_name% ^
      --volume %repository_root%:/%repository_name% ^
      --workdir /%repository_name% ^
      --publish %PORT%:8888 ^
      --entrypoint jupyter ^
      --detach ^
      cneves/jupyterlab:rpy2-3.2 ^
      lab --allow-root --ip=0.0.0.0 --NotebookApp.token='' --no-browser
  ) else (
    rem Container is either `running` or `exited` => `docker start`.
    echo + docker start %repository_name%
    docker start %repository_name%
  )

  echo.
  echo + start http://localhost:%PORT%/lab
  start http://localhost:%PORT%/lab
)
