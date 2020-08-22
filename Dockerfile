FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

ARG APP_DIR_ARG=/var/projects/garage_task
ENV APP_DIR=$APP_DIR_ARG

RUN mkdir -p ${APP_DIR}

WORKDIR ${APP_DIR}

RUN gem install bundler

COPY Gemfile ${APP_DIR}/Gemfile
COPY Gemfile.lock ${APP_DIR}/Gemfile.lock
#RUN bundle update --bundler

COPY docker_postgres_init.sql ${APP_DIR}/docker_postgres_init.sql
RUN  bundle install
#COPY . ${APP_DIR}


# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

EXPOSE 3000

# Start the main process.

CMD ["rails", "server", "-b", "0.0.0.0"]
