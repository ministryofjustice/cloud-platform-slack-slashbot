FROM ruby:2.5-alpine

RUN apk --update add --virtual build_deps build-base

RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

RUN chown -R appuser:appgroup /app

USER 1000

CMD ["ruby", "app.rb"]
