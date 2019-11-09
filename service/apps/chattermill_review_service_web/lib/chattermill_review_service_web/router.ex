defmodule ChattermillReviewServiceWeb.Router do
  use ChattermillReviewServiceWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ChattermillReviewServiceWeb do
    pipe_through(:api)

    resources("/reviews", ReviewController, only: [:index, :create])
  end
end
