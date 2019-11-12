defmodule ChattermillReviewServiceWeb.AverageControllerTest do
  use ChattermillReviewServiceWeb.ConnCase, async: false
  import ChattermillReviewService.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "categories" do
    test "lists all category averages", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme one", category: category_one)
      theme_two = insert(:theme, name: "Theme two", category: category_one)
      theme_three = insert(:theme, name: "Theme three", category: category_two)
      theme_four = insert(:theme, name: "Theme four", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: -1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: 1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :categories))

      assert %{
               "averages" => [
                 %{"name" => "Category 1", "id" => category_one.id, "sentiment" => 0.33},
                 %{"name" => "Category 2", "id" => category_two.id, "sentiment" => -0.25}
               ]
             } == json_response(conn, 200)
    end
  end

  describe "themes" do
    test "lists all theme averages", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme 1", category: category_one)
      theme_two = insert(:theme, name: "Theme 2", category: category_one)
      theme_three = insert(:theme, name: "Theme 3", category: category_two)
      theme_four = insert(:theme, name: "Theme 4", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: -1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: 1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :themes))

      assert %{
               "averages" => [
                 %{"name" => "Theme 1", "id" => theme_one.id, "sentiment" => 0.00},
                 %{"name" => "Theme 2", "id" => theme_two.id, "sentiment" => 0.67},
                 %{"name" => "Theme 3", "id" => theme_three.id, "sentiment" => -0.67},
                 %{"name" => "Theme 4", "id" => theme_four.id, "sentiment" => 0.00}
               ]
             } == json_response(conn, 200)
    end
  end
end
