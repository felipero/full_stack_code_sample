defmodule ChattermillReviewService.Reviews do
  @moduledoc """
  The Reviews context.
  """

  import Ecto.Query, warn: false
  alias ChattermillReviewService.Repo

  alias ChattermillReviewService.Reviews.Review

  @doc """
  Returns the list of reviews.

  ## Examples

      iex> list_reviews()
      [%Review{}, ...]

  """
  def list_reviews do
    Review
    |> Repo.all()
    |> Repo.preload(:theme_sentiments)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(id), do: Repo.get!(Review, id)

  @doc """
  Creates a review.

  ## Examples

      iex> create_review(%{field: value})
      {:ok, %Review{}}

      iex> create_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_review(attrs \\ %{})

  def create_review(
        %{
          "id" => _id,
          "comment" => _comment,
          "themes" => theme_sentiments,
          "created_at" => inserted_at
        } = params
      ) do
    attrs =
      params
      |> Map.drop(["themes", "created_at"])
      |> Map.put("theme_sentiments", theme_sentiments)
      |> Map.put("inserted_at", inserted_at)

    create_review(attrs)
  end

  def create_review(attrs) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{source: %Review{}}

  """
  def change_review(%Review{} = review) do
    Review.changeset(review, %{})
  end

  alias ChattermillReviewService.Reviews.ThemeSentiment

  @doc """
  Returns the list of categories with its sentiment average.

  ## Examples

      iex> average_sentiments_by_category()
      [%{name: "Category 1", id: 452, sentiment: 0.00}]

  """
  def average_sentiments_by_category() do
    query =
      from(s in ThemeSentiment,
        join: t in assoc(s, :theme),
        join: c in assoc(t, :category),
        group_by: [c.name, c.id],
        order_by: c.name,
        select: [c.name, c.id, avg(s.sentiment)]
      )

    query
    |> Repo.all()
    |> Enum.map(fn entry ->
      name = Enum.at(entry, 0)
      id = Enum.at(entry, 1)

      sentiment =
        entry
        |> Enum.at(2)
        |> Decimal.round(2)
        |> Decimal.to_float()

      %{
        name: name,
        id: id,
        sentiment: sentiment
      }
    end)
  end

  @doc """
  Returns the list of themes with its sentiment average.

  ## Examples

      iex> average_sentiments_by_theme()
      [%{name: "Theme 1", id: 6724, sentiment: 0.00}]

  """
  def average_sentiments_by_theme() do
    query =
      from(s in ThemeSentiment,
        join: t in assoc(s, :theme),
        group_by: [t.name, t.id],
        order_by: t.name,
        select: [t.name, t.id, avg(s.sentiment)]
      )

    query
    |> Repo.all()
    |> Enum.map(fn entry ->
      name = Enum.at(entry, 0)
      id = Enum.at(entry, 1)

      sentiment =
        entry
        |> Enum.at(2)
        |> Decimal.round(2)
        |> Decimal.to_float()

      %{
        name: name,
        id: id,
        sentiment: sentiment
      }
    end)
  end
end
