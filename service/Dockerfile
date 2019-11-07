FROM elixir:1.9

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y postgresql-client inotify-tools

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new

WORKDIR /usr/src/umbrella
COPY . .

ENV MIX_ENV prod
ENV DATABASE_URL ecto://postgres:postgres@chattermill-postgres-service.default:5432/chattermill_review_service_prod 
ENV SECRET_KEY_BASE LCCZm2SCbZDYoIRIecOApmNAmdITmk9U0qrCAUMu46/KaFsW1KWCKU0b3c6k0d1K

RUN mix deps.get --only prod

EXPOSE 4000

CMD ["mix", "start.prod"]