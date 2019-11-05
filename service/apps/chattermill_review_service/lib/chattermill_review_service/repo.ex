defmodule ChattermillReviewService.Repo do
  use Ecto.Repo,
    otp_app: :chattermill_review_service,
    adapter: Ecto.Adapters.Postgres
end
