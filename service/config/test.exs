use Mix.Config

# Configure your database
config :chattermill_review_service, ChattermillReviewService.Repo,
  username: "postgres",
  password: "postgres",
  database: "chattermill_review_service_test",
  hostname: System.get_env("PG_HOST") || "localhost",
  port: System.get_env("PG_PORT") || 5432,
  pool: Ecto.Adapters.SQL.Sandbox

config :chattermill_review_service, ReviewAMQPWorker, queue: "chattermill_review_test"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chattermill_review_service_web, ChattermillReviewServiceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
