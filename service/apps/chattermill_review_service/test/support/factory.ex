defmodule ChattermillReviewService.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: ChattermillReviewService.Repo

  alias ChattermillReviewService.{
    Themes.Theme,
    Themes.Category
  }

  def category_factory do
    %Category{name: sequence(:name, &"Category #{&1}")}
  end

  def theme_factory do
    %Theme{
      name: sequence(:name, &"Theme #{&1}"),
      category: build(:category)
    }
  end
end
