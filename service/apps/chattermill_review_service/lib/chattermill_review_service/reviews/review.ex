defmodule ChattermillReviewService.Reviews.Review do
  @moduledoc """
    Review schema to represent user reviews
  """
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
    |> cast(attrs, [:id, :comment, :inserted_at])
    |> cast_assoc(:theme_sentiments)
    |> validate_required([:comment])
  end
end
