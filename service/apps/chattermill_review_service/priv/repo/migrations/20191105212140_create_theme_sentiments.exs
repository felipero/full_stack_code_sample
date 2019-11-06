defmodule ChattermillReviewService.Repo.Migrations.CreateThemeSentiments do
  use Ecto.Migration

  def change do
    create table(:theme_sentiments) do
      add(:sentiment, :integer, null: false)
      add(:theme_id, references(:themes, on_delete: :nothing, null: false))
      add(:review_id, references(:reviews, on_delete: :nothing, null: false))

      timestamps()
    end

    create(index(:theme_sentiments, [:review_id]))
    create(index(:theme_sentiments, [:review_id, :theme_id], unique: true))
  end
end
