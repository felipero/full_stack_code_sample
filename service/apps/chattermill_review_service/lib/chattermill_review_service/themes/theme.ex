defmodule ChattermillReviewService.Themes.Theme do
  @moduledoc """
    Theme schem to represent an aspect of our client's business (payments, delivery, product quality, etc).
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias ChattermillReviewService.Themes.Category

  schema "themes" do
    field(:name, :string)

    belongs_to(:category, Category)

    timestamps()
  end

  @doc false
  def changeset(theme, attrs) do
    theme
    |> cast(attrs, [:name, :category_id])
    |> validate_required([:name, :category_id])
    |> assoc_constraint(:category)
  end
end
