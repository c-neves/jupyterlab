# jupyterlab-template

JupyterLab with Python kernel, R kernel and a "hybrid Python and R kernel" (rpy2).

## `windows`

### `setup`

Install [`git`](https://git-scm.com/download/win).

Install [`docker`](https://hub.docker.com/?overlay=onboarding).

Put the folder `scripts` inside the root of your repository.

For each repository you have, asign a unique value to `PORT` on **line 4** inside `scripts\start.bat`:

```{batch}
1 @echo off
2
3 rem Attribute a specific port for each git repository.
4 set PORT=8888
```

### `start`

Run the script `scripts\start.bat`.

From the command line:

```
cd my-repository
.\scripts\start.bat
```

This will start a docker container running the jupyterlab server and will also launch the browser at `http://localhost:8888/lab` if `PORT` is set to `8888`.

### `kill`

Run the script `scripts\kill.bat`.

From the command line:

```
cd my-repository
.\scripts\kill.bat
```

This will kill the running container, i.e. it will stop running, but it will still take disk space.

### `restart`

Run the script `scripts\kill.bat`.

From the command line:

```
cd my-repository
.\scripts\kill.bat
```

This will kill and then start the container.
