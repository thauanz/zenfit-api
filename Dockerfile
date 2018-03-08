FROM ruby:2.5

MAINTAINER Thauan Zatta <thauanz@gmail.com>

ENV LANG="C.UTF-8"

RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends build-essential \
        apt-utils libpq-dev postgresql-client-9.6 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

EXPOSE 3001
EXPOSE 9292

COPY . /app/

RUN ["bundle", "install"]

ENTRYPOINT ["./entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3001"]

