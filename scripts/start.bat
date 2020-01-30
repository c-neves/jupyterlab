@echo off

rem Attribute a specific port for each git repository.
set PORT=8888

rem TODO: verify if git and docker minimum required versions are installed.

rem NOTE: https://stackoverflow.com/questions/25033155/my-batch-script-only-works-the-second-time
setlocal enabledelayedexpansion

git rev-parse --show-toplevel > nul
if ERRORLEVEL 1 (
  rem You must be inside a git repository to run this script!
  pause
) else (
  for /f %%i in ('git config --get remote.origin.url') do set repository_url=%%i
  for /f %%i in ("!repository_url!") do set repository_name=%%~ni
  for /f %%i in ('git rev-parse --show-toplevel') do set repository_root=%%i

  set docker_ps=docker ps -aq -f name=!repository_name!
  for /f %%i in ('!docker_ps!') do set container_hash=%%i

  if "!container_hash!" == "" (
    rem Container doesn't exit yet => `docker run`.
    echo.
    echo + docker run --name !repository_name! --volume !repository_root!:/!repository_name! --workdir /!repository_name! --publish %PORT%:8888 --entrypoint jupyter --detach cneves/jupyterlab:rpy2-3.2 lab --allow-root --ip=0.0.0.0 --NotebookApp.token='' --no-browser
    docker run ^
      --name !repository_name! ^
      --volume %userprofile%\.ssh:/root/.ssh ^
      --volume !repository_root!:/!repository_name! ^
      --workdir /!repository_name! ^
      --publish %PORT%:8888 ^
      --entrypoint jupyter ^
      --detach ^
      cneves/jupyterlab:rpy2-3.2 ^
      lab --allow-root --ip=0.0.0.0 --NotebookApp.token='' --no-browser

    docker exec !repository_name! chmod 700 /root/.ssh/id_rsa

    pause

    timeout /t 2
  ) else (
    rem Container is either `running` or `exited` => `docker start`.
    echo.
    echo + docker start !repository_name!
    docker start !repository_name!

    timeout /t 1
  )


  echo.
  echo + start http://localhost:%PORT%/lab
  start http://localhost:%PORT%/lab
)
