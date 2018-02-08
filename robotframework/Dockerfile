FROM ubuntu:16.04

LABEL description="Docker image for the Robot Framework http://robotframework.org/ modified for Yleisradio usacases"
LABEL usage=" "

# Set timezone to Europe/Helsinki and install dependencies
#   * git & curl & wget
#   * python
#   * xvfb
#   * chrome
#   * chrome selenium driver
#   * hi-res fonts

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -yqq  update \
    && apt-get upgrade -yqq \
    && apt-get install -y \
    apt-utils \
    sudo \
    tzdata \
    python-pip \
    python-setuptools \
    xvfb \
    git \
    unzip \
    wget \
    curl \
    dbus-x11 \
    xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic \
    --no-install-recommends \
    && apt-get clean autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "Europe/Helsinki" > /etc/timezone \
    && rm /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` \
    && mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION \
    && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION  \
    && rm /tmp/chromedriver_linux64.zip \
    && chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver \
    && ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver \
    && curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get -yqq update \
    && apt-get -yqq install google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && chmod a+x /usr/bin/google-chrome

# Fix hanging Chrome, see https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS /dev/null
ENV DISPLAY=:99

# Install Robot Framework libraries
COPY requirements.txt /tmp/
RUN pip install --upgrade pip
RUN pip install -Ur /tmp/requirements.txt && rm /tmp/requirements.txt

ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
