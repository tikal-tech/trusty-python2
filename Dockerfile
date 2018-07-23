FROM ubuntu:14.04

# cale-se debconf! (a instalacao fica menos verbosa)
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
apt-get -qq update && \ 
apt-get -qq upgrade > /dev/null && \
apt-get -qq install \
build-essential \
chromium-chromedriver \
curl \
git \
git-core \
libbz2-dev \
libffi-dev \
libgconf-2-4 \
libncurses5-dev \
libncursesw5-dev \
libnss3-dev \
libpq-dev \
libqt5webkit5-dev \
libreadline-dev \
libsqlite3-dev \
libssl-dev \
libxml2-dev \
libxslt1-dev \
libxslt-dev \
llvm \
make \
poppler-utils \
python2.7-dev \
python-dev \
python-pip \
qt5-default \
tidy \
tk-dev \
wget \
wkhtmltopdf \
xvfb \
xz-utils \
zlib1g-dev \
> /dev/null && \
apt-get clean

# Configurando o wkhtmltopdf para gerar os pdfs
RUN echo '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf -q $*' \
> /usr/bin/wkhtmltopdf.sh
RUN chmod a+x /usr/bin/wkhtmltopdf.sh
RUN ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

## # essa parte ainda ta experimental
## # Usuario padrao
## # https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
## RUN useradd --no-log-init -m -G sudo ubuntu && passwd -d ubuntu                                                                           
## 
## USER ubuntu
## ENV HOME /home/ubuntu
## WORKDIR $HOME
## 
## # instalar e configurar o python via pyenv
## RUN git clone git://github.com/yyuu/pyenv.git .pyenv
## ENV PYENV_ROOT $HOME/.pyenv
## ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
## 
## RUN pyenv install 2.7.15
## RUN pyenv global 2.7.15
## RUN pyenv rehash
## 
## # custom entrypoint. mapeia o usuario uid/guid do workdir e/ou folder alvo ao usuario ubuntu
## COPY docker_entrypoint.sh /usr/local/bin/docker_entrypoint
## ENTRYPOINT ["docker_entrypoint"]
