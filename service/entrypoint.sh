#!/usr/bin/env bash
set -e

mix ecto.setup.prod

exec mix phx.server
