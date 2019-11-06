defmodule ChattermillReviewService.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: ChattermillReviewService.Repo

  alias ChattermillReviewService.{
    Reviews.Review,
    Reviews.ThemeSentiment,
    Themes.Theme,
    Themes.Category
  }

  def review_factory do
    %Review{comment: "some comment"}
  end

  def theme_sentiment_factory do
    %ThemeSentiment{
      review: build(:review),
      theme: build(:theme),
      sentiment: sequence(:sentiment, [-1, 0, 1])
    }
  end

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
