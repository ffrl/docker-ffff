FROM ubuntu:14.04
MAINTAINER Cyrus Fox "cyrus AT lambdacore.de"
RUN apt-get update -qq && apt-get -y install nodejs npm git-core sudo

# Setup ffff
RUN mkdir -p /opt/peers && mkdir -p /opt/ffff
RUN useradd -U -u 2000 -d /opt/peers ffff
RUN git clone https://github.com/ffrl/ffff.git /opt/ffff
RUN chown -R ffff.ffff /opt/peers /opt/ffff /opt/ffff/static
RUN cd /opt/ffff && npm config set registry http://registry.npmjs.org/ && npm install express

# We set a fixed path as we are in an docker environment
RUN sed -e "s/\/tmp\/peers/\/opt\/peers/g" -i  /opt/ffff/server.js

# We listen on all interfaces
RUN sed -e "s/\, 'localhost' / /g" -i /opt/ffff/server.js

# Setup cheap start script
RUN echo '#!/bin/bash' > /opt/ffff/start.sh
RUN echo '/usr/bin/sudo -u ffff /usr/bin/nodejs /opt/ffff/server.js' >> /opt/ffff/start.sh
RUN chmod +x /opt/ffff/start.sh

EXPOSE 8080

CMD ["/opt/ffff/start.sh"]
