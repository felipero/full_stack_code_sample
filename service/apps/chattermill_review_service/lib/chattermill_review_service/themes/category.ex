defmodule ChattermillReviewService.Themes.Category do
  @moduledoc """
    Category schema to represent groups of Theme
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias ChattermillReviewService.Themes.Theme

  schema "categories" do
    field(:name, :string)

    has_many(:themes, Theme)

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
