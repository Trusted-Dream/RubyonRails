FROM ruby:3.0.0
RUN apt-get update && apt-get install -y curl postgresql-client vim && \
apt-get install -y gcc g++ make apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn
# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_15.x | bash - && \
apt-get install -y nodejs
RUN mkdir /dream_app
WORKDIR /dream_app
COPY Gemfile /dream_app/Gemfile
COPY Gemfile.lock /dream_app/Gemfile.lock
COPY . /dream_app
RUN bundle install
#RUN touch /var/log/cron.log
# RUN rails webpacker:install
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]