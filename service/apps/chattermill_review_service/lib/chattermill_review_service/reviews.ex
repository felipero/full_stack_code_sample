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
    Repo.all(Review)
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
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Review{} = review) do
    Repo.delete(review)
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
  Returns the list of theme_sentiments.

  ## Examples

      iex> list_theme_sentiments()
      [%ThemeSentiment{}, ...]

  """
  def list_theme_sentiments do
    Repo.all(ThemeSentiment)
  end

  @doc """
  Gets a single theme_sentiment.

  Raises `Ecto.NoResultsError` if the Theme sentiment does not exist.

  ## Examples

      iex> get_theme_sentiment!(123)
      %ThemeSentiment{}

      iex> get_theme_sentiment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_theme_sentiment!(id), do: Repo.get!(ThemeSentiment, id)

  @doc """
  Creates a theme_sentiment.

  ## Examples

      iex> create_theme_sentiment(%{field: value})
      {:ok, %ThemeSentiment{}}

      iex> create_theme_sentiment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_theme_sentiment(attrs \\ %{}) do
    %ThemeSentiment{}
    |> ThemeSentiment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a theme_sentiment.

  ## Examples

      iex> update_theme_sentiment(theme_sentiment, %{field: new_value})
      {:ok, %ThemeSentiment{}}

      iex> update_theme_sentiment(theme_sentiment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_theme_sentiment(%ThemeSentiment{} = theme_sentiment, attrs) do
    theme_sentiment
    |> ThemeSentiment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ThemeSentiment.

  ## Examples

      iex> delete_theme_sentiment(theme_sentiment)
      {:ok, %ThemeSentiment{}}

      iex> delete_theme_sentiment(theme_sentiment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_theme_sentiment(%ThemeSentiment{} = theme_sentiment) do
    Repo.delete(theme_sentiment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking theme_sentiment changes.

  ## Examples

      iex> change_theme_sentiment(theme_sentiment)
      %Ecto.Changeset{source: %ThemeSentiment{}}

  """
  def change_theme_sentiment(%ThemeSentiment{} = theme_sentiment) do
    ThemeSentiment.changeset(theme_sentiment, %{})
  end
end
