FROM elixir:1.9

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y postgresql-client inotify-tools

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new

WORKDIR /usr/src/umbrella
COPY . .

ENV MIX_ENV prod
ENV SECRET_KEY_BASE LCCZm2SCbZDYoIRIecOApmNAmdITmk9U0qrCAUMu46/KaFsW1KWCKU0b3c6k0d1K

ENV AMQP_HOST chattermill-rabbitmq-service.default 
ENV AMQP_PORT 5672
ENV AMQP_QUEUE chattermill_review_prod

ENV DATABASE_URL ecto://postgres:postgres@chattermill-postgres-service.default:5432/chattermill_review_service_prod 

RUN mix deps.get --only prod

EXPOSE 4000

ENTRYPOINT ["./entrypoint.sh"]
