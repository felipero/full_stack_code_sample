defmodule ChattermillReviewService.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :comment, :string

      timestamps()
    end

  end
end
