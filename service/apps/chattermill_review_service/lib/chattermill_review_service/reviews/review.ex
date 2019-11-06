defmodule ChattermillReviewService.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChattermillReviewService.Reviews.ThemeSentiment

  schema "reviews" do
    field(:comment, :string)

    has_many(:theme_sentiments, ThemeSentiment)

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:comment])
    |> validate_required([:comment])
  end
end
