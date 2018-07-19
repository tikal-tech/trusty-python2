FROM ubuntu:14.04
ENV PYTHONUNBUFFERED 1
ENV PYTHONIOENCODING UTF-8

# calando o debconf e o apt-get a instalacao da uma acelerada
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Instalando as dependencias do sistema
RUN apt-get -qq update && \ 
apt-get -qq upgrade > /dev/null && \
apt-get -qq install \
git \
python2.7-dev \
libpq-dev \
python-dev \
xvfb \
poppler-utils \
build-essential \
libxml2-dev \
libxslt1-dev \
libxslt-dev \
libxml2-dev \
zlib1g-dev \
libxml2-dev \
libxslt-dev \
tidy \
libncurses5-dev \
libffi-dev \
libssl-dev \
libnss3-dev \
libgconf-2-4 \
chromium-chromedriver \
qt5-default \
libqt5webkit5-dev \
wkhtmltopdf > /dev/null

# Configurando o wkhtmltopdf para gerar os pdfs
RUN echo '#!/bin/bash\nxvfb-run -a --server-args="-screen 0, 1024x768x24" /usr/bin/wkhtmltopdf -q $*' > /usr/bin/wkhtmltopdf.sh
RUN chmod a+x /usr/bin/wkhtmltopdf.sh
RUN ln -s /usr/bin/wkhtmltopdf.sh /usr/local/bin/wkhtmltopdf

# Usuario padrao
# uid 1000 tem boa chance de coincidir com o uid de usuarios linux (srry macOSistas)
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd --no-log-init -m -G sudo -u 1000 ubuntu
USER ubuntu
ENV HOME /home/ubuntu
WORKDIR $HOME

# instalar e configurar o python via pyenv
RUN git clone git://github.com/yyuu/pyenv.git .pyenv
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install 2.7.15
RUN pyenv global 2.7.15
RUN pyenv rehash
