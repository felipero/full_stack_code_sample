defmodule ChattermillReviewService.Repo.Migrations.CreateThemes do
  use Ecto.Migration

  def change do
    create table(:themes) do
      add(:name, :string, null: false)
      add(:category_id, references(:categories, on_delete: :restrict, null: false))

      timestamps()
    end

    create(index(:themes, [:category_id]))
  end
end
