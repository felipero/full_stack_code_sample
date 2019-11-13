defmodule ChattermillReviewService.Seed do
  alias ChattermillReviewService.Repo
  alias ChattermillReviewService.Reviews.{Review, ThemeSentiment}

  def bulk_from_json_file(path, table) do
    attrs =
      __DIR__
      |> Path.join(path)
      |> File.read!()
      |> Jason.decode!()
      |> timestamps

    Repo.insert_all(table, attrs, on_conflict: :nothing)
  end

  def each_from_json_file(path, function) do
    __DIR__
    |> Path.join(path)
    |> File.read!()
    |> Jason.decode!()
    |> Enum.each(function)
  end

  def create_review(
        %{
          "id" => id,
          "comment" => _comment,
          "themes" => theme_sentiments_attrs,
          "created_at" => inserted_at
        } = params
      ) do
    attrs =
      params
      |> Map.drop(["themes", "created_at"])
      |> Map.put("inserted_at", inserted_at)

    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert!(on_conflict: :nothing)

    theme_sentiments_attrs
    |> Enum.map(fn ts -> Map.merge(ts, %{"review_id" => id}) end)
    |> Enum.each(&ChattermillReviewService.Seed.create_theme_sentiment/1)
  end

  def create_theme_sentiment(theme_sentiment_attrs) do
    %ThemeSentiment{}
    |> ThemeSentiment.changeset(theme_sentiment_attrs)
    |> Repo.insert!(on_conflict: :nothing)
  end

  defp timestamps(items) do
    Enum.map(items, fn item ->
      Map.merge(item, %{inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()})
    end)
  end
end

alias ChattermillReviewService.Seed

Seed.bulk_from_json_file("sample_data/categories.json", "categories")
Seed.bulk_from_json_file("sample_data/themes.json", "themes")
Seed.each_from_json_file("sample_data/reviews.json", &Seed.create_review/1)
