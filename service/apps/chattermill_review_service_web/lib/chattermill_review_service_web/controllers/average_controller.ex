defmodule ChattermillReviewServiceWeb.AverageController do
  use ChattermillReviewServiceWeb, :controller

  alias ChattermillReviewService.Reviews

  action_fallback(ChattermillReviewServiceWeb.FallbackController)

  def categories(conn, params) when params == %{}, do: categories(conn, %{"id" => nil})

  def categories(conn, %{"id" => id}) do
    averages = Reviews.average_sentiments_by_category(cast_id(id))
    render(conn, "averages.json", averages: averages)
  end

  def themes(conn, params) when params == %{}, do: themes(conn, %{"id" => nil})

  def themes(conn, %{"id" => id}) do
    averages = Reviews.average_sentiments_by_theme(cast_id(id))
    render(conn, "averages.json", averages: averages)
  end

  defp cast_id(id) when is_binary(id) and id != "", do: String.to_integer(id)
  defp cast_id(id), do: id
end
