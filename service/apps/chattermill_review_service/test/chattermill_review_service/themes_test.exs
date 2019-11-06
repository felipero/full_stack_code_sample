defmodule ChattermillReviewService.ThemesTest do
  use ChattermillReviewService.DataCase
  import ChattermillReviewService.Factory

  alias ChattermillReviewService.Themes

  describe "categories" do
    alias ChattermillReviewService.Themes.Category

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_categories/0 returns all categories" do
      category = insert(:category)
      assert Themes.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = insert(:category)
      assert Themes.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} =
               Themes.create_category(params_for(:category, %{name: "Category Foo"}))

      assert category.name == "Category Foo"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Themes.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = insert(:category)
      assert {:ok, %Category{} = category} = Themes.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = insert(:category)
      assert {:error, %Ecto.Changeset{}} = Themes.update_category(category, @invalid_attrs)
      assert category == Themes.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = insert(:category)
      assert {:ok, %Category{}} = Themes.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Themes.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = insert(:category)
      assert %Ecto.Changeset{} = Themes.change_category(category)
    end
  end
end
