defmodule ChattermillReviewServiceWeb.AverageController do
  use ChattermillReviewServiceWeb, :controller

  alias ChattermillReviewService.Reviews

  action_fallback(ChattermillReviewServiceWeb.FallbackController)

  def categories(conn, params) when params == %{}, do: categories(conn, %{"id" => nil})

  def categories(conn, %{"id" => id}) do
    id =
      case id do
        id when is_binary(id) and id != "" ->
          String.to_integer(id)

        id ->
          id
      end

    averages = Reviews.average_sentiments_by_category(id)
    render(conn, "averages.json", averages: averages)
  end

  def themes(conn, params) when params == %{}, do: themes(conn, %{"id" => nil})

  def themes(conn, %{"id" => id}) do
    averages = Reviews.average_sentiments_by_theme(id)
    render(conn, "averages.json", averages: averages)
  end
end
