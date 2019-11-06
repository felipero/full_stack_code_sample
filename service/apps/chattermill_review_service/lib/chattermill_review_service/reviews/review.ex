defmodule ChattermillReviewService.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reviews" do
    field(:comment, :string)

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:comment])
    |> validate_required([:comment])
  end
end
