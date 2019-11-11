defmodule ChattermillReviewServiceWeb.ReviewController do
  use ChattermillReviewServiceWeb, :controller

  alias ChattermillReviewService.Reviews
  alias ChattermillReviewService.ReviewAMQPWorker

  action_fallback(ChattermillReviewServiceWeb.FallbackController)

  def index(conn, _params) do
    reviews = Reviews.list_reviews()
    render(conn, "index.json", reviews: reviews)
  end

  def create(conn, %{"review" => review_params}) do
    case review_params do
      %{
        "id" => _,
        "comment" => _,
        "created_at" => _,
        "themes" => themes
      } ->
        if Enum.all?(themes, &match?(%{"theme_id" => _, "sentiment" => _}, &1)) do
          case ReviewAMQPWorker.publish_review(review_params) do
            {:ok, _} ->
              conn
              |> put_status(:accepted)
              |> json(:ok)

            {:error, reason, _payload} ->
              conn
              |> render_error("Invalid data. #{reason}.")
          end
        else
          conn
          |> render_error("Invalid data. Themes field does not match the required format.")
        end

      _ ->
        conn
        |> render_error("Invalid data. Review does not meet the required format.")
    end
  end

  defp render_error(conn, reason) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{
      errors: %{reason: reason}
    })
  end
end
