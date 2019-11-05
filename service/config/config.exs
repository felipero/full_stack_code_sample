# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :chattermill_review_service,
  ecto_repos: [ChattermillReviewService.Repo]

config :chattermill_review_service_web,
  ecto_repos: [ChattermillReviewService.Repo],
  generators: [context_app: :chattermill_review_service, binary_id: true]

# Configures the endpoint
config :chattermill_review_service_web, ChattermillReviewServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "GJ+dlDpC69I4HvwsBxlEzIvA/UqvU2hRKUzSq3R4OGRbIX53VSXDHnAFypXSAafH",
  render_errors: [view: ChattermillReviewServiceWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ChattermillReviewServiceWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
