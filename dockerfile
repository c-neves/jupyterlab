FROM python:3.8.1-slim

MAINTAINER Carlos Neves

# Install R version 3.5.2.
# INSTRUCTIONS: https://cran.r-project.org/bin/linux/debian/
ENV R_VERSION=3.5.2
RUN apt update && \
  apt install -y r-base=$R_VERSION-1 r-base-dev=$R_VERSION-1 libatlas3-base

# Clean apt cache to free up disk space.
RUN apt clean

# Upgrade pip.
RUN pip install --no-cache-dir --upgrade pip

# Install jupyter notebook and jupyter lab.
RUN pip install --no-cache-dir jupyter jupyterlab

# Install R kernel and make it available to jupyter.
ENV CRAN_MIRROR=https://cloud.r-project.org
RUN Rscript -e "install.packages(c('repr', 'IRdisplay', 'IRkernel'), type = 'source', repos = '$CRAN_MIRROR')"
RUN Rscript -e "IRkernel::installspec(user = FALSE)"

# Install [rpy2](https://rpy2.bitbucket.io/).
ENV RPY2_VERSION 3.2
RUN pip install --no-cache-dir rpy2==$RPY2_VERSION
