FROM ubuntu:18.04

LABEL description="Docker image for the Robot Framework http://robotframework.org/ modified for Yleisradio use cases"
LABEL usage=" "

# Create user
RUN useradd automation --shell /bin/bash --create-home

# install all sorts of usefull applications
RUN apt-get -y update && apt-get install -yqq xvfb tzdata wget gnupg software-properties-common curl unzip \
    libxml2-utils python3-distutils

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

RUN echo "Europe/Helsinki" > /etc/timezone \
    && rm /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

#install python 3.8.1
RUN apt update \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt install -y python3.8 \
    && rm /usr/bin/python3 \
    && ln -fs /usr/bin/python3.8 /usr/bin/python3 \
    && ln -fs /usr/bin/python3 /usr/bin/python

#install google chrome latest version
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
    && apt-get -yqq update \
    && apt-get -yqq install google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && chmod a+x /usr/bin/google-chrome

#install chromedriver based on the chrome-version (compatible chromedriver and chrome has same main version number)
RUN CHROME_VERSION=$(google-chrome --version) \
    && MAIN_VERSION=${CHROME_VERSION#Google Chrome } && MAIN_VERSION=${MAIN_VERSION%%.*} \
    && echo "installing latest chromedriver main version: $MAIN_VERSION" \
    && CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_$MAIN_VERSION` \
    && echo "chrome version: $CHROME_VERSION" \
    && echo "chromedriver version: $CHROMEDRIVER_VERSION" \
    && mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION \
    && echo "directory for chromedriver set: /opt/chromedriver-$CHROMEDRIVER_VERSION" \
    && curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION  \
    && rm /tmp/chromedriver_linux64.zip \
    && chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver \
    && echo "original file: /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver" \
    && echo "linked to file: /usr/local/bin/chromedriver" \
    && ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# set display port and dbus env to avoid crash and hanging
ENV DISPLAY :99
ENV DBUS_SESSION_BUS_ADDRESS /dev/null

#install pip
RUN wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install --upgrade pip \
	&& rm -f get-pip.py

# Install Robot Framework libraries
#(pypi setup for jsonlibrary is broken and it needs separate installation from master)
COPY requirements.txt /tmp/
RUN pip install -Ur /tmp/requirements.txt && rm /tmp/requirements.txt
RUN pip install https://github.com/nottyo/robotframework-jsonlibrary/archive/master.zip

#pythonpath is needed for test running (note when building container: map yle-ovp-test --> /ovp_tests)
ENV PYTHONPATH /ovp_tests/resources/libraries:/ovp_tests/resources/variables:/ovp_tests/scripts/python:/ovp_tests/env
ENV PYTHONIOENCODING "utf-8"
ENV HOME /ovp_tests

CMD ["bash"]