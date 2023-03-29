defmodule TempleLiveview.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :votes_count, :integer
      add :body, :text

      timestamps()
    end
  end
end
