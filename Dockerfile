FROM bitnami/rails:latest

# Install OS dependencies
USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends clamdscan

USER bitnami
COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock

# Install bundler
RUN sudo gem install bundler:1.17.2
# RUN bundle version && fail

WORKDIR $APP_PATH
RUN sudo bundle install
COPY . $APP_PATH

USER root
# Precompile assets
RUN echo "TCPSocket 3310" > /etc/clamav/clamd.conf
RUN echo "TCPAddr 192.168.220.134" >> /etc/clamav/clamd.conf

USER bitnami
# Entrypoint and CMD
