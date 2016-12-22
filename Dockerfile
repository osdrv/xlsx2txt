FROM whiteboxio/ruby:2.3.3-alpine
ADD Gemfile /usr/local/www/xls2txt/
ADD Gemfile.lock /usr/local/www/xls2txt/
RUN apk --update add --virtual build-dependencies libstdc++ ruby-dev build-base g++ musl-dev make && \  
    gem install bundler --no-ri --no-rdoc && \
    cd /usr/local/www/xls2txt ; bundle install --without development test
ADD . /usr/local/www/xls2txt/
COPY config/xls2txt.whitebox.io.nginx.conf /etc/nginx/conf.d/xls2txt.whitebox.io/site.conf
RUN chown -R nobody:nogroup /usr/local/www/xls2txt/
USER nobody
ENV RACK_ENV production
EXPOSE 9595
WORKDIR /usr/local/www/xls2txt/
