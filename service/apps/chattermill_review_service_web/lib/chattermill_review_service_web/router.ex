defmodule ChattermillReviewServiceWeb.Router do
  use ChattermillReviewServiceWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ChattermillReviewServiceWeb do
    pipe_through(:api)

    resources("/reviews", ReviewController, only: [:create])

    get("/averages/categories", AverageController, :categories)
    get("/averages/categories/:id", AverageController, :categories)
    get("/averages/themes", AverageController, :themes)
    get("/averages/themes/:id", AverageController, :themes)
  end
end
