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
end
