defmodule ChattermillReviewServiceWeb.ReviewController do
  use ChattermillReviewServiceWeb, :controller

  alias ChattermillReviewService.Reviews
  alias ChattermillReviewService.Reviews.Review

  action_fallback(ChattermillReviewServiceWeb.FallbackController)

  def index(conn, _params) do
    reviews = Reviews.list_reviews()
    render(conn, "index.json", reviews: reviews)
  end

  def create(conn, %{"review" => review_params}) do
    with {:ok, %Review{} = review} <- Reviews.create_review(review_params) do
      conn
      |> put_status(:created)
      |> render("show.json", review: review)
    end
  end
end
