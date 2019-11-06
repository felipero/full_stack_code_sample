defmodule ChattermillReviewService.Reviews.ThemeSentiment do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChattermillReviewService.Themes.Theme
  alias ChattermillReviewService.Reviews.Review

  schema "theme_sentiments" do
    field(:sentiment, :integer)

    belongs_to(:theme, Theme)
    belongs_to(:review, Review)

    timestamps()
  end

  @doc false
  def changeset(theme_sentiment, attrs) do
    theme_sentiment
    |> cast(attrs, [:sentiment, :theme_id, :review_id])
    |> validate_required([:sentiment, :theme_id, :review_id])
    |> assoc_constraint(:review)
    |> assoc_constraint(:theme)
    |> unique_constraint(:review_id, name: :theme_sentiments_review_id_theme_id_index)
  end
end
