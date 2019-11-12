defmodule ChattermillReviewServiceWeb.AverageController do
  use ChattermillReviewServiceWeb, :controller

  alias ChattermillReviewService.Reviews

  action_fallback(ChattermillReviewServiceWeb.FallbackController)

  def categories(conn, params) when params == %{}, do: categories(conn, %{"term" => nil})
  def categories(conn, %{"id" => id}), do: categories(conn, %{"term" => cast_id(id)})

  def categories(conn, %{"term" => term}) do
    averages = Reviews.average_sentiments_by_category(term)
    render(conn, "averages.json", averages: averages)
  end

  def themes(conn, params) when params == %{}, do: themes(conn, %{"term" => nil})
  def themes(conn, %{"id" => id}), do: themes(conn, %{"term" => cast_id(id)})

  def themes(conn, %{"term" => term}) do
    averages = Reviews.average_sentiments_by_theme(term)
    render(conn, "averages.json", averages: averages)
  end

  defp cast_id(id) when is_binary(id) and id != "", do: String.to_integer(id)
  defp cast_id(id), do: id
end
