FROM ruby:2.2.0
MAINTAINER Michael Wallasch <development@po2mc.de>
ENV REFRESHED_AT 2015-03-13

RUN \
  apt-get update && apt-get install -y python python-dev python-pip python-virtualenv && \
  rm -rf /var/lib/apt/lists/*

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
ONBUILD ADD Gemfile /app/Gemfile
ONBUILD RUN bundle install
ONBUILD ADD . /data

CMD ["bash"]
