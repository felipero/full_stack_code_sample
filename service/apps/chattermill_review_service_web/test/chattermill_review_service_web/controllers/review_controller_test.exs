defmodule ChattermillReviewServiceWeb.ReviewControllerTest do
  use ChattermillReviewServiceWeb.ConnCase, async: false
  import ChattermillReviewService.Factory

  alias ChattermillReviewService.Repo
  alias ChattermillReviewService.Reviews
  alias ChattermillReviewService.Reviews.Review

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create review" do
    @create_attrs %{
      id: 54_321_720,
      comment: "not cool",
      created_at: "2019-07-18T23:28:36.000Z",
      themes: [
        %{
          theme_id: 6423,
          sentiment: -1
        }
      ]
    }
    test "renders review when data is valid", %{conn: conn} do
      insert(:theme, id: 6423)
      conn = post(conn, Routes.review_path(conn, :create), review: @create_attrs)
      assert "ok" = json_response(conn, 202)

      Process.sleep(10)

      assert %Review{id: 54_321_720, comment: "not cool", inserted_at: ~N[2019-07-18 23:28:36]} =
               Repo.get!(Review, 54_321_720)
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
