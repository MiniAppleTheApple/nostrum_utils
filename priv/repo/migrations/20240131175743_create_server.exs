defmodule Mark.Repo.Migrations.CreateServer do
  use Ecto.Migration

  def change do
    create table(:server) do
      add :name, :string
    end
  end
end
