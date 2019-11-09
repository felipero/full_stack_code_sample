defmodule ChattermillReviewServiceWeb.ReviewControllerTest do
  use ChattermillReviewServiceWeb.ConnCase
  import ChattermillReviewService.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all reviews", %{conn: conn} do
      review = insert(:review, id: 357, comment: "awesome", inserted_at: "2019-11-09T14:04:19")
      insert(:theme_sentiment, review: review, sentiment: -1)
      conn = get(conn, Routes.review_path(conn, :index))

      assert %{
               "data" => [
                 %{
                   "comment" => "awesome",
                   "created_at" => "2019-11-09T14:04:19",
                   "id" => 357,
                   "theme_sentiments" => [
                     %{
                       "review_id" => 357,
                       "sentiment" => -1,
                       "theme_id" => _
                     }
                   ]
                 }
               ]
             } = json_response(conn, 200)
    end
  end

  describe "create review" do
    @create_attrs %{
      id: 54_321_729,
      comment: "not cool",
      created_at: "2019-07-18T23:28:36.000Z",
      themes: [
        %{
          theme_id: 6427,
          sentiment: -1
        }
      ]
    }
    test "renders review when data is valid", %{conn: conn} do
      insert(:theme, id: 6427)
      conn = post(conn, Routes.review_path(conn, :create), review: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.review_path(conn, :index))

      assert [
               %{
                 "id" => id,
                 "comment" => "not cool",
                 "created_at" => "2019-07-18T23:28:36"
               }
             ] = json_response(conn, 200)["data"]
    end

    @invalid_attrs %{
      id: 1,
      comment: "",
      created_at: nil,
      themes: [%{theme_id: 1200, sentiment: nil}]
    }
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.review_path(conn, :create), review: @invalid_attrs)

      assert %{
               "errors" => %{
                 "comment" => ["can't be blank"],
                 "theme_sentiments" => [%{"sentiment" => ["can't be blank"]}]
               }
             } = json_response(conn, 422)
    end
  end
end
