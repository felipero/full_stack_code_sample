defmodule ChattermillReviewServiceWeb.AverageController do
  use ChattermillReviewServiceWeb, :controller

  alias ChattermillReviewService.Reviews

  action_fallback(ChattermillReviewServiceWeb.FallbackController)

  def categories(conn, _params) do
    averages = Reviews.average_sentiments_by_category()
    render(conn, "averages.json", averages: averages)
  end

  def themes(conn, _params) do
    averages = Reviews.average_sentiments_by_theme()
    render(conn, "averages.json", averages: averages)
  end
end
