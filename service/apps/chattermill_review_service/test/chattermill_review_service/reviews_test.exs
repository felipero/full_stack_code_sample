defmodule ChattermillReviewService.ReviewsTest do
  use ChattermillReviewService.DataCase
  import ChattermillReviewService.Factory

  alias ChattermillReviewService.Reviews
  alias ChattermillReviewService.Reviews.{Review, ThemeSentiment}

  describe "reviews" do
    @update_attrs %{comment: "some updated comment"}
    @invalid_attrs %{comment: nil}

    test "list_reviews/0 returns all reviews" do
      review = insert(:review)
      insert(:theme_sentiment, review: review)

      assert Reviews.list_reviews() == [Repo.preload(review, :theme_sentiments)]
    end

    test "get_review!/1 returns the review with given id" do
      review = insert(:review)
      assert Reviews.get_review!(review.id) == review
    end

    test "create_review/1 with valid data containing themes key creates a review" do
      insert(:theme, id: 6373)

      attrs = %{
        "comment" => "excellent",
        "themes" => [
          %{
            "theme_id" => 6373,
            "sentiment" => 1
          }
        ],
        "created_at" => "2019-07-18T23:28:36.000Z",
        "id" => 59_458_292
      }

      assert {:ok, %Review{} = review} = Reviews.create_review(attrs)
      assert review.comment == "excellent"
      assert [%ThemeSentiment{theme_id: 6373}] = review.theme_sentiments
    end

    test "create_review/1 with valid data creates a review" do
      assert {:ok, %Review{} = review} = Reviews.create_review(params_for(:review))
      assert review.comment == "some comment"
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_review(@invalid_attrs)
    end
  end

  describe "theme_sentiments" do
    test "average_sentiments_by_category/0 returns a list of categories with the average sentiment" do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme one", category: category_one)
      theme_two = insert(:theme, name: "Theme two", category: category_one)
      theme_three = insert(:theme, name: "Theme three", category: category_two)
      theme_four = insert(:theme, name: "Theme four", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: -1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: 1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)

      assert [
               %{name: "Category 1", id: category_one.id, sentiment: 0.33},
               %{name: "Category 2", id: category_two.id, sentiment: -0.25}
             ] == Reviews.average_sentiments_by_category()
    end

    test "average_sentiments_by_theme/0 returns a list of themes with the average sentiment" do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme 1", category: category_one)
      theme_two = insert(:theme, name: "Theme 2", category: category_one)
      theme_three = insert(:theme, name: "Theme 3", category: category_two)
      theme_four = insert(:theme, name: "Theme 4", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: -1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: 1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)

      assert [
               %{name: "Theme 1", id: theme_one.id, sentiment: 0.00},
               %{name: "Theme 2", id: theme_two.id, sentiment: 0.67},
               %{name: "Theme 3", id: theme_three.id, sentiment: -0.67},
               %{name: "Theme 4", id: theme_four.id, sentiment: 0.00}
             ] == Reviews.average_sentiments_by_theme()
    end
  end
end
