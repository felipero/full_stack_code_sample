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

  describe "themes" do
    alias ChattermillReviewService.Themes.Theme

    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    test "list_themes/0 returns all themes" do
      theme = insert(:theme)
      assert [%Theme{} = returned_theme] = Themes.list_themes()
      assert returned_theme.id == theme.id
      assert returned_theme.category_id == theme.category_id
      assert returned_theme.name == theme.name
    end

    test "get_theme!/1 returns the theme with given id" do
      theme = insert(:theme)
      assert %Theme{} = returned_theme = Themes.get_theme!(theme.id)
      assert returned_theme.name == theme.name
    end

    test "create_theme/1 with valid data creates a theme" do
      assert {:ok, %Theme{} = theme} =
               Themes.create_theme(params_with_assocs(:theme, %{name: "Theme Bar"}))

      assert theme.name == "Theme Bar"
    end

    test "create_theme/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Themes.create_theme(@invalid_attrs)
    end

    test "update_theme/2 with valid data updates the theme" do
      theme = insert(:theme)
      assert {:ok, %Theme{} = theme} = Themes.update_theme(theme, @update_attrs)
      assert theme.name == "some updated name"
    end

    test "update_theme/2 with invalid data returns error changeset" do
      theme = insert(:theme)
      assert {:error, %Ecto.Changeset{}} = Themes.update_theme(theme, @invalid_attrs)
      assert theme.name == Themes.get_theme!(theme.id).name
    end

    test "delete_theme/1 deletes the theme" do
      theme = insert(:theme)
      assert {:ok, %Theme{}} = Themes.delete_theme(theme)
      assert_raise Ecto.NoResultsError, fn -> Themes.get_theme!(theme.id) end
    end

    test "change_theme/1 returns a theme changeset" do
      theme = insert(:theme)
      assert %Ecto.Changeset{} = Themes.change_theme(theme)
    end
  end
end
