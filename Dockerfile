FROM whitebox/ruby:2.3.3-alpine
ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN apk --update add --virtual build-dependencies libstdc++ ruby-dev build-base g++ musl-dev make && \  
    gem install bundler --no-ri --no-rdoc && \
    cd /app ; bundle install --without development test
#&& \
#    apk del build-dependencies
ADD . /app
RUN chown -R nobody:nogroup /app
USER nobody
ENV RACK_ENV production
EXPOSE 9595
WORKDIR /app
