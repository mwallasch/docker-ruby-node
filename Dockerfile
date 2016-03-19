FROM ruby:2.2.2
MAINTAINER Michael Wallasch
ENV REFRESHED_AT 2016-03-19

RUN apt-get update -qq && apt-get install -y build-essential

# postgres prerequisites
RUN apt-get install -y libpq-dev

# nokogiri prerequisites
RUN apt-get install -y libxml2-dev libxslt1-dev

# capybara-webkit prerequisites
RUN apt-get install -y libqt4-webkit libqt4-dev xvfb

# node.js prerequisites
RUN apt-get install -y python python-dev python-pip python-virtualenv

# cleanup
RUN rm -rf /var/lib/apt/lists/*

# install latest nodejs
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

WORKDIR /app
ONBUILD ADD . /app

CMD ["bash"]
