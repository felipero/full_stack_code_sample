defmodule ChattermillReviewServiceWeb.ReviewControllerTest do
  use ChattermillReviewServiceWeb.ConnCase, async: false
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
      assert "ok" = json_response(conn, 202)

      Process.sleep(10)

      conn = get(conn, Routes.review_path(conn, :index))

      assert [
               %{
                 "id" => id,
                 "comment" => "not cool",
                 "created_at" => "2019-07-18T23:28:36"
               }
             ] = json_response(conn, 200)["data"]
    end

    @invalid_review_attrs %{
      comment: "some review",
      created_at: nil,
      themes: [%{theme_id: 1200, sentiment: nil}]
    }
    test "renders errors when review is not with all fields", %{conn: conn} do
      Logger.remove_backend(:console)
      on_exit(fn -> Logger.add_backend(:console) end)
      conn = post(conn, Routes.review_path(conn, :create), review: @invalid_review_attrs)

      assert %{
               "errors" => %{
                 "reason" => "Invalid data. Review does not meet the required format."
               }
             } ==
               json_response(conn, 422)
    end

    @invalid_themes_attrs %{
      id: 1,
      comment: "My comment",
      created_at: nil,
      themes: [%{theme_id: 1200, sentiment: nil}, %{}]
    }
    test "renders errors when themes are not inthe valid format", %{conn: conn} do
      Logger.remove_backend(:console)
      on_exit(fn -> Logger.add_backend(:console) end)
      conn = post(conn, Routes.review_path(conn, :create), review: @invalid_themes_attrs)

      assert %{
               "errors" => %{
                 "reason" => "Invalid data. Themes field does not match the required format."
               }
             } ==
               json_response(conn, 422)
    end

    @invalid_char_attrs %{
      id: 1,
      comment: "sdf \xFF sd",
      created_at: nil,
      themes: [%{theme_id: 1200, sentiment: nil}]
    }
    test "renders errors when data can't be encoded to json invalid", %{conn: conn} do
      Logger.remove_backend(:console)
      on_exit(fn -> Logger.add_backend(:console) end)
      conn = post(conn, Routes.review_path(conn, :create), review: @invalid_char_attrs)

      assert %{
               "errors" => %{
                 "reason" =>
                   "Invalid data. invalid byte 0xFF in <<115, 100, 102, 32, 255, 32, 115, 100>>."
               }
             } ==
               json_response(conn, 422)
    end
  end
end
