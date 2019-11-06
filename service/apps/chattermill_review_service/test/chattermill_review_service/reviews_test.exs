defmodule ChattermillReviewService.ReviewsTest do
  use ChattermillReviewService.DataCase
  import ChattermillReviewService.Factory

  alias ChattermillReviewService.Reviews

  describe "reviews" do
    alias ChattermillReviewService.Reviews.Review

    @update_attrs %{comment: "some updated comment"}
    @invalid_attrs %{comment: nil}

    test "list_reviews/0 returns all reviews" do
      review = insert(:review)
      assert Reviews.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = insert(:review)
      assert Reviews.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      assert {:ok, %Review{} = review} = Reviews.create_review(params_for(:review))
      assert review.comment == "some comment"
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = insert(:review)
      assert {:ok, %Review{} = review} = Reviews.update_review(review, @update_attrs)
      assert review.comment == "some updated comment"
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = insert(:review)
      assert {:error, %Ecto.Changeset{}} = Reviews.update_review(review, @invalid_attrs)
      assert review == Reviews.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = insert(:review)
      assert {:ok, %Review{}} = Reviews.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = insert(:review)
      assert %Ecto.Changeset{} = Reviews.change_review(review)
    end
  end

  describe "theme_sentiments" do
    alias ChattermillReviewService.Reviews.ThemeSentiment

    @update_attrs params_for(:theme_sentiment, %{sentiment: 0})
    @invalid_attrs %{review_id: nil, theme_id: nil, sentiment: nil}

    test "list_theme_sentiments/0 returns all theme_sentiments" do
      theme_sentiment = insert(:theme_sentiment)

      assert [
               %ThemeSentiment{
                 id: id,
                 sentiment: sentiment,
                 review_id: review_id,
                 theme_id: theme_id
               }
             ] = Reviews.list_theme_sentiments()

      assert id == theme_sentiment.id
      assert review_id == theme_sentiment.review_id
      assert theme_id == theme_sentiment.theme_id
      assert sentiment == theme_sentiment.sentiment
    end

    test "get_theme_sentiment!/1 returns the theme_sentiment with given id" do
      theme_sentiment = insert(:theme_sentiment)

      assert %ThemeSentiment{} =
               returned_theme_sentiment = Reviews.get_theme_sentiment!(theme_sentiment.id)

      assert returned_theme_sentiment.sentiment == theme_sentiment.sentiment
    end

    test "create_theme_sentiment/1 with valid data creates a theme_sentiment" do
      assert {:ok, %ThemeSentiment{} = theme_sentiment} =
               Reviews.create_theme_sentiment(
                 params_with_assocs(:theme_sentiment, %{sentiment: -1})
               )

      assert theme_sentiment.sentiment == -1
    end

    test "create_theme_sentiment/1 with invalid data returns error changeset" do
      assert {:error,
              %Ecto.Changeset{
                errors: [
                  sentiment: {"can't be blank", [validation: :required]},
                  theme_id: {"can't be blank", [validation: :required]},
                  review_id: {"can't be blank", [validation: :required]}
                ]
              }} = Reviews.create_theme_sentiment(@invalid_attrs)
    end

    test "update_theme_sentiment/2 with valid data updates the theme_sentiment" do
      theme_sentiment = insert(:theme_sentiment)

      assert {:ok, %ThemeSentiment{} = theme_sentiment} =
               Reviews.update_theme_sentiment(theme_sentiment, @update_attrs)

      assert theme_sentiment.sentiment == 0
    end

    test "update_theme_sentiment/2 with invalid data returns error changeset" do
      theme_sentiment = insert(:theme_sentiment)

      assert {:error, %Ecto.Changeset{}} =
               Reviews.update_theme_sentiment(theme_sentiment, @invalid_attrs)

      assert theme_sentiment.sentiment ==
               Reviews.get_theme_sentiment!(theme_sentiment.id).sentiment
    end

    test "delete_theme_sentiment/1 deletes the theme_sentiment" do
      theme_sentiment = insert(:theme_sentiment)
      assert {:ok, %ThemeSentiment{}} = Reviews.delete_theme_sentiment(theme_sentiment)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_theme_sentiment!(theme_sentiment.id) end
    end

    test "change_theme_sentiment/1 returns a theme_sentiment changeset" do
      theme_sentiment = insert(:theme_sentiment)
      assert %Ecto.Changeset{} = Reviews.change_theme_sentiment(theme_sentiment)
    end
  end
end
