defmodule ChattermillReviewServiceWeb.AverageView do
  use ChattermillReviewServiceWeb, :view
  alias ChattermillReviewServiceWeb.AverageView

  def render("averages.json", %{averages: averages}) do
    %{averages: render_many(averages, AverageView, "average.json")}
  end

  def render("average.json", %{average: average}) do
    %{
      name: average.name,
      id: average.id,
      sentiment: average.sentiment
    }
  end
end
