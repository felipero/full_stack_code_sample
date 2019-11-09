defmodule ChattermillReviewServiceWeb.ReviewView do
  use ChattermillReviewServiceWeb, :view
  alias ChattermillReviewServiceWeb.ReviewView

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, ReviewView, "review.json")}
  end

  def render("review.json", %{review: review}) do
    %{
      id: review.id,
      comment: review.comment,
      theme_sentiments:
        render_many(review.theme_sentiments, ReviewView, "theme_sentiment.json",
          as: :theme_sentiment
        ),
      created_at: review.inserted_at
    }
  end

  def render("theme_sentiment.json", %{theme_sentiment: theme_sentiment}) do
    %{
      theme_id: theme_sentiment.theme_id,
      review_id: theme_sentiment.review_id,
      sentiment: theme_sentiment.sentiment
    }
  end
end
