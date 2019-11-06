defmodule ChattermillReviewService.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: ChattermillReviewService.Repo

  alias ChattermillReviewService.{
    Themes.Category
  }

  def category_factory do
    %Category{name: sequence(:name, &"Category #{&1}")}
  end
end
